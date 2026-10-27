//! The derivatives reconciler: the renditions and embeddings that should exist (asset × render spec, asset × model
//! id) against those that do, with the difference queued. Lost jobs, deleted renditions, render-spec bumps and model
//! upgrades heal themselves.

use sqlx::{PgConnection, PgPool};
use uuid::Uuid;

use crate::notify;

/// A rendition that every asset of a media kind (`image`, `video`) should have; `spec_id` names its render spec.
#[derive(Clone, Debug)]
pub struct Rendition {
    pub kind: String,
    pub role: String,
    pub spec_id: String,
    /// The library rendition quality (`libraries.rendition_quality`) this rendition is for; none for every library.
    pub only_for: Option<String>,
}

/// The derivatives the server wants: renditions, and an embedding by each active model.
#[derive(Clone, Debug, Default)]
pub struct Profile {
    pub renditions: Vec<Rendition>,
    pub models: Vec<String>,
    /// The OCR models whose text every image should have (`asset_ocr`): an `ocr` job for each that lacks it.
    pub ocr: Vec<String>,
    /// The spec id of the full-size export of an edited image's current version (`edit_export`), which an `export`
    /// job makes; none for no exports.
    pub export: Option<String>,
}

/// Queues a `render` job (payload `{"asset", "role", "spec_id"}`), `transcode` for a video, which FFmpeg's workers
/// render, for each missing rendition, an `embed` job (`{"asset", "model_id"}`) for each missing embedding and an
/// `ocr` job (the same payload) for each image without the text of an OCR model, and returns how many. A finished job with the same key is
/// queued again. Assets of private libraries get `device` jobs: without a grant the server never sees their media.
pub async fn reconcile(pool: &PgPool, profile: &Profile) -> sqlx::Result<u64> {
    let mut queued = 0;
    loop {
        let ids = queue(&mut *pool.acquire().await?, profile, None, BATCH).await?;
        queued += ids;
        if (ids as i64) < BATCH {
            return Ok(queued);
        }
    }
}

/// Queues the missing derivatives of `ids` on `conn`, in the transaction that commits them, and returns how many.
pub async fn assets(conn: &mut PgConnection, profile: &Profile, ids: &[Uuid]) -> sqlx::Result<u64> {
    queue(conn, profile, Some(ids), i64::MAX).await
}

/// Queues up to `limit` missing derivatives, of the assets `only` names or of all.
async fn queue(conn: &mut PgConnection, profile: &Profile, only: Option<&[Uuid]>, limit: i64) -> sqlx::Result<u64> {
    let renditions = &profile.renditions;
    let kinds: Vec<&str> = renditions.iter().map(|r| r.kind.as_str()).collect();
    let roles: Vec<&str> = renditions.iter().map(|r| r.role.as_str()).collect();
    let specs: Vec<&str> = renditions.iter().map(|r| r.spec_id.as_str()).collect();
    let qualities: Vec<&str> = renditions.iter().map(|r| r.only_for.as_deref().unwrap_or("")).collect();
    let ids: Vec<Uuid> = sqlx::query_scalar(RECONCILE)
        .bind(&kinds)
        .bind(&roles)
        .bind(&specs)
        .bind(&profile.models)
        .bind(limit)
        .bind(only)
        .bind(&profile.ocr)
        .bind(&profile.export)
        .bind(&qualities)
        .fetch_all(&mut *conn)
        .await?;
    if let Some(id) = ids.first() {
        notify(conn, *id).await?;
    }
    Ok(ids.len() as u64)
}

/// Jobs per statement, so that a pass over a large library never holds one long transaction.
const BATCH: i64 = 1000;

