//! Image renditions (photolib-design docs/08 §4, ADR-0084): the render specs, the profile the reconciler compares
//! every image with, and the `render` job, which makes all of an image's missing renditions from one decode in the
//! sandbox and replaces those of older specs in the job's transaction.

use std::{
    path::{Path, PathBuf},
    sync::{
        Arc, Mutex,
        atomic::{AtomicUsize, Ordering},
    },
};

use async_trait::async_trait;
use photolib_jobs::{
    Handler, Job,
    reconcile::{Profile, Rendition},
};
use photolib_media::{
    Worker,
    render::{Format, Output, Request},
};
use photolib_storage::{Hash, journal::Journal};
use serde::Serialize;
use serde_json::{Value, json};
use sqlx::{PgConnection, Row};
use uuid::Uuid;

use crate::{
    external::{self, Libraries},
    ingest::{Locals, local, local_path},
};

/// The job type.
pub const RENDER: &str = "render";
/// Renditions live in the data directory (ADR-0022: `derived: local`).
const STORE: &str = "local";

/// How a rendition is made (docs/08 §4.3); any change makes it another spec, with another id.
#[derive(Clone, Debug, Serialize)]
pub struct Spec {
    pub role: &'static str,
    pub generator: &'static str,
    /// Bumped whenever the output bytes would change.
    pub generator_version: u32,
    pub format: Format,
    /// The short side, 0 when only `long` bounds it.
    pub short: u32,
    pub long: u32,
    /// The long side for a photo sphere (docs/08 §7), when it is larger.
    pub sphere_long: u32,
    pub quality: u8,
    /// Keeps a wide-gamut source as Display P3.
    pub wide: bool,
}

impl Spec {
    /// 16 bytes of the BLAKE3 hash of the spec's JSON, in hex.
    pub fn id(&self) -> String {
        let json = serde_json::to_vec(self).expect("a spec serialises");
        blake3::hash(&json).to_hex()[..32].to_string()
    }
}

/// The built-in rendition set (docs/08 §4.1).
pub fn specs() -> Vec<Spec> {
    let spec = |role, format, short, long, sphere_long, quality, wide| Spec {
        role,
        generator: "vips",
        // 2: PQ and HLG stills are tone-mapped and previews keep gain maps (ADR-0390), so every image renders again.
        generator_version: 2,
        format,
        short,
        long,
        sphere_long,
        quality,
        wide,
    };
    vec![
        spec("thumb_s", Format::Webp, 256, 1024, 0, 70, false),
        spec("thumb_m", Format::Webp, 720, 2048, 0, 75, false),
        spec("preview", Format::Jpeg, 0, 2160, 8192, 85, true),
    ]
}

/// The renditions the reconciler wants of every image.
pub fn profile(specs: &[Spec]) -> Profile {
    let rendition = |spec: &Spec| Rendition {
        kind: "image".into(),
        role: spec.role.into(),
        spec_id: spec.id(),
    };
    Profile {
        renditions: specs.iter().map(rendition).collect(),
        models: vec![],
        ocr: vec![],
        export: None,
    }
}

/// The `render` job's handler, on a `worker:cpu` role: one sandboxed renderer per job running at once.
pub struct Render {
    journal: Arc<Journal>,
    specs: Vec<Spec>,
    photolibd: PathBuf,
    /// Where the api role stages uploads, and where copies from object stores and the renderers' files go.
    dirs: (PathBuf, PathBuf),
    libraries: Arc<Libraries>,
    idle: Mutex<Vec<(Worker, PathBuf)>>,
    made: AtomicUsize,
}

impl Render {
    pub fn new(
        journal: Arc<Journal>,
        work_dir: &Path,
        photolibd: PathBuf,
        specs: Vec<Spec>,
        libraries: Arc<Libraries>,
    ) -> std::io::Result<Render> {
        let scratch = work_dir.join("render");
        std::fs::create_dir_all(&scratch)?;
        Ok(Render {
            journal,
            specs,
            photolibd,
            dirs: (work_dir.join("uploads"), scratch),
            libraries,
            idle: Mutex::default(),
            made: AtomicUsize::new(0),
        })
    }

    /// The journal the renditions are put through.
    pub(crate) fn journal(&self) -> Arc<Journal> {
        self.journal.clone()
    }

    /// A renderer and its directory, with `in` (read) and `out` (write) below it.
    fn renderer(&self) -> std::io::Result<(Worker, PathBuf)> {
        if let Some(idle) = self.idle.lock().expect("no panics holding the renderers").pop() {
            return Ok(idle);
        }
        let n = self.made.fetch_add(1, Ordering::Relaxed);
        let dir = self.dirs.1.join(format!("renderer-{n}"));
        for sub in ["in", "out"] {
            std::fs::create_dir_all(dir.join(sub))?;
        }
        let worker = Worker::renderer(self.photolibd.clone(), dir.join("in"), dir.join("out"));
        Ok((worker, dir))
    }
}

