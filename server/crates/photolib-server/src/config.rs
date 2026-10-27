use std::{
    collections::BTreeMap,
    fmt, fs,
    net::SocketAddr,
    path::{Path, PathBuf},
};

use figment::{
    Figment,
    providers::{Env, Format, Serialized},
};
use photolib_authz::Capability;
use serde::{Deserialize, Deserializer, Serialize, de::Error as _};
use serde_saphyr::figment::Yaml;
use tracing_subscriber::filter::Targets;

use crate::{proxy::Network, role::Role, secret::Secret, tone::ToneMapping, webauthn::RelyingParty};

#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
#[allow(clippy::struct_excessive_bools)] // the file's independent on/off settings, not the states of one thing
pub struct Config {
    pub config_version: u32,
    #[serde(default = "default_roles", deserialize_with = "roles_from_names")]
    pub roles: Vec<Role>,
    /// The one port of the process (ADR-0046): health, the API, uploads and `/metrics`.
    #[serde(default = "default_listen")]
    pub listen: SocketAddr,
    /// The path every endpoint is served under, such as `/photos`, for a proxy that serves photolibd beside other
    /// applications; `/` serves the root.
    #[serde(default = "default_base_path", deserialize_with = "base_path")]
    pub base_path: String,
    /// The web app (`flutter build web`'s output), which photolibd serves at the root in place of the setup page.
    pub web_root: Option<PathBuf>,
    /// The proxies whose `X-Forwarded-For` and `X-Forwarded-Proto` photolibd believes.
    #[serde(default = "default_trusted_proxies", deserialize_with = "networks")]
    pub trusted_proxies: Vec<Network>,
    /// Accept sign-ins over plain HTTP from beyond the local networks.
    #[serde(default)]
    pub allow_insecure_http: bool,
    /// Answer the apps' multicast DNS questions on the local network (OPS-29), when `listen` is not loopback.
    #[serde(default = "default_discovery")]
    pub discovery: bool,
    pub data_dir: Option<PathBuf>,
    pub work_dir: Option<PathBuf>,
    #[serde(default)]
    pub allow_network_fs: bool,
    #[serde(default)]
    pub database: Database,
    #[serde(default)]
    pub log: Log,
    #[serde(default)]
    pub metrics: Metrics,
    #[serde(default)]
    pub traces: Traces,
    #[serde(default = "default_grace")]
    pub shutdown_grace_secs: u64,
    /// Object stores by name (ADR-0022); `local`, the data directory, always exists.
    #[serde(default)]
    pub stores: BTreeMap<String, Store>,
    #[serde(default)]
    pub placement: Placement,
    /// ExifTool for ingest's full metadata dump: its path, or an interpreter and the script; empty keeps no dump.
    #[serde(default)]
    pub exiftool: Vec<PathBuf>,
    /// The directory of the `ffmpeg` and `ffprobe` that render videos on `worker:transcode`; unset renders none.
    pub ffmpeg_dir: Option<PathBuf>,
    /// What converts HDR videos to SDR for their renditions (ADR-0390): `auto` is libplacebo where a Vulkan device
    /// works in the media sandbox, else zimg on the CPU.
    #[serde(default)]
    pub tone_mapping: ToneMapping,
    /// How `api` streams videos.
    #[serde(default)]
    pub streaming: Streaming,
    /// The folders under which administrators may add external libraries; empty allows none.
    #[serde(default)]
    pub external_roots: Vec<PathBuf>,
    /// The origin people and apps reach the API at, e.g. https://photos.example.com: passkeys bind to its host.
    pub public_url: Option<String>,
    /// OpenID Connect providers people sign in with, by id (ADR-0087).
    #[serde(default)]
    pub oidc: BTreeMap<String, OidcProvider>,
    /// `none` turns off every connection of the privacy manifest, whatever its own switch says (ADR-0058).
    pub outbound: Option<Outbound>,
    /// POST events to the URLs accounts register (ADR-0263).
    #[serde(default)]
    pub webhooks: bool,
    /// The OPRF seed and the server's OPAQUE key pair (ADR-0052): beside the configuration file unless set, never in
    /// `data_dir`, which is synced, copied and holds the database dumps.
    pub opaque_key_file: Option<PathBuf>,
    /// Settings this file pins: the console shows them read-only, "set in config", and the API cannot change them.
    #[serde(default)]
    pub settings: Pinned,
    /// The `ml` role.
    #[serde(default)]
    pub ml: Ml,
}

/// The instance settings and capability switches the configuration pins (ADR-0240); unset leaves one to the console.
#[derive(Debug, Clone, Default, PartialEq, Eq, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct Pinned {
    /// Every account must set up a second factor.
    pub require_two_factor: Option<bool>,
    /// Face recognition starts on for new accounts.
    pub face_recognition_default: Option<bool>,
    /// Days in the trash, 1 to 3650.
    pub trash_retention_days: Option<u32>,
    /// The free disk share below which ingest pauses, 0 to 50.
    pub min_free_disk_percent: Option<u32>,
    /// Days in which the scrub checks every original, 1 to 3650.
    pub scrub_days: Option<u32>,
    /// Hours after which a device's backup is silent, 1 to 8760.
    pub backup_silent_hours: Option<u32>,
    /// The server's switches by capability, such as `uploads: false`; they win over every account's and library's.
    #[serde(default)]
    pub policy: BTreeMap<String, bool>,
}

impl Pinned {
    /// The instance settings it pins, by field name.
    pub fn names(&self) -> Vec<&'static str> {
        let set = [
            ("require_two_factor", self.require_two_factor.is_some()),
            ("face_recognition_default", self.face_recognition_default.is_some()),
            ("trash_retention_days", self.trash_retention_days.is_some()),
            ("min_free_disk_percent", self.min_free_disk_percent.is_some()),
            ("scrub_days", self.scrub_days.is_some()),
            ("backup_silent_hours", self.backup_silent_hours.is_some()),
        ];
        set.into_iter()
            .filter(|(_, pinned)| *pinned)
            .map(|(name, _)| name)
            .collect()
    }

    fn problems(&self) -> Vec<String> {
        let mut problems = Vec::new();
        if self
            .trash_retention_days
            .is_some_and(|days| !(1..=3650).contains(&days))
        {
            problems.push("settings.trash_retention_days: 1 to 3650".into());
        }
        if self.min_free_disk_percent.is_some_and(|percent| percent > 50) {
            problems.push("settings.min_free_disk_percent: 0 to 50".into());
        }
        if self.scrub_days.is_some_and(|days| !(1..=3650).contains(&days)) {
            problems.push("settings.scrub_days: 1 to 3650".into());
        }
        if self
            .backup_silent_hours
            .is_some_and(|hours| !(1..=8760).contains(&hours))
        {
            problems.push("settings.backup_silent_hours: 1 to 8760".into());
        }
        let names = Capability::ALL.map(Capability::name);
        for name in self.policy.keys().filter(|name| !names.contains(&name.as_str())) {
            problems.push(format!(
                "settings.policy.{name}: not a capability; one of {}",
                names.join(", ")
            ));
        }
        problems
    }
}

