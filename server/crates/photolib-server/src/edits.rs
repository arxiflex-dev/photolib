//! Edit recipes on the server (roadmap M8-01, ADR-0391): the kernel's recipe calls made typed. Recipes come from any
//! device and carry the bytes of masks and patches, so nothing here trusts them: every recipe is checked and put in its
//! canonical form by the kernel before it is stored, and what is stored is only read back through the same calls.

use async_trait::async_trait;
use photolib_jobs::{
    Handler, Job,
    reconcile::{self, Profile},
};
use photolib_kernel::proto::{
    kernel::v1::{
        CallResponse, MapRegionsRequest, MapRegionsResponse, MappedRegion, Method, Region, ResolveRecipeRequest,
        ResolveRecipeResponse, call_response,
    },
    model::v1::EditRecipe,
};
use prost::Message;

/// The job that queues what follows a change of an asset's current version.
pub const FOLLOW: &str = "follow";
/// The spec of an edited image's full-size export (role `edit_export`); any change of its output makes another id.
pub const EXPORT_SPEC: &str = "edit-export-1";

/// A recipe checked by the kernel, in its canonical encoding.
#[derive(Clone, Debug, PartialEq)]
pub struct Checked {
    /// The recipe the kernel accepted.
    pub recipe: EditRecipe,
    /// The canonical encoding: what is stored in `versions.recipe`.
    pub bytes: Vec<u8>,
    /// Its SHA-256: `versions.recipe_hash`.
    pub hash: Vec<u8>,
    /// The edited picture's size in pixels, when the original's was given.
    pub size: (u32, u32),
}

/// The `follow` job's handler (`worker:cpu`): an asset's current version changed, so the reconciler queues what its
/// picture now needs again: the renditions, the text OCR reads and the full-size export of that version. It holds the
/// profile the reconciler compares the asset with.
pub struct Follow(pub Profile);

#[async_trait]
impl Handler for Follow {
    async fn run(&self, job: &Job, tx: &mut sqlx::PgConnection) -> Result<(), String> {
        let payload: serde_json::Value = serde_json::from_slice(&job.payload).map_err(|e| e.to_string())?;
        let asset = payload
            .get("asset")
            .and_then(|a| a.as_str())
            .and_then(|a| a.parse().ok());
        let asset: uuid::Uuid = asset.ok_or("the job names no asset")?;
        reconcile::assets(tx, &self.0, &[asset])
            .await
            .map_err(|e| e.to_string())?;
        Ok(())
    }
}

/// Runs a kernel call; the error names the field the kernel refused.
fn kernel<R: Message + Default>(method: Method, request: &impl Message) -> Result<R, String> {
    let answer = photolib_kernel::call(method as u32, &request.encode_to_vec());
    match CallResponse::decode(answer.as_slice()).ok().and_then(|a| a.result) {
        Some(call_response::Result::Response(bytes)) => R::decode(bytes.as_slice()).map_err(|e| e.to_string()),
        Some(call_response::Result::Error(error)) => Err(error
            .params
            .get("field")
            .cloned()
            .unwrap_or_else(|| format!("{:?}", error.code()))),
        None => Err("no answer".into()),
    }
}

/// The recipe encoded in `bytes`, checked for a picture of `size` (0 for none) and put in its canonical form.
pub fn check(bytes: &[u8], size: (u32, u32)) -> Result<Checked, String> {
    let recipe = EditRecipe::decode(bytes).map_err(|_| "recipe".to_owned())?;
    let request = ResolveRecipeRequest {
        recipe: Some(recipe),
        width: size.0,
        height: size.1,
    };
    let resolved: ResolveRecipeResponse = kernel(Method::ResolveRecipe, &request)?;
    let recipe = resolved.recipe.ok_or("recipe")?;
    Ok(Checked {
        bytes: recipe.encode_to_vec(),
        recipe,
        hash: resolved.sha256,
        size: (resolved.width, resolved.height),
    })
}

/// Where `regions` of a picture in the version `from` are in the version `to`; none is the original.
pub fn map(
    from: Option<&EditRecipe>,
    to: Option<&EditRecipe>,
    regions: Vec<Region>,
) -> Result<Vec<MappedRegion>, String> {
    let request = MapRegionsRequest {
        from: from.cloned(),
        to: to.cloned(),
        regions,
    };
    let answer: MapRegionsResponse = kernel(Method::MapRegions, &request)?;
    Ok(answer.regions)
}

#[cfg(test)]
mod tests {
    use std::time::Duration;