/// Queues up to `$5` missing derivatives that have no queued or running job, of the assets `$6` lists or of all.
const RECONCILE: &str = "
WITH desired AS (
    SELECT l.privacy, CASE a.media_kind WHEN 'video' THEN 'transcode' ELSE 'render' END AS type,
        concat_ws(':', 'render', a.id, s.role, s.spec_id) AS key,
        json_build_object('asset', a.id, 'role', s.role, 'spec_id', s.spec_id) AS payload
    FROM assets a
    JOIN libraries l ON l.id = a.library_id
    JOIN unnest($1::text[], $2::text[], $3::text[], $9::text[]) AS s (kind, role, spec_id, only_for)
        ON s.kind = a.media_kind AND (s.only_for = '' OR s.only_for = l.rendition_quality)
    WHERE ($6::uuid[] IS NULL OR a.id = ANY($6)) AND NOT EXISTS (
        SELECT FROM asset_files f WHERE f.asset_id = a.id AND f.role = s.role AND f.state = 'present'
            AND f.render_spec ->> 'spec_id' = s.spec_id
            -- An image's rendition is of one version of it (docs/dev/editor-recipes.md).
            AND (s.kind <> 'image' OR f.render_spec ->> 'version_id' IS NOT DISTINCT FROM a.current_version_id::text))
    UNION ALL
    SELECT l.privacy, 'embed', concat_ws(':', 'embed', a.id, m.model_id),
        json_build_object('asset', a.id, 'model_id', m.model_id)
    FROM assets a
    JOIN libraries l ON l.id = a.library_id
    CROSS JOIN unnest($4::text[]) AS m (model_id)
    WHERE a.media_kind IS NOT NULL AND ($6::uuid[] IS NULL OR a.id = ANY($6))
        AND NOT EXISTS (SELECT FROM asset_embeddings e WHERE e.asset_id = a.id AND e.model_id = m.model_id)
    UNION ALL
    SELECT l.privacy, 'ocr', concat_ws(':', 'ocr', a.id, m.model_id),
        json_build_object('asset', a.id, 'model_id', m.model_id)
    FROM assets a
    JOIN libraries l ON l.id = a.library_id
    CROSS JOIN unnest($7::text[]) AS m (model_id)
    WHERE a.media_kind = 'image' AND ($6::uuid[] IS NULL OR a.id = ANY($6))
        AND NOT EXISTS (SELECT FROM asset_ocr o WHERE o.asset_id = a.id AND o.model_id = m.model_id
            -- Text read in the current version, or before versions had recipes when the current one is no edit.
            AND (o.version_id = a.current_version_id OR (o.version_id IS NULL AND NOT EXISTS (
                SELECT FROM versions v WHERE v.id = a.current_version_id AND v.kind = 'edit'))))
    UNION ALL
    SELECT l.privacy, 'export', concat_ws(':', 'export', a.id, v.id),
        json_build_object('asset', a.id, 'version', v.id)
    FROM assets a
    JOIN libraries l ON l.id = a.library_id
    JOIN versions v ON v.id = a.current_version_id AND v.kind = 'edit'
    WHERE $8::text IS NOT NULL AND a.media_kind = 'image' AND ($6::uuid[] IS NULL OR a.id = ANY($6))
        AND NOT EXISTS (SELECT FROM asset_files f WHERE f.asset_id = a.id AND f.role = 'edit_export'
            AND f.state = 'present' AND f.render_spec ->> 'spec_id' = $8
            AND f.render_spec ->> 'version_id' = v.id::text)
)
INSERT INTO jobs (id, type, payload, status, placement, idempotency_key)
SELECT photolib_uuidv7(), type, convert_to(payload::text, 'UTF8'), 'queued',
    CASE WHEN privacy = 'private' THEN 'device' ELSE 'server' END, key
FROM desired d
WHERE NOT EXISTS (SELECT FROM jobs j WHERE j.idempotency_key = d.key AND j.status IN ('queued', 'running'))
LIMIT $5
ON CONFLICT (idempotency_key) DO UPDATE SET status = 'queued', attempts = 0, run_after = now(), error = NULL,
    placement = excluded.placement, grant_id = NULL
WHERE jobs.status NOT IN ('queued', 'running')
RETURNING id";

#[cfg(test)]
mod tests {
    use async_trait::async_trait;
    use sqlx::PgConnection;
    use tokio_util::sync::CancellationToken;

    use super::*;
    use crate::{
        Handler, Job, Worker,
        testing::{asset, database, exec, fast, library, scalar},
    };

    /// Stores what a `render` or `embed` job asks for, as the real renderer and model would.
    struct Derive;

