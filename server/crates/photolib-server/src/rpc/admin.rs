//! The admin console's API (OPS-02, ADR-0063): the server's status, jobs, reprocessing, the audit log, the log tail,
//! settings, stores and the doctor. A change commits together with its audit event.

use std::{fs, path::Path, sync::Arc, time::Duration};

use photolib_storage::check_key;

use buffa::Enumeration;
use buffa_types::google::protobuf::Timestamp;
use connectrpc::{ConnectError, ErrorCode, RequestContext, ServiceRequest, ServiceResult};
use photolib_authz::{Action, Capability, Principal, Resource, can};
use photolib_jobs::{DEFAULT_PAUSE, MAINTENANCE, max_pause};
use photolib_proto::{connect::photolib::api::v1::AdminService, proto::photolib::api::v1 as pb};
use photolib_storage::journal::Journal;
use serde_json::{Value, json};
use sqlx::{PgPool, Postgres, Transaction};
use tokio_util::sync::CancellationToken;

use super::{ApiError, authz::actor, users::internal};
use crate::{
    accounts::{from_db, timestamp},
    backup::{self, BACKUP},
    doctor::{self, Doctor, Status},
    external::{self, Refused},
    guard::Dry,
    logging::Tail,
    policy::PRESETS,
    render,
};

/// The admin console's service on the instance's database.
pub struct Admin {
    pool: PgPool,
    doctor: Arc<Doctor>,
    /// The stores the backups are in, and what stops this process for a restore.
    backups: Option<(Arc<Journal>, CancellationToken)>,
}

impl Admin {
    pub fn new(pool: PgPool, doctor: Arc<Doctor>) -> Self {
        Self {
            pool,
            doctor,
            backups: None,
        }
    }

    /// Lists and restores the backups of `journal`'s stores, cancelling `shutdown` for a restore.
    #[must_use]
    pub fn with_backups(self, journal: Arc<Journal>, shutdown: CancellationToken) -> Self {
        Self {
            backups: Some((journal, shutdown)),
            ..self
        }
    }

    /// The dumps in the stores, the newest drill, the newest that passed and the newest restore.
    async fn backups(&self, response: &mut pb::GetStatusResponse) -> Result<(), ConnectError> {
        if let Some((journal, _)) = &self.backups {
            for (store, name, size) in backup::list(journal.stores()).await {
                let micros = backup::created(&name).map(|secs| secs.saturating_mul(1_000_000));
                response.backups.push(pb::Backup {
                    created_at: micros.map(timestamp).into(),
                    name,
                    size_bytes: i64::try_from(size).unwrap_or(i64::MAX),
                    store,
                    ..Default::default()
                });
            }
        }
        for (kind, verified, field) in [
            ("drill", false, &mut response.last_drill),
            ("drill", true, &mut response.last_verified_restore),
            ("restore", false, &mut response.last_restore),
        ] {
            let run: Option<(String, String, bool, String, i64)> = sqlx::query_as(RUN)
                .bind(kind)
                .bind(verified)
                .fetch_optional(&self.pool)
                .await
                .map_err(internal)?;
            *field = run
                .map(|(store, dump, ok, detail, at)| pb::BackupRun {
                    store,
                    dump,
                    ok,
                    detail,
                    finished_at: Some(timestamp(at)).into(),
                    ..Default::default()
                })
                .into();
        }
        Ok(())
    }

    pub(super) fn seen(&self) -> Option<doctor::Seen> {
        self.doctor.seen.clone()
    }

    async fn begin(&self) -> Result<Transaction<'static, Postgres>, ConnectError> {
        self.pool.begin().await.map_err(internal)
    }

    /// `root` as the root of an external library, `library` if given, in a transaction that holds the lock of
    /// external libraries: a folder under one of `external_roots` that neither holds nor lies in another library or
    /// photolibd's own directories.
    async fn root(
        &self,
        tx: &mut Transaction<'static, Postgres>,
        root: &str,
        library: Option<uuid::Uuid>,
    ) -> Result<String, ConnectError> {
        let others: Vec<String> =
            sqlx::query_scalar("SELECT root_uri FROM libraries WHERE kind = 'external' AND id IS DISTINCT FROM $1")
                .bind(library)
                .fetch_all(&mut **tx)
                .await
                .map_err(internal)?;
        let config = &self.doctor.config;
        let state = config.state_dirs().into_iter().map(|(_, dir)| dir);
        let taken: Vec<_> = (config.data_dir.clone().into_iter().chain(state))
            .chain(others.into_iter().map(Into::into))
            .collect();
        match external::root(Path::new(root), &config.external_roots, &taken) {
            Ok(root) => Ok(root.to_str().ok_or_else(|| invalid("root"))?.to_owned()),
            Err(Refused::Unreadable) => Err(invalid("root")),
            Err(Refused::NotAllowed) => {
                Err(ApiError::new(ErrorCode::PermissionDenied, "library.root_not_allowed").into())
            }
            Err(Refused::Overlaps) => Err(precondition("library.root_overlaps")),
        }
    }

    /// The root and fingerprint of the external library `id`, locked for the transaction.
    async fn external(
        &self,
        tx: &mut Transaction<'static, Postgres>,
        id: uuid::Uuid,
    ) -> Result<(String, Vec<String>), ConnectError> {
        let row: Option<(String, String, Option<Vec<String>>)> =
            sqlx::query_as("SELECT kind, root_uri, fingerprint FROM libraries WHERE id = $1 FOR UPDATE")
                .bind(id)
                .fetch_optional(&mut **tx)
                .await
                .map_err(internal)?;
        match row {
            None => Err(ApiError::new(ErrorCode::NotFound, "library.not_found").into()),
            Some((kind, root, fingerprint)) if kind == "external" => Ok((root, fingerprint.unwrap_or_default())),
            Some(_) => Err(precondition("library.not_external")),
        }
    }

    /// Appends the change to the audit log, by the request's account, and commits it.
    async fn commit(
        &self,
        mut tx: Transaction<'static, Postgres>,
        ctx: &RequestContext,
        action: &str,
        target: Value,
        details: Value,
    ) -> Result<(), ConnectError> {
        sqlx::query("SELECT audit_append($1::uuid, $2, $3::jsonb, $4::jsonb)")
            .bind(actor(ctx)?.to_string())
            .bind(action)
            .bind(target.to_string())
            .bind(details.to_string())
            .execute(&mut *tx)
            .await
            .map_err(internal)?;
        tx.commit().await.map_err(internal)
    }
}

fn invalid(field: &'static str) -> ConnectError {
    ApiError::new(ErrorCode::InvalidArgument, "field.invalid")
        .param("field", field)
        .into()
}

fn precondition(reason: &'static str) -> ConnectError {
    ApiError::new(ErrorCode::FailedPrecondition, reason).into()
}

fn pinned(field: &str) -> ConnectError {
    ApiError::new(ErrorCode::FailedPrecondition, "setting.pinned")
        .param("field", field)
        .into()
}

fn uuid(text: &str, field: &'static str) -> Result<uuid::Uuid, ConnectError> {
    text.parse().map_err(|_| invalid(field))
}

/// `size`, else `default`, at most `max`.
fn page(size: i32, default: i64, max: i64) -> i64 {
    match size {
        ..=0 => default,
        size => i64::from(size).min(max),
    }
}

fn check_status(status: Status) -> pb::CheckStatus {
    match status {
        Status::Ok => pb::CheckStatus::CHECK_STATUS_OK,
        Status::Warn => pb::CheckStatus::CHECK_STATUS_WARN,
        Status::Fail => pb::CheckStatus::CHECK_STATUS_FAIL,
    }
}

/// A library's status, with the dry run of what its last scan holds back.
fn library_status(row: LibraryRow) -> Result<pb::LibraryStatus, ConnectError> {
    let (id, name, owner_handle, kind, state, asset_count, polled, held, missing) = row;
    let held = held.zip(missing).map(|(scan, missing)| {
        let dry = Dry::new(external::HIDE, id, scan, missing.into(), asset_count);
        pb::Confirmation {
            count: dry.count,
            total: dry.total,
            token: dry.token,
            ..Default::default()
        }
    });
    Ok(pb::LibraryStatus {
        library_id: id.to_string(),
        name,
        owner_handle,
        kind: from_db(&kind, "LIBRARY_KIND_").map_err(internal)?,
        state: from_db(&state, "LIBRARY_STATE_").map_err(internal)?,
        asset_count,
        held: held.into(),
        polled_folder_count: polled,
        ..Default::default()
    })
}

fn pause(kind: String, until: Timestamp, by: String) -> pb::JobPause {
    pb::JobPause {
        r#type: kind,
        until_at: Some(until).into(),
        paused_by_user_id: by,
        ..Default::default()
    }
}

const ACCOUNTS: &str = "SELECT u.id::text, u.handle, count(DISTINCT a.id), coalesce(sum(f.size), 0)::bigint
    FROM users u LEFT JOIN assets a ON a.owner_id = u.id LEFT JOIN asset_files f ON f.asset_id = a.id
    GROUP BY u.id ORDER BY u.handle";
const FILES: &str =
    "SELECT role, count(*), coalesce(sum(size), 0)::bigint FROM asset_files GROUP BY role ORDER BY role";
/// Each library with its last scan if that waits for a confirmation.
const LIBRARIES: &str = "SELECT l.id, l.name, u.handle, l.kind, l.state,
      (SELECT count(*) FROM assets a WHERE a.library_id = l.id), coalesce(l.unwatched, 0)::int8, h.id, h.missing
    FROM libraries l JOIN users u ON u.id = l.owner_id
    LEFT JOIN LATERAL (SELECT s.id, s.missing, s.held FROM library_scans s WHERE s.library_id = l.id
      ORDER BY s.started_at DESC LIMIT 1) h ON h.held
    ORDER BY l.name, l.id";
type LibraryRow = (
    uuid::Uuid,
    String,
    String,
    String,
    String,
    i64,
    i64,
    Option<uuid::Uuid>,
    Option<i32>,
);
const JOB_COUNTS: &str = "SELECT type, status, count(*) FROM jobs WHERE status IN ('queued', 'running', 'dead')
    GROUP BY type, status ORDER BY type, status";
const PAUSES: &str = "SELECT type, (extract(EPOCH FROM until) * 1e6)::bigint, coalesce(paused_by::text, '')
    FROM job_pauses WHERE until > now() ORDER BY type";
const JOBS: &str = "SELECT id::text, type, status, attempts, coalesce(error, ''), coalesce(progress, 0)::float8,
      coalesce(idempotency_key, ''), (extract(EPOCH FROM created_at) * 1e6)::bigint,
      (extract(EPOCH FROM run_after) * 1e6)::bigint
    FROM jobs WHERE ($1 = '' OR status = $1) AND ($2 = '' OR type = $2) AND ($3 = '' OR id < $3::uuid)
    ORDER BY id DESC LIMIT $4";
/// Queues a job of each type in `$4` for each asset of the scope, or re-arms a finished one with its key; private
/// libraries are processed on their devices.
const REPROCESS: &str = "
INSERT INTO jobs (id, type, payload, status, idempotency_key)
SELECT photolib_uuidv7(), k.type, convert_to(json_build_object('asset', a.id)::text, 'UTF8'), 'queued',
    k.type || ':' || a.id
FROM assets a
JOIN libraries l ON l.id = a.library_id
CROSS JOIN unnest($4::text[]) AS k (type)
WHERE l.privacy = 'standard' AND (a.id = ANY($1::text[]::uuid[]) OR (a.library_id = $2::uuid AND ($3 = ''
    OR EXISTS (SELECT FROM asset_files f WHERE f.asset_id = a.id AND f.role = 'original'
        AND starts_with(f.key, $3 || '/')))))
ON CONFLICT (idempotency_key) DO UPDATE SET status = 'queued', attempts = 0, run_after = now(), error = NULL
WHERE jobs.status NOT IN ('queued', 'running')
RETURNING id";
const AUDIT: &str = "SELECT id, (extract(EPOCH FROM at) * 1e6)::bigint, coalesce(actor_user_id::text, ''), action,
      coalesce(target::text, ''), coalesce(details::text, '')
    FROM audit_events WHERE ($1 = 0 OR id < $1) ORDER BY id DESC LIMIT $2";
const SETTINGS: &str = "SELECT require_two_factor, face_recognition_default, trash_retention_days,
    min_free_disk_percent, scrub_days, backup_silent_hours, min_free_disk_gb FROM instance_settings";
/// The open findings, each with the asset whose file the object is (a motion photo's video shares its key); an external
/// library's file by its path under the library's root.
const FINDINGS: &str = "SELECT i.store, coalesce(l.root_uri || '/', '') || i.key, i.kind, i.detail,
      (extract(EPOCH FROM i.found_at) * 1e6)::bigint, coalesce(a.id::text, ''), coalesce(a.original_filename, ''),
      coalesce(u.handle, '')
    FROM integrity_findings i LEFT JOIN libraries l ON l.id = i.library_id
    LEFT JOIN LATERAL (SELECT f.asset_id FROM asset_files f JOIN assets x ON x.id = f.asset_id
      WHERE f.storage = i.store AND f.key = i.key AND x.library_id = coalesce(i.library_id, x.library_id)
      ORDER BY f.byte_offset NULLS FIRST LIMIT 1) f ON true
    LEFT JOIN assets a ON a.id = f.asset_id LEFT JOIN users u ON u.id = a.owner_id
    WHERE i.resolved_at IS NULL ORDER BY i.found_at DESC, i.id DESC LIMIT 100";
const SCRUBS: &str = "SELECT store, (extract(EPOCH FROM cycle_ended_at) * 1e6)::bigint FROM scrubs ORDER BY store";
const DEVICE_BACKUPS: &str = "SELECT d.id::text, d.name, u.handle, (extract(EPOCH FROM d.last_seen_at) * 1e6)::bigint,
      (extract(EPOCH FROM b.reported_at) * 1e6)::bigint, b.pending,
      b.reported_at < now() - make_interval(hours => i.backup_silent_hours)
    FROM device_backups b JOIN devices d ON d.id = b.device_id JOIN users u ON u.id = d.user_id
    CROSS JOIN instance_settings i ORDER BY b.reported_at, d.id";

