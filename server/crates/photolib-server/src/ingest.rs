//! The ingest pipeline (photolib-design docs/08 §3.2, ADR-0066): complete uploads become assets. A worker identifies
//! each file by its magic bytes, reads its metadata and capture time with the kernel as clients do, dumps it with
//! ExifTool in the sandbox, groups Live Photos and RAW+JPEG pairs, and commits the assets, their files and first
//! versions in the job's transaction, with the derivatives they need queued in it. Everything a file says is data.
//! Files a scan finds in an external library (ADR-0093) go the same way, read in place and hashed later, with what
//! their XMP sidecars say (ADR-0259).

mod commit;
pub mod extract;
pub mod group;
pub mod sniff;

use std::{
    collections::HashMap,
    fs::File,
    os::unix::fs::FileExt,
    path::{Path, PathBuf},
    sync::{
        Arc, Mutex,
        atomic::{AtomicUsize, Ordering},
    },
    time::{Duration, SystemTime},
};

use async_trait::async_trait;
use photolib_jobs::{
    Handler, Job, NewJob,
    reconcile::{self, Profile},
};
use photolib_kernel::proto::kernel::v1::ReadMetadataResponse;
use photolib_media::ExifTool;
use photolib_storage::{Hash, Local, journal::Journal};
use serde_json::{Value, json};
use sqlx::{PgConnection, Row};
use uuid::Uuid;

use crate::{
    external::{self, Batch, HASH, Libraries},
    library,
};
use extract::{Extraction, extract, named};
use group::{Part, Role, group};
use photolib_storage::fs::Identity;
use sniff::{Media, sniff};

/// The job type.
pub const INGEST: &str = "ingest";
/// The sweep that checks again, with this release's type detection, the assets an older one found no photo or video
/// in (ADR-0066).
pub const RETYPE: &str = "retype";
/// The assets a `retype` job reads; the next job goes on after the last.
const RETYPE_BATCH: u8 = if cfg!(test) { 1 } else { 100 };

/// Queues the ingest of complete uploads, which become assets together, in the caller's transaction.
pub async fn enqueue(conn: &mut PgConnection, uploads: &[Uuid]) -> sqlx::Result<Uuid> {
    let payload = json!({ "uploads": uploads }).to_string();
    let key = format!("{INGEST}:{}", uploads[0]);
    let job = NewJob {
        key: Some(&key),
        ..NewJob::new(INGEST, payload.as_bytes())
    };
    photolib_jobs::enqueue(conn, &job).await
}

/// A file as ingest reads it: a complete upload, or a file a scan found in an external library.
struct Source {
    /// The upload's.
    id: Uuid,
    owner: Uuid,
    library: Uuid,
    length: i64,
    /// Scanned files are hashed later.
    hash: Option<Vec<u8>>,
    store: String,
    key: String,
    path: Option<String>,
    /// `upload` or `scan`.
    source: &'static str,
}

/// An XMP sidecar a scan found beside photos or videos: `IMG_1234.jpg.xmp` or `IMG_1234.xmp` (ADR-0259).
struct Sidecar {
    name: String,
    key: String,
    length: i64,
    metadata: ReadMetadataResponse,
    /// The source it belongs to: the first it names, so that it is one asset's.
    of: Option<usize>,
}

impl Sidecar {
    /// What a sidecar's name names, when it is one: the name of a file, or of a file without its extension.
    fn names(name: &str) -> Option<&str> {
        let (base, extension) = name.rsplit_once('.')?;
        (extension.eq_ignore_ascii_case("xmp") && !base.is_empty()).then_some(base)
    }
}

/// What a file is and says.
struct Read {
    media: Media,
    extraction: Extraction,
    motion: Option<Motion>,
}

/// A motion photo's video: a range of the original.
struct Motion {
    offset: u64,
    length: u64,
    hash: Hash,
    mime: &'static str,
}

/// The `ingest` job's handler, on a `worker:cpu` role.
pub struct Ingest {
    journal: Arc<Journal>,
    /// Where the api role stages uploads: a staged copy is read while it exists, never downloaded back.
    staging: PathBuf,
    /// Copies of originals from object stores, and a directory per ExifTool process.
    scratch: PathBuf,
    exiftool: Option<ExifTools>,
    profile: Profile,
    libraries: Arc<Libraries>,
}

impl Ingest {
    /// What the reconciler queues for the assets this ingests.
    pub(crate) fn profile(&self) -> &Profile {
        &self.profile
    }

    /// `exiftool` starts ExifTool (its path, or an interpreter and the script); empty, no dump is kept.
    pub fn new(
        journal: Arc<Journal>,
        work_dir: &Path,
        photolibd: PathBuf,
        exiftool: Vec<PathBuf>,
        profile: Profile,
        libraries: Arc<Libraries>,
    ) -> std::io::Result<Ingest> {
        let scratch = work_dir.join("ingest");
        std::fs::create_dir_all(&scratch)?;
        Ok(Ingest {
            journal,
            staging: work_dir.join("uploads"),
            exiftool: (!exiftool.is_empty()).then(|| ExifTools {
                photolibd,
                command: exiftool,
                scratch: scratch.clone(),
                idle: Mutex::default(),
                made: AtomicUsize::new(0),
            }),
            scratch,
            profile,
            libraries,
        })
    }

    /// Copies the files of asset `id` to where its library's template puts them in its library's store, and records
    /// them there; their uploads are deleted by the next purge.
    async fn place(&self, tx: &mut PgConnection, id: Uuid, files: &[(&Source, &Read, Role)]) -> Result<(), String> {
        let library = files[0].0.library;
        let (store, template) = library::target(tx, library).await?;
        let asset = library::asset(tx, id).await.map_err(|e| e.to_string())?;
        let mut placed = vec![];
        let recorded = async {
            for (upload, _, _) in files {
                let name = (upload.path.as_deref().and_then(|path| path.rsplit('/').next()))
                    .map_or_else(|| upload.id.to_string(), str::to_owned);
                let base = library::base(library, &template, &asset, &name);
                let (from, hash) = ((upload.store.as_str(), upload.key.as_str()), upload.blake3()?);
                let place = library::place(&self.journal, from, &store, &base, hash, &self.scratch).await;
                placed.push(place.map_err(|e| e.to_string())?);
            }
            let keys: Vec<String> = placed.iter().map(|(key, _)| key.clone()).collect();
            (commit::files(tx, id, files, &store, &keys).await).map_err(|e| e.to_string())
        }
        .await;
        if let Err(error) = recorded {
            for (_, op) in placed {
                let _ = op.abandon().await;
            }
            return Err(error);
        }
        for ((_, op), (upload, _, _)) in placed.iter().zip(files) {
            op.switch(tx).await.map_err(|e| e.to_string())?;
            (self
                .journal
                .delete_after(tx, &upload.store, &upload.key, Duration::ZERO))
            .await
            .map_err(|e| e.to_string())?;
        }
        Ok(())
    }
}

impl Source {
    fn blake3(&self) -> Result<Hash, String> {
        let hash = self.hash.clone().unwrap_or_default().try_into();
        Ok(Hash(hash.map_err(|_| "a malformed hash")?))
    }
}