    #[async_trait]
    impl Handler for Derive {
        async fn run(&self, job: &Job, tx: &mut PgConnection) -> Result<(), String> {
            let sql = match job.kind.as_str() {
                "render" | "transcode" => {
                    "INSERT INTO asset_files (id, asset_id, role, storage, key, render_spec)
                     SELECT photolib_uuidv7(), (p->>'asset')::uuid, p->>'role', 'derived', 'k',
                       jsonb_build_object('spec_id', p->>'spec_id')
                     FROM (SELECT convert_from($1, 'UTF8')::jsonb AS p) job"
                }
                _ => {
                    "INSERT INTO asset_embeddings (asset_id, model_id, embedding)
                     SELECT (p->>'asset')::uuid, p->>'model_id', '\\x01'
                     FROM (SELECT convert_from($1, 'UTF8')::jsonb AS p) job"
                }
            };
            sqlx::query(sql)
                .bind(&job.payload)
                .execute(tx)
                .await
                .map_err(|error| error.to_string())?;
            Ok(())
        }
    }

    fn profile(model: &str) -> Profile {
        let rendition = |kind: &str| Rendition {
            kind: kind.into(),
            role: "thumb_s".into(),
            spec_id: "s1".into(),
            only_for: None,
        };
        Profile {
            renditions: vec![rendition("image"), rendition("video")],
            models: vec![model.into()],
            ocr: vec![],
            export: None,
        }
    }

    /// The jobs by key and status, keys shortened to their type and target.
    async fn jobs(pool: &PgPool) -> Vec<(String, String, String)> {
        sqlx::query_as(
            "SELECT regexp_replace(idempotency_key, ':[0-9a-f-]{36}', ''), placement, status
             FROM jobs ORDER BY 1, 2, 3",
        )
        .fetch_all(pool)
        .await
        .unwrap()
    }

    async fn idle(pool: &PgPool) {
        let started = photolib_spawn::Running::start();
        loop {
            let busy: i64 = sqlx::query_scalar(
                "SELECT count(*) FROM jobs WHERE placement = 'server' AND status IN ('queued', 'running')",
            )
            .fetch_one(pool)
            .await
            .unwrap();
            if busy == 0 {
                return;
            }
            assert!(started.elapsed().as_secs() < 10, "{:?}", jobs(pool).await);
            tokio::time::sleep(std::time::Duration::from_millis(10)).await;
        }
    }

    async fn derived(pool: &PgPool, sql: &str, asset: Uuid) -> Vec<String> {
        sqlx::query_scalar(sql).bind(asset).fetch_all(pool).await.unwrap()
    }

    #[tokio::test]
    async fn a_deleted_thumbnail_is_rendered_again_and_a_new_model_embeds_every_asset() {
        let pool = database().await;
        let standard = library(&pool, "standard").await;
        let (image, video) = (
            asset(&pool, standard, "image").await,
            asset(&pool, standard, "video").await,
        );
        asset(&pool, library(&pool, "private").await, "image").await;
        let shutdown = CancellationToken::new();
        let worker = Worker::new(pool.clone(), "w", 2, fast())
            .handle("render", Derive)
            .handle("transcode", Derive)
            .handle("embed", Derive);
        tokio::spawn(worker.run(shutdown.clone()));

        assert_eq!(reconcile(&pool, &profile("clip@1")).await.unwrap(), 6);
        idle(&pool).await;
        let done = |kind: &str| (kind.to_string(), "server".to_string(), "done".to_string());
        let device = |kind: &str| (kind.to_string(), "device".to_string(), "queued".to_string());
        let mut expected = vec![
            device("embed:clip@1"),
            done("embed:clip@1"),
            done("embed:clip@1"),
            device("render:thumb_s:s1"),
            done("render:thumb_s:s1"),
            done("render:thumb_s:s1"),
        ];
        assert_eq!(jobs(&pool).await, expected);
        assert_eq!(
            reconcile(&pool, &profile("clip@1")).await.unwrap(),
            0,
            "nothing is missing"
        );

        exec(&pool, "DELETE FROM asset_files WHERE asset_id = $1", image).await;
        exec(
            &pool,
            "UPDATE asset_files SET state = 'missing' WHERE asset_id = $1",
            video,
        )
        .await;
        assert_eq!(reconcile(&pool, &profile("clip@1")).await.unwrap(), 2);
        idle(&pool).await;
        let thumbnails = "SELECT state FROM asset_files WHERE asset_id = $1 ORDER BY state DESC";
        assert_eq!(derived(&pool, thumbnails, image).await, ["present"]);
        assert_eq!(derived(&pool, thumbnails, video).await, ["present", "missing"]);

        assert_eq!(reconcile(&pool, &profile("clip@2")).await.unwrap(), 3);
        idle(&pool).await;
        let models = "SELECT model_id FROM asset_embeddings WHERE asset_id = $1 ORDER BY 1";
        for asset in [image, video] {
            assert_eq!(derived(&pool, models, asset).await, ["clip@1", "clip@2"]);
        }
        expected.splice(
            3..3,
            [device("embed:clip@2"), done("embed:clip@2"), done("embed:clip@2")],
        );
        assert_eq!(jobs(&pool).await, expected);
        shutdown.cancel();
    }