/// The `ml` role (ADR-0245).
#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields, default)]
pub struct Ml {
    /// ONNX Runtime 1.31's library: its official CPU build, or one with this machine's accelerators.
    pub runtime: PathBuf,
    /// Where `photolibd models` installs models and the role finds them; unset, `<data_dir>/models`.
    pub models_dir: Option<PathBuf>,
    /// The resident memory, in MB of 10^6 bytes, this process stays under while it runs models.
    pub memory_mb: u64,
    /// On a remote ML node, the API it reports to, such as https://photos.example.com.
    pub server: Option<String>,
    /// What the API asks of remote ML nodes, and what a node presents.
    pub token: Option<Secret<String>>,
    /// Whether the scheduler and ingest queue an `ocr` job for every image; a process with the `ml` role and a
    /// database runs them. Off, no picture's text is read.
    pub ocr: bool,
    /// Whether this process finds faces (ADR-0389) in the photos of accounts that agreed to it; nothing is found for
    /// the others whatever this says.
    pub faces: bool,
    /// The registry id of the model that describes faces: `sface`, or the optional `auraface` (install it with
    /// `photolibd models fetch auraface`).
    pub face_embedder: String,
}

impl Default for Ml {
    fn default() -> Self {
        Self {
            runtime: "libonnxruntime.so".into(),
            models_dir: None,
            memory_mb: 2000,
            server: None,
            token: None,
            ocr: true,
            faces: true,
            face_embedder: "sface".into(),
        }
    }
}

/// The master switch of outbound connections.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum Outbound {
    /// Every connection off, for air-gapped installs.
    None,
}

/// An OpenID Connect provider, such as Authentik, Keycloak, Authelia or a cloud one.
#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct OidcProvider {
    /// What the sign-in button says.
    pub name: String,
    pub issuer: String,
    pub client_id: String,
    /// Unset for a public client, which PKCE alone protects.
    pub client_secret: Option<Secret<String>>,
    #[serde(default = "default_scopes")]
    pub scopes: Vec<String>,
    /// Creates an account for a person the provider vouches for who has none.
    #[serde(default)]
    pub provision: bool,
    /// Links a person to the account that has their verified email.
    #[serde(default)]
    pub link_by_email: bool,
    /// Sets the role from a claim at every sign-in; whoever maps to no role is refused.
    pub roles: Option<RoleClaim>,
}

/// The values of a claim, such as `groups`, that give each role; the highest role wins.
#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct RoleClaim {
    pub claim: String,
    #[serde(default)]
    pub admin: Vec<String>,
    #[serde(default)]
    pub user: Vec<String>,
    #[serde(default)]
    pub viewer: Vec<String>,
}

/// An S3-compatible object store.
#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct Store {
    pub kind: StoreKind,
    pub endpoint: String,
    pub bucket: String,
    #[serde(default = "default_region")]
    pub region: String,
    /// Keys live under it, e.g. `home/`.
    #[serde(default)]
    pub prefix: String,
    pub access_key_id: String,
    pub secret_access_key: Secret<String>,
    /// How long one call, such as a 64 MiB part, may take.
    #[serde(default = "default_store_timeout")]
    pub timeout_secs: u64,
    /// Turns on the scrub's full re-hash, which downloads every original, with at most this many GiB a month.
    pub rehash_gib_per_month: Option<u32>,
}

/// The stores that new managed libraries and the scheduled database backups go to (ADR-0022 point 2).
#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields, default)]
pub struct Placement {
    /// Where new managed libraries go.
    pub libraries: String,
    /// Where scheduled backups go.
    pub backups: String,
}

impl Default for Placement {
    fn default() -> Self {
        Placement {
            libraries: "local".into(),
            backups: "local".into(),
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum StoreKind {
    S3,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields, default)]
pub struct Database {
    pub url: Option<Secret<String>>,
    pub data_dir: Option<PathBuf>,
    /// Dump the database to `<data_dir>/backups` before migrating it.
    pub pre_upgrade_dump: bool,
    pub keep_dumps: usize,
    /// Where `pg_dump`, `pg_restore` and `psql` are, and `postgres` and `initdb` for `cluster`; unset means `PATH`.
    pub bin_dir: Option<PathBuf>,
    /// The PostgreSQL cluster photolibd runs itself, instead of one at `url`.
    pub cluster: Option<PathBuf>,
    /// The database on the previous PostgreSQL major's cluster, which an empty `url` starts from (ADR-0266).
    pub upgrade_from: Option<Secret<String>>,
    /// When the scheduled backup runs, five cron fields in UTC; its restore drill follows.
    pub backup_cron: String,
    /// How many scheduled backups `placement.backups` keeps.
    pub keep_backups: usize,
}

impl Default for Database {
    fn default() -> Self {
        Database {
            url: None,
            data_dir: None,
            pre_upgrade_dump: true,
            keep_dumps: 3,
            bin_dir: None,
            cluster: None,
            upgrade_from: None,
            backup_cron: "0 3 * * *".into(),
            keep_backups: 14,
        }
    }
}

/// Adaptive streaming (ADR-0246): the rungs `api` encodes on demand with FFmpeg from `ffmpeg_dir`.
#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields, default)]
pub struct Streaming {
    /// How many rungs are encoded at once; 0 streams only stored proxies.
    pub sessions: usize,
    /// The segment cache in `work_dir`, with the copies of originals on object stores it encodes from.
    pub cache_gib: u64,
}

impl Default for Streaming {
    fn default() -> Self {
        Self {
            sessions: 2,
            cache_gib: 20,
        }
    }
}

#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct Log {
    #[serde(default)]
    pub format: LogFormat,
    #[serde(default = "default_filter")]
    pub filter: String,
}

impl Default for Log {
    fn default() -> Self {
        Log {
            format: LogFormat::default(),
            filter: default_filter(),
        }
    }
}

#[derive(Debug, Clone, Default, Deserialize, Serialize)]
#[serde(deny_unknown_fields, default)]
pub struct Metrics {
    /// The bearer token `/metrics` and `/diagnostics` require; unset, there are none.
    pub token: Option<Secret<String>>,
}

#[derive(Debug, Clone, Default, Deserialize, Serialize)]
#[serde(deny_unknown_fields, default)]
pub struct Traces {
    /// Where to send spans over OTLP/HTTP, such as `http://127.0.0.1:4318/v1/traces`; unset sends them nowhere.
    pub otlp_endpoint: Option<String>,
}

#[derive(Debug, Default, Clone, Copy, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum LogFormat {
    #[default]
    Json,
    Text,
}

/// A list, or a comma separated string as an environment variable gives it.
fn names<'de, D: Deserializer<'de>>(deserializer: D) -> Result<Vec<String>, D::Error> {
    #[derive(Deserialize)]
    #[serde(untagged)]
    enum Names {
        List(String),
        Many(Vec<String>),
    }
    Ok(match Names::deserialize(deserializer)? {
        Names::List(list) => list.split(',').map(|name| name.trim().to_string()).collect(),
        Names::Many(names) => names,
    })
}

fn roles_from_names<'de, D: Deserializer<'de>>(deserializer: D) -> Result<Vec<Role>, D::Error> {
    crate::role::resolve(&names(deserializer)?).map_err(D::Error::custom)
}

fn networks<'de, D: Deserializer<'de>>(deserializer: D) -> Result<Vec<Network>, D::Error> {
    names(deserializer)?
        .iter()
        .map(|name| name.parse().map_err(D::Error::custom))
        .collect()
}