    use photolib_db::{
        migrate::{Upgrade, embedded, upgrade},
        testpg,
    };
    use photolib_jobs::{Timing, Worker, reconcile::Rendition};
    use photolib_kernel::proto::model::v1::{CropOperation, Operation, operation::Kind};

    use super::*;

    pub(crate) fn crop(x: f32, y: f32, width: f32, height: f32) -> EditRecipe {
        EditRecipe {
            schema_version: 1,
            operations: vec![Operation {
                operation_id: "crop".into(),
                kind: Some(Kind::Crop(CropOperation { x, y, width, height })),
                ..Default::default()
            }],
            ..Default::default()
        }
    }

    #[test]
    fn a_recipe_is_stored_in_the_kernels_canonical_form_with_its_hash() {
        let sent = crop(0.25, -0.0, 0.5, 1.0);
        let checked = check(&sent.encode_to_vec(), (0, 0)).unwrap();
        assert_eq!(checked.hash.len(), 32);
        assert_eq!(EditRecipe::decode(checked.bytes.as_slice()).unwrap(), checked.recipe);
        let again = check(&checked.bytes, (400, 300)).unwrap();
        assert_eq!(again.bytes, checked.bytes, "canonical bytes are a fixed point");
        assert_eq!(again.hash, checked.hash);
        assert_eq!(check(&[0xff], (0, 0)).unwrap_err(), "recipe");
        assert_eq!(
            check(&crop(0.9, 0.0, 0.5, 1.0).encode_to_vec(), (0, 0)).unwrap_err(),
            "operations[0].crop"
        );
    }

    #[test]
    fn regions_move_between_versions() {
        let cropped = crop(0.5, 0.0, 0.5, 1.0);
        let region = Region {
            x: 0.5,
            y: 0.25,
            width: 0.25,
            height: 0.5,
        };
        let mapped = map(None, Some(&cropped), vec![region]).unwrap();
        assert_eq!(mapped.len(), 1);
        let mapped = mapped[0].region.unwrap();
        assert!(
            (mapped.x - 0.0).abs() < 1e-6 && (mapped.width - 0.5).abs() < 1e-6,
            "{mapped:?}"
        );
    }

    #[tokio::test]
    async fn a_follow_job_queues_what_the_current_version_needs() {
        let db = testpg::database().await;
        upgrade(&db.pool, &Upgrade::new(&embedded())).await.unwrap();
        sqlx::raw_sql(
            "INSERT INTO users (id, handle, display_name) VALUES (md5('u')::uuid, 'u', 'U');
             INSERT INTO libraries (id, owner_id, name, kind, root_uri)
             VALUES (md5('l')::uuid, md5('u')::uuid, 'L', 'managed', 'l');
             INSERT INTO assets (id, library_id, owner_id, source, media_kind)
             VALUES (md5('a')::uuid, md5('l')::uuid, md5('u')::uuid, 'upload', 'image');
             INSERT INTO versions (id, asset_id, kind, recipe) VALUES (md5('v')::uuid, md5('a')::uuid, 'edit', '\\x');
             UPDATE assets SET current_version_id = md5('v')::uuid;
             INSERT INTO jobs (id, type, payload, status, placement, idempotency_key)
             VALUES (photolib_uuidv7(), 'follow',
                     convert_to(json_build_object('asset', md5('a')::uuid)::text, 'UTF8'),
                     'queued', 'server', 'follow:a');",
        )
        .execute(&db.pool)
        .await
        .unwrap();
        let profile = Profile {
            renditions: vec![Rendition {
                kind: "image".into(),
                role: "thumb_s".into(),
                spec_id: "s".into(),
                only_for: None,
            }],
            export: Some(EXPORT_SPEC.into()),
            ..Profile::default()
        };
        let timing = Timing {
            poll_min: Duration::from_millis(10),
            poll_max: Duration::from_millis(50),
            ..Timing::default()
        };
        let shutdown = tokio_util::sync::CancellationToken::new();
        let worker = Worker::new(db.pool.clone(), "t", 1, timing).handle(FOLLOW, Follow(profile));
        let running = tokio::spawn(worker.run(shutdown.clone()));
        let started = photolib_spawn::Running::start();
        loop {
            let queued: Vec<String> = sqlx::query_scalar("SELECT type FROM jobs WHERE type <> 'follow' ORDER BY type")
                .fetch_all(&db.pool)
                .await
                .unwrap();
            if queued == ["export", "render"] {
                break;
            }
            assert!(started.elapsed() < Duration::from_secs(10), "{queued:?}");
            tokio::time::sleep(Duration::from_millis(20)).await;
        }
        shutdown.cancel();
        running.await.unwrap();
    }
}
