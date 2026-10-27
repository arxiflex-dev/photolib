//! The `photolibd` binary as an operator sees it: exit codes, messages and signals.

use std::{
    io::{BufRead, BufReader, Read, Write},
    net::{SocketAddr, TcpStream},
    path::Path,
    process::{ExitStatus, Output, Stdio},
    sync::mpsc::{self, Receiver},
    thread,
    time::Duration,
};

use photolib_spawn::{Group, Running, Signal, output, tool};

const PHOTOLIBD: &str = env!("CARGO_BIN_EXE_photolibd");
/// The most a run of one of photolibd's commands or of another tool may take.
const TOOL: Duration = Duration::from_secs(120);

fn photolibd(dir: &Path, yaml: &str) -> Group {
    let file = dir.join("photolib.yaml");
    std::fs::write(&file, yaml).unwrap();
    let mut photolibd = photolib_spawn::command(PHOTOLIBD, Signal::SIGTERM);
    photolibd
        .arg("--config")
        .arg(&file)
        .env_clear()
        .stdout(Stdio::null())
        .stderr(Stdio::piped());
    Group::start(photolibd, Signal::SIGTERM)
}

/// photolibd with `args`, run to its end.
fn run(args: &[&str]) -> Output {
    output(tool(PHOTOLIBD).args(args).env_clear(), TOOL)
}

fn wait(child: &mut Group, limit: Duration) -> ExitStatus {
    let started = Running::start();
    loop {
        if let Some(status) = child.try_wait().unwrap() {
            return status;
        }
        assert!(started.elapsed() < limit, "photolibd did not exit within {limit:?}");
        thread::sleep(Duration::from_millis(20));
    }
}

fn failed_start(dir: &Path, yaml: &str) -> (Option<i32>, String) {
    let mut child = photolibd(dir, yaml);
    let status = wait(&mut child, Duration::from_secs(10));
    let mut stderr = String::new();
    child.stderr.take().unwrap().read_to_string(&mut stderr).unwrap();
    (status.code(), stderr)
}

#[test]
fn an_unknown_key_stops_startup_with_a_message_that_names_it() {
    let (code, stderr) = failed_start(
        tempfile::tempdir().unwrap().path(),
        "config_version: 1\nroles: [ml]\nlisten_adress: 127.0.0.1:0\n",
    );
    assert_eq!(code, Some(2), "{stderr}");
    assert!(
        stderr.contains("listen_adress") && stderr.contains("invalid"),
        "{stderr}"
    );
}

#[test]
fn contradictory_roles_stop_startup() {
    let (code, stderr) = failed_start(
        tempfile::tempdir().unwrap().path(),
        "config_version: 1\nroles: [all, ml]\n",
    );
    assert_eq!(code, Some(2), "{stderr}");
    assert!(stderr.contains("use it alone"), "{stderr}");
}

#[test]
fn a_missing_config_file_stops_startup() {
    let output = run(&["--config", "/nonexistent/photolib.yaml"]);
    assert_eq!(output.status.code(), Some(2));
    assert!(String::from_utf8_lossy(&output.stderr).contains("/nonexistent/photolib.yaml"));
}

fn log_lines(stderr: impl Read + Send + 'static) -> Receiver<serde_json::Value> {
    let (send, receive) = mpsc::channel();
    thread::spawn(move || {
        for line in BufReader::new(stderr).lines().map_while(Result::ok) {
            if let Ok(value) = serde_json::from_str(&line) {
                let _ = send.send(value);
            }
        }
    });
    receive
}

fn next_message(logs: &Receiver<serde_json::Value>, message: &str) -> serde_json::Value {
    let started = Running::start();
    while started.elapsed() < Duration::from_secs(10) {
        if let Ok(line) = logs.recv_timeout(Duration::from_millis(100))
            && line["fields"]["message"] == message
        {
            return line;
        }
    }
    panic!("no log line '{message}' within 10s");
}

fn get(addr: SocketAddr, path: &str) -> String {
    let mut stream = TcpStream::connect(addr).unwrap();
    write!(stream, "GET {path} HTTP/1.1\r\nHost: test\r\nConnection: close\r\n\r\n").unwrap();
    let mut response = String::new();
    stream.read_to_string(&mut response).unwrap();
    response
}

const ML: &str = "config_version: 1\nroles: [ml]\nlisten: 127.0.0.1:0\nshutdown_grace_secs: 5\n";
const TOKEN: &str = "test-token-test-token-test-token";

fn scrape(addr: SocketAddr) -> String {
    raw(
        addr,
        &format!("GET /metrics HTTP/1.1\r\nHost: test\r\nAuthorization: Bearer {TOKEN}\r\nConnection: close\r\n\r\n"),
    )
}

/// The address of the "listening" log line.
fn addr(listening: &serde_json::Value) -> SocketAddr {
    listening["fields"]["addr"].as_str().unwrap().parse().unwrap()
}

#[test]
fn sigterm_drains_and_exits_cleanly_after_readiness_was_served() {
    let dir = tempfile::tempdir().unwrap();
    let mut child = photolibd(dir.path(), ML);
    let logs = log_lines(child.stderr.take().unwrap());
    let addr = addr(&next_message(&logs, "listening"));
    assert!(get(addr, "/readyz/ml").starts_with("HTTP/1.1 200"));
    assert!(get(addr, "/readyz/api").starts_with("HTTP/1.1 404"));

    child.signal(Signal::SIGTERM);
    next_message(&logs, "shutting down");
    let drained = next_message(&logs, "drained");
    assert_eq!(drained["fields"]["aborted"], 0);
    assert!(wait(&mut child, Duration::from_secs(10)).success());
    assert!(TcpStream::connect(addr).is_err(), "the listener is closed");
}

/// The TCP ports `pid` listens on: its sockets among the kernel's listening ones.
fn listening_ports(pid: u32) -> Vec<u16> {
    let fds: Vec<String> = std::fs::read_dir(format!("/proc/{pid}/fd"))
        .unwrap()
        .filter_map(|fd| Some(std::fs::read_link(fd.ok()?.path()).ok()?.to_str()?.into()))
        .collect();
    ["tcp", "tcp6"]
        .map(|table| std::fs::read_to_string(format!("/proc/{pid}/net/{table}")).unwrap_or_default())
        .concat()
        .lines()
        .filter_map(|line| {
            let fields: Vec<&str> = line.split_whitespace().collect();
            let ours = fields[3] == "0A" && fds.contains(&format!("socket:[{}]", fields[9]));
            ours.then(|| u16::from_str_radix(fields[1].rsplit(':').next()?, 16).ok())?
        })
        .collect()
}