fn default_trusted_proxies() -> Vec<Network> {
    ["127.0.0.0/8", "::1"].map(|net| net.parse().unwrap()).into()
}

/// `/` or segments of unreserved URL characters, without a trailing slash.
fn base_path<'de, D: Deserializer<'de>>(deserializer: D) -> Result<String, D::Error> {
    let path = String::deserialize(deserializer)?;
    let trimmed = path.trim_end_matches('/');
    let segment = |s: &str| !s.is_empty() && s.bytes().all(|b| b.is_ascii_alphanumeric() || b"-._~".contains(&b));
    match trimmed.strip_prefix('/') {
        _ if trimmed.is_empty() && path.starts_with('/') => Ok("/".into()),
        Some(rest) if rest.split('/').all(segment) => Ok(trimmed.into()),
        _ => Err(D::Error::custom(format!("`{path}` is not a path such as /photos"))),
    }
}

fn default_base_path() -> String {
    "/".into()
}

fn default_roles() -> Vec<Role> {
    crate::role::resolve(&["all".to_string()]).unwrap_or_default()
}

fn default_discovery() -> bool {
    true
}

fn default_listen() -> SocketAddr {
    SocketAddr::from(([127, 0, 0, 1], 8080))
}

fn default_filter() -> String {
    "info".into()
}

fn default_grace() -> u64 {
    30
}

fn default_region() -> String {
    "us-east-1".into()
}

fn default_store_timeout() -> u64 {
    120
}

fn default_scopes() -> Vec<String> {
    ["openid", "profile", "email"].map(String::from).to_vec()
}

/// Whether `path` is in `dir`, as far as their existing parts resolve.
fn inside(path: &Path, dir: &Path) -> bool {
    let resolved = |path: &Path| {
        let path = std::path::absolute(path).unwrap_or_else(|_| path.into());
        // Its deepest ancestor that exists, resolved, and the rest as written.
        let base = path
            .ancestors()
            .find_map(|base| Some((fs::canonicalize(base).ok()?, base)));
        base.map_or_else(
            || path.clone(),
            |(resolved, base)| resolved.join(path.strip_prefix(base).unwrap_or(&path)),
        )
    };
    resolved(path).starts_with(resolved(dir))
}

#[derive(Debug)]
pub struct ConfigError(pub Vec<String>);

impl fmt::Display for ConfigError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for problem in &self.0 {
            writeln!(f, "  - {problem}")?;
        }
        Ok(())
    }
}

impl std::error::Error for ConfigError {}

/// The version of the configuration schema this binary reads.
pub const CONFIG_VERSION: u32 = 1;

/// The `PHOTOLIB_*` variables that other programs read — the `photolib` CLI, the compose file, the developer tools
/// (`PHOTOLIB_TOOLCHAINS`: the agents' shared toolchains), tests and the design repository's work-item driver —
/// lowercased; any other is a setting, and an unknown one stops photolibd. `tools/tests/test_photolib_env.sh` checks
/// that every name the repository uses is one or the other.
const NOT_SETTINGS: &str = "config token server library state domain upstream version subnet data flags tools_cache \
    toolchains cache upload_bytes cli_files scan_files rescan_files sync_assets upgrade_assets record_fixtures \
    playable ml_models ml_golden ml_soak_secs crash chaos_worker proxies_child spawn_stopped browser_slots \
    hdr_review hdr_seconds heif_samples remote";

impl Config {
    /// Where workers stage files: `work_dir`, else `tmp/` in the data directory (same filesystem as the libraries).
    pub fn work_dir(&self) -> Option<PathBuf> {
        self.work_dir
            .clone()
            .or_else(|| self.data_dir.as_ref().map(|dir| dir.join("tmp")))
    }

    /// Whether webhooks deliver and new ones may be made: `webhooks`, unless `outbound: none`.
    pub fn webhooks(&self) -> bool {
        self.webhooks && self.outbound != Some(Outbound::None)
    }

    /// Where models are installed.
    pub fn models_dir(&self) -> Option<PathBuf> {
        (self.ml.models_dir.clone()).or_else(|| self.data_dir.as_ref().map(|dir| dir.join("models")))
    }

    /// Where passkeys bind, from `public_url`.
    pub fn relying_party(&self) -> Option<RelyingParty> {
        RelyingParty::from_url(self.public_url.as_deref()?)
    }

    /// The directories that hold scratch files and the database; they must not sit on network or FUSE filesystems.
    pub fn state_dirs(&self) -> Vec<(&'static str, PathBuf)> {
        let work = self.work_dir().map(|dir| ("work_dir", dir));
        let database = self.database.data_dir.clone().map(|dir| ("database.data_dir", dir));
        let cluster = self.database.cluster.clone().map(|dir| ("database.cluster", dir));
        work.into_iter().chain(database).chain(cluster).collect()
    }

    /// Reads the file (if any), then `PHOTOLIB_*` variables, then the command-line roles; later sources win.
    pub fn load(file: Option<&Path>, roles: Option<Vec<String>>) -> Result<Config, ConfigError> {
        let mut figment = Figment::new();
        if let Some(file) = file {
            let text = fs::read_to_string(file).map_err(|error| {
                ConfigError(vec![format!("cannot read the config file {}: {error}", file.display())])
            })?;
            figment = figment.merge(Yaml::string(&text));
        }
        figment = figment.merge(
            Env::prefixed("PHOTOLIB_")
                .split("__")
                .ignore(&NOT_SETTINGS.split_whitespace().collect::<Vec<_>>()),
        );
        if let Some(roles) = roles {
            figment = figment.merge(Serialized::default("roles", roles));
        }
        check_version(&figment)?;
        let mut config: Config = figment.extract().map_err(|errors| {
            ConfigError(
                errors
                    .into_iter()
                    .map(|error| format!("{}: {}", error.path.join("."), error.kind))
                    .collect(),
            )
        })?;
        if config.opaque_key_file.is_none()
            && let Some(dir) = file.and_then(|file| std::path::absolute(file).ok()?.parent().map(Path::to_path_buf))
        {
            config.opaque_key_file = Some(dir.join("opaque.key"));
        }
        match config.problems() {
            problems if problems.is_empty() => Ok(config),
            problems => Err(ConfigError(problems)),
        }
    }