/// A renderer on loan to a job, which derefs to its directory (`out` holds what it rendered). It rejoins the pool of
/// idle renderers when dropped.
pub(crate) struct Lease<'a> {
    idle: &'a Mutex<Vec<(Worker, PathBuf)>>,
    renderer: Option<(Worker, PathBuf)>,
}

impl std::ops::Deref for Lease<'_> {
    type Target = Path;

    fn deref(&self) -> &Path {
        self.renderer.as_ref().map_or_else(|| Path::new(""), |(_, dir)| dir)
    }
}

impl Drop for Lease<'_> {
    fn drop(&mut self) {
        if let Some(renderer) = self.renderer.take() {
            // A poisoned pool is still a pool of renderers.
            self.idle
                .lock()
                .unwrap_or_else(std::sync::PoisonError::into_inner)
                .push(renderer);
        }
    }
}

#[async_trait]
impl Handler for Render {
    async fn run(&self, job: &Job, tx: &mut PgConnection) -> Result<(), String> {
        self.render(job, tx).await.map_err(|error| error.to_string())
    }

    async fn committed(&self, _job: &Job) {
        if let Err(error) = self.journal.finish_switched().await {
            tracing::warn!(%error, "replaced renditions stay until recovery deletes them");
        }
    }
}

type Fallible<T> = Result<T, Box<dyn std::error::Error + Send + Sync>>;

impl Render {
    /// The scratch directory the sandboxed renderers and FFmpeg write in.
    pub(crate) fn scratch(&self) -> &Path {
        &self.dirs.1
    }

    /// The original of `row` (a row of [`ORIGINAL`]) as a file this process may read, which goes with the returned
    /// guard: of a video, for FFmpeg's sandbox to read.
    pub(crate) async fn staged(&self, tx: &mut PgConnection, row: &sqlx::postgres::PgRow) -> Fallible<Locals> {
        let (store, key, size): (String, String, i64) = (row.get("storage"), row.get("key"), row.get("size"));
        let source: Option<Vec<u8>> = row.get("content_hash");
        let (library, dirs) = (row.get("library_id"), (&*self.dirs.0, &*self.dirs.1));
        Ok(Locals(vec![match store.as_str() {
            external::STORE => self.libraries.copy(tx, library, &key, size, dirs.1).await?,
            _ => {
                let hash = source.as_deref().unwrap_or_default();
                local(&self.journal, dirs, &store, &key, hash, size).await?
            }
        }]))
    }

    /// Renders the original of `row` (a row of [`ORIGINAL`]) in a sandboxed child, as `outputs` says for a photo
    /// sphere or not, and returns what it wrote, into `out` of the directory. The picture is that of the current
    /// version.
    pub(crate) async fn sandboxed(
        &self,
        tx: &mut PgConnection,
        row: &sqlx::postgres::PgRow,
        outputs: impl FnOnce(bool) -> Vec<Output>,
    ) -> Fallible<(photolib_media::render::Rendered, Lease<'_>)> {
        self.sandboxed_as(tx, row, true, outputs).await
    }

    /// [`Self::sandboxed`], with the current version's edit applied only if `edited`.
    pub(crate) async fn sandboxed_as(
        &self,
        tx: &mut PgConnection,
        row: &sqlx::postgres::PgRow,
        edited: bool,
        outputs: impl FnOnce(bool) -> Vec<Output>,
    ) -> Fallible<(photolib_media::render::Rendered, Lease<'_>)> {
        let original = self.staged(tx, row).await?;
        let sphere = row.get::<Vec<String>, _>("facets").iter().any(|f| f == "sphere_360");
        let mime: String = row.get("mime");
        let (mut worker, dir) = self.renderer()?;
        let input = dir.join("in").join(Uuid::now_v7().to_string());
        let path = local_path(&original.0[0]);
        std::fs::hard_link(&path, &input).or_else(|_| std::fs::copy(&path, &input).map(drop))?;
        // The current version's recipe, in a file beside the original, which the child reads (ADR-0391).
        let recipe: Option<Vec<u8>> = row.get("recipe");
        let edit = match recipe.filter(|_| edited) {
            Some(bytes) => {
                let file = dir.join("in").join(format!("{}.recipe", Uuid::now_v7()));
                std::fs::write(&file, bytes)?;
                Some(file)
            }
            None => None,
        };
        let request = Request {
            input: input.clone(),
            // A RAW's embedded preview takes the RAW's orientation.
            orientation: (mime.starts_with("image/x-"))
                .then(|| row.get::<Option<i16>, _>("orientation").unwrap_or(1) as u8),
            mime,
            edit,
            outputs: outputs(sphere),
        };
        let rendered = worker.render(&request).await;
        let _ = std::fs::remove_file(&input);
        if let Some(edit) = &request.edit {
            drop(std::fs::remove_file(edit));
        }
        // The renderer's `out` directory holds this job's files until the caller has read them: it goes back to the
        // pool when the lease is dropped, never before, or another job's output would replace them.
        let lease = Lease {
            idle: &self.idle,
            renderer: Some((worker, dir)),
        };
        Ok((rendered.map_err(|failure| format!("{failure:?}"))?, lease))
    }