/// A stored file as a job reads it: the staged copy of its upload while there is one (`dirs.0`, never downloaded
/// back), else the store's file or a verified copy in `dirs.1`.
pub(crate) async fn local(
    journal: &Journal,
    (staging, scratch): (&Path, &Path),
    store: &str,
    key: &str,
    hash: &[u8],
    length: i64,
) -> Result<Local, String> {
    let staged = staging.join(key.rsplit('/').next().unwrap_or_default());
    if key.contains("/uploads/") && std::fs::metadata(&staged).is_ok_and(|m| m.len() == length as u64) {
        return Ok(Local::InPlace(staged));
    }
    let hash = Hash(hash.try_into().map_err(|_| "a malformed hash")?);
    (journal.local(store, key, hash, scratch).await).map_err(|e| e.to_string())
}

impl Ingest {
    /// Complete uploads of standard libraries, with ExifTool's dump of each original; their upload rows go.
    async fn uploads(&self, job: &Job, tx: &mut PgConnection, now: i64) -> Result<Vec<Uuid>, String> {
        let ids: Vec<Uuid> = serde_json::from_slice::<Value>(&job.payload)
            .ok()
            .and_then(|p| serde_json::from_value(p["uploads"].clone()).ok())
            .ok_or("a malformed payload")?;
        let uploads = complete(tx, &ids).await.map_err(|e| e.to_string())?;
        let mut reads = vec![];
        let mut locals = Locals(vec![]);
        for upload in &uploads {
            let dirs = (self.staging.as_path(), self.scratch.as_path());
            let (store, key) = (&upload.store, &upload.key);
            let hash = upload.hash.as_deref().unwrap_or_default();
            let local = local(&self.journal, dirs, store, key, hash, upload.length).await?;
            let name = upload.path.clone().unwrap_or_default();
            reads.push(read_at(local_path(&local), upload.length as u64, name, now).await?);
            locals.0.push(local);
            job.progress(reads.len() as f32 / uploads.len() as f32);
        }
        let assets = self.commit(tx, &uploads, &reads, Some(&locals), &[]).await?;
        // The vector a device handed off with one of an asset's files; one the asset has already stays.
        let (mut asset_of, mut upload) = (vec![], vec![]);
        for (asset, files) in &assets {
            for source in files.iter().filter_map(|i| uploads.get(*i)) {
                asset_of.push(*asset);
                upload.push(source.id);
            }
        }
        sqlx::query(
            "INSERT INTO asset_embeddings (asset_id, model_id, embedding)
             SELECT DISTINCT ON (a.asset) a.asset, u.embedding_model, u.embedding
             FROM unnest($1::uuid[], $2::uuid[]) AS a (asset, upload) JOIN uploads u ON u.id = a.upload
             WHERE u.embedding IS NOT NULL ORDER BY a.asset, u.id ON CONFLICT DO NOTHING",
        )
        .bind(asset_of)
        .bind(upload)
        .execute(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;
        sqlx::query("DELETE FROM uploads WHERE id = ANY($1)")
            .bind(uploads.iter().map(|u| u.id).collect::<Vec<_>>())
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        Ok(assets.into_iter().map(|(asset, _)| asset).collect())
    }

    /// The pending files of a folder of an external library, read in place: media become assets, other files are
    /// recorded as unsupported and those that cannot be read as failed. Their `hash` job follows.
    async fn scanned(&self, job: &Job, tx: &mut PgConnection, batch: Batch, now: i64) -> Result<Vec<Uuid>, String> {
        let Some(library) = self.libraries.open(tx, batch.library).await? else {
            return Ok(vec![]);
        };
        let names: Vec<String> = sqlx::query_scalar(
            "SELECT name FROM library_files WHERE library_id = $1 AND dir = $2 AND name = ANY($3)
               AND state = 'pending' ORDER BY name FOR UPDATE",
        )
        .bind(batch.library)
        .bind(&batch.dir)
        .bind(&batch.names)
        .fetch_all(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;
        let (mut sources, mut reads, mut outcomes, mut sidecars) = (vec![], vec![], vec![], vec![]);
        for name in &names {
            library.limits.files.take(1).await;
            let path = external::join(&batch.dir, name);
            let (key, xmp) = (path.clone(), Sidecar::names(name).is_some());
            let read = (library.store).with_file(&path, move |file, id| {
                let read = read(file, id.size, &key, now);
                let sidecar = (read.as_ref()).is_ok_and(|read| xmp && !read.media.supported());
                (id, read, sidecar.then(|| extract::sidecar(file, id.size)))
            });
            let (identity, read) = match read.await {
                Err(error @ photolib_storage::Error::Timeout(_)) => return Err(error.to_string()),
                Err(error) => (None, Err(error.to_string())),
                Ok((identity, read, Some(Err(error)))) => (Some(identity), read.and(Err(error))),
                Ok((identity, read, sidecar)) => {
                    if let Some(Ok(Some(metadata))) = sidecar {
                        let length = i64::try_from(identity.size).unwrap_or(i64::MAX);
                        let (name, key) = (name.clone(), path.clone());
                        sidecars.push(Sidecar {
                            name,
                            key,
                            length,
                            metadata,
                            of: None,
                        });
                    }
                    (Some(identity), read)
                }
            };
            // The source's index once it is media, else nothing; or why it cannot be read.
            let outcome = read.map(|read| {
                read.media.supported().then(|| {
                    sources.push(Source {
                        id: Uuid::nil(),
                        owner: library.owner,
                        library: batch.library,
                        length: identity.map_or(0, |id| id.size as i64),
                        hash: None,
                        store: external::STORE.into(),
                        key: path.clone(),
                        path: Some(path),
                        source: "scan",
                    });
                    reads.push(read);
                    sources.len() - 1
                })
            });
            outcomes.push((name, identity, outcome));
            job.progress(outcomes.len() as f32 / names.len() as f32);
        }
        for (n, source) in sources.iter().enumerate() {
            let name = source.key.rsplit('/').next().unwrap_or_default();
            let stem = name.rsplit_once('.').map(|(stem, _)| stem);
            for sidecar in sidecars.iter_mut().filter(|s| s.of.is_none()) {
                let base = Sidecar::names(&sidecar.name);
                if base == Some(name) || base.is_some() && base == stem {
                    sidecar.of = Some(n);
                }
            }
        }
        let assets = self.commit(tx, &sources, &reads, None, &sidecars).await?;
        let mut asset_of = vec![None; sources.len()];
        for (asset, files) in &assets {
            for &file in files {
                asset_of[file] = Some(*asset);
            }
        }
        let sidecar_of: HashMap<&str, Uuid> = (sidecars.iter())
            .filter_map(|s| Some((s.name.as_str(), (*asset_of.get(s.of?)?)?)))
            .collect();
        let mut hashed = vec![];
        for (name, identity, outcome) in outcomes {
            let (state, asset, error) = match outcome {
                Ok(Some(source)) => {
                    hashed.push(name.clone());
                    ("ingested", asset_of[source], None)
                }
                Ok(None) => match sidecar_of.get(name.as_str()) {
                    Some(&asset) => {
                        hashed.push(name.clone());
                        ("ingested", Some(asset), None)
                    }
                    None => ("unsupported", None, None),
                },
                Err(error) => ("failed", None, Some(error)),
            };
            let field = |f: fn(Identity) -> i64| identity.map(f);
            sqlx::query(
                "UPDATE library_files SET state = $4, asset_id = $5, error = $6, dev = coalesce($7, dev),
                   inode = coalesce($8, inode), size = coalesce($9, size), mtime_ns = coalesce($10, mtime_ns)
                 WHERE library_id = $1 AND dir = $2 AND name = $3",
            )
            .bind(batch.library)
            .bind(&batch.dir)
            .bind(name)
            .bind(state)
            .bind(asset)
            .bind(error)
            .bind(field(|i| i.dev as i64))
            .bind(field(|i| i.inode as i64))
            .bind(field(|i| i.size as i64))
            .bind(field(|i| i.mtime_ns))
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        }
        if !hashed.is_empty() {
            let batch = Batch { names: hashed, ..batch };
            external::enqueue(tx, HASH, &batch, false)
                .await
                .map_err(|e| e.to_string())?;
        }
        Ok(assets.into_iter().map(|(asset, _)| asset).collect())
    }

    /// Groups the files and commits an asset of each group with the sidecars of its files, and ExifTool's dump of its
    /// original when `locals` holds the files; returns each asset with its files.
    async fn commit(
        &self,
        tx: &mut PgConnection,
        sources: &[Source],
        reads: &[Read],
        locals: Option<&Locals>,
        sidecars: &[Sidecar],
    ) -> Result<Vec<(Uuid, Vec<usize>)>, String> {
        let parts: Vec<_> = (sources.iter().zip(reads))
            .map(|(source, read)| Part {
                path: source.path.as_deref().unwrap_or_default(),
                media: read.media,
                extraction: &read.extraction,
            })
            .collect();
        let mut assets = vec![];
        for files in group(&parts)? {
            let original = files[0].0;
            let dump = match (&self.exiftool, locals.and_then(|locals| locals.0.get(original))) {
                (Some(exiftool), Some(local)) if reads.get(original).is_some_and(|read| read.media.supported()) => {
                    exiftool.dump(local_path(local)).await
                }
                _ => None,
            };
            let indexes: Vec<usize> = files.iter().map(|f| f.0).collect();
            // The newer metadata wins, and of two as new, the sidecar of the file over the one of its name's stem.
            let mut theirs: Vec<&Sidecar> = (sidecars.iter())
                .filter(|s| s.of.is_some_and(|i| indexes.contains(&i)))
                .collect();
            theirs.sort_by_cached_key(|s| {
                let date = s.metadata.times.iter().find(|t| t.source == "xmp-xmp:MetadataDate");
                (date.map(|t| t.local_datetime.clone()), s.name.matches('.').count())
            });
            let said: Vec<_> = theirs.iter().map(|s| &s.metadata).collect();
            let files: Vec<_> = (files.into_iter())
                .map(|(i, role)| (&sources[i], &reads[i], role))
                .collect();
            let asset = commit::asset(tx, &files, &said, dump, None).await;
            let asset = asset.map_err(|e| e.to_string())?;
            if files[0].0.store == external::STORE {
                let keys: Vec<String> = files.iter().map(|f| f.0.key.clone()).collect();
                let recorded = commit::files(tx, asset, &files, external::STORE, &keys).await;
                recorded.map_err(|e| e.to_string())?;
                (commit::sidecars(tx, asset, &theirs).await).map_err(|e| e.to_string())?;
            } else {
                self.place(tx, asset, &files).await?;
            }
            assets.push((asset, indexes));
        }
        Ok(assets)
    }
}

#[async_trait]
impl Handler for Ingest {
    async fn run(&self, job: &Job, tx: &mut PgConnection) -> Result<(), String> {
        let assets = match serde_json::from_slice::<Batch>(&job.payload) {
            Ok(batch) => self.scanned(job, tx, batch, now()).await?,
            Err(_) => self.uploads(job, tx, now()).await?,
        };
        reconcile::assets(tx, &self.profile, &assets)
            .await
            .map_err(|e| e.to_string())?;
        Ok(())
    }
}

/// Queues this release's `retype` sweep, once per version of type detection: the scheduler does at its start.
pub async fn sweep(pool: &sqlx::PgPool) -> sqlx::Result<()> {
    let key = format!("{RETYPE}:{}", sniff::VERSION);
    let job = NewJob {
        key: Some(&key),
        ..NewJob::new(RETYPE, b"{}")
    };
    photolib_jobs::enqueue(&mut *pool.acquire().await?, &job)
        .await
        .map(drop)
}

/// The `retype` job's handler, on a `worker:cpu` role: checks again a batch of standard libraries' assets that an
/// older type detection found no photo or video in, renders those that are one now through the reconciler and queues
/// the next batch. The first queues the ingest of external libraries' unsupported files again.
pub struct Retype(pub Arc<Ingest>);

#[async_trait]
impl Handler for Retype {
    async fn run(&self, job: &Job, tx: &mut PgConnection) -> Result<(), String> {
        let after = serde_json::from_slice::<Value>(&job.payload)
            .ok()
            .and_then(|payload| payload.get("after")?.as_str()?.parse().ok());
        if after.is_none() {
            external::retype(tx).await.map_err(|e| e.to_string())?;
        }
        let rows = sqlx::query(
            "SELECT a.id, a.owner_id, a.library_id, a.source_ref, f.size, f.content_hash, f.storage, f.key
             FROM assets a JOIN libraries l ON l.id = a.library_id AND l.privacy = 'standard'
             JOIN asset_files f ON f.asset_id = a.id AND f.role = 'original' AND f.state = 'present'
             WHERE a.id > $1 AND a.media_kind IS NULL AND coalesce(a.sniff_version, 0) < $2
               AND f.storage <> $3 AND f.size IS NOT NULL
             ORDER BY a.id LIMIT $4 FOR UPDATE OF a SKIP LOCKED",
        )
        .bind(after.unwrap_or_else(Uuid::nil))
        .bind(sniff::VERSION)
        .bind(external::STORE)
        .bind(i16::from(RETYPE_BATCH))
        .fetch_all(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;
        let mut retyped = vec![];
        for row in &rows {
            let source = Source {
                id: row.get("id"),
                owner: row.get("owner_id"),
                library: row.get("library_id"),
                length: row.get("size"),
                hash: row.get("content_hash"),
                store: row.get("storage"),
                key: row.get("key"),
                path: row.get("source_ref"),
                // Only a new asset takes its source from here.
                source: "upload",
            };
            if self.0.retype(tx, &source).await? {
                retyped.push(source.id);
            }
        }
        (reconcile::assets(tx, &self.0.profile, &retyped).await).map_err(|e| e.to_string())?;
        if let Some(last) = rows.last().filter(|_| rows.len() == usize::from(RETYPE_BATCH)) {
            let last: Uuid = last.get("id");
            let key = format!("{RETYPE}:{}:{last}", sniff::VERSION);
            let payload = json!({ "after": last }).to_string();
            let next = NewJob {
                key: Some(&key),
                ..NewJob::new(RETYPE, payload.as_bytes())
            };
            photolib_jobs::enqueue(tx, &next).await.map_err(|e| e.to_string())?;
        }
        Ok(())
    }
}

impl Ingest {
    /// Reads `source`, the original of an asset without a media kind, again and gives the asset what ingest now would:
    /// a photo or video its metadata, any other file its name's capture time. Returns whether it is media.
    async fn retype(&self, tx: &mut PgConnection, source: &Source) -> Result<bool, String> {
        let dirs = (self.staging.as_path(), self.scratch.as_path());
        let hash = source.hash.as_deref().unwrap_or_default();
        let local = local(&self.journal, dirs, &source.store, &source.key, hash, source.length).await?;
        let path = local_path(&local);
        let _copy = Locals(vec![local]);
        let size = u64::try_from(source.length).map_err(|e| e.to_string())?;
        let read = read_at(path.clone(), size, source.path.clone().unwrap_or_default(), now()).await?;
        sqlx::query("UPDATE asset_files SET mime = $2 WHERE asset_id = $1 AND role = 'original'")
            .bind(source.id)
            .bind(read.media.mime)
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        let dump = match &self.exiftool {
            Some(exiftool) if read.media.supported() => exiftool.dump(path).await,
            _ => None,
        };
        let files = [(source, &read, Role::Original)];
        (commit::asset(tx, &files, &[], dump, Some(source.id)).await).map_err(|e| e.to_string())?;
        if let Some(motion) = &read.motion {
            (commit::motion(tx, source.id, &source.store, &source.key, motion).await).map_err(|e| e.to_string())?;
        }
        Ok(read.media.supported())
    }
}

fn now() -> i64 {
    SystemTime::now()
        .duration_since(SystemTime::UNIX_EPOCH)
        .map_or(0, |d| d.as_secs() as i64)
}

/// The complete uploads of standard libraries among `ids`, locked; those already ingested are gone.
async fn complete(tx: &mut PgConnection, ids: &[Uuid]) -> sqlx::Result<Vec<Source>> {
    let rows = sqlx::query(
        "SELECT u.id, u.owner_id, u.library_id, u.length, u.hash, u.store, u.key, u.path FROM uploads u
         JOIN libraries l ON l.id = u.library_id
         WHERE u.id = ANY($1) AND u.completed_at IS NOT NULL AND l.privacy = 'standard'
         ORDER BY u.id FOR UPDATE OF u",
    )
    .bind(ids)
    .fetch_all(&mut *tx)
    .await?;
    Ok(rows
        .iter()
        .map(|row| Source {
            id: row.get("id"),
            owner: row.get("owner_id"),
            library: row.get("library_id"),
            length: row.get("length"),
            hash: row.get("hash"),
            store: row.get("store"),
            key: row.get("key"),
            path: row.get("path"),
            source: "upload",
        })
        .collect())
}

/// The files a job reads; copies from object stores are removed however the job ends.
pub(crate) struct Locals(pub Vec<Local>);

impl Drop for Locals {
    fn drop(&mut self) {
        for local in &self.0 {
            if let Local::Copy(copy) = local {
                let _ = std::fs::remove_file(copy);
            }
        }
    }
}

pub(crate) fn local_path(local: &Local) -> PathBuf {
    match local {
        Local::InPlace(path) | Local::Copy(path) => path.clone(),
    }
}

/// [`read`] of the file at `path`, off the async threads.
async fn read_at(path: PathBuf, size: u64, name: String, now: i64) -> Result<Read, String> {
    let read = tokio::task::spawn_blocking(move || {
        let file = File::open(&path).map_err(|e| format!("cannot open {}: {e}", path.display()))?;
        read(&file, size, &name, now)
    });
    read.await.map_err(|e| e.to_string())?
}

/// Identifies `file` and reads what it says, with a motion photo's video hashed and identified. No parser reads a file
/// that is no photo or video: only its name dates it (ADR-0066).
fn read(file: &File, size: u64, name: &str, now: i64) -> Result<Read, String> {
    let media = sniff(&head(file, 0, size)?);
    if !media.supported() {
        return Ok(Read {
            media,
            extraction: named(name, now)?,
            motion: None,
        });
    }
    let extraction = extract(file, size, name, now)?;
    let motion = match &extraction.metadata.motion_video {
        Some(span) if span.offset.checked_add(span.length).is_some_and(|end| end <= size) => {
            let mut hasher = blake3::Hasher::new();
            let mut buffer = vec![0; 1 << 20];
            let mut at = span.offset;
            while at < span.offset + span.length {
                let take = buffer.len().min((span.offset + span.length - at) as usize);
                file.read_exact_at(&mut buffer[..take], at).map_err(|e| e.to_string())?;
                hasher.update(&buffer[..take]);
                at += take as u64;
            }
            Some(Motion {
                offset: span.offset,
                length: span.length,
                hash: hasher.finalize().into(),
                mime: sniff(&head(file, span.offset, span.offset + span.length)?).mime,
            })
        }
        _ => None,
    };
    Ok(Read {
        media,
        extraction,
        motion,
    })
}

/// Up to 4 KiB from `offset`, the bytes formats are told apart by.
fn head(file: &File, offset: u64, end: u64) -> Result<Vec<u8>, String> {
    let mut head = vec![0; end.saturating_sub(offset).min(4096) as usize];
    file.read_exact_at(&mut head, offset).map_err(|e| e.to_string())?;
    Ok(head)
}

/// ExifTool processes, one per job running at once, each reading only the files linked into its own directory.
struct ExifTools {
    photolibd: PathBuf,
    command: Vec<PathBuf>,
    scratch: PathBuf,
    idle: Mutex<Vec<(ExifTool, PathBuf)>>,
    made: AtomicUsize,
}

impl ExifTools {
    /// ExifTool's dump of `file`; none when ExifTool fails or answers more than 1 MiB (ADR-0024), which only costs the
    /// info panel.
    async fn dump(&self, file: PathBuf) -> Option<Value> {
        let idle = self.idle.lock().expect("no thread panics holding ExifTools").pop();
        let (mut exiftool, dir) = match idle {
            Some(idle) => idle,
            None => {
                let dir = (self.scratch).join(format!("exiftool-{}", self.made.fetch_add(1, Ordering::Relaxed)));
                if let Err(error) = std::fs::create_dir_all(&dir) {
                    tracing::warn!(%error, "cannot make a directory for ExifTool");
                    return None;
                }
                let exiftool = ExifTool::new(self.photolibd.clone(), self.command.clone(), dir.clone(), dir.clone());
                (exiftool, dir)
            }
        };
        let link = dir.join(Uuid::now_v7().to_string());
        let dumped = match std::fs::hard_link(&file, &link).or_else(|_| std::fs::copy(&file, &link).map(drop)) {
            Ok(()) => exiftool.dump(&link).await.map_err(|failure| format!("{failure:?}")),
            Err(error) => Err(error.to_string()),
        };
        let _ = std::fs::remove_file(&link);
        self.idle
            .lock()
            .expect("no thread panics holding ExifTools")
            .push((exiftool, dir));
        match dumped {
            Ok(dump) => Some(Value::Object(dump)),
            Err(error) => {
                tracing::warn!(%error, "ExifTool could not read a file");
                None
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use std::{collections::BTreeMap, time::Duration};

    use photolib_db::{
        migrate::{Upgrade, embedded, upgrade},
        testpg,
    };
    use photolib_jobs::{Timing, Worker, reconcile::Rendition};
    use photolib_kernel::proto::model::v1::CaptureTimePrecision as P;
    use photolib_storage::{
        BlobStore,
        fs::FsStore,
        marker::{self, Candidate, Stores},
        testing::garage_store,
    };
    use tokio_util::sync::CancellationToken;

    use super::*;
    use crate::{
        ingest::{
            extract::tests::{
                client_side,
                xmp::{bag, with_xmp, xmp},
            },
            sniff::tests::corpus,
        },
        library::{self, StorageJobs, template::numbered},
    };

    /// An instance with the stores `local` and `s3` (Garage), Ann's standard and private libraries on `local` and a
    /// work directory.
    struct Instance {
        pool: sqlx::PgPool,
        journal: Arc<Journal>,
        owner: Uuid,
        library: Uuid,
        private: Uuid,
        work: tempfile::TempDir,
        _db: testpg::TestDb,
    }

    async fn instance() -> Instance {
        let db = testpg::database().await;
        upgrade(&db.pool, &Upgrade::new(&embedded())).await.unwrap();
        let work = tempfile::tempdir().unwrap();
        for dir in ["data", "uploads"] {
            std::fs::create_dir(work.path().join(dir)).unwrap();
        }
        let local: Arc<dyn BlobStore> = Arc::new(
            FsStore::open(&work.path().join("data"), Duration::from_secs(30))
                .await
                .unwrap(),
        );
        let candidates = vec![
            Candidate {
                name: "local".into(),
                store: local,
                adopt: true,
            },
            Candidate {
                name: "s3".into(),
                store: Arc::new(garage_store(Duration::from_secs(30))),
                adopt: false,
            },
        ];
        let stores = Stores::check(&db.pool, Uuid::now_v7(), candidates).await;
        let journal = Arc::new(Journal::start(db.pool.clone(), stores).await.unwrap());
        let (owner, library, private) = (Uuid::now_v7(), Uuid::now_v7(), Uuid::now_v7());
        sqlx::query("INSERT INTO users (id, handle, display_name) VALUES ($1, 'ann', 'Ann')")
            .bind(owner)
            .execute(&db.pool)
            .await
            .unwrap();
        sqlx::query(
            "INSERT INTO libraries (id, owner_id, name, kind, privacy, root_uri) VALUES
             ($1, $3, 'Photos', 'managed', 'standard', 'photos'), ($2, $3, 'Vault', 'managed', 'private', 'vault')",
        )
        .bind(library)
        .bind(private)
        .bind(owner)
        .execute(&db.pool)
        .await
        .unwrap();
        Instance {
            pool: db.pool.clone(),
            journal,
            owner,
            library,
            private,
            work,
            _db: db,
        }
    }

    impl Instance {
        /// A complete upload of `data` from `path` into `library`, its staged copy kept or gone.
        async fn upload(&self, library: Uuid, path: &str, data: &[u8], staged: bool) -> Uuid {
            let id = Uuid::now_v7();
            let file = self.work.path().join("uploads").join(id.to_string());
            std::fs::write(&file, data).unwrap();
            let key = format!("libraries/{library}/uploads/{id}");
            let store: String = sqlx::query_scalar("SELECT store FROM libraries WHERE id = $1")
                .bind(library)
                .fetch_one(&self.pool)
                .await
                .unwrap();
            let written = (self.journal.put(&store, &key, &file, Hash::of(data)).await).unwrap();
            let mut tx = self.pool.begin().await.unwrap();
            written.switch(&mut tx).await.unwrap();
            sqlx::query(
                "INSERT INTO uploads (id, owner_id, library_id, length, hash, received, store, key, completed_at,
                   expires_at, path)
                 VALUES ($1, $2, $3, $4, $5, $4, $8, $6, now(), now(), $7)",
            )
            .bind(id)
            .bind(self.owner)
            .bind(library)
            .bind(data.len() as i64)
            .bind(Hash::of(data).0.to_vec())
            .bind(&key)
            .bind(path)
            .bind(&store)
            .execute(&mut *tx)
            .await
            .unwrap();
            tx.commit().await.unwrap();
            written.finish().await.unwrap();
            if !staged {
                std::fs::remove_file(file).unwrap();
            }
            id
        }

        /// Queues the ingest of each batch and runs a worker until no job is left.
        async fn ingest(&self, batches: &[Vec<Uuid>], profile: Profile) {
            for batch in batches {
                enqueue(&mut self.pool.acquire().await.unwrap(), batch).await.unwrap();
            }
            self.run(profile).await;
        }

        /// Runs a worker that scans external libraries and ingests until no such job is left.
        async fn run(&self, profile: Profile) {
            let ingest = self.ingester(profile);
            self.work(external::SCAN, external::Scanner(ingest.libraries.clone()))
                .await;
            self.work(INGEST, ingest).await;
        }

        fn ingester(&self, profile: Profile) -> Ingest {
            let libraries = Arc::new(Libraries::new(Duration::from_secs(30)));
            let journal = self.journal.clone();
            Ingest::new(
                journal,
                self.work.path(),
                "photolibd".into(),
                vec![],
                profile,
                libraries,
            )
            .unwrap()
        }

        /// Runs a worker with `handler` until no `kind` job is left.
        async fn work(&self, kind: &str, handler: impl photolib_jobs::Handler + 'static) {
            let timing = Timing {
                poll_min: Duration::from_millis(10),
                poll_max: Duration::from_millis(50),
                ..Timing::default()
            };
            let shutdown = CancellationToken::new();
            let worker = Worker::new(self.pool.clone(), "test", 4, timing).handle(kind, handler);
            let running = tokio::spawn(worker.run(shutdown.clone()));
            let open = "SELECT count(*) FROM jobs WHERE type = $1 AND status IN ('queued', 'running')";
            while sqlx::query_scalar::<_, i64>(open)
                .bind(kind)
                .fetch_one(&self.pool)
                .await
                .unwrap()
                > 0
            {
                tokio::time::sleep(Duration::from_millis(20)).await;
            }
            shutdown.cancel();
            running.await.unwrap();
        }
    }

    /// The columns an asset should have for what the kernel told a client about its original.
    fn expected(read: &Extraction, media: Media) -> Value {
        let (metadata, capture) = (&read.metadata, &read.capture);
        let time = capture.capture_time.clone().unwrap_or_default();
        let turned = (5..=8).contains(&metadata.orientation);
        let some = |n: u64| (n > 0).then_some(n);
        let text = |s: &str| (!s.is_empty()).then(|| s.to_owned());
        let local = match time.local_datetime.as_str() {
            "" => None,
            local => {
                let padded = format!("{local}{}", &"0000-01-01T00:00:00.000"[local.len()..]);
                Some(padded)
            }
        };
        let precision = match time.precision() {
            P::Year => "year",
            P::Month => "month",
            P::Day => "day",
            P::Minute => "minute",
            P::Second => "second",
            P::Millisecond => "ms",
            P::Unspecified => "",
        };
        let at = metadata.location.as_ref();
        json!({
            "media_kind": match (media.supported(), media.kind) {
                (true, sniff::Kind::Image) => json!("image"),
                (true, sniff::Kind::Video) => json!("video"),
                _ => Value::Null,
            },
            "width": some(u64::from(if turned { metadata.height } else { metadata.width })),
            "height": some(u64::from(if turned { metadata.width } else { metadata.height })),
            "orientation": some(u64::from(metadata.orientation)),
            "make": text(&metadata.make),
            "model": text(&metadata.model),
            "lat": at.map(|a| a.latitude),
            "lon": at.map(|a| a.longitude),
            "taken_local": local,
            "taken_utc": capture.taken_at.as_ref().map(|t| t.seconds * 1000 + i64::from(t.nanos / 1_000_000)),
            "tz_offset_min": time.offset_minutes,
            "time_source": if time.source.is_empty() { "unknown" } else { &time.source },
            "time_confidence": time.confidence,
            "time_precision": text(precision),
            "duration_ms": some(metadata.duration_ms),
            "codec": text(&metadata.codec),
            "title": text(&metadata.title),
            "description": text(&metadata.description),
            "rating": metadata.rating.unwrap_or(0),
            "color_label": text(&metadata.label),
            "burst_id": text(&metadata.burst_id),
            "mime": media.mime,
            "fps": Some(metadata.frame_rate as f32).filter(|r| r.is_finite() && *r > 0.0),
        })
    }

    const STORED: &str = "SELECT json_build_object('media_kind', media_kind, 'width', width, 'height', height,
        'orientation', orientation, 'make', make, 'model', model,
        'taken_local', to_char(taken_local, 'YYYY-MM-DD\"T\"HH24:MI:SS.MS'),
        'taken_utc', (extract(epoch FROM taken_utc) * 1000)::bigint, 'tz_offset_min', tz_offset_min,
        'time_source', time_source, 'time_confidence', time_confidence, 'time_precision', time_precision,
        'duration_ms', duration_ms, 'codec', codec, 'title', title, 'description', description, 'rating', rating,
        'color_label', color_label, 'burst_id', burst_id, 'mime', f.mime), lat, lon, fps
      FROM asset_files f JOIN assets a ON a.id = f.asset_id WHERE a.source_ref = $1 AND f.role = 'original'";

    /// A row of `STORED`.
    type Stored = (Value, Option<f64>, Option<f64>, Option<f32>);

    /// The whole corpus, uploaded one folder per batch (half the files no longer staged), becomes assets whose metadata
    /// is exactly what a client's kernel extracts; Live Photos and RAW+JPEG pairs become one asset each, motion photos
    /// keep their video as a range of the original, and every asset gets version v0 and its derivatives queued.
    #[tokio::test]
    async fn the_corpus_ingests_with_the_metadata_clients_extract() {
        let at = instance().await;
        let corpus = corpus();
        let mut batches = BTreeMap::<&str, Vec<Uuid>>::new();
        for (n, (record, data)) in corpus.iter().enumerate() {
            let path = record["path"].as_str().unwrap();
            let id = at.upload(at.library, path, data, n % 2 == 0).await;
            batches.entry(path.rsplit_once('/').unwrap().0).or_default().push(id);
        }
        let profile = Profile {
            renditions: ["image", "video"]
                .map(|kind| Rendition {
                    kind: kind.into(),
                    role: "thumb_s".into(),
                    spec_id: "s1".into(),
                    only_for: None,
                })
                .into(),
            models: vec![],
            ocr: vec![],
            export: None,
        };
        at.ingest(&batches.into_values().collect::<Vec<_>>(), profile).await;

        let count = |sql: &'static str| async { sqlx::query_scalar::<_, i64>(sql).fetch_one(&at.pool).await.unwrap() };
        assert_eq!(
            count("SELECT count(*) FROM jobs WHERE type = 'ingest' AND status <> 'done'").await,
            0
        );
        assert_eq!(
            count("SELECT count(*) FROM uploads").await,
            0,
            "ingest deletes the uploads it records"
        );
        assert_eq!(count("SELECT count(*) FROM assets").await, corpus.len() as i64 - 12);
        assert_eq!(
            count(
                "SELECT count(*) FROM assets a JOIN versions v ON v.id = a.current_version_id AND v.kind = 'original'"
            )
            .await,
            corpus.len() as i64 - 12
        );
        assert_eq!(
            count("SELECT count(*) FROM jobs WHERE type IN ('render', 'transcode') AND status = 'queued'").await,
            count("SELECT count(*) FROM assets WHERE media_kind IS NOT NULL").await,
        );
        for (path, fps) in [("video/mjpeg.mov", Some(10.0)), ("stills/baseline.jpg", None)] {
            let stored: Option<f32> = sqlx::query_scalar("SELECT fps FROM assets WHERE source_ref = $1")
                .bind(path)
                .fetch_one(&at.pool)
                .await
                .unwrap();
            assert_eq!(stored, fps, "{path}: the frame rate the kernel reads");
        }
        same_as_clients(&at.pool, &corpus, false).await;
        special_facets(&at.pool, &corpus).await;
    }

    /// Special media carry the facets of the domain model that their corpus quirks call for (docs/08 §2.2): shown in
    /// 2D with a badge, or slowed.
    async fn special_facets(pool: &sqlx::PgPool, corpus: &[(Value, Vec<u8>)]) {
        let mut wrong = vec![];
        for (record, _) in corpus {
            let path = record["path"].as_str().unwrap();
            let has = |quirks: &[&str]| {
                quirks
                    .iter()
                    .any(|q| record["quirks"].as_array().unwrap().contains(&json!(q)))
            };
            let mut want: Vec<&str> = [
                (has(&["spatial_photo", "spatial_video"]), "spatial"),
                (
                    has(&["depth_apple", "depth_gdepth", "depth_dynamic", "depth_samsung"]),
                    "portrait_depth",
                ),
                (has(&["slow_motion", "slow_motion_sef"]), "slow_motion"),
            ]
            .into_iter()
            .filter_map(|(has, facet)| has.then_some(facet))
            .collect();
            want.sort_unstable();
            let got: Option<Vec<String>> = sqlx::query_scalar(
                "SELECT array(SELECT f FROM unnest(facets) f
                   WHERE f IN ('spatial', 'portrait_depth', 'slow_motion', 'time_lapse') ORDER BY f)
                 FROM assets WHERE source_ref = $1",
            )
            .bind(path)
            .fetch_optional(pool)
            .await
            .unwrap();
            if got.is_some_and(|got| got != want) {
                wrong.push(format!("{path}: want {want:?}"));
            }
        }
        assert!(wrong.is_empty(), "{}", wrong.join("\n"));
    }

    /// Each corpus file has the columns a client's kernel extracts, its motion video and its group; files that are not
    /// media are read by no parser, so they have only the capture time their name gives, and are no assets when
    /// `scanned`.
    async fn same_as_clients(pool: &sqlx::PgPool, corpus: &[(Value, Vec<u8>)], scanned: bool) {
        let mut wrong = vec![];
        for (record, data) in corpus {
            let path = record["path"].as_str().unwrap();
            let row: Option<Stored> = sqlx::query_as(STORED).bind(path).fetch_optional(pool).await.unwrap();
            // Read in binary: PostgreSQL's text would round the coordinates and frame rate.
            let stored = row.map(|(mut stored, lat, lon, fps)| {
                (stored["lat"], stored["lon"], stored["fps"]) = (json!(lat), json!(lon), json!(fps));
                stored
            });
            let partner =
                (record["group"]["role"].as_str()).is_some_and(|role| ["live_motion", "raw_alt"].contains(&role));
            let media = sniff(data);
            let want = (!partner && !(scanned && !media.supported())).then(|| {
                let read = if media.supported() {
                    client_side(data, path)
                } else {
                    Extraction {
                        capture: client_side(&[], path).capture,
                        ..Extraction::default()
                    }
                };
                expected(&read, media)
            });
            if stored != want {
                wrong.push(format!("{path}:\n  want {want:?}\n  got  {stored:?}"));
            }
            let motion: Option<Value> = sqlx::query_scalar(
                "SELECT json_build_object('offset', byte_offset, 'length', size) FROM asset_files f
                 JOIN assets a ON a.id = f.asset_id WHERE a.source_ref = $1 AND f.role = 'motion_extracted'",
            )
            .bind(path)
            .fetch_optional(pool)
            .await
            .unwrap();
            if motion.unwrap_or_default() != record["metadata"]["motion"] {
                wrong.push(format!("{path}: motion video {}", record["metadata"]["motion"]));
            }
        }
        assert!(wrong.is_empty(), "{} files differ:\n{}", wrong.len(), wrong.join("\n"));
        let pairs: Vec<(String, String)> = sqlx::query_as(
            "SELECT a.original_filename, string_agg(f.role, ',' ORDER BY f.role) FROM assets a
             JOIN asset_files f ON f.asset_id = a.id WHERE a.facets && '{live,raw_jpeg_pair}' GROUP BY a.id, 1 ORDER BY 1",
        )
        .fetch_all(pool)
        .await
        .unwrap();
        assert_eq!(pairs.len(), 12);
        assert!(
            pairs
                .iter()
                .all(|(_, roles)| { ["live_motion,original", "original,original_alt"].contains(&roles.as_str()) })
        );
    }

    /// Read in place from an external library, the corpus becomes the same assets as uploaded, with the same metadata.
    #[tokio::test]
    async fn the_corpus_scans_with_the_metadata_clients_extract() {
        let at = instance().await;
        let (root, corpus) = (at.work.path().join("nas"), corpus());
        for (record, data) in &corpus {
            let file = root.join(record["path"].as_str().unwrap());
            std::fs::create_dir_all(file.parent().unwrap()).unwrap();
            std::fs::write(file, data).unwrap();
        }
        let library = Uuid::now_v7();
        sqlx::query(
            "INSERT INTO libraries (id, owner_id, name, kind, access, root_uri) VALUES ($1, $2, 'NAS', 'external', 'ro', $3)",
        )
        .bind(library)
        .bind(at.owner)
        .bind(root.to_str().unwrap())
        .execute(&at.pool)
        .await
        .unwrap();
        let mut tx = at.pool.begin().await.unwrap();
        external::scan(&mut tx, library).await.unwrap();
        tx.commit().await.unwrap();
        at.run(Profile::default()).await;
        same_as_clients(&at.pool, &corpus, true).await;
    }

    /// The keywords a photo's own XMP holds become its uploader's tags, as a scanned photo's do (ADR-0259).
    #[tokio::test]
    async fn an_uploads_keywords_become_its_owners_tags() {
        let at = instance().await;
        let data = std::fs::read(concat!(
            env!("CARGO_MANIFEST_DIR"),
            "/../../../testdata/corpus/files/time/dst-overlap.jpg"
        ));
        let data = data.unwrap();
        let keywords = [
            bag("dc:subject", &["Ann", "beach"]),
            bag("lr:hierarchicalSubject", &["People|Ann"]),
        ];
        let jpeg = with_xmp(&data, &xmp(&format!(">{}", keywords.concat())));
        let upload = at.upload(at.library, "a.jpg", &jpeg, true).await;
        at.ingest(&[vec![upload]], Profile::default()).await;
        let tags: Vec<String> = sqlx::query_scalar(
            "SELECT t.path FROM asset_tags x JOIN tags t ON t.id = x.tag_id JOIN assets a ON a.id = x.asset_id
             WHERE a.owner_id = $1 AND t.owner_id = $1 ORDER BY 1",
        )
        .bind(at.owner)
        .fetch_all(&at.pool)
        .await
        .unwrap();
        assert_eq!(tags, ["People|Ann", "beach"]);
    }

    /// Private libraries hold ciphertext: ingest never reads their uploads. A finished batch is not ingested twice.
    #[tokio::test]
    async fn private_uploads_are_never_read_and_a_batch_is_ingested_once() {
        let at = instance().await;
        let (record, data) = &corpus()[0];
        let path = record["path"].as_str().unwrap();
        let mine = at.upload(at.library, path, data, true).await;
        let sealed = at.upload(at.private, "sealed", data, true).await;
        at.ingest(&[vec![mine], vec![sealed], vec![mine]], Profile::default())
            .await;
        let assets: Vec<Uuid> = sqlx::query_scalar("SELECT library_id FROM assets")
            .fetch_all(&at.pool)
            .await
            .unwrap();
        assert_eq!(assets, [at.library]);
        let uploads: Vec<Uuid> = sqlx::query_scalar("SELECT id FROM uploads")
            .fetch_all(&at.pool)
            .await
            .unwrap();
        assert_eq!(uploads, [sealed]);
    }

    /// What an older release that knew no JPEG left of assets: no media kind, nothing the file says, an older version.
    const UNKNOWN: &str =
        "UPDATE assets SET media_kind = NULL, facets = '{}', taken_local = NULL, tz_offset_min = NULL,
        tz_name = NULL, taken_utc = NULL, time_source = 'unknown', time_confidence = NULL, time_precision = NULL,
        lat = NULL, lon = NULL, alt = NULL, location_source = NULL, width = NULL, height = NULL, orientation = NULL,
        duration_ms = NULL, fps = NULL, codec = NULL, color = NULL, make = NULL, model = NULL, title = NULL,
        description = NULL, color_label = NULL, burst_id = NULL, sniff_version = NULL WHERE source_ref = ANY($1)";

    /// An asset by its path: its id, the version of type detection that checked it and the columns `STORED` reads.
    async fn typed(
        pool: &sqlx::PgPool,
        path: &str,
    ) -> (Uuid, Option<i16>, Value, Option<f64>, Option<f64>, Option<f32>) {
        let sql = STORED.replacen("SELECT ", "SELECT a.id, sniff_version, ", 1);
        sqlx::query_as(&sql).bind(path).fetch_one(pool).await.unwrap()
    }

    /// When a release teaches type detection a format, its sweep checks again the assets an older version found no
    /// photo or video in, a job per asset here: one that is media now gets the metadata, capture time and media kind
    /// clients extract on the same asset id, its motion video and its renditions; one that is still none is dated by
    /// its name again and marked as checked. Assets of private libraries, and those this version checked, are never
    /// read.
    #[tokio::test]
    async fn a_new_type_detection_makes_media_of_what_an_older_one_did_not_know() {
        let at = instance().await;
        let corpus = corpus();
        let photo = "compound/motion/PXL_20230330_184138390.MP.jpg";
        let paths = [photo, "names/DOC-20191120-WA0006.pdf", "stills/xmp-itxt.png"];
        let mut uploads = vec![];
        for (record, data) in corpus
            .iter()
            .filter(|(r, _)| paths.contains(&r["path"].as_str().unwrap()))
        {
            uploads.push(vec![
                at.upload(at.library, record["path"].as_str().unwrap(), data, true)
                    .await,
            ]);
        }
        let image = Rendition {
            kind: "image".into(),
            role: "thumb_s".into(),
            spec_id: "s1".into(),
            only_for: None,
        };
        let profile = Profile {
            renditions: vec![image],
            ..Profile::default()
        };
        at.ingest(&uploads, profile.clone()).await;
        let mut ingested = vec![];
        for path in paths {
            ingested.push(typed(&at.pool, path).await);
        }
        assert!(ingested.iter().all(|asset| asset.1 == Some(sniff::VERSION)));
        sqlx::query(UNKNOWN).bind(&paths[..2]).execute(&at.pool).await.unwrap();
        let sealed = Uuid::now_v7();
        exec(
            &at.pool,
            &format!(
                "UPDATE asset_files SET mime = 'application/octet-stream' WHERE role = 'original';
                 DELETE FROM asset_files WHERE role = 'motion_extracted';
                 DELETE FROM jobs WHERE type = 'render';
                 UPDATE assets SET media_kind = NULL WHERE source_ref = '{}';
                 INSERT INTO assets (id, library_id, owner_id, source) VALUES ('{sealed}', '{}', '{}', 'upload');
                 INSERT INTO asset_files (id, asset_id, role, storage, key, size, content_hash)
                 VALUES (gen_random_uuid(), '{sealed}', 'original', 'local', 'nowhere', 1, '\\x00');",
                paths[2], at.private, at.owner
            ),
        )
        .await;

        sweep(&at.pool).await.unwrap();
        sweep(&at.pool).await.unwrap();
        at.work(RETYPE, Retype(Arc::new(at.ingester(profile)))).await;
        let photo = typed(&at.pool, photo).await;
        assert_eq!(
            photo, ingested[0],
            "the photo is what ingest made of it, on the same asset"
        );
        assert_eq!(
            typed(&at.pool, paths[1]).await,
            ingested[1],
            "the PDF is still no photo, dated by its name again, and checked"
        );
        let png = typed(&at.pool, paths[2]).await;
        assert_eq!(
            (png.1, &png.2["media_kind"]),
            (Some(sniff::VERSION), &Value::Null),
            "checked by this version"
        );
        let counts: (i64, i64, i64, Option<i16>, Value) = sqlx::query_as(
            "SELECT (SELECT count(*) FROM jobs WHERE type = 'render'),
               (SELECT count(*) FROM jobs WHERE type = 'render' AND idempotency_key LIKE '%' || $1 || '%'),
               (SELECT count(*) FROM jobs WHERE type = 'retype' AND status = 'done'),
               (SELECT sniff_version FROM assets WHERE id = $2),
               (SELECT json_build_object('offset', byte_offset, 'length', size) FROM asset_files
                WHERE asset_id = $1::uuid AND role = 'motion_extracted')",
        )
        .bind(photo.0.to_string())
        .bind(sealed)
        .fetch_one(&at.pool)
        .await
        .unwrap();
        let record = &corpus.iter().find(|(r, _)| r["path"] == paths[0]).unwrap().0;
        // One render, the photo's through the reconciler; a job per asset, then one that finds none left; the private
        // library's file unread; the motion video found again.
        assert_eq!(counts, (1, 1, 3, None, record["metadata"]["motion"].clone()));
    }

    async fn exec(pool: &sqlx::PgPool, sql: &str) {
        sqlx::raw_sql(sql).execute(pool).await.unwrap();
    }

    /// The ids, keys and hashes of a library's files, in the order their assets were ingested.
    async fn files(pool: &sqlx::PgPool, library: Uuid) -> Vec<(Uuid, String, Vec<u8>)> {
        sqlx::query_as(
            "SELECT f.id, f.key, f.content_hash FROM asset_files f JOIN assets a ON a.id = f.asset_id
             WHERE a.library_id = $1 ORDER BY a.id, f.id",
        )
        .bind(library)
        .fetch_all(pool)
        .await
        .unwrap()
    }

    /// On a filesystem and on S3 alike, ingest places each original once where its library's template says, with its
    /// BLAKE3 hash; a new template places only new uploads, until the re-layout job moves the others too.
    #[tokio::test]
    async fn a_template_places_new_originals_only_until_the_library_is_relaid_out() {
        let at = instance().await;
        let corpus = corpus();
        let bytes = |path: &str| corpus.iter().find(|(r, _)| r["path"] == path).unwrap().1.clone();
        let (first, second) = (
            bytes("compound/exif/nonsense-offset.jpg"),
            bytes("compound/exif/null-island.jpg"),
        );
        for store in ["local", "s3"] {
            let library = library::create(&at.pool, &at.journal, store, at.owner, "Photos")
                .await
                .unwrap();
            let blobs = at.journal.stores().get(store).unwrap();
            let root = format!("libraries/{library}");
            assert!(marker::library_online(blobs.as_ref(), &root, library).await.unwrap());
            let a = at.upload(library, "DCIM/nonsense-offset.jpg", &first, true).await;
            at.ingest(&[vec![a]], Profile::default()).await;
            let twin = at.upload(library, "Old/nonsense-offset.jpg", &first, false).await;
            at.ingest(&[vec![twin]], Profile::default()).await;
            let dated = format!("{root}/originals/2020/2020-02/nonsense-offset.jpg");
            let before = files(&at.pool, library).await;
            let keys = |files: &[(Uuid, String, Vec<u8>)]| files.iter().map(|f| f.1.clone()).collect::<Vec<_>>();
            assert_eq!(keys(&before), [dated.clone(), numbered(&dated, 2)]);

            library::set_template(&at.pool, library, Some("{{make}}/{{model}}/{{filename}}"))
                .await
                .unwrap();
            let b = at.upload(library, "DCIM/null-island.jpg", &second, true).await;
            at.ingest(&[vec![b]], Profile::default()).await;
            let camera = format!("{root}/originals/Canon/Canon EOS 5D Mark IV");
            let placed = files(&at.pool, library).await;
            assert_eq!(placed[..2], before, "earlier originals stay where they are");
            assert_eq!(placed[2].1, format!("{camera}/null-island.jpg"));

            library::enqueue_relayout(&mut at.pool.acquire().await.unwrap(), library, store)
                .await
                .unwrap();
            let relayout = StorageJobs::new(at.pool.clone(), at.journal.clone(), at.work.path(), "local");
            at.work(library::RELAYOUT, relayout.unwrap()).await;
            let moved = files(&at.pool, library).await;
            let ids = |files: &[(Uuid, String, Vec<u8>)]| files.iter().map(|f| f.0).collect::<Vec<_>>();
            assert_eq!(ids(&moved), ids(&placed), "files keep their ids");
            assert_eq!(
                keys(&moved),
                [
                    format!("{camera}/nonsense-offset.jpg"),
                    format!("{camera}/nonsense-offset (2).jpg"),
                    format!("{camera}/null-island.jpg"),
                ]
            );

            // The uploads and the old places are deleted; each original carries its hash in its row and its object.
            at.journal.purge().await.unwrap();
            let mut expected = keys(&moved);
            expected.push(format!("{root}/.photolib/library.json"));
            expected.sort();
            assert_eq!(blobs.list(&root).await.unwrap(), expected);
            for ((_, key, hash), bytes) in moved.iter().zip([&first, &first, &second]) {
                assert_eq!(hash, &Hash::of(bytes).0.to_vec());
                assert_eq!(blobs.head(key).await.unwrap().unwrap().hash, Some(Hash::of(bytes)));
            }
        }
    }
}