    fn problems(&self) -> Vec<String> {
        let mut problems = Vec::new();
        let on_instance: Vec<String> = self
            .roles
            .iter()
            .filter(|role| role.needs_instance())
            .map(Role::to_string)
            .collect();
        if !on_instance.is_empty() {
            let why = format!(
                "the roles {} work on the data directory and the database",
                on_instance.join(", ")
            );
            if self.data_dir.is_none() {
                problems.push(format!(
                    "data_dir: required because {why}; set data_dir or PHOTOLIB_DATA_DIR"
                ));
            }
            if self.database.url.is_none() && self.database.cluster.is_none() {
                problems.push(format!(
                    "database.url or database.cluster: required because {why}; set database.url \
                     (PHOTOLIB_DATABASE__URL), or database.cluster (PHOTOLIB_DATABASE__CLUSTER) for a cluster \
                     photolibd runs itself"
                ));
            }
        }
        match &self.database.cluster {
            Some(_) if self.database.url.is_some() => {
                problems.push("database.cluster: photolibd runs its own cluster, so database.url must be unset".into());
            }
            Some(dir) if !dir.is_absolute() => {
                problems.push(format!("database.cluster: {} must be an absolute path", dir.display()));
            }
            _ => {}
        }
        for (name, url) in [
            ("url", &self.database.url),
            ("upgrade_from", &self.database.upgrade_from),
        ] {
            if let Some(url) = url
                && !["postgres://", "postgresql://"]
                    .iter()
                    .any(|scheme| url.expose().starts_with(scheme))
            {
                problems.push(format!(
                    "database.{name}: must be a PostgreSQL URL, postgres://user:password@host/database"
                ));
            }
        }
        if let Err(error) = self.database.backup_cron.parse::<photolib_jobs::cron::Cron>() {
            problems.push(format!("database.backup_cron: {error}"));
        }
        if self.database.keep_backups == 0 {
            problems.push("database.keep_backups: must be at least 1".into());
        }
        if self.database.keep_dumps == 0 {
            problems.push("database.keep_dumps: must be at least 1, or the pre-upgrade dump is deleted at once".into());
        }
        if self.log.filter.parse::<Targets>().is_err() {
            problems.push(
                "log.filter: not a valid filter; use a level or per-module levels such as info,photolib_server=debug"
                    .into(),
            );
        }
        if self
            .metrics
            .token
            .as_ref()
            .is_some_and(|token| token.expose().len() < 32)
        {
            problems.push(
                "metrics.token: must be at least 32 characters, such as the output of `openssl rand -hex 16`".into(),
            );
        }
        problems.extend(self.ml.problems().into_iter().map(|problem| format!("ml.{problem}")));
        if let Some(endpoint) = &self.traces.otlp_endpoint
            && !endpoint.starts_with("http://")
        {
            problems.push("traces.otlp_endpoint: must be the http:// URL of an OTLP/HTTP collector, such as http://127.0.0.1:4318/v1/traces".into());
        }
        for (name, store) in &self.stores {
            if name == "local" {
                problems.push("stores.local: `local` is the data directory and cannot be configured".into());
            }
            if !store.prefix.is_empty() && (store.prefix.starts_with('/') || !store.prefix.ends_with('/')) {
                problems.push(format!(
                    "stores.{name}.prefix: must not start with / and must end with /, e.g. home/"
                ));
            }
            if store.timeout_secs == 0 {
                problems.push(format!("stores.{name}.timeout_secs: must be at least 1"));
            }
            if store.rehash_gib_per_month == Some(0) {
                problems.push(format!(
                    "stores.{name}.rehash_gib_per_month: must be at least 1; leave it out to only check sizes and hashes"
                ));
            }
        }
        for (id, provider) in &self.oidc {
            if !(1..=32).contains(&id.len())
                || !id
                    .bytes()
                    .all(|b| b.is_ascii_lowercase() || b.is_ascii_digit() || b"-_".contains(&b))
            {
                problems.push(format!("oidc.{id}: an id is 1 to 32 of a-z, 0-9, - and _"));
            }
            problems.extend(
                provider
                    .problems()
                    .into_iter()
                    .map(|problem| format!("oidc.{id}.{problem}")),
            );
        }
        for (name, store) in [
            ("libraries", &self.placement.libraries),
            ("backups", &self.placement.backups),
        ] {
            if store != "local" && !self.stores.contains_key(store) {
                problems.push(format!(
                    "placement.{name}: {store:?} is neither `local` nor one of the stores"
                ));
            }
        }
        for root in self.external_roots.iter().filter(|root| !root.is_absolute()) {
            problems.push(format!(
                "external_roots: {} must be an absolute path, such as /srv/photos",
                root.display()
            ));
        }
        if self.public_url.is_some() && self.relying_party().is_none() {
            problems.push("public_url: must be an https:// origin without a path, such as https://photos.example.com (or http://localhost:<port> for development)".into());
        }
        match (&self.opaque_key_file, &self.data_dir) {
            (None, _) if self.roles.contains(&Role::Api) => problems.push(
                "opaque_key_file: required when no configuration file is read; set PHOTOLIB_OPAQUE_KEY_FILE".into(),
            ),
            (Some(key), Some(data_dir)) if inside(key, data_dir) => problems.push(format!(
                "opaque_key_file: {} is in data_dir, which is synced, copied and holds the database backups; keep \
                 the key apart from them",
                key.display()
            )),
            _ => {}
        }
        if self.shutdown_grace_secs == 0 {
            problems.push("shutdown_grace_secs: must be at least 1, or in-flight work is cut off at once".into());
        }
        problems.extend(self.settings.problems());
        problems
    }
}

impl Ml {
    fn problems(&self) -> Vec<String> {
        let mut problems = Vec::new();
        if self.token.as_ref().is_some_and(|token| token.expose().len() < 32) {
            problems.push("token: must be at least 32 characters, such as the output of `openssl rand -hex 16`".into());
        }
        if self.memory_mb < 512 {
            problems.push("memory_mb: must be at least 512".into());
        }
        if !["sface", "auraface"].contains(&self.face_embedder.as_str()) {
            problems.push("face_embedder: sface or auraface".into());
        }
        let Some(server) = &self.server else {
            return problems;
        };
        if self.token.is_none() {
            problems.push("server: a node reports to it with ml.token, which is not set".into());
        }
        let url = url::Url::parse(server);
        if !url.is_ok_and(|url| crate::oidc::secure(&url) && url.path() == "/" && url.query().is_none()) {
            problems.push("server: the https:// origin of the API, such as https://photos.example.com (http:// only on this machine)".into());
        }
        problems
    }
}

impl OidcProvider {
    fn problems(&self) -> Vec<String> {
        let mut problems = Vec::new();
        if !(1..=100).contains(&self.name.chars().count()) || self.name.contains(char::is_control) {
            problems.push("name: 1 to 100 printable characters, as the sign-in button shows them".into());
        }
        let issuer = url::Url::parse(&self.issuer);
        if !issuer.is_ok_and(|url| crate::oidc::secure(&url) && url.query().is_none() && url.fragment().is_none()) {
            problems.push("issuer: an https:// URL without query or fragment (http:// only on localhost)".into());
        }
        if self.client_id.is_empty() {
            problems.push("client_id: required, as registered at the provider".into());
        }
        let word = |scope: &String| {
            !scope.is_empty() && scope.bytes().all(|b| b.is_ascii_graphic() && b != b'"' && b != b'\\')
        };
        if !self.scopes.iter().any(|scope| scope == "openid") || !self.scopes.iter().all(word) {
            problems.push("scopes: must include openid, each a word without spaces".into());
        }
        if let Some(roles) = &self.roles
            && (roles.claim.is_empty()
                || [&roles.admin, &roles.user, &roles.viewer]
                    .iter()
                    .all(|values| values.is_empty()))
        {
            problems.push("roles: needs a claim and a value for admin, user or viewer".into());
        }
        problems
    }
}

