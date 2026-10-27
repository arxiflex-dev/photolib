//! An idle server writes nothing to disk for ten minutes, so NAS disks can spin down: PostgreSQL's WAL, through which
//! every change goes, does not move, and neither PostgreSQL's background writers nor the server write a byte. Ten
//! minutes of the default timing run in ten seconds: every interval is divided by 60.

use std::time::Duration;

use async_trait::async_trait;
use photolib_db::{
    migrate::{Upgrade, embedded, upgrade},
    testpg,
};
use photolib_jobs::{
    Handler, Job, Timing, Worker,
    reconcile::{Profile, Rendition, reconcile},
    scheduler,
};
use sqlx::{PgConnection, PgPool};
use tokio_util::sync::CancellationToken;

const SCALE: u32 = 60;

struct Unused;

#[async_trait]
impl Handler for Unused {
    async fn run(&self, _: &Job, _: &mut PgConnection) -> Result<(), String> {
        Err("an idle server runs no job".into())
    }
}

/// Bytes written to storage by `pid`, from /proc/<pid>/io.
fn written(pid: u32) -> u64 {
    let io = std::fs::read_to_string(format!("/proc/{pid}/io")).unwrap();
    let line = io.lines().find(|line| line.starts_with("write_bytes:"));
    line.unwrap()[12..].trim().parse().unwrap()
}

/// The WAL position, and the bytes written by this process and PostgreSQL's background writers.
async fn writes(pool: &PgPool) -> (String, u64) {
    let wal = sqlx::query_scalar("SELECT pg_current_wal_insert_lsn()::text")
        .fetch_one(pool)
        .await
        .unwrap();
    let writers: Vec<i32> = sqlx::query_scalar(
        "SELECT pid FROM pg_stat_activity
         WHERE backend_type IN ('checkpointer', 'background writer', 'walwriter', 'autovacuum launcher')",
    )
    .fetch_all(pool)
    .await
    .unwrap();
    let bytes: u64 = writers.into_iter().map(|pid| written(pid as u32)).sum();
    (wal, bytes + written(std::process::id()))
}

#[tokio::test(flavor = "multi_thread")]
async fn an_idle_server_writes_nothing_for_ten_minutes() {
    let db = testpg::database().await;
    let pool = db.pool;
    upgrade(&pool, &Upgrade::new(&embedded())).await.unwrap();
    // A library whose derivatives all exist, the finished jobs that made them, and a schedule that is not due.
    sqlx::raw_sql(
        "INSERT INTO users (id, handle, display_name) VALUES (photolib_uuidv7(), 'ann', 'Ann');
         INSERT INTO libraries (id, owner_id, name, kind, root_uri)
           SELECT photolib_uuidv7(), id, 'Photos', 'managed', 'file:///photos' FROM users;
         INSERT INTO assets (id, library_id, owner_id, source, media_kind)
           SELECT photolib_uuidv7(), id, owner_id, 'upload', 'image' FROM libraries, generate_series(1, 100);
         INSERT INTO job_schedules (name, cron, type, next_run)
           VALUES ('nightly', '0 3 * * *', 'backup', now() + interval '1 day');",
    )
    .execute(&pool)
    .await
    .unwrap();
    let profile = Profile {
        renditions: vec![Rendition {
            kind: "image".into(),
            role: "thumb_s".into(),
            spec_id: "s1".into(),
            only_for: None,
        }],
        models: vec!["clip@1".into()],
        ocr: vec![],
        export: None,
    };
    assert_eq!(reconcile(&pool, &profile).await.unwrap(), 200);
    sqlx::raw_sql(
        "INSERT INTO asset_files (id, asset_id, role, storage, key, render_spec)
           SELECT photolib_uuidv7(), id, 'thumb_s', 'derived', 'k', '{\"spec_id\": \"s1\"}' FROM assets;
         INSERT INTO asset_embeddings (asset_id, model_id, embedding) SELECT id, 'clip@1', '\\x01' FROM assets;
         UPDATE jobs SET status = 'done', attempts = 1;",
    )
    .execute(&pool)
    .await
    .unwrap();
    // What the earlier writes leave autovacuum and the checkpointer to do: statistics (whose old rows VACUUM then
    // removes), hint bits and dirty pages.
    for settle in ["ANALYZE", "VACUUM", "CHECKPOINT"] {
        sqlx::query(settle).execute(&pool).await.unwrap();
    }

    let default = Timing::default();
    let timing = Timing {
        lease: default.lease / SCALE,
        retry: default.retry / SCALE,
        poll_min: default.poll_min / SCALE,
        poll_max: default.poll_max / SCALE,
        tick: default.tick / SCALE,
        reconcile: default.reconcile / SCALE,
    };
    let before = writes(&pool).await;
    let shutdown = CancellationToken::new();
    let worker = Worker::new(pool.clone(), "idle", 2, timing)
        .handle("render", Unused)
        .handle("embed", Unused);
    let roles = [
        tokio::spawn(worker.run(shutdown.clone())),
        tokio::spawn(scheduler::run(pool.clone(), profile, timing, shutdown.clone())),
    ];
    tokio::time::sleep(Duration::from_secs(600) / SCALE).await;
    shutdown.cancel();
    for role in roles {
        role.await.unwrap();
    }
    assert_eq!(writes(&pool).await, before);
}