/// The newest run of kind `$1`, only one that worked when `$2`.
const RUN: &str = "SELECT store, dump, ok, detail, (extract(EPOCH FROM finished_at) * 1e6)::bigint FROM backup_runs
    WHERE kind = $1 AND (ok OR NOT $2) ORDER BY finished_at DESC, id DESC LIMIT 1";

type SettingsRow = (bool, bool, i32, i32, i32, i32, i32);
type FindingRow = (String, String, String, String, i64, String, String, String);
type DeviceBackupRow = (String, String, String, Option<i64>, i64, i64, bool);

fn settings((two_factor, faces, retention, percent, scrub, silent, gb): SettingsRow) -> pb::Settings {
    let positive = |value: i32| u32::try_from(value).unwrap_or_default();
    pb::Settings {
        require_two_factor: two_factor,
        face_recognition_default: faces,
        trash_retention_days: positive(retention),
        min_free_disk_percent: positive(percent),
        scrub_days: positive(scrub),
        backup_silent_hours: positive(silent),
        min_free_disk_gb: positive(gb),
        ..Default::default()
    }
}

/// What the health dashboard adds to the status: open integrity findings, the scrubs and the devices' backups.
async fn health(pool: &PgPool, response: &mut pb::GetStatusResponse) -> Result<(), ConnectError> {
    let findings: Vec<FindingRow> = sqlx::query_as(FINDINGS).fetch_all(pool).await.map_err(internal)?;
    for (store, key, kind, detail, found_at, asset_id, file_name, owner_handle) in findings {
        response.findings.push(pb::IntegrityFinding {
            store,
            key,
            kind: from_db(&kind, "FINDING_KIND_").map_err(internal)?,
            detail,
            found_at: Some(timestamp(found_at)).into(),
            asset_id,
            file_name,
            owner_handle,
            ..Default::default()
        });
    }
    let scrubs: Vec<(String, Option<i64>)> = sqlx::query_as(SCRUBS).fetch_all(pool).await.map_err(internal)?;
    response.scrubs = (scrubs.into_iter())
        .map(|(store, ended)| pb::StoreScrub {
            store,
            cycle_ended_at: ended.map(timestamp).into(),
            ..Default::default()
        })
        .collect();
    let backups: Vec<DeviceBackupRow> = sqlx::query_as(DEVICE_BACKUPS).fetch_all(pool).await.map_err(internal)?;
    response.device_backups = (backups.into_iter())
        .map(
            |(device_id, name, owner_handle, seen, reported, pending_count, silent)| pb::DeviceBackup {
                device_id,
                name,
                owner_handle,
                last_seen_at: seen.map(timestamp).into(),
                reported_at: Some(timestamp(reported)).into(),
                pending_count,
                silent,
                ..Default::default()
            },
        )
        .collect();
    Ok(())
}

/// A level of the server's policy: the server's, an account's or a library's switches, and the account whose effective
/// values the console shows there (ADR-0240).
struct Level {
    user: Option<uuid::Uuid>,
    library: Option<uuid::Uuid>,
    account: Option<uuid::Uuid>,
}

impl Admin {
    /// The level `user_id` and `library_id` name, as `GetPolicyRequest` says.
    async fn level(&self, user_id: &str, library_id: &str) -> Result<Level, ConnectError> {
        let user = match user_id {
            "" => None,
            id => {
                let id = uuid(id, "user_id")?;
                let found: bool = sqlx::query_scalar("SELECT EXISTS (SELECT FROM users WHERE id = $1)")
                    .bind(id)
                    .fetch_one(&self.pool)
                    .await
                    .map_err(internal)?;
                if !found {
                    return Err(ApiError::new(ErrorCode::NotFound, "user.not_found").into());
                }
                Some(id)
            }
        };
        if library_id.is_empty() {
            return Ok(Level {
                user,
                library: None,
                account: user,
            });
        }
        let library = uuid(library_id, "library_id")?;
        let owner: Option<uuid::Uuid> = sqlx::query_scalar("SELECT owner_id FROM libraries WHERE id = $1")
            .bind(library)
            .fetch_optional(&self.pool)
            .await
            .map_err(internal)?;
        let owner = owner.ok_or_else(|| ApiError::new(ErrorCode::NotFound, "library.not_found"))?;
        Ok(Level {
            user: None,
            library: Some(library),
            account: user.or(Some(owner)),
        })
    }

    /// Every capability's switch as `level` sees it.
    async fn switches(&self, level: &Level) -> Result<Vec<pb::PolicySwitch>, ConnectError> {
        let effective = photolib_authz::policy(&self.pool, level.account, level.library).await;
        let own: Vec<(String, bool)> = sqlx::query_as(
            "SELECT capability, enabled FROM policy_switches
             WHERE user_id IS NOT DISTINCT FROM $1 AND library_id IS NOT DISTINCT FROM $2",
        )
        .bind(level.user)
        .bind(level.library)
        .fetch_all(&self.pool)
        .await
        .map_err(internal)?;
        let switches = effective.map_err(internal)?.into_iter().zip(1..);
        Ok(switches
            .map(|((capability, enabled, source), number)| pb::PolicySwitch {
                capability: pb::Capability::from_i32(number).unwrap_or_default().into(),
                enabled,
                source: match source.as_str() {
                    "config" => pb::PolicySource::POLICY_SOURCE_CONFIG,
                    "library" => pb::PolicySource::POLICY_SOURCE_LIBRARY,
                    "user" => pb::PolicySource::POLICY_SOURCE_USER,
                    "server" => pb::PolicySource::POLICY_SOURCE_SERVER,
                    _ => pb::PolicySource::POLICY_SOURCE_DEFAULT,
                }
                .into(),
                set: own
                    .iter()
                    .find(|(name, _)| name == capability.name())
                    .map(|(_, on)| *on),
                ..Default::default()
            })
            .collect())
    }
}

#[allow(refining_impl_trait)]
impl AdminService for Admin {
    async fn get_status(
        &self,
        _ctx: RequestContext,
        _request: ServiceRequest<'_, pb::GetStatusRequest>,
    ) -> ServiceResult<pb::GetStatusResponse> {
        let pool = &self.pool;
        let accounts: Vec<(String, String, i64, i64)> =
            sqlx::query_as(ACCOUNTS).fetch_all(pool).await.map_err(internal)?;
        let files: Vec<(String, i64, i64)> = sqlx::query_as(FILES).fetch_all(pool).await.map_err(internal)?;
        let libraries: Vec<LibraryRow> = sqlx::query_as(LIBRARIES).fetch_all(pool).await.map_err(internal)?;
        let jobs: Vec<(String, String, i64)> = sqlx::query_as(JOB_COUNTS).fetch_all(pool).await.map_err(internal)?;
        let pauses: Vec<(String, i64, String)> = sqlx::query_as(PAUSES).fetch_all(pool).await.map_err(internal)?;
        let mut response = pb::GetStatusResponse {
            accounts: accounts
                .into_iter()
                .map(|(user_id, handle, asset_count, size_bytes)| pb::AccountUsage {
                    user_id,
                    handle,
                    asset_count,
                    size_bytes,
                    ..Default::default()
                })
                .collect(),
            files: files
                .into_iter()
                .map(|(role, file_count, size_bytes)| pb::FileUsage {
                    role,
                    file_count,
                    size_bytes,
                    ..Default::default()
                })
                .collect(),
            pauses: pauses
                .into_iter()
                .map(|(kind, until, by)| pause(kind, timestamp(until), by))
                .collect(),
            ..Default::default()
        };
        for library in libraries {
            response.libraries.push(library_status(library)?);
        }
        for (kind, status, count) in jobs {
            response.jobs.push(pb::JobCount {
                r#type: kind,
                status: from_db(&status, "JOB_STATUS_").map_err(internal)?,
                count,
                ..Default::default()
            });
        }
        health(pool, &mut response).await?;
        self.backups(&mut response).await?;
        Ok(response.into())
    }

    async fn list_stores(
        &self,
        _ctx: RequestContext,
        _request: ServiceRequest<'_, pb::ListStoresRequest>,
    ) -> ServiceResult<pb::ListStoresResponse> {
        let stores = self
            .doctor
            .stores()
            .await
            .into_iter()
            .map(|(check, free)| pb::StoreStatus {
                name: check.name.trim_start_matches("store ").into(),
                status: check_status(check.status).into(),
                detail: check.detail,
                free_bytes: free.map(|bytes| bytes as i64),
                ..Default::default()
            });
        Ok(pb::ListStoresResponse {
            stores: stores.collect(),
            ..Default::default()
        }
        .into())
    }