fn check_version(figment: &Figment) -> Result<(), ConfigError> {
    let problem = match figment.extract_inner::<u32>("config_version") {
        Ok(CONFIG_VERSION) => return Ok(()),
        Ok(version) if version > CONFIG_VERSION => format!(
            "config_version: {version} is newer than this photolibd understands ({CONFIG_VERSION}); upgrade photolibd"
        ),
        Ok(version) => format!("config_version: {version} is not a known version; the current one is {CONFIG_VERSION}"),
        Err(_) => {
            format!("config_version: required; add `config_version: {CONFIG_VERSION}` to the file")
        }
    };
    Err(ConfigError(vec![problem]))
}

#[cfg(test)]
#[allow(
    clippy::result_large_err,
    reason = "figment::Jail closures must return figment::Error"
)]
mod tests {
    use figment::Jail;

    use super::*;
    use crate::testing::assert_contains;

    const MINIMAL: &str = "
config_version: 1
data_dir: /data
database:
  url: postgres://photolib:hunter2@db/photolib
";

    fn load_with(yaml: &str, env: &[(&str, &str)]) -> Result<Config, ConfigError> {
        let mut result = None;
        Jail::expect_with(|jail| {
            jail.create_file("photolib.yaml", yaml)?;
            for (name, value) in env {
                jail.set_env(name, value);
            }
            result = Some(Config::load(Some(Path::new("photolib.yaml")), None));
            Ok(())
        });
        result.unwrap()
    }

    fn problems(result: Result<Config, ConfigError>) -> String {
        result.expect_err("the configuration must be refused").to_string()
    }

    #[test]
    fn the_debs_configuration_runs_every_role_on_its_own_cluster() {
        let deb = include_str!("../../../../deploy/debian/photolibd.yaml");
        let config = load_with(deb, &[]).unwrap();
        assert_eq!(config.roles.len(), 9);
        assert_eq!(config.listen, SocketAddr::from(([0, 0, 0, 0], 8080)));
        let cluster = config.database.cluster.as_deref();
        assert_eq!(cluster, Some(Path::new("/var/lib/photolib/postgres")));
        let key = config.opaque_key_file.unwrap();
        assert!(
            !key.starts_with(config.data_dir.unwrap()),
            "the OPAQUE key lives apart from the libraries"
        );
        assert_eq!(config.ffmpeg_dir, Some(PathBuf::from("/usr/bin")));
    }

    #[test]
    fn hdr_is_converted_by_libplacebo_where_it_runs_unless_the_settings_name_a_converter() {
        use crate::tone::ToneMapping;
        assert_eq!(load_with(MINIMAL, &[]).unwrap().tone_mapping, ToneMapping::Auto);
        for (name, mapping) in [
            ("auto", ToneMapping::Auto),
            ("zimg", ToneMapping::Zimg),
            ("placebo", ToneMapping::Placebo),
        ] {
            let config = load_with(&format!("{MINIMAL}\ntone_mapping: {name}\n"), &[]).unwrap();
            assert_eq!(config.tone_mapping, mapping);
        }
        let env = load_with(MINIMAL, &[("PHOTOLIB_TONE_MAPPING", "zimg")]).unwrap();
        assert_eq!(env.tone_mapping, ToneMapping::Zimg);
        assert!(problems(load_with(&format!("{MINIMAL}\ntone_mapping: hable\n"), &[])).contains("tone_mapping"));
    }

    #[test]
    fn a_minimal_file_gets_the_documented_defaults() {
        let config = load_with(MINIMAL, &[]).unwrap();
        assert_eq!(config.roles.len(), 9);
        assert_eq!(config.listen, SocketAddr::from(([127, 0, 0, 1], 8080)));
        assert!(config.metrics.token.is_none(), "no /metrics unless a token is set");
        assert_eq!(config.log.format, LogFormat::Json);
        assert_eq!(config.shutdown_grace_secs, 30);
        assert_eq!(
            config.traces.otlp_endpoint, None,
            "no span leaves the process unless asked"
        );
        assert_eq!(config.work_dir(), Some(PathBuf::from("/data/tmp")));
        assert_eq!(config.ffmpeg_dir, None, "no FFmpeg, no video renditions");
        assert_eq!((config.streaming.sessions, config.streaming.cache_gib), (2, 20));
        let database = &config.database;
        assert!(database.pre_upgrade_dump);
        assert_eq!((database.keep_dumps, database.bin_dir.as_deref()), (3, None));
        assert_eq!(database.cluster, None, "no PostgreSQL of photolibd's own unless asked");
        assert_eq!(
            (database.backup_cron.as_str(), database.keep_backups),
            ("0 3 * * *", 14)
        );
        assert_eq!(config.placement.backups, "local");
        assert_eq!(config.relying_party(), None, "no passkeys without a public address");
        let public = load_with(&format!("{MINIMAL}public_url: https://photos.example.com/\n"), &[]);
        let rp = public.unwrap().relying_party().unwrap();
        assert_eq!(rp.origin, "https://photos.example.com");
        let without_database = load_with("config_version: 1\nroles: [ml]\n", &[]).unwrap();
        assert!(without_database.database.pre_upgrade_dump);
        assert!(
            config.external_roots.is_empty(),
            "no external library unless the operator names where"
        );
        assert!(config.discovery, "the apps find the server on its network");
        let quiet = load_with(MINIMAL, &[("PHOTOLIB_DISCOVERY", "false")]).unwrap();
        assert!(!quiet.discovery);
    }

    #[test]
    fn outbound_none_turns_every_connection_off_from_the_file_or_the_environment() {
        assert_eq!(load_with(MINIMAL, &[]).unwrap().outbound, None, "each switch decides");
        let none = Some(Outbound::None);
        assert_eq!(
            load_with(&format!("{MINIMAL}outbound: none\n"), &[]).unwrap().outbound,
            none
        );
        assert_eq!(
            load_with(MINIMAL, &[("PHOTOLIB_OUTBOUND", "none")]).unwrap().outbound,
            none
        );
        let other = problems(load_with(&format!("{MINIMAL}outbound: all\n"), &[]));
        assert!(other.contains("outbound") && other.contains("none"), "{other}");
    }

    #[test]
    fn webhooks_are_off_by_default_and_outbound_none_turns_them_off() {
        assert!(!load_with(MINIMAL, &[]).unwrap().webhooks());
        assert!(
            load_with(&format!("{MINIMAL}webhooks: true\n"), &[])
                .unwrap()
                .webhooks()
        );
        let both = format!("{MINIMAL}webhooks: true\noutbound: none\n");
        assert!(!load_with(&both, &[]).unwrap().webhooks());
        assert!(load_with(MINIMAL, &[("PHOTOLIB_WEBHOOKS", "true")]).unwrap().webhooks());
    }

