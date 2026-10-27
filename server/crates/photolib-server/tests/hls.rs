//! Adaptive streaming (photolib-design docs/08 §5.1, §5.4, §5.8; ADR-0246): a video's HLS ladder as players fetch it
//! from `/media/{asset}/hls/`: the stored R1 in slices, the other rungs encoded on demand in any order, sessions that
//! pause ahead of the player and stop when idle, the segment cache, object stores, access and the resume position.

use std::{
    path::{Path, PathBuf},
    sync::Arc,
    time::{Duration, Instant},
};

use axum::{
    Router,
    body::Body,
    http::{HeaderMap, Request, StatusCode},
};
use photolib_db::{
    migrate::{Upgrade, embedded, upgrade},
    testpg,
};
use photolib_jobs::{NewJob, Timing, Worker};
use photolib_server::{
    accounts::Accounts,
    db::DbError,
    external::Libraries,
    hls::{Hls, Room},
    keys::ApiKeys,
    media::Media,
    rpc::{Caller, Sessions, Users},
    video::{Ffmpeg, TRANSCODE, Transcode},
};
use photolib_spawn::{output, tool};
use photolib_storage::{
    BlobStore, Hash,
    fs::FsStore,
    journal::Journal,
    marker::{Candidate, Stores},
    testing::garage_store,
};
use serde_json::Value;
use tokio_util::sync::CancellationToken;
use tower::ServiceExt;
use uuid::Uuid;

const PHOTOLIBD: &str = env!("CARGO_BIN_EXE_photolibd");
const LIMIT: Duration = Duration::from_secs(300);

/// The pinned FFmpeg (`tools/video/ffmpeg.sh`), or the directory `TEST_FFMPEG` names.
fn tools() -> PathBuf {
    if let Some(dir) = std::env::var_os("TEST_FFMPEG") {
        return dir.into();
    }
    let script = Path::new(env!("CARGO_MANIFEST_DIR")).join("../../../tools/video/ffmpeg.sh");
    let done = output(tool("bash").arg(&script), Duration::from_secs(600));
    assert!(done.status.success(), "{}", String::from_utf8_lossy(&done.stderr));
    PathBuf::from(String::from_utf8(done.stdout).unwrap().trim())
}

fn run(tools: &Path, name: &str, args: &[&str]) -> Vec<u8> {
    let done = output(tool(tools.join(name)).args(["-v", "error"]).args(args), LIMIT);
    assert!(
        done.status.success(),
        "{name} {args:?}: {}",
        String::from_utf8_lossy(&done.stderr)
    );
    done.stdout
}

/// `seconds` of H.264 `height` pixels high at 16:9 and 30 fps with sound, in Matroska, which R1 must replace; or, for
/// `hdr`, of 10-bit AV1 tagged as HDR10 (BT.2020, PQ) in MP4, with a key frame every 2 s.
fn clip(tools: &Path, dir: &Path, seconds: u32, height: u32, hdr: bool) -> PathBuf {
    if hdr {
        let (coded, file) = (dir.join("coded.mp4"), dir.join("clip.mp4"));
        let size = format!("{}x{height}", height * 16 / 9);
        let source = format!("testsrc2=s={size}:r=30:d={seconds}[v];sine=r=48000:d={seconds}[a]");
        let args = [
            "-filter_complex",
            &source,
            "-map",
            "[v]",
            "-map",
            "[a]",
            "-c:v",
            "libsvtav1",
            "-preset",
            "12",
            "-svtav1-params",
            "lp=1",
            "-g",
            "60",
            "-pix_fmt",
            "yuv420p10le",
            "-c:a",
            "aac",
            "-threads",
            "2",
            coded.to_str().unwrap(),
        ];
        run(tools, "ffmpeg", &args);
        // The encoder's wrapper drops the transfer and the primaries; the sequence header says them.
        let colours = "av1_metadata=color_primaries=9:transfer_characteristics=16:matrix_coefficients=9";
        let args = [
            "-i",
            coded.to_str().unwrap(),
            "-c",
            "copy",
            "-bsf:v",
            colours,
            file.to_str().unwrap(),
        ];
        run(tools, "ffmpeg", &args);
        return file;
    }
    let file = dir.join("clip.mkv");
    let size = format!("{}x{height}", height * 16 / 9);
    let source = format!("testsrc2=s={size}:r=30:d={seconds}[v];sine=r=48000:d={seconds}[a]");
    let args = [
        "-filter_complex",
        &source,
        "-map",
        "[v]",
        "-map",
        "[a]",
        "-c:v",
        "libopenh264",
        "-b:v",
        "4M",
    ];
    let mut args = args.to_vec();
    args.extend(["-c:a", "aac", "-threads", "2", file.to_str().unwrap()]);
    run(tools, "ffmpeg", &args);
    file
}