    async fn render(&self, job: &Job, tx: &mut PgConnection) -> Fallible<()> {
        let payload: Value = serde_json::from_slice(&job.payload)?;
        let asset: Uuid = serde_json::from_value(payload["asset"].clone())?;
        // The jobs of one asset take turns: the first makes every missing rendition, the others find them made.
        sqlx::query("SELECT pg_advisory_xact_lock(hashtextextended($1::text, 0))")
            .bind(asset)
            .execute(&mut *tx)
            .await?;
        let Some(row) = sqlx::query(ORIGINAL).bind(asset).fetch_optional(&mut *tx).await? else {
            return Ok(());
        };
        let present: Vec<String> = row.get("specs");
        let missing: Vec<&Spec> = self.specs.iter().filter(|s| !present.contains(&s.id())).collect();
        if missing.is_empty() {
            return Ok(());
        }
        let source: Option<Vec<u8>> = row.get("content_hash");
        let library: Uuid = row.get("library_id");
        let (rendered, dir) = self
            .sandboxed(tx, &row, |sphere| {
                (missing.iter())
                    .map(|spec| Output {
                        file: spec.id(),
                        format: spec.format,
                        short: spec.short,
                        long: if sphere {
                            spec.long.max(spec.sphere_long)
                        } else {
                            spec.long
                        },
                        quality: spec.quality,
                        wide: spec.wide,
                    })
                    .collect()
            })
            .await?;
        let source = (source.as_deref().map(<[u8; 32]>::try_from).transpose()?).map(|h| Hash(h).to_string());
        let mut made = vec![];
        for (spec, &(format, width, height)) in missing.iter().zip(&rendered.outputs) {
            let file = dir.join("out").join(spec.id());
            let bytes = std::fs::read(&file)?;
            let (mime, ext) = match format {
                Format::Webp if bytes.starts_with(b"RIFF") && bytes.get(8..12) == Some(b"WEBP") => {
                    ("image/webp", "webp")
                }
                Format::Jpeg if bytes.starts_with(&[0xff, 0xd8, 0xff]) => ("image/jpeg", "jpg"),
                _ => {
                    return Err(format!("the renderer wrote no {format:?} for {}", spec.role).into());
                }
            };
            let id = Uuid::now_v7();
            // Spread over 256 directories by the random end of the asset's id.
            let key = format!(
                "derived/{library}/{}/{asset}/{id}.{ext}",
                &asset.simple().to_string()[30..]
            );
            let hash = Hash::of(&bytes);
            self.journal.put(STORE, &key, &file, hash).await?.switch(tx).await?;
            let _ = std::fs::remove_file(&file);
            let made_from = json!({"spec_id": spec.id(), "generator": spec.generator,
                "generator_version": spec.generator_version, "width": width, "height": height,
                "source_hash": source,
                "version_id": row.get::<Option<Uuid>, _>("current_version_id")});
            sqlx::query(
                "INSERT INTO asset_files (id, asset_id, role, storage, key, mime, size, content_hash, render_spec)
                 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)",
            )
            .bind(id)
            .bind(asset)
            .bind(spec.role)
            .bind(STORE)
            .bind(key)
            .bind(mime)
            .bind(bytes.len() as i64)
            .bind(hash.0.to_vec())
            .bind(made_from)
            .execute(&mut *tx)
            .await?;
            made.push((id, spec.role));
        }
        // The renditions these replace are deleted once the job commits (`committed`).
        let replaced: Vec<(String, String)> = sqlx::query_as(
            "DELETE FROM asset_files WHERE asset_id = $1 AND role = ANY($2) AND render_spec IS NOT NULL
               AND id <> ALL($3) RETURNING storage, key",
        )
        .bind(asset)
        .bind(made.iter().map(|f| f.1).collect::<Vec<_>>())
        .bind(made.iter().map(|f| f.0).collect::<Vec<_>>())
        .fetch_all(&mut *tx)
        .await?;
        for (store, key) in replaced {
            self.journal.delete(&store, &key).await?.switch(tx).await?;
        }
        sqlx::query("UPDATE assets SET thumbhash = $2 WHERE id = $1")
            .bind(asset)
            .bind(&rendered.thumbhash)
            .execute(&mut *tx)
            .await?;
        Ok(())
    }
}

/// An image's original and the ids of the specs of its present renditions.
pub(crate) const ORIGINAL: &str = "
SELECT a.library_id, a.facets, a.orientation, a.current_version_id, v.recipe, f.storage, f.key, f.content_hash,
    f.size, coalesce(f.mime, '') AS mime,
    array(SELECT r.render_spec ->> 'spec_id' FROM asset_files r
          WHERE r.asset_id = a.id AND r.state = 'present' AND r.render_spec IS NOT NULL
            AND r.render_spec ->> 'version_id' IS NOT DISTINCT FROM a.current_version_id::text) AS specs
FROM assets a LEFT JOIN versions v ON v.id = a.current_version_id AND v.kind = 'edit'
JOIN asset_files f ON f.asset_id = a.id AND f.role = 'original' AND f.byte_offset IS NULL
WHERE a.id = $1 AND a.media_kind = 'image'";