#[test]
fn photolibd_opens_one_port_which_serves_metrics_to_the_bearer_of_the_token() {
    let dir = tempfile::tempdir().unwrap();
    let mut child = photolibd(dir.path(), &format!("{ML}metrics: {{token: {TOKEN}}}\n"));
    let logs = log_lines(child.stderr.take().unwrap());
    let addr = addr(&next_message(&logs, "listening"));
    assert_eq!(listening_ports(child.id()), [addr.port()]);
    get(addr, "/readyz");
    let metrics = scrape(addr);
    assert!(metrics.starts_with("HTTP/1.1 200"), "{metrics}");
    assert!(
        metrics.contains(r#"photolib_http_request_duration_seconds_count{route="/readyz",status="200"} 1"#),
        "{metrics}"
    );
    assert!(get(addr, "/metrics").starts_with("HTTP/1.1 401"));
    get(addr, "/nowhere");
    let logged = next_message(&logs, "request finished");
    assert_eq!(logged["span"]["path"], "/nowhere", "scrapes log at debug");
    child.signal(Signal::SIGTERM);
    assert!(wait(&mut child, Duration::from_secs(10)).success());
}

fn command(config: &Path, args: &[&str]) -> (Option<i32>, String) {
    let output = run(&[&["--config", config.to_str().unwrap()], args].concat());
    let text = String::from_utf8_lossy(&output.stdout) + String::from_utf8_lossy(&output.stderr);
    (output.status.code(), text.into_owned())
}

#[tokio::test(flavor = "multi_thread")]
async fn a_downgrade_is_refused_until_the_pre_upgrade_dump_is_restored() {
    use photolib_db::{
        dump::Dumps,
        migrate::{Migration, Upgrade, embedded, upgrade},
        testpg,
    };

    let db = testpg::database().await;
    let dir = tempfile::tempdir().unwrap();
    let data_dir = dir.path().join("data");
    std::fs::create_dir(&data_dir).unwrap();
    let bin_dir = testpg::bin_dir();
    let yaml = format!(
        "config_version: 1\nroles: [api]\nlisten: 127.0.0.1:0\ndata_dir: {}\ndatabase:\n  url: \"{}\"\n  bin_dir: {}\n",
        data_dir.display(),
        db.url,
        bin_dir.display()
    );
    let config = dir.path().join("photolib.yaml");
    stop(listening(dir.path(), &yaml).0);
    assert!(
        data_dir.join(".photolib/store.json").exists(),
        "the data directory is the store `local`"
    );

    let mut newer = embedded();
    let current = newer.last().unwrap().version;
    newer.push(Migration::new("9999_newer.sql", "CREATE TABLE newer (x int);").unwrap());
    let dumps = Dumps {
        url: db.url.clone(),
        bin_dir: Some(bin_dir),
        dir: data_dir.join("backups"),
        keep: 3,
    };
    let up = Upgrade {
        dumps: Some(dumps),
        ..Upgrade::new(&newer)
    };
    upgrade(&db.pool, &up).await.unwrap();

    let (code, stderr) = failed_start(dir.path(), &yaml);
    assert_eq!(code, Some(1), "{stderr}");
    assert!(
        stderr.contains("downgraded") && stderr.contains("photolibd restore"),
        "{stderr}"
    );

    let (code, output) = command(&config, &["restore"]);
    assert_eq!(code, Some(0), "{output}");
    assert!(output.contains(&format!("pre-{current:04}-9999-")), "{output}");
    assert_eq!(
        command(&config, &["doctor", "schema"]),
        (Some(0), "the schema has no drift\n".into())
    );
    stop(listening(dir.path(), &yaml).0);

    sqlx::query("ALTER TABLE users ADD COLUMN nickname text")
        .execute(&db.pool)
        .await
        .unwrap();
    let (code, output) = command(&config, &["doctor", "schema"]);
    assert_eq!(code, Some(1), "{output}");
    assert!(output.contains("unexpected: column users.nickname text"), "{output}");
}

#[tokio::test(flavor = "multi_thread")]
async fn the_next_start_restores_the_backup_the_console_asked_for_and_serves_the_epoch_that_counts_it() {
    use photolib_db::testpg;
    use serde_json::json;

    let db = testpg::database().await;
    let dir = tempfile::tempdir().unwrap();
    let data_dir = dir.path().join("data");
    std::fs::create_dir(&data_dir).unwrap();
    let yaml = format!(
        "config_version: 1\nroles: [api]\nlisten: 127.0.0.1:0\ndata_dir: {}\ndatabase:\n  url: \"{}\"\n  bin_dir: {}\n",
        data_dir.display(),
        db.url,
        testpg::bin_dir().display()
    );
    let epoch = |addr| rpc(addr, "ServerInfoService/GetServerInfo", None, json!({}))["epoch"].clone();
    let (child, _, addr) = listening(dir.path(), &yaml);
    let before = epoch(addr);
    stop(child);
    let key = "backups/backup-20261020T030000Z.dump";
    photolib_db::dump::dump(&db.url, Some(&testpg::bin_dir()), &data_dir.join(key))
        .await
        .unwrap();
    sqlx::query("INSERT INTO users (id, handle, display_name) VALUES (gen_random_uuid(), 'late', 'Late')")
        .execute(&db.pool)
        .await
        .unwrap();
    photolib_server::backup::request_restore(&data_dir, "local", key).unwrap();

    let (child, _, addr) = listening(dir.path(), &yaml);
    let after = epoch(addr);
    stop(child);
    let instance = before.as_str().unwrap().strip_suffix(".0").unwrap();
    assert_eq!(after, json!(format!("{instance}.1")), "devices see the restore");
    let late: i64 = sqlx::query_scalar("SELECT count(*) FROM users WHERE handle = 'late'")
        .fetch_one(&db.pool)
        .await
        .unwrap();
    assert_eq!(late, 0, "the rows are the backup's");
    let runs: Vec<(String, String, bool)> = sqlx::query_as("SELECT kind, dump, ok FROM backup_runs")
        .fetch_all(&db.pool)
        .await
        .unwrap();
    assert_eq!(runs, [("restore".into(), key.into(), true)]);
}

/// The Helm chart's pre-upgrade job: the start's database part, and an exit.
#[tokio::test(flavor = "multi_thread")]
async fn migrate_brings_the_database_to_this_release_once_and_refuses_a_downgrade() {
    use photolib_db::{
        dump,
        migrate::{Migration, Upgrade, embedded, upgrade},
        testpg,
    };

    let db = testpg::database().await;
    let dir = tempfile::tempdir().unwrap();
    let data_dir = dir.path().join("data");
    std::fs::create_dir(&data_dir).unwrap();
    let config = dir.path().join("photolib.yaml");
    let yaml = format!(
        "config_version: 1\nroles: [api]\ndata_dir: {}\ndatabase:\n  url: \"{}\"\n  bin_dir: {}\n",
        data_dir.display(),
        db.url,
        testpg::bin_dir().display()
    );
    std::fs::write(&config, yaml).unwrap();
    let mut newer = embedded();
    let current = newer.last().unwrap().version;
    for _ in 0..2 {
        let said = format!("the schema is at {current}\n");
        assert_eq!(command(&config, &["migrate"]), (Some(0), said));
    }
    assert!(data_dir.join(".photolib/instance.json").exists());
    assert_eq!(
        dump::newest(&data_dir.join("backups")),
        None,
        "the second run changed nothing"
    );

    newer.push(Migration::new("9999_newer.sql", "CREATE TABLE newer (x int);").unwrap());
    upgrade(&db.pool, &Upgrade::new(&newer)).await.unwrap();
    let (code, output) = command(&config, &["migrate"]);
    assert_eq!(code, Some(1), "{output}");
    assert!(output.contains("photolibd was downgraded"), "{output}");
}

/// A desktop or a package install without Docker: photolibd runs PostgreSQL itself for each command that needs it,
/// and stops it when it ends.
#[test]
fn with_database_cluster_photolibd_runs_postgresql_itself_and_stops_it() {
    let dir = tempfile::tempdir().unwrap();
    let (data_dir, cluster) = (dir.path().join("data"), dir.path().join("pg"));
    std::fs::create_dir(&data_dir).unwrap();
    let bin = photolib_db::testpg::bin_dir();
    // Made as photolibd makes it (photolib_db::cluster's tests), but without the syncs that take a loaded machine
    // minutes.
    let initdb = output(
        tool(bin.join("initdb"))
            .args(["-U", "photolib", "-A", "trust", "--no-sync", "-D"])
            .arg(&cluster),
        TOOL,
    );
    assert!(initdb.status.success(), "{initdb:?}");
    std::fs::write(cluster.join("postgresql.auto.conf"), "fsync = off\n").unwrap();
    let yaml = format!(
        "config_version: 1\nroles: [api]\nlisten: 127.0.0.1:0\ndata_dir: {}\ndatabase:\n  cluster: {}\n  bin_dir: {}\n",
        data_dir.display(),
        cluster.display(),
        bin.display()
    );
    let config = dir.path().join("photolib.yaml");
    std::fs::write(&config, &yaml).unwrap();
    let (code, output) = command(&config, &["migrate"]);
    assert_eq!(code, Some(0), "{output}");
    let running = || cluster.join("postmaster.pid").exists();
    assert!(!running(), "postgres stops with the command");
    let (child, lines, addr) = listening(dir.path(), &yaml);
    let started = lines
        .iter()
        .find(|line| line["fields"]["message"] == "the database cluster started");
    assert_eq!(started.unwrap()["fields"]["dir"], cluster.display().to_string());
    assert!(get(addr, "/readyz").starts_with("HTTP/1.1 200"));
    stop(child);
    assert!(!running(), "postgres stops with photolibd");
}

/// The log lines up to the one that says `message`.
fn lines_until(logs: &Receiver<serde_json::Value>, message: &str) -> Vec<serde_json::Value> {
    let mut lines = Vec::new();
    while lines
        .last()
        .is_none_or(|line: &serde_json::Value| line["fields"]["message"] != message)
    {
        lines.push(
            logs.recv_timeout(Duration::from_secs(10))
                .unwrap_or_else(|_| panic!("no log line '{message}' within 10s: {lines:?}")),
        );
    }
    lines
}

fn post_json(addr: SocketAddr, path: &str, body: &str) -> String {
    post(addr, path, "", body)
}

fn post(addr: SocketAddr, path: &str, headers: &str, body: &str) -> String {
    raw(
        addr,
        &format!(
            "POST {path} HTTP/1.1\r\nHost: test\r\nConnection: close\r\nContent-Type: application/json\r\n\
             {headers}Content-Length: {}\r\n\r\n{body}",
            body.len()
        ),
    )
}

fn raw(addr: SocketAddr, request: &str) -> String {
    let mut stream = TcpStream::connect(addr).unwrap();
    stream.write_all(request.as_bytes()).unwrap();
    let mut response = String::new();
    stream.read_to_string(&mut response).unwrap();
    response
}

/// The idle-memory budget of docs/19 §3 (tools/perf/budgets.json); with `PERF_RESULTS` set, the result is appended
/// there for `tools/perf/perf.py`.
#[tokio::test(flavor = "multi_thread")]
async fn photolibd_without_ml_idles_in_at_most_150_mb() {
    let db = photolib_db::testpg::database().await;
    let dir = tempfile::tempdir().unwrap();
    let data_dir = dir.path().join("data");
    std::fs::create_dir(&data_dir).unwrap();
    let roles = "api, scheduler, worker:cpu, worker:io, worker:gpu, worker:transcode, worker:import, worker:export";
    let mut child = photolibd(
        dir.path(),
        &format!(
            "config_version: 1\nroles: [{roles}]\nlisten: 127.0.0.1:0\ndata_dir: {}\ndatabase:\n  url: \"{}\"\n",
            data_dir.display(),
            db.url
        ),
    );
    let logs = log_lines(child.stderr.take().unwrap());
    next_message(&logs, "listening");
    thread::sleep(Duration::from_secs(2));
    let ps = output(tool("ps").args(["-o", "rss=", "-p", &child.id().to_string()]), TOOL);
    let kib: f64 = String::from_utf8(ps.stdout).unwrap().trim().parse().unwrap();
    child.signal(Signal::SIGTERM);
    assert!(wait(&mut child, Duration::from_secs(10)).success());
    let mb = (kib * 1024.0 / 1e4).round() / 100.0;
    if let Ok(path) = std::env::var("PERF_RESULTS") {
        let line = serde_json::json!({"budget": "server-idle-rss", "metric": "rss", "target": "server", "value": mb});
        let mut file = std::fs::OpenOptions::new()
            .create(true)
            .append(true)
            .open(path)
            .unwrap();
        writeln!(file, "{line}").unwrap();
    }
    assert!(mb <= 150.0, "photolibd idles in {mb:.1} MB");
}

#[tokio::test(flavor = "multi_thread")]
async fn the_scheduler_serves_the_watermark_lag_it_samples() {
    let db = photolib_db::testpg::database().await;
    let dir = tempfile::tempdir().unwrap();
    let data_dir = dir.path().join("data");
    std::fs::create_dir(&data_dir).unwrap();
    let yaml = format!(
        "config_version: 1\nroles: [scheduler]\nlisten: 127.0.0.1:0\nmetrics: {{token: {TOKEN}}}\n\
         data_dir: {}\ndatabase:\n  url: \"{}\"\n",
        data_dir.display(),
        db.url
    );
    let mut child = photolibd(dir.path(), &yaml);
    let logs = log_lines(child.stderr.take().unwrap());
    let address = addr(&next_message(&logs, "listening"));
    // A change that ended above a transaction held open has waited for it, but less than a sample (ADR-0053): no
    // lag yet, where the age of the oldest open transaction would be at least 300 ms.
    let (mut open, xid) = (db.pool.begin().await.unwrap(), "SELECT pg_current_xact_id()");
    sqlx::query(xid).execute(&mut *open).await.unwrap();
    sqlx::query(xid).execute(&db.pool).await.unwrap();
    tokio::time::sleep(Duration::from_millis(300)).await;
    let response = scrape(address);
    open.rollback().await.unwrap();
    let lag = (response.lines())
        .find_map(|line| line.strip_prefix("photolib_sync_watermark_lag_seconds ")?.parse().ok())
        .unwrap_or(f64::NAN);
    assert!(response.starts_with("HTTP/1.1 200") && lag == 0.0, "{response}");
    child.signal(Signal::SIGTERM);
    assert!(wait(&mut child, Duration::from_secs(10)).success());
}

/// A successful unary call in JSON, as the session `bearer`.
fn rpc(addr: SocketAddr, method: &str, bearer: Option<&str>, body: serde_json::Value) -> serde_json::Value {
    let headers = bearer.map_or(String::new(), |token| format!("Authorization: Bearer {token}\r\n"));
    let response = post(addr, &format!("/photolib.api.v1.{method}"), &headers, &body.to_string());
    assert!(response.starts_with("HTTP/1.1 200"), "{method}: {response}");
    let (head, mut chunks) = response.split_once("\r\n\r\n").unwrap();
    assert!(head.to_lowercase().contains("transfer-encoding: chunked"), "{head}");
    let mut body = String::new();
    while let Some((size, rest)) = chunks.split_once("\r\n")
        && let Ok(size @ 1..) = usize::from_str_radix(size, 16)
    {
        body += &rest[..size];
        chunks = &rest[size + 2..];
    }
    serde_json::from_str(&body).unwrap()
}

/// Signs in with OPAQUE as a client does; returns the session token.
fn sign_in(addr: SocketAddr, handle: &str, password: &[u8]) -> String {
    use base64::{Engine, engine::general_purpose::STANDARD};
    use opaque_ke::{ClientLogin, ClientLoginFinishParameters, CredentialResponse, Identifiers};
    use photolib_server::auth::{CONTEXT, Suite};

    let start = ClientLogin::<Suite>::start(&mut rand_core::OsRng, password).unwrap();
    let ke1 = STANDARD.encode(start.message.serialize());
    let started = rpc(
        addr,
        "AuthService/StartLogin",
        None,
        serde_json::json!({ "handle": handle, "ke1": ke1 }),
    );
    let ke2 = STANDARD.decode(started["ke2"].as_str().unwrap()).unwrap();
    let parameters = ClientLoginFinishParameters::new(Some(CONTEXT), Identifiers::default(), None);
    let ke2 = CredentialResponse::deserialize(&ke2).unwrap();
    let finish = start
        .state
        .finish(&mut rand_core::OsRng, password, ke2, parameters)
        .unwrap();
    let body = serde_json::json!({
        "loginId": started["loginId"],
        "ke3": STANDARD.encode(finish.message.serialize()),
        "device": { "name": "CLI", "platform": "linux" },
    });
    let finished = rpc(addr, "AuthService/FinishLogin", None, body);
    finished["session"]["token"].as_str().unwrap().into()
}

/// Sets `password` with the setup token `setup`, as a client does.
fn set_password(addr: SocketAddr, setup: &str, password: &[u8]) {
    use base64::{Engine, engine::general_purpose::STANDARD};
    use opaque_ke::{ClientRegistration, RegistrationResponse};
    use photolib_server::auth::Suite;

    let start = ClientRegistration::<Suite>::start(&mut rand_core::OsRng, password).unwrap();
    let request = serde_json::json!({
        "registrationRequest": STANDARD.encode(start.message.serialize()),
        "passwordSetupToken": setup,
    });
    let started = rpc(addr, "AuthService/StartPasswordSetup", None, request);
    let response = STANDARD.decode(started["registrationResponse"].as_str().unwrap());
    let response = RegistrationResponse::deserialize(&response.unwrap()).unwrap();
    let finish = start
        .state
        .finish(&mut rand_core::OsRng, password, response, Default::default())
        .unwrap();
    let ksf_params = [&[1, 0, 4, 0, 0, 0, 0, 0, 3, 1][..], &[5; 16]].concat();
    let record = serde_json::json!({
        "registrationRecord": STANDARD.encode(finish.message.serialize()),
        "ksfParams": STANDARD.encode(ksf_params),
        "passwordSetupToken": setup,
        "registrationId": started["registrationId"],
    });
    rpc(addr, "AuthService/FinishPasswordSetup", None, record);
}

/// Starts photolibd until it listens: the process, its log so far and its address.
fn listening(dir: &Path, yaml: &str) -> (Group, Vec<serde_json::Value>, SocketAddr) {
    let mut child = photolibd(dir, yaml);
    let logs = log_lines(child.stderr.take().unwrap());
    let lines = lines_until(&logs, "listening");
    let addr = lines.last().unwrap()["fields"]["addr"]
        .as_str()
        .unwrap()
        .parse()
        .unwrap();
    (child, lines, addr)
}

fn stop(mut child: Group) {
    child.signal(Signal::SIGTERM);
    assert!(wait(&mut child, Duration::from_secs(10)).success());
}

#[tokio::test(flavor = "multi_thread")]
async fn a_new_instance_logs_a_one_time_token_whose_admin_sets_a_password_and_signs_in() {
    use std::os::unix::fs::PermissionsExt;

    use serde_json::json;

    const SETUP: &str = "/photolib.api.v1.SetupService/CreateFirstAdmin";
    let db = photolib_db::testpg::database().await;
    let dir = tempfile::tempdir().unwrap();
    let data_dir = dir.path().join("data");
    std::fs::create_dir(&data_dir).unwrap();
    let yaml = format!(
        "config_version: 1\nroles: [api]\nlisten: 127.0.0.1:0\ndata_dir: {}\ndatabase:\n  url: \"{}\"\n",
        data_dir.display(),
        db.url
    );
    let (child, lines, addr) = listening(dir.path(), &yaml);
    let tokens: Vec<&serde_json::Value> = lines
        .iter()
        .filter(|line| line["fields"]["setup_token"].is_string())
        .collect();
    assert_eq!(tokens.len(), 1, "{lines:?}");
    assert_eq!(tokens[0]["level"], "WARN");
    let token = tokens[0]["fields"]["setup_token"].as_str().unwrap();
    assert!(
        token.len() == 64 && token.bytes().all(|b| b.is_ascii_hexdigit()),
        "{token}"
    );
    let accounts: i64 = sqlx::query_scalar("SELECT count(*) FROM users")
        .fetch_one(&db.pool)
        .await
        .unwrap();
    assert_eq!(accounts, 0, "no default account exists");

    let request = |token: &str| json!({ "setupToken": token, "user": { "handle": "root", "displayName": "Root" } });
    let refused = post_json(addr, SETUP, &request(&"0".repeat(64)).to_string());
    assert!(refused.starts_with("HTTP/1.1 403"), "{refused}");
    let created = rpc(addr, "SetupService/CreateFirstAdmin", None, request(token));
    assert_eq!(created["user"]["role"], "USER_ROLE_ADMIN");
    let again = post_json(addr, SETUP, &request(token).to_string());
    assert!(again.starts_with("HTTP/1.1 400"), "{again}");
    // The upload endpoints run beside the API and refuse anonymous requests.
    let limits = raw(
        addr,
        "OPTIONS /upload HTTP/1.1\r\nHost: test\r\nConnection: close\r\n\r\n",
    );
    assert!(
        limits.starts_with("HTTP/1.1 204") && limits.contains("upload-limit: max-append-size="),
        "{limits}"
    );
    let anonymous = post_json(addr, "/upload", "");
    assert!(anonymous.starts_with("HTTP/1.1 401"), "{anonymous}");
    // So do the media endpoints, which show nothing to anyone who may not see it.
    let media = get(addr, &format!("/media/{}/thumb_s", uuid::Uuid::now_v7()));
    assert!(
        media.starts_with("HTTP/1.1 404") && media.contains("cache-control: private, no-store"),
        "{media}"
    );
    // And the hints channel, for signed-in devices only.
    let hints = get(addr, "/events?streams=account");
    assert!(hints.starts_with("HTTP/1.1 401"), "{hints}");

    set_password(addr, created["passwordSetup"]["token"].as_str().unwrap(), b"pw");
    let session = sign_in(addr, "root", b"pw");
    let users = rpc(addr, "UserService/ListUsers", Some(&session), json!({}));
    assert_eq!(users["users"][0]["handle"], "root");
    // Devices download the models it installed from it, signed in.
    let yunet = "yunet@2026may/face_detection_yunet_2026may.onnx";
    let size = photolib_models::REGISTRY
        .iter()
        .find(|m| m.id == "yunet")
        .unwrap()
        .files[0]
        .size;
    std::fs::create_dir_all(data_dir.join("models/yunet@2026may")).unwrap();
    let installed = std::fs::File::create(data_dir.join("models").join(yunet)).unwrap();
    installed.set_len(size).unwrap();
    let model = |auth: &str| {
        let request = format!("HEAD /models/{yunet} HTTP/1.1\r\nHost: test\r\n{auth}Connection: close\r\n\r\n");
        raw(addr, &request)
    };
    let downloaded = model(&format!("Authorization: Bearer {session}\r\n"));
    assert!(
        downloaded.starts_with("HTTP/1.1 200") && downloaded.contains(&format!("content-length: {size}")),
        "{downloaded}"
    );
    let anonymous = model("");
    assert!(anonymous.starts_with("HTTP/1.1 404"), "{anonymous}");
    let key = dir.path().join("opaque.key");
    let mode = std::fs::metadata(&key).unwrap().permissions().mode();
    assert_eq!(mode & 0o777, 0o600, "beside the configuration file");
    assert!(!data_dir.join(".photolib/opaque.key").exists(), "never in data_dir");
    // A device that follows hints holds its channel open, which stopping photolibd ends within `stop`'s 10 s, not
    // the 30 s grace for requests.
    let mut hints = TcpStream::connect(addr).unwrap();
    let request =
        format!("GET /events?streams=account HTTP/1.1\r\nHost: test\r\nAuthorization: Bearer {session}\r\n\r\n");
    hints.write_all(request.as_bytes()).unwrap();
    let (mut seen, mut buffer) = (String::new(), [0; 4096]);
    while !seen.contains("data: account\n\n") {
        let read = hints.read(&mut buffer).unwrap();
        assert!(read > 0, "{seen}");
        seen.push_str(std::str::from_utf8(&buffer[..read]).unwrap());
    }
    assert!(seen.starts_with("HTTP/1.1 200"), "{seen}");
    stop(child);

    let oidc =
        "oidc:\n  sso:\n    name: Home SSO\n    issuer: https://sso.example/realms/home\n    client_id: photolib\n";
    let (child, lines, addr) = listening(dir.path(), &format!("{yaml}{oidc}"));
    assert!(
        lines.iter().all(|line| line["fields"].get("setup_token").is_none()),
        "{lines:?}"
    );
    let session = sign_in(addr, "root", b"pw");
    rpc(addr, "UserService/ListUsers", Some(&session), json!({}));
    let info = rpc(addr, "ServerInfoService/GetServerInfo", None, json!({}));
    assert_eq!(
        (&info["authMethods"], &info["oidcProviders"]),
        (
            &json!(["AUTH_METHOD_OPAQUE", "AUTH_METHOD_OIDC"]),
            &json!([{ "id": "sso", "name": "Home SSO" }])
        ),
        "the providers are configured, and none is contacted before someone signs in"
    );
    stop(child);

    // The only administrator forgot the password: whoever runs the host makes a setup token.
    let config = dir.path().join("photolib.yaml");
    let (code, out) = command(&config, &["admin", "password-setup", "nobody"]);
    assert_eq!(code, Some(1), "{out}");
    assert!(out.contains("no active account is nobody"), "{out}");
    let public = "public_url: https://photos.example.com\nbase_path: /photos\n";
    std::fs::write(&config, format!("{yaml}{public}")).unwrap();
    let (code, out) = command(&config, &["admin", "password-setup", " ROOT "]);
    assert_eq!(code, Some(0), "{out}");
    let link = out
        .lines()
        .find_map(|line| line.strip_prefix("https://photos.example.com/photos/#/password-setup?handle=root&token="))
        .unwrap_or_else(|| panic!("{out}"));
    assert!(link.len() == 64 && out.contains("seven days"), "{out}");
    let (child, _, addr) = listening(dir.path(), &yaml);
    set_password(addr, link, b"new");
    sign_in(addr, "root", b"new");
    // A script has no OPAQUE client: whoever runs the host makes it an API key, shown once.
    let (code, out) = command(&config, &["admin", "api-key", "nobody"]);
    assert_eq!(
        (code, out.contains("no active account is nobody")),
        (Some(1), true),
        "{out}"
    );
    let (code, out) = command(&config, &["admin", "api-key", "root", "--scope", "everything"]);
    assert_eq!((code, out.contains("everything")), (Some(1), true), "{out}");
    let (code, out) = command(
        &config,
        &["admin", "api-key", "root", "--scope", "manage_users", "--days", "30"],
    );
    assert_eq!(code, Some(0), "{out}");
    let secret = out
        .lines()
        .find(|line| line.starts_with("plk_"))
        .unwrap_or_else(|| panic!("{out}"));
    let users = rpc(addr, "UserService/ListUsers", Some(secret), json!({}));
    assert_eq!(users["users"][0]["handle"], "root", "{users}");
    stop(child);
    let audit: Option<String> = sqlx::query_scalar(
        "SELECT actor_user_id::text FROM audit_events WHERE action = 'password_setup.create' ORDER BY id DESC LIMIT 1",
    )
    .fetch_one(&db.pool)
    .await
    .unwrap();
    assert_eq!(audit, None, "made on the host, by no account");

    std::fs::remove_file(&key).unwrap();
    let (code, stderr) = failed_start(dir.path(), &yaml);
    assert_eq!(code, Some(1), "{stderr}");
    assert!(
        stderr.contains(&key.display().to_string()) && stderr.contains("backup"),
        "{stderr}"
    );
    assert!(!key.exists(), "no new key replaces the one the passwords need");
}

/// A new instance running `roles`, whose first administrator `root` (root@example.org) was created and has no password
/// yet: the process, its address, its data directory and the administrator's password setup token.
fn set_up(dir: &Path, url: &str, roles: &str) -> (Group, SocketAddr, std::path::PathBuf, String) {
    let data_dir = dir.join("data");
    std::fs::create_dir(&data_dir).unwrap();
    let yaml = format!(
        "config_version: 1\nroles: [{roles}]\nlisten: 127.0.0.1:0\ndata_dir: {}\ndatabase:\n  url: \"{url}\"\n",
        data_dir.display()
    );
    let (child, lines, addr) = listening(dir, &yaml);
    let token = lines.iter().find_map(|line| line["fields"]["setup_token"].as_str());
    let root = serde_json::json!({ "handle": "root", "displayName": "Root", "email": "root@example.org" });
    let request = serde_json::json!({ "setupToken": token.unwrap(), "user": root });
    let created = rpc(addr, "SetupService/CreateFirstAdmin", None, request);
    let setup = created["passwordSetup"]["token"].as_str().unwrap().to_string();
    (child, addr, data_dir, setup)
}

/// Each account that may upload gets its managed library "Photos" on the store of new libraries, as its upload target,
/// which the admin console lists: the first administrator and the accounts they create, but no viewer.
#[tokio::test(flavor = "multi_thread")]
async fn each_new_account_that_may_upload_gets_a_managed_library_to_upload_into() {
    use serde_json::json;

    let db = photolib_db::testpg::database().await;
    let dir = tempfile::tempdir().unwrap();
    let (child, addr, data_dir, setup) = set_up(dir.path(), &db.url, "api, scheduler, worker:io");
    set_password(addr, &setup, b"pw");
    let session = sign_in(addr, "root", b"pw");
    for (handle, role) in [("kid", "USER_ROLE_USER"), ("guest", "USER_ROLE_VIEWER")] {
        let user = json!({ "handle": handle, "displayName": handle, "role": role });
        rpc(addr, "UserService/CreateUser", Some(&session), json!({ "user": user }));
    }
    let open = "SELECT count(*) FROM jobs WHERE type = 'library-create' AND status <> 'done'";
    let started = Running::start();
    while sqlx::query_scalar::<_, i64>(open).fetch_one(&db.pool).await.unwrap() > 0 {
        assert!(
            started.elapsed() < TOOL,
            "the libraries were not created within {TOOL:?}"
        );
        tokio::time::sleep(Duration::from_millis(50)).await;
    }
    let libraries: Vec<(String, String, String, String, bool)> = sqlx::query_as(
        "SELECT u.handle, l.id::text, l.name, l.store, l.is_upload_target FROM libraries l
         JOIN users u ON u.id = l.owner_id WHERE l.kind = 'managed' ORDER BY u.handle",
    )
    .fetch_all(&db.pool)
    .await
    .unwrap();
    let made: Vec<_> = (libraries.iter())
        .map(|(handle, _, name, store, target)| (handle.as_str(), name.as_str(), store.as_str(), *target))
        .collect();
    assert_eq!(
        made,
        [("kid", "Photos", "local", true), ("root", "Photos", "local", true)]
    );
    let status = rpc(addr, "AdminService/GetStatus", Some(&session), json!({}));
    let mut listed: Vec<(String, String)> = (status["libraries"].as_array().unwrap().iter())
        .map(|l| {
            (
                l["ownerHandle"].as_str().unwrap().into(),
                l["libraryId"].as_str().unwrap().into(),
            )
        })
        .collect();
    listed.sort();
    let ids: Vec<(String, String)> = (libraries.iter())
        .map(|(handle, id, ..)| (handle.clone(), id.clone()))
        .collect();
    assert_eq!(listed, ids, "the console lists them, for `photolib upload --library`");
    for (_, id, ..) in &libraries {
        let marker = data_dir.join(format!("libraries/{id}/.photolib/library.json"));
        assert!(marker.is_file(), "{}", marker.display());
    }
    stop(child);
}

/// When setup stopped before the first administrator had a password, `photolibd admin password-setup` prints a token
/// for the account, named by its handle or email, with which it sets one in the apps; each token replaces the one
/// before, for seven days, and is audited as made on the host.
#[tokio::test(flavor = "multi_thread")]
async fn password_setup_prints_a_token_with_which_an_account_sets_a_password() {
    let db = photolib_db::testpg::database().await;
    let dir = tempfile::tempdir().unwrap();
    let (child, addr, ..) = set_up(dir.path(), &db.url, "api");
    let config = dir.path().join("photolib.yaml");
    let mut tokens = vec![];
    for account in ["Root@Example.org", "root"] {
        let (code, out) = command(&config, &["admin", "password-setup", account]);
        assert_eq!(code, Some(0), "{out}");
        let mut lines = out
            .lines()
            .skip_while(|line| !line.starts_with("A password setup token for root,"));
        tokens.push(lines.nth(1).unwrap_or_else(|| panic!("{out}")).to_string());
    }
    let root: String = sqlx::query_scalar("SELECT id::text FROM users WHERE handle = 'root'")
        .fetch_one(&db.pool)
        .await
        .unwrap();
    let stored: Vec<(Vec<u8>, i64)> = sqlx::query_as(
        "SELECT token_hash, extract(EPOCH FROM expires_at - now())::bigint FROM password_setups WHERE user_id = $1::uuid",
    )
    .bind(&root)
    .fetch_all(&db.pool)
    .await
    .unwrap();
    let [(hash, left)] = &stored[..] else {
        panic!("{stored:?}")
    };
    assert_eq!(
        hash,
        &photolib_server::auth::token_hash(&tokens[1]),
        "the newer replaces the older"
    );
    assert!((7 * 86_400 - 60..=7 * 86_400).contains(left), "{left}");
    let audited: Vec<(Option<String>, String)> = sqlx::query_as(
        "SELECT actor_user_id::text, target ->> 'user_id' FROM audit_events WHERE action = 'password_setup.create'
         ORDER BY id OFFSET 1",
    )
    .fetch_all(&db.pool)
    .await
    .unwrap();
    assert_eq!(audited, vec![(None, root); 2]);
    set_password(addr, &tokens[1], b"pw");
    sign_in(addr, "root@example.org", b"pw");
    let (code, out) = command(&config, &["admin", "password-setup", "nobody"]);
    assert_eq!(code, Some(1), "{out}");
    assert!(out.contains("no active account is nobody"), "{out}");
    stop(child);
}

/// `photolibd doctor` asks the running photolibd, which saw how the API's requests arrived, and checks on its own
/// when none answers; the bundle carries the checks and the log.
#[tokio::test(flavor = "multi_thread")]
async fn doctor_reports_through_the_running_server_and_alone_without_it() {
    let db = photolib_db::testpg::database().await;
    let dir = tempfile::tempdir().unwrap();
    let data_dir = dir.path().join("data");
    std::fs::create_dir(&data_dir).unwrap();
    let yaml = format!(
        "config_version: 1\nroles: [api]\nlisten: 127.0.0.1:0\nmetrics: {{token: {TOKEN}}}\ndata_dir: {}\ndatabase:\n  url: \"{}\"\n",
        data_dir.display(),
        db.url
    );
    let mut child = photolibd(dir.path(), &yaml);
    let logs = log_lines(child.stderr.take().unwrap());
    let api = addr(&next_message(&logs, "listening"));
    let config = dir.path().join("photolib.yaml");
    // What doctor reads to ask the running photolibd, as a fixed port would be (photolib-design#501).
    let yaml = yaml.replace("127.0.0.1:0", &api.to_string());
    std::fs::write(&config, &yaml).unwrap();
    let mut stream = TcpStream::connect(api).unwrap();
    write!(
        stream,
        "POST /photolib.api.v1.ServerInfoService/GetServerInfo HTTP/1.1\r\nHost: photos.example.org\r\n\
         X-Forwarded-For: 203.0.113.9\r\nX-Forwarded-Proto: https\r\nContent-Type: application/json\r\n\
         Content-Length: 2\r\nConnection: close\r\n\r\n{{}}"
    )
    .unwrap();
    stream.read_to_string(&mut String::new()).unwrap();
    let bundle = dir.path().join("bundle.json");
    let (code, out) = command(&config, &["doctor", "--bundle", bundle.to_str().unwrap()]);
    // The test clusters run without fsync, for speed.
    assert_eq!(code, Some(1), "{out}");
    for line in [
        "fail postgres: fsync is off",
        "ok   config: valid",
        "ok   schema: no drift",
        "ok   instance marker: instance ",
        "ok   store local: online",
        "ok   proxy: requests arrive through a reverse proxy over HTTPS",
    ] {
        assert!(out.contains(line), "{line} in {out}");
    }
    let bundle: serde_json::Value = serde_json::from_slice(&std::fs::read(&bundle).unwrap()).unwrap();
    assert!(bundle["log"].to_string().contains("listening"), "{bundle}");
    assert_eq!(bundle["config"]["database.url"], "[redacted]");
    assert_eq!(bundle["config"]["roles"], serde_json::json!(["api"]));
    child.signal(Signal::SIGTERM);
    assert!(wait(&mut child, Duration::from_secs(10)).success());

    let (code, out) = command(&config, &["doctor"]);
    assert_eq!(code, Some(1), "{out}");
    assert!(out.contains("warn proxy: only the running photolibd sees"), "{out}");
    assert!(out.contains("ok   store local: online"), "{out}");
    std::fs::write(&config, yaml.replace(&db.url, "postgres://nobody@127.0.0.1:1/none")).unwrap();
    let (code, out) = command(&config, &["doctor"]);
    assert_eq!(code, Some(1), "{out}");
    assert!(out.contains("fail postgres: pool timed out"), "{out}");
}

#[test]
fn models_import_installs_a_bundle_offline_and_asks_before_a_bring_your_own_licence() {
    let dir = tempfile::tempdir().unwrap();
    let data = dir.path().join("data");
    let config = dir.path().join("photolib.yaml");
    let yaml = format!("config_version: 1\nroles: [ml]\ndata_dir: {}\n", data.display());
    std::fs::write(&config, yaml).unwrap();
    // A tar of `<model>/manifest.json` and `<model>/<file>` holding "their weights", for `licence` and `id@revision`.
    let bundle = |model: &str, file: &str, spdx: &str| {
        let (id, revision) = model.split_once('@').unwrap();
        let manifest = serde_json::json!({
            "id": id, "revision": revision, "task": "face_detection",
            "licence": {"spdx": spdx, "source": "https://example.org/terms"},
            "files": [{"name": file, "size": 13, "targets": ["server"],
                       "sha256": "50e8b37229b0292fdd42b42db2a23b45148b386d0686171e01a8d5bf3025b5ec"}]
        });
        let root = dir.path().join(format!("{model}.bundle"));
        std::fs::create_dir_all(root.join(model)).unwrap();
        std::fs::write(root.join(model).join("manifest.json"), manifest.to_string()).unwrap();
        std::fs::write(root.join(model).join(file), "their weights").unwrap();
        let tar = dir.path().join(format!("{model}.tar"));
        let tarred = output(tool("tar").arg("-cf").arg(&tar).arg("-C").arg(&root).arg("."), TOOL);
        assert!(tarred.status.success());
        tar.display().to_string()
    };

    let byo = bundle("byo@1", "w.onnx", "CC-BY-NC-4.0");
    let (code, out) = command(&config, &["models", "import", &byo]);
    assert_eq!(code, Some(1), "{out}");
    assert!(
        out.contains("WARNING: byo@1 is bring-your-own") && out.contains("--accept-licence CC-BY-NC-4.0"),
        "{out}"
    );
    assert!(!data.join("models/byo@1").exists());
    let (code, out) = command(&config, &["models", "import", &byo, "--accept-licence", "CC-BY-NC-4.0"]);
    assert_eq!(code, Some(0), "{out}");
    assert!(
        out.contains("WARNING: byo@1 is bring-your-own") && out.contains("imported byo@1"),
        "{out}"
    );
    assert_eq!(
        std::fs::read(data.join("models/byo@1/w.onnx")).unwrap(),
        b"their weights"
    );

    let fake = bundle("yunet@2026may", "face_detection_yunet_2026may.onnx", "MIT");
    let (code, out) = command(&config, &["models", "import", &fake]);
    assert_eq!(code, Some(1), "{out}");
    assert!(
        out.contains("yunet@2026may: face_detection_yunet_2026may.onnx does not match its SHA-256"),
        "{out}"
    );

    let (code, out) = command(&config, &["models", "fetch", "insightface"]);
    assert_eq!(code, Some(1), "{out}");
    assert!(out.contains("insightface is not in the registry"), "{out}");
    std::fs::write(
        &config,
        format!(
            "config_version: 1\nroles: [ml]\ndata_dir: {}\noutbound: none\n",
            data.display()
        ),
    )
    .unwrap();
    let (code, out) = command(&config, &["models", "fetch"]);
    assert_eq!(code, Some(1), "{out}");
    assert!(out.contains("outbound: none") && out.contains("models import"), "{out}");
}

fn diagnostics(addr: SocketAddr) -> serde_json::Value {
    let response = raw(
        addr,
        &format!(
            "GET /diagnostics HTTP/1.1\r\nHost: test\r\nAuthorization: Bearer {TOKEN}\r\nConnection: close\r\n\r\n"
        ),
    );
    let (_, body) = response.split_once("\r\n\r\n").unwrap();
    serde_json::from_str(body).unwrap()
}

fn ml_check(addr: SocketAddr) -> serde_json::Value {
    let checks = diagnostics(addr)["checks"].as_array().unwrap().clone();
    checks.into_iter().find(|c| c["name"] == "ml").unwrap_or_default()
}

/// A remote ML node as an operator runs one, without a database: on ONNX Runtime's official library it self-tests
/// the face models, and reports them to the API with its token, under glibc's settings for ML (ADR-0245).
#[tokio::test(flavor = "multi_thread")]
async fn an_ml_node_self_tests_its_models_and_reports_them_to_the_api_with_its_token() {
    let (library, models, _) = photolib_ml::testing::onnx();
    let db = photolib_db::testpg::database().await;
    let (api_dir, node_dir) = (tempfile::tempdir().unwrap(), tempfile::tempdir().unwrap());
    let data_dir = api_dir.path().join("data");
    std::fs::create_dir(&data_dir).unwrap();
    let ml_token = "node-token-node-token-node-token";
    let (api, _, api_addr) = listening(
        api_dir.path(),
        &format!(
            "config_version: 1\nroles: [api]\nlisten: 127.0.0.1:0\nmetrics: {{token: {TOKEN}}}\ndata_dir: {}\n\
             database:\n  url: \"{}\"\nml: {{token: {ml_token}}}\n",
            data_dir.display(),
            db.url
        ),
    );
    assert_eq!(ml_check(api_addr)["status"], "warn", "no node has reported yet");
    let (node, lines, node_addr) = listening(
        node_dir.path(),
        &format!(
            "{ML}metrics: {{token: {TOKEN}}}\nml:\n  runtime: {}\n  models_dir: {}\n  server: http://{api_addr}\n  token: {ml_token}\n",
            library.display(),
            models.path().display()
        ),
    );
    let environ = std::fs::read(format!("/proc/{}/environ", node.id())).unwrap();
    assert!(
        String::from_utf8_lossy(&environ).contains("MALLOC_ARENA_MAX=2"),
        "{lines:?}"
    );
    let started = Running::start();
    let reported = loop {
        let check = ml_check(api_addr);
        if check["detail"].as_str().unwrap_or_default().contains("sface") {
            break check;
        }
        assert!(started.elapsed() < Duration::from_secs(120), "no report: {check}");
        thread::sleep(Duration::from_millis(200));
    };
    assert_eq!(reported["status"], "ok", "{reported}");
    for file in [
        "yunet@2026may/face_detection_yunet_2026may.onnx on cpu",
        "sface@2021dec/face_recognition_sface_2021dec.onnx on cpu",
    ] {
        assert!(reported["detail"].as_str().unwrap().contains(file), "{reported}");
    }
    assert_eq!(
        ml_check(node_addr)["detail"],
        reported["detail"],
        "the node's own diagnostics say the same"
    );
    assert!(
        !scrape(node_addr).contains("photolib_ml_backend_disabled{"),
        "no backend is disabled"
    );
    stop(node);
    stop(api);
}