    #[test]
    fn the_ml_role_loads_onnx_runtime_and_its_models_where_the_operator_says() {
        let config = load_with(MINIMAL, &[]).unwrap();
        assert_eq!(
            config.ml.runtime,
            PathBuf::from("libonnxruntime.so"),
            "the library's search path"
        );
        assert_eq!(config.models_dir(), Some(PathBuf::from("/data/models")));
        assert_eq!((config.ml.memory_mb, config.ml.server.as_deref()), (2000, None));
        assert!(config.ml.token.is_none(), "no remote node unless a token is set");
        assert!(config.ml.ocr, "pictures' text is read unless the operator turns it off");
        let off = load_with("config_version: 1\nroles: [ml]\nml: {ocr: false}\n", &[]).unwrap();
        assert!(!off.ml.ocr);
        let token = "node-token-node-token-node-token";
        let node = load_with(
            &format!("config_version: 1\nroles: [ml]\nml: {{models_dir: /models, server: 'https://photos.example.com', token: {token}}}\n"),
            &[("PHOTOLIB_ML__RUNTIME", "/opt/ort/libonnxruntime.so.1.31.0")],
        )
        .unwrap();
        assert_eq!(node.models_dir(), Some(PathBuf::from("/models")));
        assert_eq!(node.ml.runtime, PathBuf::from("/opt/ort/libonnxruntime.so.1.31.0"));
        assert_eq!(node.ml.token.as_ref().map(|t| t.expose().as_str()), Some(token));
        assert!(!format!("{node:?}").contains(token));
        assert_eq!(
            load_with("config_version: 1\nroles: [ml]\n", &[]).unwrap().models_dir(),
            None
        );
        for (ml, expected) in [
            ("{token: short}", vec!["ml.token", "32"]),
            ("{server: 'https://photos.example.com'}", vec!["ml.server", "ml.token"]),
            (
                "{server: 'http://photos.example.com', token: node-token-node-token-node-token}",
                vec!["ml.server", "https://"],
            ),
            ("{memory_mb: 100}", vec!["ml.memory_mb", "512"]),
            (
                "{face_embedder: arcface}",
                vec!["ml.face_embedder", "sface", "auraface"],
            ),
        ] {
            assert_contains(&problems(load_with(&format!("{MINIMAL}ml: {ml}\n"), &[])), &expected);
        }
        // Faces are found for accounts that agreed, with SFace unless the administrator chose AuraFace (ADR-0389).
        assert_eq!((config.ml.faces, config.ml.face_embedder.as_str()), (true, "sface"));
        let aura = load_with(
            &format!("{MINIMAL}ml: {{face_embedder: auraface, faces: false}}\n"),
            &[],
        )
        .unwrap();
        assert_eq!((aura.ml.faces, aura.ml.face_embedder.as_str()), (false, "auraface"));
        let local = format!("{MINIMAL}ml: {{server: 'http://127.0.0.1:8080', token: {token}}}\n");
        assert!(load_with(&local, &[]).is_ok(), "plain HTTP on this machine only");
    }

    #[test]
    fn yaml_errors_name_the_problem_and_fix() {
        for (yaml, expected) in [
            (format!("{MINIMAL}datadir: /other\n"), vec!["datadir", "data_dir"]),
            (MINIMAL.replace("  url:", "  urll: x\n  url:"), vec!["urll", "url"]),
            (format!("{MINIMAL}roles: [all, api]\n"), vec!["roles", "alone"]),
            (
                "config_version: 1\nroles: [api]\n".into(),
                vec!["data_dir", "database.url", "database.cluster", "api"],
            ),
            (
                MINIMAL.replace("database:", "database:\n  cluster: /var/lib/photolib/pg"),
                vec!["database.cluster", "database.url must be unset"],
            ),
            (
                "config_version: 1\ndata_dir: /data\ndatabase: {cluster: pg}\n".into(),
                vec!["database.cluster", "absolute"],
            ),
            ("roles: [ml]\n".into(), vec!["config_version"]),
            (
                "config_version: 2\nroles: [ml]\n".into(),
                vec!["config_version", "newer", "upgrade photolibd"],
            ),
            (format!("{MINIMAL}log: {{filter: 'info,=='}}\n"), vec!["log.filter"]),
            (
                format!("{MINIMAL}shutdown_grace_secs: 0\n"),
                vec!["shutdown_grace_secs"],
            ),
            (
                format!("{MINIMAL}traces: {{otlp_endpoint: 'collector:4318'}}\n"),
                vec!["traces.otlp_endpoint", "http://"],
            ),
            (format!("{MINIMAL}listen: nowhere\n"), vec!["listen"]),
            (format!("{MINIMAL}admin_listen: 127.0.0.1:8081\n"), vec!["admin_listen"]),
            (
                format!("{MINIMAL}metrics: {{token: short}}\n"),
                vec!["metrics.token", "32"],
            ),
            (
                format!("{MINIMAL}external_roots: [/srv/photos, photos]\n"),
                vec!["external_roots", "photos", "absolute"],
            ),
            (
                format!("{MINIMAL}public_url: http://photos.example.com\n"),
                vec!["public_url", "https://"],
            ),
            (
                MINIMAL.replace("  url:", "  keep_dumps: 0\n  url:"),
                vec!["database.keep_dumps"],
            ),
            (
                MINIMAL.replace(
                    "  url:",
                    "  keep_backups: 0\n  backup_cron: daily\n  upgrade_from: mysql://x\n  url:",
                ),
                vec!["database.keep_backups", "database.backup_cron", "database.upgrade_from"],
            ),
            (
                format!("{MINIMAL}placement: {{backups: nas}}\n"),
                vec!["placement.backups", "nas"],
            ),
            (
                "config_version: 1\nshutdown_grace_secs: 0\nlog: {filter: 'info,x=nope'}\n".into(),
                vec!["data_dir", "database.url", "log.filter", "shutdown_grace_secs"],
            ),
        ] {
            assert_contains(&problems(load_with(&yaml, &[])), &expected);
        }
    }

    #[test]
    fn photolibd_serves_the_web_app_from_web_root_when_it_is_set() {
        assert_eq!(load_with(MINIMAL, &[]).unwrap().web_root, None);
        let config = load_with(MINIMAL, &[("PHOTOLIB_WEB_ROOT", "/srv/photolib/web")]).unwrap();
        assert_eq!(config.web_root, Some("/srv/photolib/web".into()));
    }

    #[test]
    fn behind_a_proxy_photolibd_serves_the_root_trusts_loopback_and_wants_https() {
        let config = load_with(MINIMAL, &[]).unwrap();
        assert_eq!(config.base_path, "/");
        let trusted: Vec<String> = config.trusted_proxies.iter().map(|n| n.to_string()).collect();
        assert_eq!(trusted, ["127.0.0.0/8", "::1/128"]);
        assert!(!config.allow_insecure_http);
        let env = [
            ("PHOTOLIB_BASE_PATH", "/photos/"),
            ("PHOTOLIB_TRUSTED_PROXIES", "172.30.0.0/16, 10.0.0.7,fd00::/8"),
            ("PHOTOLIB_ALLOW_INSECURE_HTTP", "true"),
        ];
        let config = load_with(MINIMAL, &env).unwrap();
        assert_eq!(config.base_path, "/photos");
        let trusted: Vec<String> = config.trusted_proxies.iter().map(|n| n.to_string()).collect();
        assert_eq!(trusted, ["172.30.0.0/16", "10.0.0.7/32", "fd00::/8"]);
        assert!(config.allow_insecure_http);
        let listed = format!("{MINIMAL}base_path: /a/b-c_d.e~\ntrusted_proxies: [192.168.1.1/24]\n");
        let config = load_with(&listed, &[]).unwrap();
        assert_eq!(config.base_path, "/a/b-c_d.e~");
        assert_eq!(config.trusted_proxies[0].to_string(), "192.168.1.0/24");
        for (yaml, expected) in [
            ("base_path: photos", "base_path"),
            ("base_path: /a//b", "base_path"),
            ("base_path: /a?b", "base_path"),
            ("trusted_proxies: [10.0.0.0/33]", "10.0.0.0/33"),
            ("trusted_proxies: [::1/129]", "::1/129"),
            ("trusted_proxies: proxy.lan", "proxy.lan"),
        ] {
            let message = problems(load_with(&format!("{MINIMAL}{yaml}\n"), &[]));
            assert_contains(&message, &[expected]);
        }
    }