    async fn list_jobs(
        &self,
        _ctx: RequestContext,
        request: ServiceRequest<'_, pb::ListJobsRequest>,
    ) -> ServiceResult<pb::ListJobsResponse> {
        let request = request.to_owned_message();
        if !request.page_token.is_empty() {
            uuid(&request.page_token, "page_token")?;
        }
        let status = match request.status.as_known() {
            Some(pb::JobStatus::JOB_STATUS_UNSPECIFIED) | None => String::new(),
            Some(status) => status.proto_name()["JOB_STATUS_".len()..].to_lowercase(),
        };
        let limit = page(request.page_size, 100, 500);
        type Row = (String, String, String, i32, String, f64, String, i64, i64);
        let rows: Vec<Row> = sqlx::query_as(JOBS)
            .bind(status)
            .bind(&request.r#type)
            .bind(&request.page_token)
            .bind(limit)
            .fetch_all(&self.pool)
            .await
            .map_err(internal)?;
        let next_page_token = match rows.len() as i64 == limit {
            true => rows.last().map(|row| row.0.clone()).unwrap_or_default(),
            false => String::new(),
        };
        let mut jobs = vec![];
        for (job_id, kind, status, attempts, error, progress, key, created, run) in rows {
            jobs.push(pb::Job {
                job_id,
                r#type: kind,
                status: from_db(&status, "JOB_STATUS_").map_err(internal)?,
                attempts,
                error,
                progress_percent: (progress * 100.0).round() as u32,
                key,
                created_at: Some(timestamp(created)).into(),
                run_at: Some(timestamp(run)).into(),
                ..Default::default()
            });
        }
        Ok(pb::ListJobsResponse {
            jobs,
            next_page_token,
            ..Default::default()
        }
        .into())
    }

    async fn retry_job(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::RetryJobRequest>,
    ) -> ServiceResult<pb::RetryJobResponse> {
        let id = uuid(&request.to_owned_message().job_id, "job_id")?;
        let mut tx = self.begin().await?;
        if !photolib_jobs::retry(&mut tx, id).await.map_err(internal)? {
            return Err(precondition("job.not_retryable"));
        }
        let target = json!({ "job_id": id.to_string() });
        self.commit(tx, &ctx, "job.retry", target, Value::Null).await?;
        Ok(pb::RetryJobResponse::default().into())
    }

    async fn cancel_job(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::CancelJobRequest>,
    ) -> ServiceResult<pb::CancelJobResponse> {
        let id = uuid(&request.to_owned_message().job_id, "job_id")?;
        let mut tx = self.begin().await?;
        if !photolib_jobs::cancel(&mut tx, id).await.map_err(internal)? {
            return Err(precondition("job.not_cancellable"));
        }
        let target = json!({ "job_id": id.to_string() });
        self.commit(tx, &ctx, "job.cancel", target, Value::Null).await?;
        Ok(pb::CancelJobResponse::default().into())
    }

    async fn pause_job_type(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::PauseJobTypeRequest>,
    ) -> ServiceResult<pb::PauseJobTypeResponse> {
        let request = request.to_owned_message();
        if request.r#type.is_empty() {
            return Err(invalid("type"));
        }
        let length = match request.pause_minutes {
            0 => DEFAULT_PAUSE,
            minutes => Duration::from_secs(u64::from(minutes) * 60),
        };
        if length > max_pause(&request.r#type) {
            return Err(invalid("pause_minutes"));
        }
        let who = ctx.extensions().get().copied().unwrap_or(Principal::Anonymous);
        if MAINTENANCE.contains(&request.r#type.as_str())
            && !can(&self.pool, who, Action::PauseMaintenance, Resource::Server)
                .await
                .map_err(internal)?
        {
            return Err(ApiError::new(ErrorCode::PermissionDenied, "job.maintenance").into());
        }
        let by = actor(&ctx)?;
        let mut tx = self.begin().await?;
        let until = photolib_jobs::pause(&mut tx, &request.r#type, length, Some(by))
            .await
            .map_err(internal)?;
        let target = json!({ "type": request.r#type });
        let details = json!({ "minutes": length.as_secs() / 60 });
        self.commit(tx, &ctx, "job.pause", target, details).await?;
        Ok(pb::PauseJobTypeResponse {
            pause: Some(pause(request.r#type, until.into(), by.to_string())).into(),
            ..Default::default()
        }
        .into())
    }

    async fn resume_job_type(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::ResumeJobTypeRequest>,
    ) -> ServiceResult<pb::ResumeJobTypeResponse> {
        let kind = request.to_owned_message().r#type;
        let mut tx = self.begin().await?;
        if !photolib_jobs::resume(&mut tx, &kind).await.map_err(internal)? {
            return Err(precondition("job.not_paused"));
        }
        let target = json!({ "type": kind });
        self.commit(tx, &ctx, "job.resume", target, Value::Null).await?;
        Ok(pb::ResumeJobTypeResponse::default().into())
    }

    async fn reprocess(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::ReprocessRequest>,
    ) -> ServiceResult<pb::ReprocessResponse> {
        let request = request.to_owned_message();
        let mut kinds = vec![];
        for kind in &request.kinds {
            kinds.push(match kind.as_known() {
                Some(pb::ReprocessKind::REPROCESS_KIND_METADATA) => "metadata",
                Some(pb::ReprocessKind::REPROCESS_KIND_RENDITIONS) => "renditions",
                Some(pb::ReprocessKind::REPROCESS_KIND_FACES) => "faces",
                _ => return Err(invalid("kinds")),
            });
        }
        let selection = !request.asset_ids.is_empty();
        if kinds.is_empty() {
            return Err(invalid("kinds"));
        }
        if selection == !request.library_id.is_empty() {
            return Err(invalid("library_id"));
        }
        if selection && !request.folder.is_empty() {
            return Err(invalid("folder"));
        }
        for id in &request.asset_ids {
            uuid(id, "asset_ids")?;
        }
        let library = match selection {
            true => None,
            false => Some(uuid(&request.library_id, "library_id")?.to_string()),
        };
        let folder = request.folder.trim_matches('/');
        let mut tx = self.begin().await?;
        let queued: Vec<uuid::Uuid> = sqlx::query_scalar(REPROCESS)
            .bind(&request.asset_ids)
            .bind(&library)
            .bind(folder)
            .bind(&kinds)
            .fetch_all(&mut *tx)
            .await
            .map_err(internal)?;
        photolib_jobs::notify(&mut *tx, uuid::Uuid::nil())
            .await
            .map_err(internal)?;
        let target = json!({ "library_id": library, "folder": folder, "asset_ids": request.asset_ids });
        let details = json!({ "kinds": kinds, "jobs": queued.len() });
        self.commit(tx, &ctx, "job.reprocess", target, details).await?;
        Ok(pb::ReprocessResponse {
            job_count: queued.len() as i64,
            ..Default::default()
        }
        .into())
    }

    async fn list_audit_events(
        &self,
        _ctx: RequestContext,
        request: ServiceRequest<'_, pb::ListAuditEventsRequest>,
    ) -> ServiceResult<pb::ListAuditEventsResponse> {
        let request = request.to_owned_message();
        let before: i64 = match request.page_token.as_str() {
            "" => 0,
            token => token.parse().map_err(|_| invalid("page_token"))?,
        };
        let limit = page(request.page_size, 100, 500);
        let rows: Vec<(i64, i64, String, String, String, String)> = sqlx::query_as(AUDIT)
            .bind(before)
            .bind(limit)
            .fetch_all(&self.pool)
            .await
            .map_err(internal)?;
        let next_page_token = match rows.len() as i64 == limit {
            true => rows.last().map(|row| row.0.to_string()).unwrap_or_default(),
            false => String::new(),
        };
        let events = rows
            .into_iter()
            .map(|(sequence, at, actor, action, target, details)| pb::AuditEvent {
                sequence,
                recorded_at: Some(timestamp(at)).into(),
                actor_user_id: actor,
                action,
                target_json: target,
                details_json: details,
                ..Default::default()
            });
        Ok(pb::ListAuditEventsResponse {
            events: events.collect(),
            next_page_token,
            ..Default::default()
        }
        .into())
    }

    async fn tail_logs(
        &self,
        _ctx: RequestContext,
        request: ServiceRequest<'_, pb::TailLogsRequest>,
    ) -> ServiceResult<pb::TailLogsResponse> {
        let count = page(request.to_owned_message().line_count as i32, 200, Tail::LINES as i64);
        let tail = self.doctor.tail.as_ref();
        Ok(pb::TailLogsResponse {
            lines: tail.map(|tail| tail.lines(count as usize)).unwrap_or_default(),
            ..Default::default()
        }
        .into())
    }

    async fn get_settings(
        &self,
        _ctx: RequestContext,
        _request: ServiceRequest<'_, pb::GetSettingsRequest>,
    ) -> ServiceResult<pb::GetSettingsResponse> {
        let row = sqlx::query_as(SETTINGS).fetch_one(&self.pool).await.map_err(internal)?;
        let pinned = self.doctor.config.settings.names();
        Ok(pb::GetSettingsResponse {
            settings: Some(settings(row)).into(),
            pinned: pinned.into_iter().map(Into::into).collect(),
            ..Default::default()
        }
        .into())
    }

    async fn update_settings(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::UpdateSettingsRequest>,
    ) -> ServiceResult<pb::UpdateSettingsResponse> {
        let new = request.to_owned_message().settings.into_option().unwrap_or_default();
        if !(1..=3650).contains(&new.trash_retention_days) {
            return Err(invalid("trash_retention_days"));
        }
        if new.min_free_disk_percent > 50 {
            return Err(invalid("min_free_disk_percent"));
        }
        if new.scrub_days > 3650 {
            return Err(invalid("scrub_days"));
        }
        if new.backup_silent_hours > 8760 {
            return Err(invalid("backup_silent_hours"));
        }
        if new.min_free_disk_gb > 100_000 {
            return Err(invalid("min_free_disk_gb"));
        }
        let pins = &self.doctor.config.settings;
        for (field, changed) in [
            (
                "require_two_factor",
                pins.require_two_factor.map(|on| on != new.require_two_factor),
            ),
            (
                "face_recognition_default",
                pins.face_recognition_default
                    .map(|on| on != new.face_recognition_default),
            ),
            (
                "trash_retention_days",
                pins.trash_retention_days.map(|days| days != new.trash_retention_days),
            ),
            (
                "min_free_disk_percent",
                pins.min_free_disk_percent
                    .map(|percent| percent != new.min_free_disk_percent),
            ),
            // 0 keeps these two as they are.
            (
                "scrub_days",
                pins.scrub_days.map(|days| ![0, days].contains(&new.scrub_days)),
            ),
            (
                "backup_silent_hours",
                pins.backup_silent_hours
                    .map(|hours| ![0, hours].contains(&new.backup_silent_hours)),
            ),
        ] {
            if changed == Some(true) {
                return Err(pinned(field));
            }
        }
        let mut tx = self.begin().await?;
        let row = sqlx::query_as(
            "UPDATE instance_settings SET require_two_factor = $1, face_recognition_default = $2,
               trash_retention_days = $3, min_free_disk_percent = $4, scrub_days = coalesce(nullif($5, 0), scrub_days),
               backup_silent_hours = coalesce(nullif($6, 0), backup_silent_hours), min_free_disk_gb = $7
             RETURNING require_two_factor, face_recognition_default, trash_retention_days, min_free_disk_percent,
               scrub_days, backup_silent_hours, min_free_disk_gb",
        )
        .bind(new.require_two_factor)
        .bind(new.face_recognition_default)
        .bind(new.trash_retention_days.cast_signed())
        .bind(new.min_free_disk_percent.cast_signed())
        .bind(i64::from(new.scrub_days))
        .bind(i64::from(new.backup_silent_hours))
        .bind(new.min_free_disk_gb.cast_signed())
        .fetch_one(&mut *tx)
        .await
        .map_err(internal)?;
        let stored = settings(row);
        let details = serde_json::to_value(&stored).map_err(internal)?;
        self.commit(tx, &ctx, "settings.update", json!({}), details).await?;
        Ok(pb::UpdateSettingsResponse {
            settings: Some(stored).into(),
            ..Default::default()
        }
        .into())
    }

    async fn get_policy(
        &self,
        _ctx: RequestContext,
        request: ServiceRequest<'_, pb::GetPolicyRequest>,
    ) -> ServiceResult<pb::GetPolicyResponse> {
        let request = request.to_owned_message();
        let level = self.level(&request.user_id, &request.library_id).await?;
        Ok(pb::GetPolicyResponse {
            switches: self.switches(&level).await?,
            ..Default::default()
        }
        .into())
    }

    async fn update_policy(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::UpdatePolicyRequest>,
    ) -> ServiceResult<pb::UpdatePolicyResponse> {
        let request = request.to_owned_message();
        let capability = (request.capability.as_known())
            .and_then(|known| {
                Capability::ALL
                    .get(usize::try_from(known.to_i32()).ok()?.checked_sub(1)?)
                    .copied()
            })
            .ok_or_else(|| invalid("capability"))?;
        if self.doctor.config.settings.policy.contains_key(capability.name()) {
            return Err(pinned(capability.name()));
        }
        let level = self.level(&request.user_id, &request.library_id).await?;
        let mut tx = self.begin().await?;
        let change = match request.enabled {
            Some(on) => sqlx::query(
                "INSERT INTO policy_switches (capability, user_id, library_id, enabled) VALUES ($1, $2, $3, $4)
                 ON CONFLICT (capability, user_id, library_id) DO UPDATE SET enabled = excluded.enabled",
            )
            .bind(capability.name())
            .bind(level.user)
            .bind(level.library)
            .bind(on),
            None => sqlx::query(
                "DELETE FROM policy_switches
                 WHERE capability = $1 AND user_id IS NOT DISTINCT FROM $2 AND library_id IS NOT DISTINCT FROM $3",
            )
            .bind(capability.name())
            .bind(level.user)
            .bind(level.library),
        };
        change.execute(&mut *tx).await.map_err(internal)?;
        let target = json!({ "user_id": level.user, "library_id": level.library, "capability": capability.name() });
        let details = json!({ "enabled": request.enabled });
        self.commit(tx, &ctx, "policy.update", target, details).await?;
        Ok(pb::UpdatePolicyResponse {
            switches: self.switches(&level).await?,
            ..Default::default()
        }
        .into())
    }

    async fn apply_preset(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::ApplyPresetRequest>,
    ) -> ServiceResult<pb::ApplyPresetResponse> {
        let preset = request.to_owned_message().preset;
        let name = preset
            .as_known()
            .map(|known| known.proto_name()["PRESET_".len()..].to_lowercase());
        let (name, off) = (PRESETS.iter())
            .find(|(preset, _)| Some(*preset) == name.as_deref())
            .ok_or_else(|| invalid("preset"))?;
        let pins = &self.doctor.config.settings.policy;
        let free = Capability::ALL
            .into_iter()
            .filter(|capability| !pins.contains_key(capability.name()));
        let (names, values): (Vec<&str>, Vec<bool>) = free.map(|c| (c.name(), !off.contains(&c))).unzip();
        let mut tx = self.begin().await?;
        let cleared = sqlx::query(
            "DELETE FROM policy_switches WHERE (user_id IS NOT NULL OR library_id IS NOT NULL) AND capability = ANY($1)",
        )
        .bind(&names)
        .execute(&mut *tx)
        .await
        .map_err(internal)?;
        sqlx::query(
            "INSERT INTO policy_switches (capability, enabled) SELECT * FROM unnest($1::text[], $2::bool[])
             ON CONFLICT (capability, user_id, library_id) DO UPDATE SET enabled = excluded.enabled",
        )
        .bind(&names)
        .bind(&values)
        .execute(&mut *tx)
        .await
        .map_err(internal)?;
        let switches: serde_json::Map<String, Value> = names
            .iter()
            .zip(&values)
            .map(|(name, on)| (name.to_string(), json!(on)))
            .collect();
        let details = json!({ "preset": name, "switches": switches, "cleared": cleared.rows_affected() });
        self.commit(tx, &ctx, "policy.preset", json!({}), details).await?;
        let server = Level {
            user: None,
            library: None,
            account: None,
        };
        Ok(pb::ApplyPresetResponse {
            switches: self.switches(&server).await?,
            ..Default::default()
        }
        .into())
    }

    async fn get_diagnostics(
        &self,
        _ctx: RequestContext,
        _request: ServiceRequest<'_, pb::GetDiagnosticsRequest>,
    ) -> ServiceResult<pb::GetDiagnosticsResponse> {
        let checks = self.doctor.checks().await;
        let bundle = self.doctor.bundle(&checks);
        Ok(pb::GetDiagnosticsResponse {
            checks: checks
                .into_iter()
                .map(|check| pb::Check {
                    name: check.name,
                    status: check_status(check.status).into(),
                    detail: check.detail,
                    ..Default::default()
                })
                .collect(),
            bundle_json: serde_json::to_string_pretty(&bundle).unwrap_or_default(),
            ..Default::default()
        }
        .into())
    }
    async fn create_external_library(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::CreateExternalLibraryRequest>,
    ) -> ServiceResult<pb::CreateExternalLibraryResponse> {
        let request = request.to_owned_message();
        let owner = uuid(&request.owner_user_id, "owner_user_id")?;
        let name = request.name.trim();
        if name.is_empty() {
            return Err(invalid("name"));
        }
        let mut tx = self.begin().await?;
        // One at a time, so that two new libraries cannot overlap.
        sqlx::query("SELECT pg_advisory_xact_lock(hashtext('external_libraries'))")
            .execute(&mut *tx)
            .await
            .map_err(internal)?;
        let found: bool = sqlx::query_scalar("SELECT EXISTS (SELECT FROM users WHERE id = $1)")
            .bind(owner)
            .fetch_one(&mut *tx)
            .await
            .map_err(internal)?;
        if !found {
            return Err(ApiError::new(ErrorCode::NotFound, "user.not_found").into());
        }
        let root = self.root(&mut tx, &request.root, None).await?;
        let policy = json!({
            "files_per_second": request.files_per_second.unwrap_or(external::FILES_PER_SECOND),
            "bytes_per_second": request.bytes_per_second.unwrap_or(external::BYTES_PER_SECOND),
        });
        let id = uuid::Uuid::now_v7();
        sqlx::query(
            "INSERT INTO libraries (id, owner_id, name, kind, access, root_uri, scan_policy)
             VALUES ($1, $2, $3, 'external', 'ro', $4, $5)",
        )
        .bind(id)
        .bind(owner)
        .bind(name)
        .bind(&root)
        .bind(&policy)
        .execute(&mut *tx)
        .await
        .map_err(internal)?;
        external::scan(&mut tx, id).await.map_err(internal)?;
        let target = json!({ "library_id": id.to_string() });
        let details = json!({ "owner_user_id": owner.to_string(), "name": name, "root": root, "policy": policy });
        self.commit(tx, &ctx, "library.create", target, details).await?;
        Ok(pb::CreateExternalLibraryResponse {
            library_id: id.to_string(),
            ..Default::default()
        }
        .into())
    }

    async fn scan_library(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::ScanLibraryRequest>,
    ) -> ServiceResult<pb::ScanLibraryResponse> {
        let id = uuid(&request.to_owned_message().library_id, "library_id")?;
        let mut tx = self.begin().await?;
        self.external(&mut tx, id).await?;
        if external::scan(&mut tx, id).await.map_err(internal)?.is_none() {
            return Err(precondition("library.scanning"));
        }
        let target = json!({ "library_id": id.to_string() });
        self.commit(tx, &ctx, "library.scan", target, Value::Null).await?;
        Ok(pb::ScanLibraryResponse::default().into())
    }

    async fn back_up_now(
        &self,
        ctx: RequestContext,
        _request: ServiceRequest<'_, pb::BackUpNowRequest>,
    ) -> ServiceResult<pb::BackUpNowResponse> {
        let mut tx = self.begin().await?;
        let job = photolib_jobs::enqueue(&mut tx, &photolib_jobs::NewJob::new(BACKUP, b""))
            .await
            .map_err(internal)?;
        let target = json!({ "job_id": job.to_string() });
        self.commit(tx, &ctx, "backup.start", target, Value::Null).await?;
        Ok(pb::BackUpNowResponse {
            job_id: job.to_string(),
            ..Default::default()
        }
        .into())
    }

    async fn restore_backup(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::RestoreBackupRequest>,
    ) -> ServiceResult<pb::RestoreBackupResponse> {
        let request = request.to_owned_message();
        let who = ctx.extensions().get().copied().unwrap_or(Principal::Anonymous);
        if !can(&self.pool, who, Action::PauseMaintenance, Resource::Server)
            .await
            .map_err(internal)?
        {
            return Err(ApiError::new(ErrorCode::PermissionDenied, "backup.restore").into());
        }
        let (Some((journal, shutdown)), Some(data_dir)) = (&self.backups, &self.doctor.config.data_dir) else {
            return Err(internal("this process keeps no backups"));
        };
        let store = journal.stores().get(&request.store).ok();
        let found = match (store, backup::created(&request.name)) {
            (Some(store), Some(_)) => store.head(&request.name).await.map_err(internal)?.is_some(),
            _ => false,
        };
        if !found {
            return Err(ApiError::new(ErrorCode::NotFound, "backup.not_found").into());
        }
        backup::request_restore(data_dir, &request.store, &request.name).map_err(internal)?;
        let target = json!({ "store": request.store, "dump": request.name });
        self.commit(self.begin().await?, &ctx, "backup.restore", target, Value::Null)
            .await?;
        tracing::warn!(
            store = request.store,
            dump = request.name,
            "stopping to restore a backup"
        );
        shutdown.cancel();
        Ok(pb::RestoreBackupResponse::default().into())
    }

    async fn confirm_scan(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::ConfirmScanRequest>,
    ) -> ServiceResult<pb::ConfirmScanResponse> {
        let request = request.to_owned_message();
        let id = uuid(&request.library_id, "library_id")?;
        let mut tx = self.begin().await?;
        self.external(&mut tx, id).await?;
        let hidden = match external::confirm(&mut tx, id, &request.confirmation_token)
            .await
            .map_err(internal)?
        {
            None => return Err(precondition("library.nothing_held")),
            Some(Err(dry)) => {
                let error = ApiError::new(ErrorCode::FailedPrecondition, "confirmation.required");
                return Err(error
                    .param("count", dry.count)
                    .param("total", dry.total)
                    .param("token", dry.token)
                    .into());
            }
            Some(Ok(hidden)) => hidden,
        };
        let target = json!({ "library_id": id.to_string() });
        self.commit(tx, &ctx, "library.hide", target, json!({ "count": hidden }))
            .await?;
        Ok(pb::ConfirmScanResponse {
            hidden_count: hidden,
            ..Default::default()
        }
        .into())
    }

    async fn hint_paths(
        &self,
        _ctx: RequestContext,
        request: ServiceRequest<'_, pb::HintPathsRequest>,
    ) -> ServiceResult<pb::HintPathsResponse> {
        let request = request.to_owned_message();
        let id = uuid(&request.library_id, "library_id")?;
        if request.paths.len() > 1000 {
            return Err(invalid("paths"));
        }
        let mut tx = self.begin().await?;
        let (root, _) = self.external(&mut tx, id).await?;
        let mut dirs = vec![];
        for path in &request.paths {
            let relative = match Path::new(path).strip_prefix(&root) {
                Ok(relative) => relative.to_str(),
                Err(_) => Some(path.as_str()).filter(|path| !path.starts_with('/')),
            };
            let path = relative
                .map(|path| path.trim_end_matches('/'))
                .ok_or_else(|| invalid("paths"))?;
            if !path.is_empty() && check_key(path).is_err() {
                return Err(invalid("paths"));
            }
            dirs.extend([path, path.rsplit_once('/').map_or("", |(dir, _)| dir)]);
        }
        dirs.sort_unstable();
        dirs.dedup();
        external::hint(&mut tx, id, &dirs).await.map_err(internal)?;
        tx.commit().await.map_err(internal)?;
        Ok(pb::HintPathsResponse::default().into())
    }

    async fn relocate_library(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::RelocateLibraryRequest>,
    ) -> ServiceResult<pb::RelocateLibraryResponse> {
        let request = request.to_owned_message();
        let id = uuid(&request.library_id, "library_id")?;
        let mut tx = self.begin().await?;
        sqlx::query("SELECT pg_advisory_xact_lock(hashtext('external_libraries'))")
            .execute(&mut *tx)
            .await
            .map_err(internal)?;
        let (from, fingerprint) = self.external(&mut tx, id).await?;
        let root = self.root(&mut tx, &request.root, Some(id)).await?;
        let names: Vec<String> = (fs::read_dir(&root).into_iter().flatten().flatten())
            .filter_map(|entry| entry.file_name().into_string().ok())
            .collect();
        if !fingerprint.is_empty() && !fingerprint.iter().any(|name| names.contains(name)) {
            return Err(precondition("library.root_differs"));
        }
        sqlx::query("UPDATE libraries SET root_uri = $2 WHERE id = $1")
            .bind(id)
            .bind(&root)
            .execute(&mut *tx)
            .await
            .map_err(internal)?;
        if external::scan(&mut tx, id).await.map_err(internal)?.is_none() {
            return Err(precondition("library.scanning"));
        }
        let target = json!({ "library_id": id.to_string() });
        self.commit(
            tx,
            &ctx,
            "library.relocate",
            target,
            json!({ "from": from, "root": root }),
        )
        .await?;
        Ok(pb::RelocateLibraryResponse::default().into())
    }

    async fn set_rendition_quality(
        &self,
        ctx: RequestContext,
        request: ServiceRequest<'_, pb::SetRenditionQualityRequest>,
    ) -> ServiceResult<pb::SetRenditionQualityResponse> {
        let request = request.to_owned_message();
        let id = uuid(&request.library_id, "library_id")?;
        if ![render::HIGH, render::STANDARD].contains(&request.quality.as_str()) {
            return Err(invalid("quality"));
        }
        let mut tx = self.begin().await?;
        let changed = sqlx::query("UPDATE libraries SET rendition_quality = $2 WHERE id = $1")
            .bind(id)
            .bind(&request.quality)
            .execute(&mut *tx)
            .await
            .map_err(internal)?;
        if changed.rows_affected() == 0 {
            return Err(ApiError::new(ErrorCode::NotFound, "library.not_found").into());
        }
        // The scheduler's reconciler renders the library's previews again: the other spec is missing.
        let target = json!({ "library_id": id.to_string() });
        self.commit(
            tx,
            &ctx,
            "library.rendition_quality",
            target,
            json!({ "quality": request.quality }),
        )
        .await?;
        Ok(pb::SetRenditionQualityResponse::default().into())
    }
}

#[cfg(test)]
mod tests {
    use axum::http::StatusCode;
    use buffa::Enumeration;
    use serde_json::{Value, json};

    use super::pb::ApiKeyScope;
    use crate::rpc::{
        keys::tests::key,
        users::tests::{Api, call, denied, with_admin},
    };

    async fn sql(api: &Api, statement: &str) {
        sqlx::raw_sql(statement).execute(&api.pool).await.unwrap();
    }

    /// The first administrator, without the job that creates their library: these tests count the jobs they make.
    async fn admin() -> (Api, photolib_proto::proto::photolib::api::v1::User) {
        let (api, root) = with_admin().await;
        sql(&api, "DELETE FROM jobs WHERE type = 'library-create'").await;
        (api, root)
    }

    /// The queued jobs by type and payload asset.
    async fn jobs(api: &Api) -> Vec<(String, String)> {
        sqlx::query_as(
            "SELECT type, convert_from(payload, 'UTF8')::jsonb ->> 'asset' FROM jobs WHERE status = 'queued'",
        )
        .fetch_all(&api.pool)
        .await
        .unwrap()
    }

    /// Ann's libraries L1 and L2 and her private P; L1's originals sit in folders, as `md5(name)` ids.
    const WORLD: &str = "
INSERT INTO users (id, handle, display_name) VALUES (md5('ann')::uuid, 'ann', 'Ann');
INSERT INTO libraries (id, owner_id, name, kind, privacy, root_uri)
SELECT md5(name)::uuid, md5('ann')::uuid, name, 'managed', privacy, name
FROM (VALUES ('L1', 'standard'), ('L2', 'standard'), ('P', 'private')) AS l (name, privacy);
INSERT INTO assets (id, library_id, owner_id, source)
SELECT md5(name)::uuid, md5(library)::uuid, md5('ann')::uuid, 'upload'
FROM (VALUES ('a', 'L1'), ('b', 'L1'), ('c', 'L1'), ('d', 'L1'), ('e', 'L2'), ('p', 'P')) AS a (name, library);
INSERT INTO asset_files (id, asset_id, role, storage, key, size)
SELECT gen_random_uuid(), md5(name)::uuid, role, 'local', key, 100
FROM (VALUES ('a', 'original', '2024/05/a.jpg'), ('b', 'original', '2024/05/x/b.jpg'),
    ('c', 'original', '2024/050/c.jpg'), ('d', 'original', '2023/d.jpg'), ('d', 'thumb_s', '2024/05/d.webp'),
    ('e', 'original', '2024/05/e.jpg'), ('p', 'original', '2024/05/p.bin')) AS f (name, role, key);";

    #[tokio::test]
    async fn reprocessing_queues_jobs_for_the_assets_of_its_scope_only() {
        let (api, root) = admin().await;
        sql(&api, WORLD).await;
        let names: Vec<(String, String)> =
            sqlx::query_as("SELECT md5(n)::uuid::text, n FROM unnest('{a,b,c,d,e,p,L1,P}'::text[]) n")
                .fetch_all(&api.pool)
                .await
                .unwrap();
        let name = |id: &str| names.iter().find(|(i, _)| i == id).map(|(_, n)| n.clone()).unwrap();
        let ids = |list: &[&str]| -> Vec<String> {
            list.iter()
                .map(|n| names.iter().find(|(_, m)| m == n).unwrap().0.clone())
                .collect()
        };
        let library = |n: &str| ids(&[n]).remove(0);
        let admin = Some(&root);
        let reprocess = async |body: Value| {
            let (status, answer) = call(&api.app, "AdminService/Reprocess", admin, body).await;
            assert_eq!(status, StatusCode::OK, "{answer}");
            let mut queued: Vec<_> = jobs(&api).await.into_iter().map(|(t, a)| (t, name(&a))).collect();
            queued.sort();
            sql(&api, "UPDATE jobs SET status = 'done'").await;
            (answer["jobCount"].as_str().unwrap_or("0").to_string(), queued)
        };
        let pair = |t: &str, a: &str| (t.to_string(), a.to_string());
        let folder = json!({ "libraryId": library("L1"), "folder": "/2024/05/",
            "kinds": ["REPROCESS_KIND_METADATA", "REPROCESS_KIND_FACES"] });
        assert_eq!(
            reprocess(folder.clone()).await,
            (
                "4".into(),
                vec![
                    pair("faces", "a"),
                    pair("faces", "b"),
                    pair("metadata", "a"),
                    pair("metadata", "b")
                ]
            )
        );
        let selection = json!({ "assetIds": ids(&["d", "e", "p"]), "kinds": ["REPROCESS_KIND_RENDITIONS"] });
        assert_eq!(
            reprocess(selection).await,
            ("2".into(), vec![pair("renditions", "d"), pair("renditions", "e")])
        );
        let whole = json!({ "libraryId": library("L1"), "kinds": ["REPROCESS_KIND_METADATA"] });
        assert_eq!(
            reprocess(whole).await,
            ("4".into(), ["a", "b", "c", "d"].map(|a| pair("metadata", a)).to_vec())
        );
        let private = json!({ "libraryId": library("P"), "kinds": ["REPROCESS_KIND_FACES"] });
        assert_eq!(reprocess(private).await, ("0".into(), vec![]));
        // A job that is still queued is not queued twice.
        sql(&api, "UPDATE jobs SET status = 'queued' WHERE type = 'faces'").await;
        assert_eq!(reprocess(folder).await.0, "2");
        for (body, field) in [
            (json!({ "kinds": ["REPROCESS_KIND_FACES"] }), "library_id"),
            (
                json!({ "libraryId": library("L1"), "assetIds": ids(&["a"]), "kinds": ["REPROCESS_KIND_FACES"] }),
                "library_id",
            ),
            (
                json!({ "assetIds": ids(&["a"]), "folder": "2024", "kinds": ["REPROCESS_KIND_FACES"] }),
                "folder",
            ),
            (
                json!({ "assetIds": ["x"], "kinds": ["REPROCESS_KIND_FACES"] }),
                "asset_ids",
            ),
            (json!({ "assetIds": ids(&["a"]) }), "kinds"),
        ] {
            let mut expected = denied("invalid_argument", "field.invalid");
            expected["field"] = field.into();
            assert_eq!(
                call(&api.app, "AdminService/Reprocess", admin, body).await,
                (StatusCode::BAD_REQUEST, expected)
            );
        }
        let audited: Vec<String> = sqlx::query_scalar(
            "SELECT details ->> 'jobs' FROM audit_events WHERE action = 'job.reprocess' ORDER BY id",
        )
        .fetch_all(&api.pool)
        .await
        .unwrap();
        assert_eq!(audited, ["4", "2", "4", "0", "2"]);
    }

    /// The API of `api`'s instance, its admin console reading the configuration `change` makes.
    async fn with_config(api: &Api, change: impl FnOnce(&mut crate::config::Config)) -> axum::Router {
        use std::sync::Arc;

        let keys = crate::keys::ApiKeys::new(api.pool.clone());
        let sessions = Arc::new(crate::testing::BearerSessions);
        let users = crate::rpc::Users::start(api.accounts.clone(), keys, sessions);
        let mut config = crate::testing::config(&[crate::role::Role::Api], api.data.path());
        change(&mut config);
        let doctor = crate::doctor::Doctor {
            config,
            pool: Some(api.pool.clone()),
            seen: None,
            tail: None,
            ml: None,
        };
        let admin = super::Admin::new(api.pool.clone(), Arc::new(doctor));
        let users = Some(Arc::new(users.await.unwrap()));
        crate::rpc::api(uuid::Uuid::now_v7().to_string(), users, None, Some(admin))
    }

    #[tokio::test]
    async fn an_external_library_lies_under_an_allowed_root_overlaps_nothing_and_is_scanned_on_demand() {
        let (api, root) = with_admin().await;
        let base = tempfile::tempdir().unwrap();
        let (nas, data) = (base.path().join("nas"), api.data.path().join("libraries"));
        for dir in [
            &nas.join("ann/2024"),
            &nas.join("bob"),
            &base.path().join("other"),
            &data,
        ] {
            std::fs::create_dir_all(dir).unwrap();
        }
        std::os::unix::fs::symlink(base.path().join("other"), nas.join("link")).unwrap();
        let app = with_config(&api, |config| {
            config.external_roots = vec![nas.clone(), api.data.path().into()];
        })
        .await;
        let admin = Some(&root);
        let path = |p: &std::path::Path| p.to_str().unwrap().to_string();
        let create = async |owner: &str, name: &str, folder: String| {
            let body = json!({ "ownerUserId": owner, "name": name, "root": folder });
            call(&app, "AdminService/CreateExternalLibrary", admin, body).await
        };
        let me = root.user_id.as_str();
        let invalid = |field: &str| {
            let mut error = denied("invalid_argument", "field.invalid");
            error["field"] = field.into();
            (StatusCode::BAD_REQUEST, error)
        };
        assert_eq!(create(me, "NAS", "nas/ann".into()).await, invalid("root"));
        assert_eq!(create(me, "NAS", path(&nas.join("nobody"))).await, invalid("root"));
        assert_eq!(create(me, " ", path(&nas.join("ann"))).await, invalid("name"));
        assert_eq!(
            create("x", "NAS", path(&nas.join("ann"))).await,
            invalid("owner_user_id")
        );
        assert_eq!(
            create(&uuid::Uuid::now_v7().to_string(), "NAS", path(&nas.join("ann"))).await,
            (StatusCode::NOT_FOUND, denied("not_found", "user.not_found"))
        );
        let not_allowed = (
            StatusCode::FORBIDDEN,
            denied("permission_denied", "library.root_not_allowed"),
        );
        assert_eq!(create(me, "NAS", path(&base.path().join("other"))).await, not_allowed);
        assert_eq!(
            create(me, "NAS", path(&nas.join("link"))).await,
            not_allowed,
            "symlinks resolved"
        );
        let overlaps = (
            StatusCode::BAD_REQUEST,
            denied("failed_precondition", "library.root_overlaps"),
        );
        assert_eq!(create(me, "NAS", path(&data)).await, overlaps, "the data directory");
        assert_eq!(create(me, "NAS", path(api.data.path())).await, overlaps);

        let (status, created) = create(me, "Ann's NAS", path(&nas.join("ann/../ann"))).await;
        assert_eq!(status, StatusCode::OK, "{created}");
        let ann = created["libraryId"].as_str().unwrap().to_string();
        let body = json!({ "ownerUserId": me, "name": "Bob", "root": path(&nas.join("bob")),
            "filesPerSecond": 0, "bytesPerSecond": "1048576" });
        let (status, bob) = call(&app, "AdminService/CreateExternalLibrary", admin, body).await;
        assert_eq!(status, StatusCode::OK, "{bob}");
        let bob = bob["libraryId"].as_str().unwrap().to_string();
        assert_eq!(create(me, "NAS", path(&nas.join("ann/2024"))).await, overlaps);
        assert_eq!(create(me, "NAS", path(&nas)).await, overlaps);
        let libraries: Vec<(String, String, String, String, String, Value)> = sqlx::query_as(
            "SELECT name, owner_id::text, kind || ' ' || access || ' ' || privacy, root_uri, state, scan_policy
             FROM libraries ORDER BY name",
        )
        .fetch_all(&api.pool)
        .await
        .unwrap();
        let canonical = |dir: &str| path(&std::fs::canonicalize(nas.join(dir)).unwrap());
        assert_eq!(
            libraries,
            [
                (
                    "Ann's NAS".into(),
                    me.into(),
                    "external ro standard".into(),
                    canonical("ann"),
                    "scanning".into(),
                    json!({ "files_per_second": 1000, "bytes_per_second": 64 << 20 })
                ),
                (
                    "Bob".into(),
                    me.into(),
                    "external ro standard".into(),
                    canonical("bob"),
                    "scanning".into(),
                    json!({ "files_per_second": 0, "bytes_per_second": 1 << 20 })
                ),
            ]
        );

        let scan =
            async |library: &str| call(&app, "AdminService/ScanLibrary", admin, json!({ "libraryId": library })).await;
        let scanning = (
            StatusCode::BAD_REQUEST,
            denied("failed_precondition", "library.scanning"),
        );
        assert_eq!(scan(&ann).await, scanning);
        sql(&api, "UPDATE library_scans SET finished_at = now(), pending = 0").await;
        assert_eq!(scan(&ann).await.0, StatusCode::OK);
        sql(&api, WORLD).await;
        let managed: String = sqlx::query_scalar("SELECT md5('L1')::uuid::text")
            .fetch_one(&api.pool)
            .await
            .unwrap();
        assert_eq!(
            scan(&managed).await,
            (
                StatusCode::BAD_REQUEST,
                denied("failed_precondition", "library.not_external")
            )
        );
        assert_eq!(
            scan(&uuid::Uuid::now_v7().to_string()).await,
            (StatusCode::NOT_FOUND, denied("not_found", "library.not_found"))
        );
        assert_eq!(scan("x").await, invalid("library_id"));
        let scans: Vec<String> = sqlx::query_scalar(
            "SELECT convert_from(payload, 'UTF8')::jsonb ->> 'library' FROM jobs WHERE type = 'scan' ORDER BY id",
        )
        .fetch_all(&api.pool)
        .await
        .unwrap();
        assert_eq!(scans, [ann.clone(), bob.clone(), ann.clone()]);
        let audited: Vec<(String, String)> = sqlx::query_as(
            "SELECT action, target ->> 'library_id' FROM audit_events WHERE action LIKE 'library.%' ORDER BY id",
        )
        .fetch_all(&api.pool)
        .await
        .unwrap();
        assert_eq!(
            audited,
            [
                ("library.create".into(), ann.clone()),
                ("library.create".into(), bob),
                ("library.scan".into(), ann)
            ]
        );
    }

    /// A scan that holds back more than the guard allows shows in the status with the count and token of its dry
    /// run; ConfirmScan hides it with that token only, audited, and then nothing waits.
    #[tokio::test]
    async fn a_held_scan_shows_its_dry_run_and_is_confirmed_with_its_token() {
        let (api, root) = with_admin().await;
        sql(&api, "INSERT INTO users (id, handle, display_name) VALUES (md5('ann')::uuid, 'ann', 'Ann');
            INSERT INTO libraries (id, owner_id, name, kind, access, root_uri)
              VALUES (md5('nas')::uuid, md5('ann')::uuid, 'NAS', 'external', 'ro', '/nas');
            INSERT INTO assets (id, library_id, owner_id, source) SELECT md5(n)::uuid, md5('nas')::uuid, md5('ann')::uuid,
              'scan' FROM unnest('{a,b,c}'::text[]) n;
            INSERT INTO asset_files (id, asset_id, role, storage, key) SELECT gen_random_uuid(), md5(n)::uuid,
              'original', 'external', 'gone/' || n || '.jpg' FROM unnest('{a,b,c}'::text[]) n;
            INSERT INTO library_files (library_id, dir, name, dev, inode, size, mtime_ns, state, asset_id, found_at)
              SELECT md5('nas')::uuid, 'gone', n || '.jpg', 1, 1, 1, 1, 'ingested', md5(n)::uuid,
                now() - interval '1 day' FROM unnest('{a,b,c}'::text[]) n;
            INSERT INTO library_scans (id, library_id, pending, finished_at, missing, held)
              VALUES (md5('scan')::uuid, md5('nas')::uuid, 0, now(), 3, true);").await;
        let admin = Some(&root);
        let (status, answer) = call(&api.app, "AdminService/GetStatus", admin, json!({})).await;
        assert_eq!(status, StatusCode::OK, "{answer}");
        let held = answer["libraries"][0]["held"].clone();
        assert_eq!((held["count"].clone(), held["total"].clone()), (json!("3"), json!("3")));
        let token = held["token"].as_str().unwrap().to_string();
        let library: String = sqlx::query_scalar("SELECT md5('nas')::uuid::text")
            .fetch_one(&api.pool)
            .await
            .unwrap();
        let confirm = async |token: &str| {
            call(
                &api.app,
                "AdminService/ConfirmScan",
                admin,
                json!({ "libraryId": library, "confirmationToken": token }),
            )
            .await
        };
        let mut required = denied("failed_precondition", "confirmation.required");
        for (name, value) in [("count", "3"), ("total", "3"), ("token", token.as_str())] {
            required[name] = value.into();
        }
        assert_eq!(confirm("").await, (StatusCode::BAD_REQUEST, required.clone()));
        assert_eq!(confirm("0123").await, (StatusCode::BAD_REQUEST, required));
        assert_eq!(confirm(&token).await, (StatusCode::OK, json!({ "hiddenCount": "3" })));
        assert_eq!(
            confirm(&token).await,
            (
                StatusCode::BAD_REQUEST,
                denied("failed_precondition", "library.nothing_held")
            )
        );
        let missing: i64 = sqlx::query_scalar("SELECT count(*) FROM asset_files WHERE state = 'missing'")
            .fetch_one(&api.pool)
            .await
            .unwrap();
        assert_eq!(missing, 3);
        let audited: Vec<String> =
            sqlx::query_scalar("SELECT details::text FROM audit_events WHERE action = 'library.hide'")
                .fetch_all(&api.pool)
                .await
                .unwrap();
        assert_eq!(audited, [r#"{"count": 3}"#]);
    }

    /// A hint names files or folders under the library's root, absolute or relative to it; each queues its folder and
    /// its folder's parent before other work. Paths outside the root are refused.
    #[tokio::test]
    async fn hints_queue_their_folders_first() {
        let (api, root) = with_admin().await;
        sql(&api, WORLD).await;
        sql(
            &api,
            "INSERT INTO libraries (id, owner_id, name, kind, access, root_uri)
              VALUES (md5('nas')::uuid, md5('ann')::uuid, 'NAS', 'external', 'ro', '/srv/nas');",
        )
        .await;
        let library: String = sqlx::query_scalar("SELECT md5('nas')::uuid::text")
            .fetch_one(&api.pool)
            .await
            .unwrap();
        let hint = async |library: &str, paths: Value| {
            call(
                &api.app,
                "AdminService/HintPaths",
                Some(&root),
                json!({ "libraryId": library, "paths": paths }),
            )
            .await
        };
        let paths = json!(["/srv/nas/2024/05/a.jpg", "2024/05/b.jpg", "2025/", "/srv/nas"]);
        assert_eq!(hint(&library, paths).await, (StatusCode::OK, json!({})));
        let queued: Vec<(String, i16)> = sqlx::query_as(
            "SELECT convert_from(payload, 'UTF8')::jsonb ->> 'dir', priority FROM jobs WHERE type = 'scan' ORDER BY 1",
        )
        .fetch_all(&api.pool)
        .await
        .unwrap();
        let dir = |dir: &str| (dir.to_string(), 10);
        assert_eq!(
            queued,
            [
                dir(""),
                dir("2024/05"),
                dir("2024/05/a.jpg"),
                dir("2024/05/b.jpg"),
                dir("2025")
            ]
        );
        let mut invalid = denied("invalid_argument", "field.invalid");
        invalid["field"] = "paths".into();
        for paths in [
            json!(["/srv/other/a.jpg"]),
            json!(["../a.jpg"]),
            json!(vec!["a.jpg"; 1001]),
        ] {
            assert_eq!(hint(&library, paths).await, (StatusCode::BAD_REQUEST, invalid.clone()));
        }
        let managed: String = sqlx::query_scalar("SELECT md5('L1')::uuid::text")
            .fetch_one(&api.pool)
            .await
            .unwrap();
        assert_eq!(
            hint(&managed, json!(["a.jpg"])).await,
            (
                StatusCode::BAD_REQUEST,
                denied("failed_precondition", "library.not_external")
            )
        );
    }

    /// A library moves to another folder under the allowed roots that holds a name its root held, and is scanned
    /// there; a folder that holds none of them, one outside the roots, or a library being scanned is refused.
    #[tokio::test]
    async fn a_library_relocates_to_a_folder_with_its_names() {
        let (api, root) = with_admin().await;
        let base = tempfile::tempdir().unwrap();
        let nas = base.path().join("nas");
        for dir in ["ann/2024", "moved/2024", "other/2023"] {
            std::fs::create_dir_all(nas.join(dir)).unwrap();
        }
        let app = with_config(&api, |config| config.external_roots = vec![nas.clone()]).await;
        let admin = Some(&root);
        let path = |dir: &str| nas.join(dir).to_str().unwrap().to_string();
        let body = json!({ "ownerUserId": root.user_id, "name": "NAS", "root": path("ann") });
        let (status, created) = call(&app, "AdminService/CreateExternalLibrary", admin, body).await;
        assert_eq!(status, StatusCode::OK, "{created}");
        let library = created["libraryId"].as_str().unwrap().to_string();
        let relocate = async |dir: String| {
            call(
                &app,
                "AdminService/RelocateLibrary",
                admin,
                json!({ "libraryId": library, "root": dir }),
            )
            .await
        };
        let scanning = (
            StatusCode::BAD_REQUEST,
            denied("failed_precondition", "library.scanning"),
        );
        assert_eq!(relocate(path("moved")).await, scanning);
        sql(
            &api,
            "UPDATE library_scans SET finished_at = now(), pending = 0;
            UPDATE libraries SET fingerprint = '{2024}'",
        )
        .await;
        assert_eq!(
            relocate(path("other")).await,
            (
                StatusCode::BAD_REQUEST,
                denied("failed_precondition", "library.root_differs")
            )
        );
        assert_eq!(
            relocate(base.path().to_str().unwrap().into()).await,
            (
                StatusCode::FORBIDDEN,
                denied("permission_denied", "library.root_not_allowed")
            )
        );
        assert_eq!(relocate(path("moved")).await, (StatusCode::OK, json!({})));
        let (now, scans): (String, i64) =
            sqlx::query_as("SELECT root_uri, (SELECT count(*) FROM library_scans) FROM libraries")
                .fetch_one(&api.pool)
                .await
                .unwrap();
        assert_eq!(
            (now, scans),
            (
                std::fs::canonicalize(nas.join("moved"))
                    .unwrap()
                    .to_str()
                    .unwrap()
                    .into(),
                2
            )
        );
        let audited: Vec<String> =
            sqlx::query_scalar("SELECT details ->> 'root' FROM audit_events WHERE action = 'library.relocate'")
                .fetch_all(&api.pool)
                .await
                .unwrap();
        assert_eq!(audited.len(), 1);
    }

    /// An administrator sets a library's rendition quality to `standard` or `high`: its `rendition_quality` changes and
    /// the change is audited; another quality or no such library is refused.
    #[tokio::test]
    async fn a_library_gets_the_rendition_quality_the_administrator_sets() {
        let (api, root) = with_admin().await;
        sql(&api, WORLD).await;
        let admin = Some(&root);
        let library: String = sqlx::query_scalar("SELECT md5('L1')::uuid::text")
            .fetch_one(&api.pool)
            .await
            .unwrap();
        let quality = async || -> String {
            sqlx::query_scalar("SELECT rendition_quality FROM libraries WHERE id = $1::uuid")
                .bind(&library)
                .fetch_one(&api.pool)
                .await
                .unwrap()
        };
        assert_eq!(quality().await, "high", "the default");
        let set = async |id: &str, quality: &str| {
            call(
                &api.app,
                "AdminService/SetRenditionQuality",
                admin,
                json!({ "libraryId": id, "quality": quality }),
            )
            .await
        };
        assert_eq!(set(&library, "standard").await, (StatusCode::OK, json!({})));
        assert_eq!(quality().await, "standard");
        let mut invalid = denied("invalid_argument", "field.invalid");
        invalid["field"] = "quality".into();
        for other in ["lossless", "", "High"] {
            assert_eq!(set(&library, other).await, (StatusCode::BAD_REQUEST, invalid.clone()));
        }
        assert_eq!(quality().await, "standard", "refused values change nothing");
        let none: String = sqlx::query_scalar("SELECT md5('none')::uuid::text")
            .fetch_one(&api.pool)
            .await
            .unwrap();
        assert_eq!(
            set(&none, "high").await,
            (StatusCode::NOT_FOUND, denied("not_found", "library.not_found"))
        );
        assert_eq!(set(&library, "high").await, (StatusCode::OK, json!({})));
        assert_eq!(quality().await, "high");
        let audited: Vec<String> = sqlx::query_scalar(
            "SELECT details ->> 'quality' FROM audit_events WHERE action = 'library.rendition_quality' ORDER BY id",
        )
        .fetch_all(&api.pool)
        .await
        .unwrap();
        assert_eq!(audited, ["standard", "high"]);
    }

    /// The database's clock, read before a request.
    async fn clock(api: &Api) -> String {
        sqlx::query_scalar("SELECT clock_timestamp()::text")
            .fetch_one(&api.pool)
            .await
            .unwrap()
    }

    /// Whether a JSON timestamp is `secs` after a moment between `before` and now, however long the request took (to
    /// the millisecond: the reply's time went through a float).
    async fn after(api: &Api, before: &str, at: &Value, secs: f64) -> bool {
        sqlx::query_scalar(
            "SELECT $2::timestamptz - make_interval(secs => $3)
               BETWEEN $1::timestamptz - interval '1 ms' AND clock_timestamp() + interval '1 ms'",
        )
        .bind(before)
        .bind(at.as_str().unwrap())
        .bind(secs)
        .fetch_one(&api.pool)
        .await
        .unwrap()
    }

    #[tokio::test]
    async fn a_pause_lasts_an_hour_by_default_at_most_a_day_and_shows_in_the_status() {
        let (api, root) = with_admin().await;
        let admin = Some(&root);
        let pause = |body: Value| call(&api.app, "AdminService/PauseJobType", admin, body);
        let before = clock(&api).await;
        let (status, paused) = pause(json!({ "type": "render" })).await;
        assert_eq!(status, StatusCode::OK, "{paused}");
        assert!(
            after(&api, &before, &paused["pause"]["untilAt"], 3600.0).await,
            "{paused}"
        );
        assert_eq!(paused["pause"]["pausedByUserId"], root.user_id.as_str());
        let before = clock(&api).await;
        let (_, day) = pause(json!({ "type": "embed", "pauseMinutes": 1440 })).await;
        assert!(after(&api, &before, &day["pause"]["untilAt"], 86400.0).await, "{day}");
        let mut too_long = denied("invalid_argument", "field.invalid");
        too_long["field"] = "pause_minutes".into();
        assert_eq!(
            pause(json!({ "type": "render", "pauseMinutes": 1441 })).await,
            (StatusCode::BAD_REQUEST, too_long)
        );
        let (_, status) = call(&api.app, "AdminService/GetStatus", admin, json!({})).await;
        let types: Vec<&str> = status["pauses"]
            .as_array()
            .unwrap()
            .iter()
            .map(|p| p["type"].as_str().unwrap())
            .collect();
        assert_eq!(types, ["embed", "render"]);
        let resume = |kind: &str| call(&api.app, "AdminService/ResumeJobType", admin, json!({ "type": kind }));
        assert_eq!(resume("render").await.0, StatusCode::OK);
        assert_eq!(
            resume("render").await,
            (StatusCode::BAD_REQUEST, denied("failed_precondition", "job.not_paused"))
        );
        // A pause that ended is gone from the status, as from the workers' view.
        sqlx::query("UPDATE job_pauses SET until = now()")
            .execute(&api.pool)
            .await
            .unwrap();
        let (_, status) = call(&api.app, "AdminService/GetStatus", admin, json!({})).await;
        assert!(status.get("pauses").is_none(), "{status}");
        let actions: Vec<String> = sqlx::query_scalar(
            "SELECT action || ' ' || (target ->> 'type') FROM audit_events WHERE actor_user_id = $1::uuid
             AND action LIKE 'job.%' ORDER BY id",
        )
        .bind(&root.user_id)
        .fetch_all(&api.pool)
        .await
        .unwrap();
        assert_eq!(actions, ["job.pause render", "job.pause embed", "job.resume render"]);
    }

    #[tokio::test]
    async fn an_administrator_pauses_a_maintenance_type_for_up_to_seven_days_in_one_request() {
        let (api, root) = with_admin().await;
        let pause = |kind: &str, minutes: u32| {
            let body = json!({ "type": kind, "pauseMinutes": minutes });
            call(&api.app, "AdminService/PauseJobType", Some(&root), body)
        };
        let mut too_long = denied("invalid_argument", "field.invalid");
        too_long["field"] = "pause_minutes".into();
        for kind in ["backup", crate::library::PURGE, crate::scrub::SCRUB] {
            let before = clock(&api).await;
            let (status, week) = pause(kind, 10080).await;
            assert_eq!(status, StatusCode::OK, "{week}");
            assert!(
                after(&api, &before, &week["pause"]["untilAt"], 7.0 * 86400.0).await,
                "{week}"
            );
            assert_eq!(
                pause(kind, 10081).await,
                (StatusCode::BAD_REQUEST, too_long.clone()),
                "{kind}"
            );
        }
        assert_eq!(pause("render", 1441).await, (StatusCode::BAD_REQUEST, too_long));
        // Pausing again sets the end anew from now, however long the type has been paused: no clamp.
        sql(
            &api,
            "UPDATE job_pauses SET until = now() + interval '1 hour' WHERE type = 'backup'",
        )
        .await;
        let before = clock(&api).await;
        let (_, again) = pause("backup", 10080).await;
        assert!(
            after(&api, &before, &again["pause"]["untilAt"], 7.0 * 86400.0).await,
            "{again}"
        );
        let since: i64 = sqlx::query_scalar(
            "SELECT count(*) FROM information_schema.columns WHERE table_name = 'job_pauses' AND column_name = 'since'",
        )
        .fetch_one(&api.pool)
        .await
        .unwrap();
        assert_eq!(since, 0, "the clamp's start column is gone");
    }

    #[tokio::test]
    async fn an_api_key_cannot_pause_maintenance_types() {
        let (api, root) = with_admin().await;
        let key = key(&api.pool, &root, &ApiKeyScope::values()[1..]).await;
        for maintenance in ["backup", crate::library::PURGE, crate::scrub::SCRUB] {
            let body = json!({ "type": maintenance });
            assert_eq!(
                call(&api.app, "AdminService/PauseJobType", Some(&key), body.clone()).await,
                (StatusCode::FORBIDDEN, denied("permission_denied", "job.maintenance")),
                "{maintenance}"
            );
            let (status, _) = call(&api.app, "AdminService/PauseJobType", Some(&root), body).await;
            assert_eq!(
                status,
                StatusCode::OK,
                "an administrator's session pauses {maintenance}"
            );
        }
        let (status, _) = call(
            &api.app,
            "AdminService/PauseJobType",
            Some(&key),
            json!({ "type": "render" }),
        )
        .await;
        assert_eq!(status, StatusCode::OK, "a key pauses other types");
    }

    #[tokio::test]
    async fn jobs_are_listed_newest_first_by_status_and_type_and_retried_or_cancelled() {
        let (api, root) = admin().await;
        let admin = Some(&root);
        sql(
            &api,
            "INSERT INTO jobs (id, type, status, attempts, error, idempotency_key)
             SELECT ('00000000-0000-7000-8000-00000000000' || n)::uuid, type, status, 5, error, key
             FROM (VALUES (1, 'render', 'dead', 'boom', 'render:a'), (2, 'render', 'queued', NULL, NULL),
                 (3, 'embed', 'dead', 'oom', NULL)) AS j (n, type, status, error, key)",
        )
        .await;
        let list = |body: Value| call(&api.app, "AdminService/ListJobs", admin, body);
        let (_, all) = list(json!({ "pageSize": 2 })).await;
        let kinds: Vec<&str> = all["jobs"]
            .as_array()
            .unwrap()
            .iter()
            .map(|j| j["type"].as_str().unwrap())
            .collect();
        assert_eq!(kinds, ["embed", "render"], "newest first");
        let (_, rest) = list(json!({ "pageSize": 2, "pageToken": all["nextPageToken"] })).await;
        assert_eq!(rest["jobs"][0]["key"], "render:a");
        assert!(rest.get("nextPageToken").is_none(), "{rest}");
        let (_, dead) = list(json!({ "status": "JOB_STATUS_DEAD", "type": "render" })).await;
        let dead = &dead["jobs"][0];
        assert_eq!(
            (&dead["error"], &dead["attempts"], &dead["status"]),
            (&json!("boom"), &json!(5), &json!("JOB_STATUS_DEAD"))
        );
        let job = json!({ "jobId": dead["jobId"] });
        assert_eq!(
            call(&api.app, "AdminService/RetryJob", admin, job.clone()).await.0,
            StatusCode::OK
        );
        assert_eq!(
            call(&api.app, "AdminService/RetryJob", admin, job.clone()).await,
            (
                StatusCode::BAD_REQUEST,
                denied("failed_precondition", "job.not_retryable")
            )
        );
        assert_eq!(
            call(&api.app, "AdminService/CancelJob", admin, job.clone()).await.0,
            StatusCode::OK
        );
        assert_eq!(
            call(&api.app, "AdminService/CancelJob", admin, job).await,
            (
                StatusCode::BAD_REQUEST,
                denied("failed_precondition", "job.not_cancellable")
            )
        );
        let (_, cancelled) = list(json!({ "status": "JOB_STATUS_CANCELLED" })).await;
        let job = &cancelled["jobs"][0];
        assert!(
            job.get("attempts").is_none() && job.get("error").is_none(),
            "retried from the start: {job}"
        );
    }

    #[tokio::test]
    async fn an_update_from_a_client_that_knows_no_scrub_or_watchdog_settings_keeps_them() {
        let (api, root) = with_admin().await;
        let older = json!({ "settings": { "trashRetentionDays": 30 } });
        let (_, kept) = call(&api.app, "AdminService/UpdateSettings", Some(&root), older).await;
        assert_eq!(
            kept["settings"],
            json!({ "trashRetentionDays": 30, "scrubDays": 90, "backupSilentHours": 48 })
        );
    }

    #[tokio::test]
    async fn settings_are_validated_stored_and_audited() {
        let (api, root) = with_admin().await;
        let admin = Some(&root);
        let (_, got) = call(&api.app, "AdminService/GetSettings", admin, json!({})).await;
        let defaults = json!({ "trashRetentionDays": 60, "minFreeDiskPercent": 5, "scrubDays": 90,
            "backupSilentHours": 48, "minFreeDiskGb": 20 });
        assert_eq!(got, json!({ "settings": defaults }));
        let valid = json!({ "requireTwoFactor": true, "trashRetentionDays": 3650, "minFreeDiskPercent": 50,
            "scrubDays": 3650, "backupSilentHours": 8760, "minFreeDiskGb": 100_000 });
        let update = async |settings: &Value| {
            call(
                &api.app,
                "AdminService/UpdateSettings",
                admin,
                json!({ "settings": settings }),
            )
            .await
        };
        for (field, value, name) in [
            ("trashRetentionDays", 0, "trash_retention_days"),
            ("trashRetentionDays", 3651, "trash_retention_days"),
            ("minFreeDiskPercent", 51, "min_free_disk_percent"),
            ("scrubDays", 3651, "scrub_days"),
            ("backupSilentHours", 8761, "backup_silent_hours"),
            ("minFreeDiskGb", 100_001, "min_free_disk_gb"),
        ] {
            let mut settings = valid.clone();
            settings[field] = value.into();
            let (status, error) = update(&settings).await;
            assert_eq!(
                (status, &error["reason"]),
                (StatusCode::BAD_REQUEST, &json!("field.invalid"))
            );
            assert_eq!(error["field"], name);
        }
        let (status, stored) = update(&valid).await;
        assert_eq!((status, &stored["settings"]), (StatusCode::OK, &valid));
        assert_eq!(
            call(&api.app, "AdminService/GetSettings", admin, json!({})).await.1["settings"],
            valid
        );
        let (_, audit) = call(
            &api.app,
            "AdminService/ListAuditEvents",
            admin,
            json!({ "pageSize": 1 }),
        )
        .await;
        let event = &audit["events"][0];
        assert_eq!(
            (&event["action"], &event["actorUserId"]),
            (&json!("settings.update"), &json!(root.user_id))
        );
        let details: Value = serde_json::from_str(event["detailsJson"].as_str().unwrap()).unwrap();
        assert_eq!(details["trashRetentionDays"], 3650);
        let (_, older) = call(
            &api.app,
            "AdminService/ListAuditEvents",
            admin,
            json!({ "pageToken": audit["nextPageToken"] }),
        )
        .await;
        let older: Vec<&Value> = older["events"]
            .as_array()
            .unwrap()
            .iter()
            .map(|e| &e["action"])
            .collect();
        assert_eq!(
            older,
            [&json!("password_setup.create"), &json!("user.create")],
            "the first administrator and its password setup, before the settings"
        );
    }

    /// Each switch of a policy answer as `name on|off source`, and ` =on` or ` =off` when the level sets it.
    fn switches(answer: &Value) -> Vec<String> {
        let tail = |value: &Value, prefix: &str| value.as_str().unwrap()[prefix.len()..].to_lowercase();
        let state = |on: &Value| if on == true { "on" } else { "off" };
        (answer["switches"].as_array().unwrap().iter())
            .map(|switch| {
                let set = switch
                    .get("set")
                    .map(|on| format!(" ={}", state(on)))
                    .unwrap_or_default();
                let (name, source) = (
                    tail(&switch["capability"], "CAPABILITY_"),
                    tail(&switch["source"], "POLICY_SOURCE_"),
                );
                format!("{name} {} {source}{set}", state(&switch["enabled"]))
            })
            .collect()
    }

    /// The switch of uploads in a policy answer.
    fn uploads(answer: &(StatusCode, Value)) -> String {
        assert_eq!(answer.0, StatusCode::OK, "{}", answer.1);
        switches(&answer.1).swap_remove(1)
    }

    /// Ann's id and her libraries L1 and L2 of `WORLD`.
    async fn ann(api: &Api) -> (String, String, String) {
        sql(api, WORLD).await;
        let ids = "SELECT md5('ann')::uuid::text, md5('L1')::uuid::text, md5('L2')::uuid::text";
        sqlx::query_as(ids).fetch_one(&api.pool).await.unwrap()
    }

    fn refused(code: &str, reason: &str, field: &str) -> (StatusCode, Value) {
        let mut error = denied(code, reason);
        error["field"] = field.into();
        let status = if code == "invalid_argument" || code == "failed_precondition" {
            StatusCode::BAD_REQUEST
        } else {
            StatusCode::NOT_FOUND
        };
        (status, error)
    }

    #[tokio::test]
    async fn the_effective_policy_resolves_server_then_account_then_library_and_names_its_source() {
        let (api, root) = with_admin().await;
        let (ann, l1, l2) = ann(&api).await;
        let get = async |body: Value| call(&api.app, "AdminService/GetPolicy", Some(&root), body).await;
        let set = async |body: Value| call(&api.app, "AdminService/UpdatePolicy", Some(&root), body).await;
        let (status, server) = get(json!({})).await;
        assert_eq!(status, StatusCode::OK);
        let defaults = super::Capability::ALL.map(|capability| format!("{} on default", capability.name()));
        assert_eq!(switches(&server), defaults);
        let off = "CAPABILITY_UPLOADS";
        assert_eq!(
            uploads(&set(json!({ "capability": off, "enabled": false })).await),
            "uploads off server =off"
        );
        let body = json!({ "userId": ann, "capability": off, "enabled": true });
        assert_eq!(uploads(&set(body).await), "uploads on user =on");
        let body = json!({ "libraryId": l1, "capability": off, "enabled": false });
        assert_eq!(uploads(&set(body).await), "uploads off library =off");
        let me = root.user_id.as_str();
        for (body, expected) in [
            (json!({}), "uploads off server =off"),
            (json!({ "userId": ann }), "uploads on user =on"),
            (json!({ "libraryId": l2 }), "uploads on user"),
            (json!({ "libraryId": l1 }), "uploads off library =off"),
            (json!({ "userId": me, "libraryId": l1 }), "uploads off library =off"),
            (json!({ "userId": me, "libraryId": l2 }), "uploads off server"),
            (json!({ "userId": me }), "uploads off server"),
        ] {
            assert_eq!(uploads(&get(body.clone()).await), expected, "{body}");
        }
        let cleared = json!({ "userId": ann, "capability": off });
        assert_eq!(uploads(&set(cleared).await), "uploads off server");

        assert_eq!(
            set(json!({ "enabled": false })).await,
            refused("invalid_argument", "field.invalid", "capability")
        );
        assert_eq!(
            get(json!({ "userId": "x" })).await,
            refused("invalid_argument", "field.invalid", "user_id")
        );
        let nobody = uuid::Uuid::now_v7().to_string();
        assert_eq!(
            get(json!({ "userId": nobody })).await,
            (StatusCode::NOT_FOUND, denied("not_found", "user.not_found"))
        );
        assert_eq!(
            get(json!({ "libraryId": nobody })).await,
            (StatusCode::NOT_FOUND, denied("not_found", "library.not_found"))
        );
        let audited: Vec<(String, Value, Value)> = sqlx::query_as(
            "SELECT actor_user_id::text, target, details FROM audit_events WHERE action = 'policy.update' ORDER BY id",
        )
        .fetch_all(&api.pool)
        .await
        .unwrap();
        let level =
            |user: Value, library: Value| json!({ "user_id": user, "library_id": library, "capability": "uploads" });
        let by_root = |target, enabled| (root.user_id.clone(), target, json!({ "enabled": enabled }));
        assert_eq!(
            audited,
            [
                by_root(level(Value::Null, Value::Null), json!(false)),
                by_root(level(json!(ann), Value::Null), json!(true)),
                by_root(level(Value::Null, json!(l1)), json!(false)),
                by_root(level(json!(ann), Value::Null), Value::Null),
            ]
        );
    }

    #[tokio::test]
    async fn a_preset_sets_every_switch_editably_clears_narrower_ones_and_is_audited() {
        let (api, root) = with_admin().await;
        let (ann, l1, _) = ann(&api).await;
        let admin = Some(&root);
        let apply =
            async |preset: &str| call(&api.app, "AdminService/ApplyPreset", admin, json!({ "preset": preset })).await;
        for body in [
            json!({ "userId": ann, "capability": "CAPABILITY_SHARING", "enabled": false }),
            json!({ "libraryId": l1, "capability": "CAPABILITY_EDITS", "enabled": true }),
        ] {
            assert_eq!(
                call(&api.app, "AdminService/UpdatePolicy", admin, body).await.0,
                StatusCode::OK
            );
        }
        let (status, archive) = apply("PRESET_ARCHIVE_VIEWER").await;
        assert_eq!(status, StatusCode::OK, "{archive}");
        assert_eq!(
            switches(&archive),
            [
                "managed_libraries off server =off",
                "uploads off server =off",
                "folder_browser on server =on",
                "device_folders off server =off",
                "sharing on server =on",
                "edits off server =off",
                "deletes off server =off",
                "xmp_writes off server =off",
                "face_recognition on server =on",
                "ml_search on server =on",
            ]
        );
        let (_, of_ann) = call(&api.app, "AdminService/GetPolicy", admin, json!({ "libraryId": l1 })).await;
        assert!(
            switches(&of_ann).iter().all(|switch| switch.ends_with(" server")),
            "{of_ann}"
        );
        let on = json!({ "capability": "CAPABILITY_UPLOADS", "enabled": true });
        assert_eq!(
            uploads(&call(&api.app, "AdminService/UpdatePolicy", admin, on).await),
            "uploads on server =on",
            "a preset's switches stay editable"
        );
        for (preset, off) in [("PRESET_FAMILY_BACKUP", "xmp_writes"), ("PRESET_PERSONAL", "sharing")] {
            let (_, answer) = apply(preset).await;
            let switched_off: Vec<String> = (switches(&answer).into_iter())
                .filter(|switch| switch.contains(" off "))
                .collect();
            assert_eq!(switched_off, [format!("{off} off server =off")], "{preset}");
        }
        assert_eq!(
            apply("PRESET_UNSPECIFIED").await,
            refused("invalid_argument", "field.invalid", "preset")
        );
        let audited: Vec<(String, Option<String>, Option<i64>)> = sqlx::query_as(
            "SELECT action, details ->> 'preset', (details ->> 'cleared')::bigint FROM audit_events
             WHERE action LIKE 'policy.%' ORDER BY id",
        )
        .fetch_all(&api.pool)
        .await
        .unwrap();
        let update = ("policy.update".to_string(), None, None);
        let preset = |name: &str, cleared| ("policy.preset".to_string(), Some(name.to_string()), Some(cleared));
        assert_eq!(
            audited,
            [
                update.clone(),
                update.clone(),
                preset("archive_viewer", 2),
                update,
                preset("family_backup", 0),
                preset("personal", 0)
            ]
        );
    }

    #[tokio::test]
    async fn a_pinned_setting_reads_set_in_config_and_the_api_cannot_change_it() {
        let (api, root) = with_admin().await;
        let (ann, l1, _) = ann(&api).await;
        let pinned = crate::config::Pinned {
            trash_retention_days: Some(30),
            scrub_days: Some(30),
            policy: [("uploads".into(), false)].into(),
            ..Default::default()
        };
        crate::policy::pin(&api.pool, &pinned).await.unwrap();
        let app = with_config(&api, |config| config.settings = pinned).await;
        let call = async |procedure: &str, body: Value| call(&app, procedure, Some(&root), body).await;
        let settings = json!({ "trashRetentionDays": 30, "minFreeDiskPercent": 5, "scrubDays": 30,
            "backupSilentHours": 48, "minFreeDiskGb": 20 });
        assert_eq!(
            call("AdminService/GetSettings", json!({})).await.1,
            json!({ "settings": settings, "pinned": ["trash_retention_days", "scrub_days"] })
        );
        for (changed, field) in [
            (
                json!({ "trashRetentionDays": 60, "minFreeDiskPercent": 5 }),
                "trash_retention_days",
            ),
            (json!({ "trashRetentionDays": 30, "scrubDays": 60 }), "scrub_days"),
        ] {
            assert_eq!(
                call("AdminService/UpdateSettings", json!({ "settings": changed })).await,
                refused("failed_precondition", "setting.pinned", field)
            );
        }
        let others = json!({ "requireTwoFactor": true, "trashRetentionDays": 30, "minFreeDiskPercent": 10,
            "scrubDays": 30, "backupSilentHours": 72, "minFreeDiskGb": 20 });
        assert_eq!(
            call("AdminService/UpdateSettings", json!({ "settings": others })).await,
            (StatusCode::OK, json!({ "settings": others }))
        );
        for (level, expected) in [
            (json!({}), "uploads off config =off"),
            (json!({ "userId": ann }), "uploads off config"),
            (json!({ "libraryId": l1 }), "uploads off config"),
        ] {
            assert_eq!(uploads(&call("AdminService/GetPolicy", level.clone()).await), expected);
            let mut change = level;
            change["capability"] = "CAPABILITY_UPLOADS".into();
            change["enabled"] = true.into();
            assert_eq!(
                call("AdminService/UpdatePolicy", change).await,
                refused("failed_precondition", "setting.pinned", "uploads")
            );
        }
        let family = call("AdminService/ApplyPreset", json!({ "preset": "PRESET_FAMILY_BACKUP" })).await;
        assert_eq!(
            uploads(&family),
            "uploads off config =off",
            "a preset leaves pins alone"
        );
        assert_eq!(switches(&family.1)[0], "managed_libraries on server =on");
    }

    /// Under the Archive viewer preset nobody has a library to upload into and none is managed, while the read-only
    /// external libraries an administrator attaches are what users see.
    #[tokio::test]
    async fn under_the_archive_viewer_users_see_their_external_libraries_and_have_nowhere_to_upload() {
        use photolib_authz::{Action, Kind, Principal, Role, scope};

        let (api, root) = with_admin().await;
        let nas = tempfile::tempdir().unwrap();
        let app = with_config(&api, |config| config.external_roots = vec![nas.path().into()]).await;
        let call = async |procedure: &str, body: Value| call(&app, procedure, Some(&root), body).await;
        let (status, _) = call("AdminService/ApplyPreset", json!({ "preset": "PRESET_ARCHIVE_VIEWER" })).await;
        assert_eq!(status, StatusCode::OK);
        let body = json!({ "user": { "handle": "ann", "displayName": "Ann", "role": "USER_ROLE_USER" } });
        let (_, ann) = call("UserService/CreateUser", body).await;
        let ann = ann["user"]["userId"].as_str().unwrap().to_string();
        let body = json!({ "ownerUserId": ann, "name": "Archive", "root": nas.path().to_str().unwrap() });
        let (status, archive) = call("AdminService/CreateExternalLibrary", body).await;
        assert_eq!(status, StatusCode::OK, "{archive}");
        for (who, sees) in [
            (&ann, vec![archive["libraryId"].as_str().unwrap()]),
            (&root.user_id, vec![]),
        ] {
            let who = Principal::User(who.parse().unwrap(), Role::User);
            let libraries = async |action| {
                let mut q = sqlx::QueryBuilder::new("SELECT id::text FROM (");
                scope(who, action, Kind::Library, &mut q);
                let ids: Vec<String> = q.push(") s").build_query_scalar().fetch_all(&api.pool).await.unwrap();
                ids
            };
            assert_eq!(libraries(Action::View).await, sees);
            assert_eq!(
                libraries(Action::Contribute).await,
                Vec::<String>::new(),
                "no upload destination"
            );
        }
        let kinds: Vec<String> = sqlx::query_scalar("SELECT kind || ' ' || access FROM libraries")
            .fetch_all(&api.pool)
            .await
            .unwrap();
        assert_eq!(kinds, ["external ro"]);
    }

    /// The console of `api`'s instance with its data directory as the store of a scheduled backup and a pre-upgrade
    /// dump, and the token it cancels to stop for a restore.
    async fn with_backups(api: &Api) -> (axum::Router, tokio_util::sync::CancellationToken) {
        use std::sync::Arc;

        let instance = uuid::Uuid::now_v7();
        sqlx::query("INSERT INTO photolib_instance (instance_id) VALUES ($1::uuid)")
            .bind(instance.to_string())
            .execute(&api.pool)
            .await
            .unwrap();
        let config = crate::testing::config(&[crate::role::Role::Api], api.data.path());
        let journal = Arc::new(crate::storage::start(&config, &api.pool, instance).await.unwrap());
        for (key, bytes) in [
            ("backups/pre-0005-0006-20261019T000000Z.dump", &b"pre"[..]),
            ("backups/backup-20261020T030000Z.dump", b"backup"),
            ("backups/notes.txt", b"not a dump"),
        ] {
            let op = journal.put_bytes("local", key, bytes).await.unwrap();
            op.settle(&mut api.pool.acquire().await.unwrap()).await.unwrap();
        }
        let shutdown = tokio_util::sync::CancellationToken::new();
        let doctor = crate::doctor::Doctor {
            config,
            pool: Some(api.pool.clone()),
            seen: None,
            tail: None,
            ml: None,
        };
        let console = super::Admin::new(api.pool.clone(), Arc::new(doctor)).with_backups(journal, shutdown.clone());
        let keys = crate::keys::ApiKeys::new(api.pool.clone());
        let users = crate::rpc::Users::start(api.accounts.clone(), keys, Arc::new(crate::testing::BearerSessions));
        let users = Some(Arc::new(users.await.unwrap()));
        let app = crate::rpc::api(uuid::Uuid::now_v7().to_string(), users, None, Some(console));
        (app, shutdown)
    }

    #[tokio::test]
    async fn the_console_shows_backups_and_drills_backs_up_and_stops_photolibd_to_restore() {
        let (api, root) = with_admin().await;
        let admin = Some(&root);
        let (app, shutdown) = with_backups(&api).await;
        sql(
            &api,
            "INSERT INTO backup_runs (id, kind, store, dump, ok, detail, finished_at) VALUES
             (gen_random_uuid(), 'drill', 'local', 'backups/a.dump', true, 'restored', '2026-10-19 03:05:00+00'),
             (gen_random_uuid(), 'drill', 'local', 'backups/b.dump', false, 'no CREATEDB', '2026-10-20 03:05:00+00'),
             (gen_random_uuid(), 'backup', 'local', 'backups/b.dump', true, '6 bytes', '2026-10-20 03:01:00+00')",
        )
        .await;
        let (_, status) = call(&app, "AdminService/GetStatus", admin, json!({})).await;
        assert_eq!(
            status["backups"],
            json!([
                { "name": "backups/backup-20261020T030000Z.dump", "sizeBytes": "6",
                  "createdAt": "2026-10-20T03:00:00Z", "store": "local" },
                { "name": "backups/pre-0005-0006-20261019T000000Z.dump", "sizeBytes": "3",
                  "createdAt": "2026-10-19T00:00:00Z", "store": "local" },
            ])
        );
        assert_eq!(
            (&status["lastDrill"], &status["lastVerifiedRestore"]),
            (
                &json!({ "store": "local", "dump": "backups/b.dump", "detail": "no CREATEDB",
                         "finishedAt": "2026-10-20T03:05:00Z" }),
                &json!({ "store": "local", "dump": "backups/a.dump", "ok": true, "detail": "restored",
                         "finishedAt": "2026-10-19T03:05:00Z" })
            )
        );
        assert_eq!(status.get("lastRestore"), None, "no restore yet");

        let (code, queued) = call(&app, "AdminService/BackUpNow", admin, json!({})).await;
        assert_eq!(code, StatusCode::OK, "{queued}");
        let kind: String = sqlx::query_scalar("SELECT type FROM jobs WHERE id = $1::uuid")
            .bind(queued["jobId"].as_str().unwrap())
            .fetch_one(&api.pool)
            .await
            .unwrap();
        assert_eq!(kind, "backup");

        let newest = json!({ "store": "local", "name": "backups/backup-20261020T030000Z.dump" });
        let adminkey = key(&api.pool, &root, &ApiKeyScope::values()[1..]).await;
        assert_eq!(
            call(&app, "AdminService/RestoreBackup", Some(&adminkey), newest.clone()).await,
            (StatusCode::FORBIDDEN, denied("permission_denied", "backup.restore"))
        );
        for missing in [
            json!({ "store": "local", "name": "backups/notes.txt" }),
            json!({ "store": "b2", "name": "backups/backup-20261020T030000Z.dump" }),
            json!({ "store": "local", "name": "backups/backup-20261021T030000Z.dump" }),
        ] {
            assert_eq!(
                call(&app, "AdminService/RestoreBackup", admin, missing).await,
                (StatusCode::NOT_FOUND, denied("not_found", "backup.not_found"))
            );
        }
        assert!(!shutdown.is_cancelled());
        let (code, _) = call(&app, "AdminService/RestoreBackup", admin, newest).await;
        assert_eq!(code, StatusCode::OK);
        assert!(shutdown.is_cancelled(), "photolibd stops to restore");
        let request: Value =
            serde_json::from_slice(&std::fs::read(api.data.path().join(".photolib/restore.json")).unwrap()).unwrap();
        assert_eq!(
            request,
            json!({ "store": "local", "dump": "backups/backup-20261020T030000Z.dump" })
        );
        let audited: Vec<String> =
            sqlx::query_scalar("SELECT action FROM audit_events WHERE action LIKE 'backup.%' ORDER BY id")
                .fetch_all(&api.pool)
                .await
                .unwrap();
        assert_eq!(audited, ["backup.start", "backup.restore"]);
    }

    #[tokio::test]
    async fn the_status_shows_usage_libraries_and_open_jobs_and_the_stores_their_state() {
        let (api, root) = admin().await;
        let admin = Some(&root);
        sql(&api, WORLD).await;
        sql(
            &api,
            "INSERT INTO jobs (id, type, status) VALUES (photolib_uuidv7(), 'render', 'dead')",
        )
        .await;
        let (_, status) = call(&api.app, "AdminService/GetStatus", admin, json!({})).await;
        let ann = status["accounts"]
            .as_array()
            .unwrap()
            .iter()
            .find(|a| a["handle"] == "ann")
            .unwrap();
        assert_eq!((&ann["assetCount"], &ann["sizeBytes"]), (&json!("6"), &json!("700")));
        assert_eq!(
            status["files"],
            json!([
                { "role": "original", "fileCount": "6", "sizeBytes": "600" },
                { "role": "thumb_s", "fileCount": "1", "sizeBytes": "100" },
            ])
        );
        let l1 = &status["libraries"][0];
        assert_eq!(
            (
                &l1["name"],
                &l1["ownerHandle"],
                &l1["kind"],
                &l1["state"],
                &l1["assetCount"]
            ),
            (
                &json!("L1"),
                &json!("ann"),
                &json!("LIBRARY_KIND_MANAGED"),
                &json!("LIBRARY_STATE_ONLINE"),
                &json!("4")
            )
        );
        assert_eq!(
            status["jobs"],
            json!([{ "type": "render", "status": "JOB_STATUS_DEAD", "count": "1" }])
        );

        // The data directory is a store once photolibd has set it up.
        let (_, stores) = call(&api.app, "AdminService/ListStores", admin, json!({})).await;
        assert_eq!(stores["stores"][0]["status"], "CHECK_STATUS_FAIL", "{stores}");
        let instance = uuid::Uuid::now_v7();
        sqlx::query("INSERT INTO photolib_instance (instance_id) VALUES ($1::uuid)")
            .bind(instance.to_string())
            .execute(&api.pool)
            .await
            .unwrap();
        let config = crate::testing::config(&[crate::role::Role::Api], api.data.path());
        crate::storage::start(&config, &api.pool, instance).await.unwrap();
        let (_, stores) = call(&api.app, "AdminService/ListStores", admin, json!({})).await;
        let local = &stores["stores"][0];
        assert_eq!(
            (&local["name"], &local["status"]),
            (&json!("local"), &json!("CHECK_STATUS_OK")),
            "{stores}"
        );
        assert!(local["freeBytes"].as_str().unwrap().parse::<u64>().unwrap() > 0);
    }

    #[tokio::test]
    async fn the_status_shows_open_findings_with_their_files_the_scrubs_and_each_device_backup() {
        let (api, root) = with_admin().await;
        sql(&api, WORLD).await;
        sql(
            &api,
            "UPDATE assets SET original_filename = 'IMG_A.JPG' WHERE id = md5('a')::uuid;
             INSERT INTO integrity_findings (id, store, key, kind, detail, found_at, resolved_at) VALUES
             (photolib_uuidv7(), 'local', '2024/05/a.jpg', 'content', 'it reads as x', '2026-01-02', NULL),
             (photolib_uuidv7(), 'local', 'libraries/x/originals/stray.jpg', 'orphan', 'no file names it', '2026-01-03',
              NULL),
             (photolib_uuidv7(), 'local', '2024/05/e.jpg', 'missing', 'it is gone', '2026-01-01', '2026-01-02');
             INSERT INTO libraries (id, owner_id, name, kind, access, root_uri)
             SELECT md5(n)::uuid, md5('ann')::uuid, n, 'external', 'ro', '/srv/' || n FROM unnest('{N1,N2}'::text[]) n;
             INSERT INTO assets (id, library_id, owner_id, source, original_filename)
             SELECT md5('x' || n)::uuid, md5(n)::uuid, md5('ann')::uuid, 'scan', n || '.jpg' FROM unnest('{N1,N2}'::text[]) n;
             INSERT INTO asset_files (id, asset_id, role, storage, key, size)
             SELECT gen_random_uuid(), md5('x' || n)::uuid, 'original', 'external', '2019/x.jpg', 100
             FROM unnest('{N1,N2}'::text[]) n;
             INSERT INTO integrity_findings (id, store, key, kind, detail, found_at, library_id) VALUES
             (photolib_uuidv7(), 'external', '2019/x.jpg', 'content', 'it cannot be read', '2026-01-04', md5('N2')::uuid);
             INSERT INTO scrubs (store, cycle_ended_at) VALUES ('local', '2026-01-04'), ('b2', NULL);
             INSERT INTO devices (id, user_id, name, platform, last_seen_at) VALUES
             (md5('phone')::uuid, md5('ann')::uuid, 'Pixel', 'android', '2026-01-05'),
             (md5('laptop')::uuid, md5('ann')::uuid, 'Laptop', 'linux', now()),
             (md5('tablet')::uuid, md5('ann')::uuid, 'Tablet', 'android', now());
             INSERT INTO device_backups (device_id, reported_at, pending) VALUES
             (md5('phone')::uuid, now() - interval '49 hours', 12), (md5('laptop')::uuid, now() - interval '1 hour', 0);",
        )
        .await;
        let (a, x, phone): (String, String, String) =
            sqlx::query_as("SELECT md5('a')::uuid::text, md5('xN2')::uuid::text, md5('phone')::uuid::text")
                .fetch_one(&api.pool)
                .await
                .unwrap();
        let status = async || call(&api.app, "AdminService/GetStatus", Some(&root), json!({})).await.1;
        let got = status().await;
        assert_eq!(
            got["findings"],
            json!([
                { "store": "external", "key": "/srv/N2/2019/x.jpg", "kind": "FINDING_KIND_CONTENT",
                  "detail": "it cannot be read", "foundAt": "2026-01-04T00:00:00Z", "assetId": x, "fileName": "N2.jpg",
                  "ownerHandle": "ann" },
                { "store": "local", "key": "libraries/x/originals/stray.jpg", "kind": "FINDING_KIND_ORPHAN",
                  "detail": "no file names it", "foundAt": "2026-01-03T00:00:00Z" },
                { "store": "local", "key": "2024/05/a.jpg", "kind": "FINDING_KIND_CONTENT", "detail": "it reads as x",
                  "foundAt": "2026-01-02T00:00:00Z", "assetId": a, "fileName": "IMG_A.JPG",
                  "ownerHandle": "ann" },
            ])
        );
        assert_eq!(
            got["scrubs"],
            json!([{ "store": "b2" }, { "store": "local", "cycleEndedAt": "2026-01-04T00:00:00Z" }])
        );
        let backups = got["deviceBackups"].as_array().unwrap();
        let summary: Vec<_> = backups
            .iter()
            .map(|b| (&b["name"], &b["ownerHandle"], &b["pendingCount"], b["silent"].as_bool()))
            .collect();
        assert_eq!(
            summary,
            [
                (&json!("Pixel"), &json!("ann"), &json!("12"), Some(true)),
                (&json!("Laptop"), &json!("ann"), &Value::Null, None),
            ],
            "the longest silent first; a device that never reported is not listed"
        );
        assert_eq!(backups[0]["lastSeenAt"], "2026-01-05T00:00:00Z");
        assert_eq!(backups[0]["deviceId"], phone);
        sql(&api, "UPDATE instance_settings SET backup_silent_hours = 72").await;
        assert_eq!(
            status().await["deviceBackups"][0]["silent"],
            Value::Null,
            "silent only past the setting"
        );
    }

    #[tokio::test]
    async fn the_log_tail_and_the_diagnostics_bundle_come_from_the_running_server() {
        let (api, root) = with_admin().await;
        let admin = Some(&root);
        let mut tail = api.tail.clone();
        std::io::Write::write_all(&mut tail, b"first\nsecond\nthird\n").unwrap();
        let (_, logs) = call(&api.app, "AdminService/TailLogs", admin, json!({ "lineCount": 2 })).await;
        assert_eq!(logs, json!({ "lines": ["second", "third"] }));
        let (status, diagnostics) = call(&api.app, "AdminService/GetDiagnostics", admin, json!({})).await;
        assert_eq!(status, StatusCode::OK);
        let names: Vec<&str> = diagnostics["checks"]
            .as_array()
            .unwrap()
            .iter()
            .map(|c| c["name"].as_str().unwrap())
            .collect();
        for name in [
            "config",
            "filesystem data_dir",
            "postgres",
            "schema",
            "instance marker",
            "store local",
            "clients",
            "proxy",
        ] {
            assert!(names.contains(&name), "{name} in {names:?}");
        }
        let bundle: Value = serde_json::from_str(diagnostics["bundleJson"].as_str().unwrap()).unwrap();
        assert_eq!(bundle["checks"].as_array().unwrap().len(), names.len());
        assert_eq!(bundle["log"], json!(["first", "second", "third"]));
        assert_eq!(bundle["config"]["database.url"], "[redacted]");
        // The proxy check saw this very request, which came with no forwarded headers and from no known address.
        let proxy = bundle["checks"]
            .as_array()
            .unwrap()
            .iter()
            .find(|c| c["name"] == "proxy")
            .unwrap();
        assert_eq!(proxy["status"], "warn", "{proxy}");
    }
}