/// The status of the `transcode` job that renders R1 of `asset` with `transcode`, once it ends.
async fn r1(pool: &sqlx::PgPool, transcode: Transcode, asset: Uuid) -> String {
    let mut conn = pool.acquire().await.unwrap();
    let payload = format!(r#"{{"asset": "{asset}", "role": "video_proxy_720"}}"#);
    photolib_jobs::enqueue(&mut conn, &NewJob::new(TRANSCODE, payload.as_bytes()))
        .await
        .unwrap();
    let timing = Timing {
        poll_min: Duration::from_millis(10),
        poll_max: Duration::from_millis(50),
        ..Timing::default()
    };
    let shutdown = CancellationToken::new();
    let worker = Worker::new(pool.clone(), "test", 1, timing).handle(TRANSCODE, transcode);
    let running = tokio::spawn(worker.run(shutdown.clone()));
    let status = loop {
        let done = "SELECT status || coalesce(': ' || error, '') FROM jobs";
        let status: String = sqlx::query_scalar(done).fetch_one(pool).await.unwrap();
        if !status.starts_with("queued") && !status.starts_with("running") {
            break status;
        }
        tokio::time::sleep(Duration::from_millis(50)).await;
    };
    shutdown.cancel();
    running.await.unwrap();
    status
}

/// `Authorization: Bearer <user id>` signs a request as that user.
struct Bearer;

#[async_trait::async_trait]
impl Sessions for Bearer {
    async fn caller(&self, headers: &HeaderMap) -> Result<Option<Caller>, DbError> {
        let bearer = headers
            .get("authorization")
            .and_then(|value| value.to_str().ok()?.strip_prefix("Bearer ")?.parse().ok());
        Ok(bearer.map(|user| Caller {
            user,
            device: Uuid::nil(),
            session: Uuid::nil(),
            must_enrol: false,
        }))
    }
}

/// Ann's video, with its R1 rendered by its `transcode` job, on `store`; Bea, who may not see it.
struct Server {
    app: Router,
    pool: sqlx::PgPool,
    journal: Arc<Journal>,
    libraries: Arc<Libraries>,
    ann: Uuid,
    bea: Uuid,
    asset: Uuid,
    proxy: Vec<u8>,
    cache: PathBuf,
    tools: PathBuf,
    shutdown: CancellationToken,
    _dir: tempfile::TempDir,
    _db: testpg::TestDb,
}

/// A server of a video of `seconds` at `height`, its ladder of `sessions` with a cache of `bytes`.
async fn server(
    store: Arc<dyn BlobStore>,
    seconds: u32,
    height: u32,
    sessions: usize,
    bytes: u64,
    idle: Duration,
) -> Server {
    server_of(false, store, seconds, height, sessions, bytes, idle).await
}

/// `server`, of an HDR10 video when `hdr`.
async fn server_of(
    hdr: bool,
    store: Arc<dyn BlobStore>,
    seconds: u32,
    height: u32,
    sessions: usize,
    bytes: u64,
    idle: Duration,
) -> Server {
    let tools = tools();
    let dir = tempfile::tempdir_in(env!("CARGO_TARGET_TMPDIR")).unwrap();
    let video = tokio::task::block_in_place(|| clip(&tools, dir.path(), seconds, height, hdr));
    let mime = if hdr { "video/mp4" } else { "video/x-matroska" };
    let db = testpg::database().await;
    upgrade(&db.pool, &Upgrade::new(&embedded())).await.unwrap();
    let candidate = Candidate {
        name: "media".into(),
        store: store.clone(),
        adopt: true,
    };
    let stores = Stores::check(&db.pool, Uuid::now_v7(), vec![candidate]).await;
    let journal = Arc::new(Journal::start(db.pool.clone(), stores).await.unwrap());
    let (ann, bea, library, asset) = (Uuid::now_v7(), Uuid::now_v7(), Uuid::now_v7(), Uuid::now_v7());
    let bytes_of = std::fs::read(&video).unwrap();
    let (key, hash) = (format!("libraries/{library}/originals/{asset}"), Hash::of(&bytes_of));
    sqlx::raw_sql(&format!(
        "INSERT INTO users (id, handle, display_name) VALUES ('{ann}', 'ann', 'Ann'), ('{bea}', 'bea', 'Bea');
         INSERT INTO libraries (id, owner_id, name, kind, privacy, root_uri, store)
         VALUES ('{library}', '{ann}', 'Photos', 'managed', 'standard', 'photos', 'media');
         INSERT INTO assets (id, library_id, owner_id, source, media_kind)
         VALUES ('{asset}', '{library}', '{ann}', 'upload', 'video')"
    ))
    .execute(&db.pool)
    .await
    .unwrap();
    let op = journal.put("media", &key, &video, hash).await.unwrap();
    let mut tx = db.pool.begin().await.unwrap();
    sqlx::query(
        "INSERT INTO asset_files (id, asset_id, role, storage, key, mime, size, content_hash)
         VALUES ($1, $2, 'original', 'media', $3, $6, $4, $5)",
    )
    .bind(Uuid::now_v7())
    .bind(asset)
    .bind(&key)
    .bind(i64::try_from(bytes_of.len()).unwrap())
    .bind(hash.0.to_vec())
    .bind(mime)
    .execute(&mut *tx)
    .await
    .unwrap();
    op.settle(&mut tx).await.unwrap();
    tx.commit().await.unwrap();

    let libraries = Arc::new(Libraries::new(Duration::from_secs(30)));
    let transcode = Transcode::new(
        journal.clone(),
        &dir.path().join("work"),
        Ffmpeg::new(PHOTOLIBD.into(), tools.clone(), 2).unwrap(),
        libraries.clone(),
    );
    assert_eq!(r1(&db.pool, transcode.unwrap(), asset).await, "done");
    let proxy_key: String = sqlx::query_scalar("SELECT key FROM asset_files WHERE role = 'video_proxy_720'")
        .fetch_one(&db.pool)
        .await
        .unwrap();
    let proxy = store.get(&proxy_key, None).await.unwrap();

    let mut server = Server {
        app: Router::new(),
        pool: db.pool.clone(),
        journal,
        libraries,
        ann,
        bea,
        asset,
        proxy,
        cache: dir.path().join("streaming"),
        tools,
        shutdown: CancellationToken::new(),
        _dir: dir,
        _db: db,
    };
    server.app = server.app(sessions, bytes, idle).await;
    server
}

impl Drop for Server {
    fn drop(&mut self) {
        self.shutdown.cancel();
    }
}

type Answer = (StatusCode, HeaderMap, Vec<u8>);

impl Server {
    /// photolibd's media endpoints with a ladder of `sessions` and a cache of `bytes` in `cache`, emptied.
    async fn app(&self, sessions: usize, bytes: u64, idle: Duration) -> Router {
        let room = Room {
            dir: self.cache.clone(),
            bytes,
            sessions,
            idle,
        };
        let ffmpeg = Ffmpeg::new(PHOTOLIBD.into(), self.tools.clone(), sessions.max(1)).unwrap();
        let (pool, journal) = (self.pool.clone(), self.journal.clone());
        let hls = Arc::new(
            Hls::new(
                pool.clone(),
                journal.clone(),
                self.libraries.clone(),
                Some(ffmpeg),
                room,
            )
            .unwrap(),
        );
        tokio::spawn(hls.clone().run(self.shutdown.child_token()));
        let users = Users::start(
            Accounts::new(pool.clone()),
            ApiKeys::new(pool.clone()),
            Arc::new(Bearer),
        );
        let media = Media::new(pool, journal, Arc::new(users.await.unwrap()), [7; 32]).with_hls(hls);
        photolib_server::media::router(Arc::new(media))
    }

    async fn send(&self, method: &str, uri: &str, user: Option<Uuid>, body: &str) -> Answer {
        let mut request = Request::builder().method(method).uri(uri);
        if let Some(user) = user {
            request = request.header("authorization", format!("Bearer {user}"));
        }
        let request = request.body(Body::from(body.to_owned())).unwrap();
        let response = self.app.clone().oneshot(request).await.unwrap();
        let (parts, body) = response.into_parts();
        let body = axum::body::to_bytes(body, usize::MAX).await.unwrap();
        (parts.status, parts.headers, body.to_vec())
    }

    async fn get(&self, uri: &str, user: Option<Uuid>) -> Answer {
        self.send("GET", uri, user, "").await
    }

    /// Ann's master playlist, with `query`.
    async fn master(&self, query: &str) -> String {
        let (status, headers, body) = self
            .get(&format!("/media/{}/hls/master.m3u8{query}", self.asset), Some(self.ann))
            .await;
        assert_eq!(status, StatusCode::OK, "{}", String::from_utf8_lossy(&body));
        assert_eq!(headers["content-type"], "application/vnd.apple.mpegurl");
        String::from_utf8(body).unwrap()
    }

    /// The rung `name` as a player reads it, signed as the master playlist signs: its playlist, its init segment's URI
    /// and its segments' URIs.
    async fn rung(&self, name: &str) -> (String, String, Vec<String>) {
        self.rung_of("", name).await
    }

    /// `rung`, of the master playlist asked with `query`.
    async fn rung_of(&self, query: &str, name: &str) -> (String, String, Vec<String>) {
        let base = format!("/media/{}/hls/", self.asset);
        let master = self.master(query).await;
        let token = master.lines().find_map(|l| l.split_once(".m3u8?t=")).unwrap().1;
        let (status, _, playlist) = self.get(&format!("{base}{name}.m3u8?t={token}"), None).await;
        assert_eq!(status, StatusCode::OK);
        let playlist = String::from_utf8(playlist).unwrap();
        let init = playlist
            .split("#EXT-X-MAP:URI=\"")
            .nth(1)
            .unwrap()
            .split('"')
            .next()
            .unwrap();
        let segments = playlist
            .lines()
            .filter(|l| !l.starts_with('#'))
            .map(|l| format!("{base}{l}"))
            .collect();
        (playlist.clone(), format!("{base}{init}"), segments)
    }

    /// `uri` as a player fetches it: again after a 503 for as long as it says, which a loaded machine may answer.
    async fn fetch(&self, uri: &str) -> Vec<u8> {
        let deadline = Instant::now() + LIMIT;
        loop {
            let (status, headers, body) = self.get(uri, None).await;
            if status == StatusCode::SERVICE_UNAVAILABLE && Instant::now() < deadline {
                let after = headers["retry-after"].to_str().unwrap().parse().unwrap();
                tokio::time::sleep(Duration::from_secs(after)).await;
                continue;
            }
            assert_eq!(status, StatusCode::OK, "{uri}: {headers:?}");
            assert_eq!(headers["cache-control"], "private, max-age=31536000, immutable");
            return body;
        }
    }

    /// What a player plays of rung `name`, fetching its segments in `order`: the init segment, then each in turn.
    async fn play(&self, name: &str, order: &[usize]) -> Vec<u8> {
        self.play_of("", name, order).await
    }

    /// `play`, of the master playlist asked with `query`.
    async fn play_of(&self, query: &str, name: &str, order: &[usize]) -> Vec<u8> {
        let (_, init, segments) = self.rung_of(query, name).await;
        let mut fetched = vec![None; segments.len()];
        for n in order.iter().copied().chain(0..segments.len()) {
            if fetched[n].is_none() {
                fetched[n] = Some(self.fetch(&segments[n]).await);
            }
        }
        let mut bytes = self.fetch(&init).await;
        bytes.extend(fetched.into_iter().flatten().flatten());
        bytes
    }

    /// The width, height, seconds and video timestamps of `bytes`, which must decode whole, with sound.
    fn decode(&self, bytes: &[u8]) -> (u64, u64, f64, Vec<f64>) {
        let file = tempfile::NamedTempFile::new_in(env!("CARGO_TARGET_TMPDIR")).unwrap();
        std::fs::write(file.path(), bytes).unwrap();
        let path = file.path().to_str().unwrap();
        run(&self.tools, "ffmpeg", &["-xerror", "-i", path, "-f", "null", "-"]);
        let probe = run(
            &self.tools,
            "ffprobe",
            &["-print_format", "json", "-show_streams", "-show_format", path],
        );
        let probe: Value = serde_json::from_slice(&probe).unwrap();
        let streams = probe["streams"].as_array().unwrap();
        assert!(
            streams
                .iter()
                .any(|s| s["codec_type"] == "audio" && s["codec_name"] == "aac")
        );
        let video = streams.iter().find(|s| s["codec_type"] == "video").unwrap();
        let packets = run(
            &self.tools,
            "ffprobe",
            &[
                "-select_streams",
                "v",
                "-show_entries",
                "packet=pts_time",
                "-of",
                "csv=p=0",
                path,
            ],
        );
        let mut times: Vec<f64> = String::from_utf8(packets)
            .unwrap()
            .lines()
            .map(|l| l.parse().unwrap())
            .collect();
        times.sort_by(f64::total_cmp);
        let seconds = probe["format"]["duration"].as_str().unwrap().parse().unwrap();
        (
            video["width"].as_u64().unwrap(),
            video["height"].as_u64().unwrap(),
            seconds,
            times,
        )
    }

    /// The pieces the rung `name` has in the cache.
    fn pieces(&self, name: &str) -> usize {
        let dirs = std::fs::read_dir(&self.cache).unwrap().flatten();
        let dir = dirs
            .map(|e| e.path())
            .find(|p| p.file_name().unwrap().to_string_lossy().starts_with(name));
        dir.map_or(0, |dir| {
            let files = std::fs::read_dir(dir).unwrap().flatten();
            files
                .filter(|f| f.file_name().to_string_lossy().ends_with(".m4s"))
                .count()
        })
    }
}

/// The processes whose command line names the cache, with their state (`T` when stopped).
fn encoders(cache: &Path) -> Vec<char> {
    let name = cache.to_string_lossy().into_owned();
    (std::fs::read_dir("/proc").unwrap().flatten())
        .filter(|p| {
            String::from_utf8_lossy(&std::fs::read(p.path().join("cmdline")).unwrap_or_default()).contains(&name)
        })
        .filter_map(|p| {
            let stat = std::fs::read_to_string(p.path().join("stat")).ok()?;
            stat[stat.rfind(')')? + 2..].chars().next()
        })
        .collect()
}

async fn until(what: &str, mut done: impl FnMut() -> bool) {
    let deadline = Instant::now() + LIMIT;
    while !done() {
        assert!(Instant::now() < deadline, "timed out waiting for {what}");
        tokio::time::sleep(Duration::from_millis(100)).await;
    }
}

async fn local() -> Arc<dyn BlobStore> {
    let dir = tempfile::tempdir_in(env!("CARGO_TARGET_TMPDIR")).unwrap().keep();
    Arc::new(FsStore::open(&dir, Duration::from_secs(30)).await.unwrap())
}

/// An HDR original is offered, to clients that say they show HDR, as a variant of its own beside the SDR ones: the
/// original's pictures copied into pieces, tagged PQ, with its sound, which plays whole; clients that do not say so,
/// the data saver and videos that are SDR never see it (ADR-0390).
#[tokio::test(flavor = "multi_thread")]
async fn an_hdr_original_is_offered_as_a_variant_of_its_own_to_clients_that_ask() {
    let server = server_of(true, local().await, 6, 360, 2, 1 << 30, Duration::from_secs(30)).await;
    let plain = server.master("").await;
    assert!(!plain.contains("VIDEO-RANGE") && !plain.contains("hdr.m3u8"), "{plain}");
    let master = server.master("?hdr=1").await;
    let variants: Vec<&str> = master.lines().filter(|l| l.starts_with("#EXT-X-STREAM-INF")).collect();
    let last = variants.last().unwrap();
    assert!(
        last.contains("VIDEO-RANGE=PQ") && last.contains("RESOLUTION=640x360,"),
        "{master}"
    );
    assert!(
        last.contains("CODECS=\"av01.0.") && last.contains(",mp4a.40.2\""),
        "{last}"
    );
    assert!(
        variants[..variants.len() - 1]
            .iter()
            .all(|v| !v.contains("VIDEO-RANGE")),
        "SDR variants are SDR: {master}"
    );
    let names: Vec<&str> = master
        .lines()
        .filter_map(|l| l.split_once(".m3u8?t="))
        .map(|(n, _)| n)
        .collect();
    assert_eq!(names.last(), Some(&"hdr"), "{names:?}");
    let saver = server.master("?saver=1&hdr=1").await;
    assert!(
        !saver.contains("hdr.m3u8"),
        "the data saver offers the lowest rung only: {saver}"
    );
    // It plays whole from its pieces, and is what the original is: AV1 at 10 bits, PQ, with AAC sound.
    let bytes = server.play_of("?hdr=1", "hdr", &[]).await;
    let (_, _, seconds, _) = server.decode(&bytes);
    assert!((seconds - 6.0).abs() < 0.3, "{seconds} s");
    let file = tempfile::NamedTempFile::new_in(env!("CARGO_TARGET_TMPDIR")).unwrap();
    std::fs::write(file.path(), &bytes).unwrap();
    let probe = run(
        &server.tools,
        "ffprobe",
        &["-print_format", "json", "-show_streams", file.path().to_str().unwrap()],
    );
    let probe: Value = serde_json::from_slice(&probe).unwrap();
    let video = probe["streams"]
        .as_array()
        .unwrap()
        .iter()
        .find(|s| s["codec_type"] == "video")
        .unwrap();
    assert_eq!(
        (
            video["codec_name"].as_str(),
            video["pix_fmt"].as_str(),
            video["color_transfer"].as_str()
        ),
        (Some("av1"), Some("yuv420p10le"), Some("smpte2084"))
    );
    // An SDR video has no such variant, whatever the client says.
    let sdr = self::server(local().await, 4, 360, 2, 1 << 30, Duration::from_secs(30)).await;
    assert!(!sdr.master("?hdr=1").await.contains("VIDEO-RANGE"));
}

/// The master playlist offers the saver rung first, the stored R1 and R2 above it, each at its size and with its
/// codecs; every rung plays whole from its segments, R1 as the very bytes of the stored proxy, and the encoded ones
/// fetched out of order, as a seek makes a player do, with one unbroken timeline.
#[tokio::test(flavor = "multi_thread")]
async fn every_rung_plays_whole_from_its_segments_fetched_in_any_order() {
    let server = server(local().await, 13, 1080, 2, 1 << 30, Duration::from_secs(30)).await;
    let master = server.master("").await;
    let variants: Vec<&str> = master.lines().filter(|l| l.starts_with("#EXT-X-STREAM-INF")).collect();
    let resolutions = ["RESOLUTION=854x480,", "RESOLUTION=1280x720,", "RESOLUTION=1920x1080,"];
    for (variant, resolution) in variants.iter().zip(resolutions) {
        assert!(variant.contains(resolution), "{variant}");
        assert!(variant.contains("CODECS=\"avc1.640029,mp4a.40.2\""), "{variant}");
    }
    let names: Vec<&str> = master
        .lines()
        .filter_map(|l| l.split_once(".m3u8?t="))
        .map(|(name, _)| name)
        .collect();
    assert_eq!(names, ["saver", "r1", "r2"]);
    let saver = server.master("?saver=1").await;
    let names: Vec<&str> = saver
        .lines()
        .filter_map(|l| l.split_once(".m3u8?t="))
        .map(|(name, _)| name)
        .collect();
    assert_eq!(names, ["saver"], "data saver");

    let (playlist, _, segments) = server.rung("r1").await;
    assert_eq!(segments.len(), 4, "{playlist}");
    assert!(playlist.contains("#EXT-X-TARGETDURATION:4\n#EXT-X-MEDIA-SEQUENCE:0\n#EXT-X-PLAYLIST-TYPE:VOD\n"));
    assert!(
        playlist.contains("#EXTINF:2.000,\n") && playlist.ends_with("#EXT-X-ENDLIST\n"),
        "{playlist}"
    );
    assert!(
        server.play("r1", &[]).await == server.proxy,
        "R1 is the stored proxy, sliced"
    );

    for (name, size) in [("saver", (854, 480)), ("r2", (1920, 1080))] {
        let bytes = server.play(name, &[3, 1, 0]).await;
        let (width, height, seconds, times) = server.decode(&bytes);
        assert_eq!((width, height), size, "{name}");
        assert!((seconds - 13.0).abs() < 0.2, "{name} lasts {seconds} s");
        assert_eq!(times.len(), 13 * 30, "{name}: every frame once");
        let gaps = times
            .windows(2)
            .filter(|w| (w[1] - w[0] - 1.0 / 30.0).abs() > 0.002)
            .count();
        assert_eq!(gaps, 0, "{name}: {times:?}");
    }
}

/// A session makes three segments beyond the furthest the player asked for and pauses, resumes when asked for more,
/// and stops once nobody asks; while every session is taken, the master playlist offers only the stored R1 and an
/// encoded segment is a 503 to try again; the cache then keeps to its budget.
#[tokio::test(flavor = "multi_thread")]
async fn a_session_pauses_ahead_of_the_player_resumes_when_asked_and_stops_when_idle() {
    let server = server(local().await, 40, 1080, 1, 1, Duration::from_secs(20)).await;
    let (_, _, segments) = server.rung("saver").await;
    server.fetch(&segments[0]).await;
    until("the session to pause", || encoders(&server.cache) == ['T']).await;
    let made = server.pieces("saver");
    assert!((7..=9).contains(&made), "{made} pieces made ahead of the first");

    let names: Vec<String> = server
        .master("")
        .await
        .lines()
        .filter_map(|l| l.split_once(".m3u8?t="))
        .map(|(n, _)| n.to_owned())
        .collect();
    assert_eq!(names, ["r1"], "no session is free");
    let (_, _, r2) = server.rung("r2").await;
    let (status, headers, _) = server.get(&r2[0], None).await;
    assert_eq!(
        (status, &headers["retry-after"]),
        (StatusCode::SERVICE_UNAVAILABLE, &"2".parse().unwrap())
    );

    server.fetch(&segments[5]).await;
    until("more pieces", || server.pieces("saver") > made + 2).await;
    until("the session to stop", || encoders(&server.cache).is_empty()).await;
    until("the cache to keep to its budget", || server.pieces("saver") == 0).await;
    assert_eq!(server.master("").await.matches("#EXT-X-STREAM-INF").count(), 3);
}

/// A file on an object store is copied into the cache once for every rung that encodes from it: R1 for the saver
/// rung, the original for R2; R1 there is sliced by ranges.
#[tokio::test(flavor = "multi_thread")]
async fn an_original_on_an_object_store_is_copied_once_for_every_rung() {
    let server = server(
        Arc::new(garage_store(Duration::from_secs(30))),
        5,
        1080,
        2,
        1 << 30,
        Duration::from_secs(30),
    )
    .await;
    assert!(
        server.play("r1", &[]).await == server.proxy,
        "R1 is the stored proxy, sliced"
    );
    for name in ["saver", "r2", "saver"] {
        server.decode(&server.play(name, &[]).await);
    }
    let copies = std::fs::read_dir(server.cache.join("sources")).unwrap().count();
    assert_eq!(copies, 2);
}

/// Nobody but who may see the video gets anything of its ladder, and a signed URI works only as it was signed;
/// where the viewer stopped is where every playlist starts.
#[tokio::test(flavor = "multi_thread")]
async fn only_viewers_stream_and_each_resumes_where_they_stopped() {
    let server = server(local().await, 13, 1080, 2, 1 << 30, Duration::from_secs(30)).await;
    let (_, init, segments) = server.rung("r1").await;
    let master = format!("/media/{}/hls/master.m3u8", server.asset);
    let forged = segments[1].replace("?t=", "?t=00");
    for (uri, user) in [
        (&master, Some(server.bea)),
        (&master, None),
        (&segments[1], Some(server.bea)),
        (&forged, None),
    ] {
        let bare = uri.split('?').next().unwrap();
        let uri = if user.is_some() { bare } else { uri };
        assert_eq!(server.get(uri, user).await.0, StatusCode::NOT_FOUND, "{uri}");
    }
    let stale = init.replacen("/r1/", "/r1/x", 1);
    assert_eq!(server.get(&stale, None).await.0, StatusCode::NOT_FOUND);
    let position = format!("/media/{}/position", server.asset);
    let (status, _, _) = server
        .send("PUT", &position, Some(server.bea), r#"{"position_ms": 6500}"#)
        .await;
    assert_eq!(status, StatusCode::NOT_FOUND);
    let (status, _, _) = server
        .send("PUT", &position, Some(server.ann), r#"{"position_ms": -1}"#)
        .await;
    assert_eq!(status, StatusCode::BAD_REQUEST);
    let (status, _, _) = server
        .send("PUT", &position, Some(server.ann), r#"{"position_ms": 6500}"#)
        .await;
    assert_eq!(status, StatusCode::NO_CONTENT);
    let kept: Option<i64> = sqlx::query_scalar("SELECT playback_position_ms FROM asset_user_state WHERE user_id = $1")
        .bind(server.ann)
        .fetch_one(&server.pool)
        .await
        .unwrap();
    assert_eq!(kept, Some(6500));
    assert!(
        server
            .master("")
            .await
            .contains("#EXT-X-START:TIME-OFFSET=6.500,PRECISE=YES\n")
    );
    assert!(
        server
            .rung("saver")
            .await
            .0
            .contains("#EXT-X-START:TIME-OFFSET=6.500,PRECISE=YES\n")
    );
    // Near the end, a video starts again.
    server
        .send("PUT", &position, Some(server.ann), r#"{"position_ms": 12000}"#)
        .await;
    assert!(!server.master("").await.contains("#EXT-X-START"));
}

/// Photolib-design#184's measure: hls.js, which the web clients play with, in Chrome and Firefox, each from a cold
/// cache, over a link of 3 Mbit/s with 40 ms round trips, starts on the saver rung; it then loads R1 once the link
/// carries 8 Mbit/s, and the saver rung again when it falls to 1.5 Mbit/s, never stalling. Its start within 2 s is
/// the budget `hls-start` (tools/perf/measure.sh), not an assertion here: a loaded machine starts a browser late.
/// Needs node, Chrome and Firefox; prints what each played.
#[tokio::test(flavor = "multi_thread")]
#[ignore = "needs node, Chrome and Firefox: the web part of tools/check.sh runs it"]
async fn hls_js_starts_on_a_3_mbit_link_and_adapts_without_stalling() {
    // 720p, whose ladder is the saver rung and R1, as R2 needs more.
    let server = server(local().await, 110, 720, 2, 1 << 30, Duration::from_secs(30)).await;
    let mut wrong = vec![];
    for browser in ["chrome", "firefox"] {
        let app = server.app(2, 1 << 30, Duration::from_secs(30)).await;
        let listener = tokio::net::TcpListener::bind("127.0.0.1:0").await.unwrap();
        let origin = format!("http://127.0.0.1:{}", listener.local_addr().unwrap().port());
        let serving = tokio::spawn(async move { axum::serve(listener, app).await });
        let (_, _, signed) = server
            .send("POST", &format!("/media/{}/hls", server.asset), Some(server.ann), "")
            .await;
        let master: Value = serde_json::from_slice(&signed).unwrap();
        let script = concat!(env!("CARGO_MANIFEST_DIR"), "/tests/hls.mjs");
        let mut node = std::process::Command::new("node");
        node.args([script, browser, &origin, master["url"].as_str().unwrap()]);
        let done = tokio::task::spawn_blocking(move || node.output())
            .await
            .unwrap()
            .unwrap();
        serving.abort();
        let said = String::from_utf8_lossy(&done.stdout);
        assert!(done.status.success(), "{said}{}", String::from_utf8_lossy(&done.stderr));
        let played: Value = serde_json::from_str(said.trim()).unwrap();
        eprintln!("{browser}: {played}");
        // The start is a time: tools/perf/measure.sh checks it against the series hls-start (budgets.json).
        let start = serde_json::json!({
            "budget": "hls-start", "metric": "start_ms", "target": browser, "value": played["start_ms"],
        });
        eprintln!("result: {start}");
        let heights: Vec<u64> = played["loaded"]
            .as_array()
            .unwrap()
            .iter()
            .map(|p| p[1].as_u64().unwrap())
            .collect();
        let checks = [
            (played["stalls"].as_array().unwrap().is_empty(), "never to stall"),
            (played["errors"].as_array().unwrap().is_empty(), "to have no error"),
            (heights.first() == Some(&480), "to start on the saver rung"),
            (heights.contains(&720), "to load R1 on 8 Mbit/s"),
            (
                heights.last() == Some(&480),
                "to load the saver rung again on 1.5 Mbit/s",
            ),
        ];
        let failed = checks.iter().filter(|(met, _)| !met);
        wrong.extend(failed.map(|(_, what)| format!("{browser}: expected {what}: {played}")));
    }
    assert!(wrong.is_empty(), "{}", wrong.join("\n"));
}