    #[test]
    fn an_unknown_environment_variable_stops_startup_and_names_it() {
        let message = problems(load_with(MINIMAL, &[("PHOTOLIB_LISTN", "0.0.0.0:1")]));
        assert!(
            message.contains("PHOTOLIB_LISTN") || message.contains("listn"),
            "{message}"
        );
    }

    #[test]
    fn environment_variables_override_the_file() {
        let env = [
            ("PHOTOLIB_LISTEN", "0.0.0.0:9000"),
            ("PHOTOLIB_DATABASE__URL", "postgres://other@db2/photolib"),
            ("PHOTOLIB_ROLES", "api,worker:cpu"),
            ("PHOTOLIB_SHUTDOWN_GRACE_SECS", "5"),
            ("PHOTOLIB_METRICS__TOKEN", "test-token-test-token-test-token"),
            ("PHOTOLIB_FFMPEG_DIR", "/opt/ffmpeg/bin"),
            ("PHOTOLIB_STREAMING__SESSIONS", "0"),
        ];
        let config = load_with(MINIMAL, &env).unwrap();
        assert_eq!(config.ffmpeg_dir, Some("/opt/ffmpeg/bin".into()));
        assert_eq!(config.streaming.sessions, 0);
        assert_eq!(config.listen.port(), 9000);
        let token = config.metrics.token.as_ref().unwrap();
        assert_eq!(token.expose(), "test-token-test-token-test-token");
        assert!(!format!("{config:?}").contains("test-token"));
        assert_eq!(config.database.url.unwrap().expose(), "postgres://other@db2/photolib");
        assert_eq!(config.roles.len(), 2);
        assert_eq!(config.shutdown_grace_secs, 5);
    }

    #[test]
    fn the_command_line_roles_override_the_file_and_the_environment() {
        Jail::expect_with(|jail| {
            jail.create_file("photolib.yaml", MINIMAL)?;
            jail.set_env("PHOTOLIB_ROLES", "api");
            let config = Config::load(Some(Path::new("photolib.yaml")), Some(vec!["ml".into()])).unwrap();
            assert_eq!(config.roles, [Role::Ml]);
            Ok(())
        });
    }

    #[test]
    fn the_config_path_and_what_the_cli_compose_and_developer_tools_read_are_not_settings() {
        for name in [
            "PHOTOLIB_CONFIG",
            "PHOTOLIB_TOOLS_CACHE",
            "PHOTOLIB_TOOLCHAINS",
            "PHOTOLIB_CACHE",
            "PHOTOLIB_UPLOAD_BYTES",
            "PHOTOLIB_ML_MODELS",
            "PHOTOLIB_TOKEN",
            "PHOTOLIB_DOMAIN",
            // What the work-item driver of the design repository exports to the agents and gates it runs.
            "PHOTOLIB_BROWSER_SLOTS",
        ] {
            let config = load_with(MINIMAL, &[(name, "/tmp/x")]);
            assert!(config.is_ok(), "{name}: {}", problems(config));
        }
    }

    #[test]
    fn the_opaque_key_lives_beside_the_config_file_or_where_set_never_in_the_data_directory() {
        let mut beside = None;
        Jail::expect_with(|jail| {
            jail.create_file("photolib.yaml", MINIMAL)?;
            let config = Config::load(Some(Path::new("photolib.yaml")), None).unwrap();
            beside = Some((config.opaque_key_file, jail.directory().join("opaque.key")));
            Ok(())
        });
        let (key, expected) = beside.unwrap();
        assert_eq!(key, Some(expected));
        let secret = load_with(MINIMAL, &[("PHOTOLIB_OPAQUE_KEY_FILE", "/run/secrets/opaque_key")]);
        assert_eq!(
            secret.unwrap().opaque_key_file.as_deref(),
            Some(Path::new("/run/secrets/opaque_key")),
            "a Docker secret"
        );
        for inside in ["/data/opaque.key", "/data/.photolib/opaque.key"] {
            let refused = problems(load_with(&format!("{MINIMAL}opaque_key_file: {inside}\n"), &[]));
            assert_contains(&refused, &["opaque_key_file", "data_dir", "backups"]);
        }
        let mut unset = None;
        Jail::expect_with(|jail| {
            for (name, value) in [
                ("PHOTOLIB_CONFIG_VERSION", "1"),
                ("PHOTOLIB_DATA_DIR", "/data"),
                ("PHOTOLIB_DATABASE__URL", "postgres://u@db/photolib"),
            ] {
                jail.set_env(name, value);
            }
            unset = Some((Config::load(None, None), Config::load(None, Some(vec!["ml".into()]))));
            Ok(())
        });
        let (api, ml) = unset.unwrap();
        assert_contains(&problems(api), &["opaque_key_file", "PHOTOLIB_OPAQUE_KEY_FILE"]);
        assert_eq!(ml.unwrap().opaque_key_file, None, "only the api role signs in");
    }

    #[test]
    fn an_ml_only_process_needs_neither() {
        let config = load_with("config_version: 1\nroles: [ml]\n", &[]).unwrap();
        assert_eq!(config.roles, [Role::Ml]);
    }

    #[test]
    fn an_invalid_database_url_is_redacted_and_names_the_fix() {
        let url = problems(load_with(
            &MINIMAL.replace("postgres://photolib:hunter2@db/photolib", "mysql://x"),
            &[],
        ));
        assert_contains(&url, &["database.url", "postgres://"]);
        assert!(!url.contains("mysql"), "an invalid secret must not be echoed: {url}");
    }

    #[test]
    fn a_missing_config_file_is_an_error_not_an_empty_configuration() {
        let message = Config::load(Some(Path::new("/nonexistent/photolib.yaml")), None)
            .unwrap_err()
            .to_string();
        assert!(message.contains("/nonexistent/photolib.yaml"), "{message}");
    }

    #[test]
    fn the_printed_configuration_never_shows_the_database_password() {
        let config = load_with(MINIMAL, &[]).unwrap();
        assert!(!format!("{config:?}").contains("hunter2"));
    }

    #[test]
    fn the_work_directory_and_the_database_directory_are_state_directories() {
        let config = load_with(MINIMAL, &[]).unwrap();
        assert_eq!(config.state_dirs(), [("work_dir", PathBuf::from("/data/tmp"))]);
        let both = format!("{MINIMAL}work_dir: /scratch\n").replace("database:", "database:\n  data_dir: /pg");
        let config = load_with(&both, &[]).unwrap();
        assert_eq!(
            config.state_dirs(),
            [
                ("work_dir", PathBuf::from("/scratch")),
                ("database.data_dir", PathBuf::from("/pg"))
            ]
        );
        let ml = load_with("config_version: 1\nroles: [ml]\n", &[]).unwrap();
        assert!(ml.state_dirs().is_empty());
        let own = [("PHOTOLIB_DATABASE__CLUSTER", "/var/lib/photolib/pg")];
        let own = load_with("config_version: 1\ndata_dir: /data\n", &own).unwrap();
        assert_eq!(
            own.state_dirs()[1],
            ("database.cluster", PathBuf::from("/var/lib/photolib/pg"))
        );
    }