    #[tokio::test]
    async fn an_image_without_text_read_by_the_ocr_model_gets_an_ocr_job_once() {
        let pool = database().await;
        let standard = library(&pool, "standard").await;
        let image = asset(&pool, standard, "image").await;
        asset(&pool, standard, "video").await;
        let private = asset(&pool, library(&pool, "private").await, "image").await;
        let ocr = Profile {
            ocr: vec!["ppocr-v5".into()],
            ..Profile::default()
        };
        assert_eq!(
            reconcile(&pool, &ocr).await.unwrap(),
            2,
            "the video has no text to read"
        );
        let queued: Vec<(String, String, String, String)> = sqlx::query_as(
            "SELECT type, idempotency_key, placement, convert_from(payload, 'UTF8')::jsonb::text FROM jobs ORDER BY 3, 2",
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        let job = |asset: Uuid, placement: &str| {
            (
                "ocr".to_string(),
                format!("ocr:{asset}:ppocr-v5"),
                placement.to_string(),
                format!(r#"{{"asset": "{asset}", "model_id": "ppocr-v5"}}"#),
            )
        };
        assert_eq!(queued, [job(private, "device"), job(image, "server")]);
        assert_eq!(reconcile(&pool, &ocr).await.unwrap(), 0, "its job is queued");

        sqlx::query("DELETE FROM jobs").execute(&pool).await.unwrap();
        sqlx::query("INSERT INTO asset_ocr (asset_id, model_id, text) VALUES ($1, 'ppocr-v5', '')")
            .bind(image)
            .execute(&pool)
            .await
            .unwrap();
        assert_eq!(
            reconcile(&pool, &ocr).await.unwrap(),
            1,
            "an empty text is read; only the private one is left"
        );
    }

    /// A version of `asset`, which `current` makes the asset's current one.
    async fn version(pool: &PgPool, asset: Uuid, kind: &str, current: bool) -> Uuid {
        let id: Uuid = sqlx::query_scalar(
            "INSERT INTO versions (id, asset_id, kind) VALUES (photolib_uuidv7(), $1, $2) RETURNING id",
        )
        .bind(asset)
        .bind(kind)
        .fetch_one(pool)
        .await
        .unwrap();
        if current {
            switch(pool, asset, id).await;
        }
        id
    }

    async fn switch(pool: &PgPool, asset: Uuid, version: Uuid) {
        sqlx::query("UPDATE assets SET current_version_id = $2 WHERE id = $1")
            .bind(asset)
            .bind(version)
            .execute(pool)
            .await
            .unwrap();
    }

    fn image_profile() -> Profile {
        Profile {
            renditions: vec![Rendition {
                kind: "image".into(),
                role: "thumb_s".into(),
                spec_id: "s1".into(),
                only_for: None,
            }],
            ocr: vec!["ppocr-v5".into()],
            export: Some("x1".into()),
            ..Profile::default()
        }
    }

    /// Stores what the jobs of the next test make, naming the version they were made for.
    async fn made(pool: &PgPool, asset: Uuid, role: &str, spec: &str) {
        // A job replaces the renditions of its role that it makes anew.
        sqlx::query("DELETE FROM asset_files WHERE asset_id = $1 AND role = $2")
            .bind(asset)
            .bind(role)
            .execute(pool)
            .await
            .unwrap();
        sqlx::query(
            "INSERT INTO asset_files (id, asset_id, role, storage, key, render_spec)
             SELECT photolib_uuidv7(), a.id, $2, 'derived', 'k', jsonb_build_object('spec_id', $3::text,
                 'version_id', a.current_version_id) FROM assets a WHERE a.id = $1",
        )
        .bind(asset)
        .bind(role)
        .bind(spec)
        .execute(pool)
        .await
        .unwrap();
    }

    #[tokio::test]
    async fn a_rendition_made_for_another_version_than_the_current_is_made_again() {
        let pool = database().await;
        let image = asset(&pool, library(&pool, "standard").await, "image").await;
        let original = version(&pool, image, "original", true).await;
        let profile = Profile {
            ocr: vec![],
            export: None,
            ..image_profile()
        };
        assert_eq!(reconcile(&pool, &profile).await.unwrap(), 1);
        made(&pool, image, "thumb_s", "s1").await;
        sqlx::query("DELETE FROM jobs").execute(&pool).await.unwrap();
        assert_eq!(
            reconcile(&pool, &profile).await.unwrap(),
            0,
            "made for the current version"
        );

        let edited = version(&pool, image, "edit", true).await;
        assert_eq!(
            reconcile(&pool, &profile).await.unwrap(),
            1,
            "the edit changes the picture"
        );
        made(&pool, image, "thumb_s", "s1").await;
        sqlx::query("DELETE FROM jobs").execute(&pool).await.unwrap();
        assert_eq!(reconcile(&pool, &profile).await.unwrap(), 0);

        // A revert needs the first version's rendition again; the edit's is in its place of the same role.
        switch(&pool, image, original).await;
        assert_eq!(reconcile(&pool, &profile).await.unwrap(), 1);
        switch(&pool, image, edited).await;
        assert_eq!(
            reconcile(&pool, &profile).await.unwrap(),
            0,
            "the job for the revert is queued, the edit's is made"
        );
    }

    #[tokio::test]
    async fn text_read_in_another_version_is_read_again_and_text_read_before_versions_stands() {
        let pool = database().await;
        let image = asset(&pool, library(&pool, "standard").await, "image").await;
        let original = version(&pool, image, "original", true).await;
        let ocr = Profile {
            ocr: vec!["ppocr-v5".into()],
            ..Profile::default()
        };
        let read = |version: Option<Uuid>| {
            let pool = pool.clone();
            async move {
                sqlx::query("DELETE FROM asset_ocr").execute(&pool).await.unwrap();
                sqlx::query("DELETE FROM jobs").execute(&pool).await.unwrap();
                sqlx::query(
                    "INSERT INTO asset_ocr (asset_id, model_id, text, version_id) VALUES ($1, 'ppocr-v5', 't', $2)",
                )
                .bind(image)
                .bind(version)
                .execute(&pool)
                .await
                .unwrap();
            }
        };
        read(None).await;
        assert_eq!(reconcile(&pool, &ocr).await.unwrap(), 0, "read as the picture came");
        read(Some(original)).await;
        assert_eq!(reconcile(&pool, &ocr).await.unwrap(), 0);

        let edited = version(&pool, image, "edit", true).await;
        read(None).await;
        assert_eq!(
            reconcile(&pool, &ocr).await.unwrap(),
            1,
            "the original's text is not the edit's"
        );
        read(Some(original)).await;
        assert_eq!(reconcile(&pool, &ocr).await.unwrap(), 1);
        read(Some(edited)).await;
        assert_eq!(reconcile(&pool, &ocr).await.unwrap(), 0);
        switch(&pool, image, original).await;
        assert_eq!(
            reconcile(&pool, &ocr).await.unwrap(),
            1,
            "a revert reads the original's again"
        );
    }

    #[tokio::test]
    async fn an_edited_image_gets_one_export_job_for_its_current_version() {
        let pool = database().await;
        let standard = library(&pool, "standard").await;
        let (image, plain, video) = (
            asset(&pool, standard, "image").await,
            asset(&pool, standard, "image").await,
            asset(&pool, standard, "video").await,
        );
        let profile = Profile {
            renditions: vec![],
            ocr: vec![],
            ..image_profile()
        };
        let original = version(&pool, image, "original", true).await;
        version(&pool, plain, "original", true).await;
        version(&pool, video, "edit", true).await;
        assert_eq!(
            reconcile(&pool, &profile).await.unwrap(),
            0,
            "only an edit is exported, and only of an image"
        );
        let edited = version(&pool, image, "edit", true).await;
        assert_eq!(reconcile(&pool, &profile).await.unwrap(), 1);
        let job: (String, String, String) =
            sqlx::query_as("SELECT type, idempotency_key, convert_from(payload, 'UTF8')::jsonb::text FROM jobs")
                .fetch_one(&pool)
                .await
                .unwrap();
        assert_eq!(job.0, "export");
        assert_eq!(job.1, format!("export:{image}:{edited}"));
        assert_eq!(job.2, format!(r#"{{"asset": "{image}", "version": "{edited}"}}"#));
        made(&pool, image, "edit_export", "x1").await;
        sqlx::query("DELETE FROM jobs").execute(&pool).await.unwrap();
        assert_eq!(reconcile(&pool, &profile).await.unwrap(), 0, "exported");
        switch(&pool, image, original).await;
        assert_eq!(
            reconcile(&pool, &profile).await.unwrap(),
            0,
            "the original is the original file"
        );
    }

    #[tokio::test]
    async fn a_videos_renditions_are_transcode_jobs() {
        let pool = database().await;
        let standard = library(&pool, "standard").await;
        for kind in ["image", "video"] {
            asset(&pool, standard, kind).await;
        }
        reconcile(&pool, &profile("clip@1")).await.unwrap();
        let types: Vec<(String, String)> = sqlx::query_as(
            "SELECT a.media_kind, j.type FROM jobs j JOIN assets a ON j.idempotency_key LIKE 'render:' || a.id || ':%'
             ORDER BY 1",
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        let typed = |kind: &str, job: &str| (kind.to_string(), job.to_string());
        assert_eq!(types, [typed("image", "render"), typed("video", "transcode")]);
    }

    #[tokio::test]
    async fn a_commit_queues_its_assets_derivatives_in_its_transaction() {
        let pool = database().await;
        let standard = library(&pool, "standard").await;
        let (new, other) = (
            asset(&pool, standard, "image").await,
            asset(&pool, standard, "image").await,
        );
        let mut tx = pool.begin().await.unwrap();
        assert_eq!(assets(&mut tx, &profile("clip@1"), &[new]).await.unwrap(), 2);
        assert!(jobs(&pool).await.is_empty(), "nothing is queued before the commit");
        tx.commit().await.unwrap();
        let keys: Vec<String> = sqlx::query_scalar("SELECT idempotency_key FROM jobs ORDER BY 1")
            .fetch_all(&pool)
            .await
            .unwrap();
        assert_eq!(
            keys,
            [format!("embed:{new}:clip@1"), format!("render:{new}:thumb_s:s1")]
        );
        assert_eq!(reconcile(&pool, &profile("clip@1")).await.unwrap(), 2, "{other}'s");
    }

    #[tokio::test]
    async fn lost_and_dead_jobs_are_queued_again_and_a_large_library_takes_several_batches() {
        let pool = database().await;
        library(&pool, "standard").await;
        // 2,500 images and one asset whose kind is not known yet.
        sqlx::query(
            "INSERT INTO assets (id, library_id, owner_id, source, media_kind)
             SELECT photolib_uuidv7(), id, owner_id, 'upload', CASE WHEN n > 0 THEN 'image' END
             FROM libraries, generate_series(0, 2500) AS n",
        )
        .execute(&pool)
        .await
        .unwrap();
        let models = Profile {
            models: vec!["clip@1".into()],
            ..Profile::default()
        };
        assert_eq!(reconcile(&pool, &models).await.unwrap(), 2500);
        assert_eq!(reconcile(&pool, &models).await.unwrap(), 0);
        let lost: Uuid =
            sqlx::query_scalar("DELETE FROM jobs WHERE id = (SELECT id FROM jobs ORDER BY id LIMIT 1) RETURNING id")
                .fetch_one(&pool)
                .await
                .unwrap();
        let dead: Uuid = sqlx::query_scalar(
            "UPDATE jobs SET status = 'dead', attempts = 5 WHERE id = (SELECT id FROM jobs ORDER BY id DESC LIMIT 1) RETURNING id",
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(reconcile(&pool, &models).await.unwrap(), 2);
        let states: Vec<(String, i32)> = sqlx::query_as("SELECT DISTINCT status, attempts FROM jobs")
            .fetch_all(&pool)
            .await
            .unwrap();
        assert_eq!(states, [("queued".into(), 0)]);
        // The lost job is a new row; the dead one is the same row again.
        let rows = "SELECT count(*) FROM jobs WHERE id = $1";
        assert_eq!(
            (
                scalar::<i64>(&pool, rows, lost).await,
                scalar::<i64>(&pool, rows, dead).await
            ),
            (0, 1)
        );
    }
}