    #[test]
    fn object_stores_are_named_with_their_secrets_from_the_environment() {
        let yaml = format!(
            "{MINIMAL}stores:\n  b2:\n    kind: s3\n    endpoint: https://s3.example\n    bucket: photolib\n    prefix: home/\n    access_key_id: id\n"
        );
        let config = load_with(&yaml, &[("PHOTOLIB_STORES__B2__SECRET_ACCESS_KEY", "s3cr3t")]).unwrap();
        let b2 = &config.stores["b2"];
        assert_eq!(
            (b2.bucket.as_str(), b2.prefix.as_str(), b2.region.as_str()),
            ("photolib", "home/", "us-east-1")
        );
        assert_eq!(
            (b2.secret_access_key.expose().as_str(), b2.timeout_secs),
            ("s3cr3t", 120)
        );
        assert!(!format!("{config:?}").contains("s3cr3t"));
        assert_eq!(
            b2.rehash_gib_per_month, None,
            "the scrub only HEADs unless told otherwise"
        );
        let rehash = load_with(
            &format!("{yaml}    rehash_gib_per_month: 50\n"),
            &[("PHOTOLIB_STORES__B2__SECRET_ACCESS_KEY", "s3cr3t")],
        );
        assert_eq!(rehash.unwrap().stores["b2"].rehash_gib_per_month, Some(50));
        let local = yaml.replace("b2:", "local:");
        let secret = |name: &str| format!("PHOTOLIB_STORES__{name}__SECRET_ACCESS_KEY");
        for (bad, name, expected) in [
            (local.as_str(), "LOCAL", vec!["stores.local", "data directory"]),
            (&yaml.replace("kind: s3", "kind: gcs"), "B2", vec!["kind", "s3"]),
            (
                &yaml.replace("prefix: home/", "prefix: /home"),
                "B2",
                vec!["stores.b2.prefix", "end with /"],
            ),
            (
                &format!("{yaml}    rehash_gib_per_month: 0\n"),
                "B2",
                vec!["stores.b2.rehash_gib_per_month", "at least 1"],
            ),
        ] {
            assert_contains(&problems(load_with(bad, &[(&secret(name), "x")])), &expected);
        }
        assert_contains(&problems(load_with(&yaml, &[])), &["secret_access_key"]);
    }

    #[test]
    fn oidc_providers_are_named_with_their_secrets_from_the_environment_and_checked() {
        let yaml = format!(
            "{MINIMAL}oidc:\n  keycloak:\n    name: Keycloak\n    issuer: https://sso.example/realms/home\n    client_id: photolib\n    roles: {{claim: groups, admin: [admins]}}\n"
        );
        let secret = [("PHOTOLIB_OIDC__KEYCLOAK__CLIENT_SECRET", "s3cr3t")];
        let config = load_with(&yaml, &secret).unwrap();
        let keycloak = &config.oidc["keycloak"];
        assert_eq!(keycloak.client_secret.as_ref().unwrap().expose(), "s3cr3t");
        assert_eq!(keycloak.scopes, ["openid", "profile", "email"]);
        assert!(!keycloak.provision && !keycloak.link_by_email);
        assert_eq!(keycloak.roles.as_ref().unwrap().admin, ["admins"]);
        assert!(!format!("{config:?}").contains("s3cr3t"));
        let local = yaml.replace("https://sso.example", "http://127.0.0.1:8081");
        assert!(load_with(&local, &[]).unwrap().oidc["keycloak"].client_secret.is_none());
        for (bad, expected) in [
            (yaml.replace("keycloak:", "Key cloak:"), vec!["oidc.Key cloak", "a-z"]),
            (yaml.replace("name: Keycloak", "name: ''"), vec!["oidc.keycloak.name"]),
            (
                yaml.replace("https://", "http://"),
                vec!["oidc.keycloak.issuer", "https://"],
            ),
            (yaml.replace("/home", "/home?x=1"), vec!["oidc.keycloak.issuer"]),
            (
                yaml.replace("client_id: photolib", "client_id: ''"),
                vec!["oidc.keycloak.client_id"],
            ),
            (
                format!("{yaml}    scopes: [profile]\n"),
                vec!["oidc.keycloak.scopes", "openid"],
            ),
            (
                format!("{yaml}    scopes: [openid, 'a b']\n"),
                vec!["oidc.keycloak.scopes"],
            ),
            (
                yaml.replace("admin: [admins]", "admin: []"),
                vec!["oidc.keycloak.roles"],
            ),
            (yaml.replace("claim: groups", "claim: ''"), vec!["oidc.keycloak.roles"]),
        ] {
            assert_contains(&problems(load_with(&bad, &[])), &expected);
        }
    }

    #[test]
    fn settings_and_policy_switches_pin_from_the_file_or_the_environment_within_their_ranges() {
        assert_eq!(
            load_with(MINIMAL, &[]).unwrap().settings,
            Pinned::default(),
            "nothing pinned"
        );
        let yaml = format!("{MINIMAL}settings:\n  trash_retention_days: 30\n  policy: {{uploads: false}}\n");
        let env = [("PHOTOLIB_SETTINGS__POLICY__MANAGED_LIBRARIES", "false")];
        let pinned = load_with(&yaml, &env).unwrap().settings;
        assert_eq!(pinned.trash_retention_days, Some(30));
        assert_eq!(pinned.names(), ["trash_retention_days"]);
        let off = BTreeMap::from([("managed_libraries".into(), false), ("uploads".into(), false)]);
        assert_eq!(pinned.policy, off);
        for (yaml, expected) in [
            (
                "{trash_retention_days: 0}",
                vec!["settings.trash_retention_days", "1 to 3650"],
            ),
            (
                "{min_free_disk_percent: 51}",
                vec!["settings.min_free_disk_percent", "0 to 50"],
            ),
            (
                "{policy: {upload: false}}",
                vec!["settings.policy.upload", "uploads, folder_browser"],
            ),
            ("{two_factor: true}", vec!["two_factor"]),
        ] {
            assert_contains(
                &problems(load_with(&format!("{MINIMAL}settings: {yaml}\n"), &[])),
                &expected,
            );
        }
    }

    #[test]
    fn placement_names_the_store_of_new_libraries() {
        assert_eq!(load_with(MINIMAL, &[]).unwrap().placement.libraries, "local");
        let yaml = format!(
            "{MINIMAL}stores:\n  b2:\n    kind: s3\n    endpoint: https://s3.example\n    bucket: b\n    access_key_id: id\n\
             placement:\n  libraries: b2\n"
        );
        let secret = [("PHOTOLIB_STORES__B2__SECRET_ACCESS_KEY", "x")];
        assert_eq!(load_with(&yaml, &secret).unwrap().placement.libraries, "b2");
        assert_contains(
            &problems(load_with(&yaml.replace("libraries: b2", "libraries: nas"), &secret)),
            &["placement.libraries", "nas", "stores"],
        );
    }
}
