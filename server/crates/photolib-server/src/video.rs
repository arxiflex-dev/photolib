//! Video renditions at ingest (photolib-design docs/08 §5, ADR-0085): a poster frame as the asset's thumbnails and
//! preview, sprite sheets for scrubbing, and the 720p proxy (R1), unless the original plays everywhere as it is.
//! FFmpeg and ffprobe run only in the media sandbox.

use std::{
    ffi::OsString,
    path::{Path, PathBuf},
    sync::Arc,
    time::Duration,
};

use async_trait::async_trait;
use photolib_jobs::{Handler, Job, reconcile::Rendition};
use photolib_media::{Failure, Limits, Policy};
use photolib_storage::{Hash, Local, journal::Journal};
use serde::{Deserialize, Serialize};
use serde_json::{Value, json};
use sqlx::PgConnection;
use uuid::Uuid;

use crate::{
    external::{self, Libraries},
    tone::{Mapper, Tone, ToneMapping, Transfer},
};

/// The job type of a video's renditions (`photolib_jobs::reconcile`), which `worker:transcode` runs.
pub const TRANSCODE: &str = "transcode";

/// The renditions every video should have, for the reconciler.
pub fn renditions() -> Vec<Rendition> {
    (RENDITIONS.iter())
        .map(|(role, _)| Rendition {
            kind: "video".into(),
            role: (*role).into(),
            spec_id: spec(role).unwrap()["spec_id"].as_str().unwrap().into(),
            only_for: None,
        })
        .collect()
}

/// The `transcode` job's handler: renders one rendition of a video's original, read from any store, into the same
/// store, or for an external library's into `local`.
pub struct Transcode {
    journal: Arc<Journal>,
    scratch: PathBuf,
    ffmpeg: Ffmpeg,
    libraries: Arc<Libraries>,
}

impl Transcode {
    pub fn new(
        journal: Arc<Journal>,
        work_dir: &Path,
        ffmpeg: Ffmpeg,
        libraries: Arc<Libraries>,
    ) -> std::io::Result<Transcode> {
        let scratch = work_dir.join("transcode");
        std::fs::create_dir_all(&scratch)?;
        Ok(Transcode {
            journal,
            scratch,
            ffmpeg,
            libraries,
        })
    }
}

#[async_trait]
impl Handler for Transcode {
    async fn run(&self, job: &Job, tx: &mut PgConnection) -> Result<(), String> {
        #[derive(Deserialize)]
        struct Payload {
            asset: Uuid,
            role: String,
        }
        let Payload { asset, role } = serde_json::from_slice(&job.payload).map_err(|_| "a malformed payload")?;
        let mut spec = spec(&role).ok_or_else(|| format!("no rendition {role}"))?;
        // Read without locking: the transaction takes no id while FFmpeg runs, so it holds back no sync reader.
        let original: Option<(Uuid, String, String, Option<Vec<u8>>, String, i64)> = sqlx::query_as(
            "SELECT a.library_id, f.storage, f.key, f.content_hash, f.mime, f.size FROM asset_files f
             JOIN assets a ON a.id = f.asset_id WHERE f.asset_id = $1 AND f.role = 'original' AND f.state = 'present'",
        )
        .bind(asset)
        .fetch_optional(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;
        let Some((library, store, key, hash, mime, size)) = original else {
            return Ok(());
        };
        let scratch = Scratch(self.scratch.join(job.id.to_string()));
        let out = scratch.0.join("out");
        std::fs::create_dir_all(&out).map_err(|e| e.to_string())?;
        // An external file renders before it is hashed, and nothing is written beside it.
        let (input, derived) = match store.as_str() {
            external::STORE => {
                let copy = self.libraries.copy(tx, library, &key, size, &scratch.0);
                (copy.await?, "local")
            }
            _ => {
                let hash = hash.clone().unwrap_or_default().try_into();
                let hash = Hash(hash.map_err(|_| "a malformed hash")?);
                let local = self.journal.local(&store, &key, hash, &scratch.0).await;
                (local.map_err(|e| e.to_string())?, store.as_str())
            }
        };
        let (Local::InPlace(input) | Local::Copy(input)) = input;
        let rendered = self.ffmpeg.render(&role, &input, &mime, &out).await;
        let insert = |storage: &str, key: String, mime: &str, size: i64, hash, spec: Value| {
            sqlx::query(
                "INSERT INTO asset_files (id, asset_id, role, storage, key, mime, size, content_hash, render_spec)
                 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)",
            )
            .bind(Uuid::now_v7())
            .bind(asset)
            .bind(role.clone())
            .bind(storage.to_owned())
            .bind(key)
            .bind(mime.to_owned())
            .bind(size)
            .bind(hash)
            .bind(spec)
        };
        let Some(outputs) = rendered.map_err(|failure| format!("{failure:?}"))? else {
            let source = self
                .ffmpeg
                .source(&input)
                .await
                .map_err(|failure| format!("{failure:?}"))?;
            if let Some(spec) = spec.as_object_mut() {
                spec.extend([("original".into(), json!(true)), ("source".into(), json!(source))]);
            }
            let row = insert(&store, key, &mime, size, hash, spec);
            row.execute(&mut *tx).await.map_err(|e| e.to_string())?;
            return Ok(());
        };
        for Output { path, mime, about } in outputs {
            let (hash, size) = Hash::of_file(&path).map_err(|e| e.to_string())?;
            let key = format!("derived/{library}/{asset}/{}", Uuid::now_v7());
            let put = self.journal.put(derived, &key, &path, hash).await;
            let put = put.map_err(|e| e.to_string())?;
            let mut spec = spec.clone();
            spec.as_object_mut().unwrap().extend(about.as_object().unwrap().clone());
            let row = insert(derived, key, mime, size as i64, Some(hash.0.to_vec()), spec);
            row.execute(&mut *tx).await.map_err(|e| e.to_string())?;
            put.settle(tx).await.map_err(|e| e.to_string())?;
        }
        Ok(())
    }
}

/// A job's scratch directory, removed however the job ends.
struct Scratch(PathBuf);

impl Drop for Scratch {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.0);
    }
}

/// What a render is: the rendition's role and how to make it. A spec id names one recipe at one generator version.
#[derive(Clone, Copy, Debug, Serialize)]
#[serde(tag = "kind", rename_all = "snake_case")]
enum Recipe {
    /// The representative frame as a still.
    Poster {
        format: Still,
        short: u32,
        long: u32,
        quality: u32,
    },
    /// A frame every `every_ms` or more, at most `max_frames`, tiled into sheets.
    Sprite {
        long: u32,
        columns: u32,
        rows: u32,
        every_ms: u32,
        max_frames: u32,
        quality: u32,
    },
    /// R1, written as one fMP4 file and the index of its pieces that HLS serves (docs/08 §5.1).
    Proxy(Ladder),
}

/// A rung of the ladder (docs/08 §5.1): H.264 and AAC-LC stereo, SDR BT.709, constant frame rate, each GOP a piece
/// of fMP4 that HLS segments group, the first alone.
#[derive(Clone, Copy, Debug, Serialize)]
pub struct Ladder {
    /// The most pixels of the picture's short side.
    pub short: u32,
    /// The most frames a second.
    pub fps: u32,
    /// The picture's bits a second at most.
    pub bit_rate: u32,
    /// A key frame every so many milliseconds of source time.
    pub gop_ms: u32,
    /// The milliseconds of an HLS segment.
    pub segment_ms: u32,
    /// The sound's bits a second.
    pub audio_bit_rate: u32,
}

/// R1, the always-available rung.
pub const R1: Ladder = Ladder {
    short: 720,
    fps: 30,
    bit_rate: 2_500_000,
    gop_ms: 2000,
    segment_ms: 4000,
    audio_bit_rate: 128_000,
};

#[derive(Clone, Copy, Debug, Serialize)]
#[serde(rename_all = "lowercase")]
enum Still {
    Webp,
    Jpeg,
}

/// Every rendition of a video (docs/08 §4.1, §5.1): the poster at the image renditions' sizes, scrubbing sprites and R1.
#[rustfmt::skip]
const RENDITIONS: [(&str, Recipe); 5] = [
    ("thumb_s", Recipe::Poster { format: Still::Webp, short: 256, long: 1024, quality: 70 }),
    ("thumb_m", Recipe::Poster { format: Still::Webp, short: 720, long: 2048, quality: 75 }),
    ("preview", Recipe::Poster { format: Still::Jpeg, short: 2160, long: 2160, quality: 85 }),
    ("sprite", Recipe::Sprite { long: 160, columns: 10, rows: 10, every_ms: 1000, max_frames: 1000, quality: 60 }),
    ("video_proxy_720", Recipe::Proxy(R1)),
];

/// Bumped whenever a recipe would make different bytes, which renders every video again: 2 is ADR-0390's tone
/// mapping, which changes every HDR video's pictures.
const GENERATOR_VERSION: u32 = 2;

fn recipe(role: &str) -> Option<Recipe> {
    RENDITIONS
        .iter()
        .find(|(known, _)| *known == role)
        .map(|(_, recipe)| *recipe)
}

/// The render spec of `role`, as stored with each rendition; `spec_id` is a hash of the rest.
pub fn spec(role: &str) -> Option<Value> {
    let recipe = recipe(role)?;
    let spec = json!({"role": role, "generator": "ffmpeg", "version": GENERATOR_VERSION, "recipe": recipe});
    let hash = blake3::hash(spec.to_string().as_bytes()).to_hex();
    let mut spec = spec;
    spec["spec_id"] = json!(hash[..32]);
    Some(spec)
}

/// The H.264 encoders R1 can use, best first: x264 in GPL builds, OpenH264 in LGPL ones.
const H264: [&str; 2] = ["libx264", "libopenh264"];

/// SDR is shown as BT.709, tagged or not.
const BT709: &str = "setparams=color_primaries=bt709:color_trc=bt709:colorspace=bt709";

/// The frames of a video, one after another as 8-bit RGB rows: frame `n` is at `n * every_ms`.
#[derive(Debug)]
pub struct Frames {
    /// Each frame's size in pixels
    pub width: u32,
    /// Each frame's size in pixels
    pub height: u32,
    /// The distance between frames
    pub every_ms: u32,
    /// The frames' pixels, `3 * width * height` bytes each
    pub pixels: Vec<u8>,
}

impl Frames {
    /// The bytes of a frame.
    fn size(&self) -> usize {
        let pixels = u64::from(self.width).saturating_mul(u64::from(self.height));
        usize::try_from(pixels.saturating_mul(3)).unwrap_or(0)
    }

    /// Each frame's time in milliseconds and its pixels.
    pub fn each(&self) -> impl Iterator<Item = (i32, &[u8])> {
        let size = self.size().max(1);
        self.pixels.chunks_exact(size).enumerate().map(|(n, rgb)| {
            let time = u64::try_from(n).unwrap_or(0).saturating_mul(u64::from(self.every_ms));
            (i32::try_from(time).unwrap_or(i32::MAX), rgb)
        })
    }
}

/// The distance between the frames of at most `most` over `duration` seconds: two seconds at least.
#[allow(clippy::cast_possible_truncation, clippy::cast_sign_loss)] // milliseconds of a video's length, rounded and positive
fn spacing(duration: f64, most: u32) -> u32 {
    (2000.0_f64.max(duration * 1000.0 / f64::from(most.max(1)))).round() as u32
}

/// The address space a Vulkan device takes: its driver maps far more than it uses, and a software one (llvmpipe)
/// starts a stack for every core.
const VULKAN_MEMORY: u64 = 8 << 30;

/// The size a file may grow to meanwhile: a software driver keeps its images in memory files, which growing checks
/// against the limit (SIGXFSZ otherwise).
const VULKAN_FILES: u64 = 4 << 30;

/// The address space of a render that converts HDR on the CPU.
const HDR_MEMORY: u64 = 6 << 30;

/// How a render turns its source's pictures into SDR BT.709.
#[derive(Clone, Debug, Default)]
pub struct Conversion {
    /// The filters between the scaled picture and the 4:2:0 format.
    colour: String,
    /// Whether FFmpeg needs a Vulkan device for them.
    vulkan: bool,
    /// Whether they convert HDR.
    hdr: bool,
}

/// A file a render wrote, with what clients need to know about it beyond its spec.
#[derive(Debug)]
pub struct Output {
    pub path: PathBuf,
    pub mime: &'static str,
    pub about: Value,
}

/// FFmpeg and ffprobe from one directory, each run in its own sandboxed child.
pub struct Ffmpeg {
    photolibd: PathBuf,
    dir: PathBuf,
    h264: &'static str,
    threads: usize,
    tone_mapping: ToneMapping,
    vulkan: tokio::sync::OnceCell<Result<(), String>>,
}

impl Ffmpeg {
    /// Converts HDR to SDR as `tone_mapping` says, by default libplacebo where it runs, else zimg.
    #[must_use]
    pub fn with_tone_mapping(mut self, tone_mapping: ToneMapping) -> Self {
        self.tone_mapping = tone_mapping;
        self
    }

    /// Whether libplacebo converts HDR here: a Vulkan device works inside the media sandbox and reads a known grey
    /// back as grey. Asked once, as every render of HDR would otherwise ask it again.
    async fn placebo(&self) -> &Result<(), String> {
        self.vulkan
            .get_or_init(|| async {
                let found = self.try_placebo().await;
                match &found {
                    Ok(()) => tracing::info!("libplacebo converts HDR to SDR"),
                    Err(why) => tracing::info!(why, "no Vulkan device works in the sandbox: zimg converts HDR to SDR"),
                }
                found
            })
            .await
    }

    async fn try_placebo(&self) -> Result<(), String> {
        let tone = Tone {
            transfer: Transfer::Pq,
            primaries: "bt2020".into(),
            matrix: "bt2020nc".into(),
            range: "tv".into(),
        };
        let filter = tone.filter(Mapper::Placebo).map_err(|_| "no filter".to_owned())?;
        // About 90 nits of PQ, as exact codes: a converted RGB grey would not be neutral to the last bit.
        let grey = "nullsrc=s=64x64:r=1:d=1,format=yuv420p10le,geq=lum_expr=500:cb_expr=512:cr_expr=512,\
                    setparams=color_primaries=bt2020:\
                    color_trc=smpte2084:colorspace=bt2020nc:range=tv";
        let mut args = words("-nostdin -threads 1 -filter_threads 1 -init_hw_device vulkan=vk");
        args.extend(words("-filter_hw_device vk -f lavfi -i"));
        args.extend([grey.to_owned(), "-frames:v".into(), "1".into(), "-vf".into()]);
        args.push(format!("{filter},format=rgba"));
        args.extend(words("-f rawvideo -pix_fmt rgba -"));
        let limits = Limits {
            memory: VULKAN_MEMORY,
            wall: Duration::from_secs(60),
            file_size: VULKAN_FILES,
            ..Limits::IMAGE
        };
        let picture = (self.sandboxed("ffmpeg", &self.dir, None, limits, &args).await)
            .map_err(|failure| format!("{failure:?}"))?;
        let at = (32 * 64 + 32) * 4;
        let [r, g, b] = match picture.get(at..at + 3) {
            Some(&[r, g, b]) => [r, g, b],
            _ => [0; 3],
        };
        let neutral = r.abs_diff(g) <= 3 && b.abs_diff(g) <= 3 && (120..=235).contains(&g);
        if picture.len() == 64 * 64 * 4 && neutral {
            Ok(())
        } else {
            Err(format!("it turned a grey into {r},{g},{b}"))
        }
    }

    /// What converts HDR here: libplacebo where it runs and the settings do not say zimg, else zimg. The sandbox lets
    /// only a software Vulkan device in (no GPU's device file is readable), which turns a 4K frame in 50 ms and a
    /// second of video in 1.5 s, so `auto` gives the pictures of a `stream` (R1, the rungs) to zimg, which takes 0.2 s.
    pub async fn mapper(&self, stream: bool) -> Result<Mapper, Failure> {
        if self.tone_mapping == ToneMapping::Zimg || (stream && self.tone_mapping == ToneMapping::Auto) {
            return Ok(Mapper::Zimg);
        }
        match (self.placebo().await, self.tone_mapping) {
            (Ok(()), _) => Ok(Mapper::Placebo),
            (Err(why), ToneMapping::Placebo) => Err(Failure::Unsupported(format!("libplacebo cannot run here: {why}"))),
            (Err(_), _) => Ok(Mapper::Zimg),
        }
    }

    /// The conversion of a source whose HDR is `tone` (none for SDR) to SDR BT.709.
    pub async fn conversion(&self, tone: Option<&Tone>, stream: bool) -> Result<Conversion, Failure> {
        let Some(tone) = tone else {
            return Ok(Conversion {
                colour: BT709.into(),
                vulkan: false,
                hdr: false,
            });
        };
        let mapper = self.mapper(stream).await?;
        Ok(Conversion {
            colour: format!("{},{BT709}", tone.filter(mapper)?),
            vulkan: mapper == Mapper::Placebo,
            hdr: true,
        })
    }

    /// `dir` holds `ffmpeg` and `ffprobe`; `photolibd` provides the sandbox. Up to `slots` renders run at once, each on
    /// its share of the cores. Fails when FFmpeg cannot encode H.264.
    pub fn new(photolibd: PathBuf, dir: PathBuf, slots: usize) -> Result<Ffmpeg, String> {
        let ffmpeg = dir.join("ffmpeg");
        let encoders = std::process::Command::new(&ffmpeg)
            .args(["-hide_banner", "-encoders"])
            .output()
            .map_err(|e| format!("cannot run {}: {e}", ffmpeg.display()))?;
        let encoders = String::from_utf8_lossy(&encoders.stdout);
        let h264 = (H264.into_iter())
            .find(|name| encoders.contains(&format!(" {name} ")))
            .ok_or_else(|| format!("{} has neither libx264 nor libopenh264", ffmpeg.display()))?;
        let cores = std::thread::available_parallelism().map_or(1, usize::from);
        Ok(Ffmpeg {
            photolibd,
            dir,
            h264,
            threads: cores.checked_div(slots).unwrap_or(1).max(1),
            tone_mapping: ToneMapping::default(),
            vulkan: tokio::sync::OnceCell::new(),
        })
    }

    /// Runs `tool` with `args` in the sandbox, reading only `input` and writing only in `out`.
    async fn sandboxed(
        &self,
        tool: &str,
        input: &Path,
        out: Option<&Path>,
        limits: Limits,
        args: &[String],
    ) -> Result<Vec<u8>, Failure> {
        let policy = Policy {
            read: vec![input.to_owned()],
            write: out.map(Path::to_owned),
            limits,
        };
        let mut tool = vec![self.dir.join(tool).into_os_string()];
        tool.extend(["-hide_banner", "-loglevel", "error"].map(OsString::from));
        tool.extend(args.iter().map(OsString::from));
        photolib_media::run(&self.photolibd, &policy, &tool).await
    }

    /// What ffprobe reads in `file`'s headers.
    pub async fn probe(&self, file: &Path) -> Result<Probe, Failure> {
        let limits = Limits {
            wall: Duration::from_secs(60),
            file_size: 0,
            ..Limits::IMAGE
        };
        let mut args = words("-print_format json -show_format -show_streams");
        args.push(file.display().to_string());
        let json = self.sandboxed("ffprobe", file, None, limits, &args).await?;
        serde_json::from_slice(&json).map_err(|e| Failure::DecoderCrash(format!("ffprobe: {e}")))
    }

    /// Whether every packet of `input`'s picture and sound is there: a truncated file plays only as far as it goes,
    /// and not at all in Firefox. Reads the whole file, decoding nothing.
    async fn complete(&self, input: &Path, probe: &Probe) -> Result<bool, Failure> {
        let mut args = words("-nostdin -xerror -i");
        args.push(input.display().to_string());
        args.extend(words("-map 0:v:0 -map 0:a:0? -c copy -f null -"));
        let limits = Limits {
            wall: Duration::from_secs_f64(60.0 + probe.duration()),
            file_size: 0,
            ..Limits::IMAGE
        };
        match self.sandboxed("ffmpeg", input, None, limits, &args).await {
            Ok(_) => Ok(true),
            Err(Failure::DecoderCrash(_)) => Ok(false),
            Err(failure) => Err(failure),
        }
    }

    /// Up to `most` frames of the video `input`, at least `2` s apart, upright and as SDR sRGB-ish RGB (BT.709), fitted
    /// to a long side of at most `long`, written as raw pixels in the directory `out` (ML-08: where the faces are
    /// looked for). The first frame is at 0 ms.
    pub async fn keyframes(&self, input: &Path, out: &Path, long: u32, most: u32) -> Result<Frames, Failure> {
        let probe = self.probe(input).await?;
        let (size, duration) = (probe.size(), probe.duration());
        if size.0 == 0 || size.1 == 0 {
            return Err(Failure::Unsupported("no picture".into()));
        }
        let frame = fit(size, u32::MAX, long);
        let every_ms = spacing(duration, most);
        // Frames in numbers, like a stream's: the CPU converter, which is fast enough for many of them.
        let conversion = self.conversion(probe.tone().as_ref(), true).await?;
        let filters = format!("fps=1000/{every_ms},{}", picture(&conversion, frame));
        let mut args = self.reading(input, 0.0, conversion.vulkan);
        args.extend(words("-map 0:v:0 -map_metadata -1 -sn -dn -vf"));
        args.push(filters);
        args.extend(words(&format!(
            "-frames:v {most} -f rawvideo -pix_fmt rgb24 -threads {}",
            self.threads
        )));
        let file = out.join("frames.rgb");
        args.push(file.display().to_string());
        self.sandboxed("ffmpeg", input, Some(out), limits(duration, &conversion), &args)
            .await?;
        let pixels = std::fs::read(&file).map_err(|e| Failure::Transient(e.to_string()))?;
        drop(std::fs::remove_file(&file));
        let frames = Frames {
            width: frame.0,
            height: frame.1,
            every_ms,
            pixels,
        };
        if frames.size() == 0 || frames.pixels.is_empty() || frames.pixels.len().checked_rem(frames.size()) != Some(0) {
            return Err(Failure::DecoderCrash("FFmpeg wrote no whole frames".into()));
        }
        Ok(frames)
    }

    /// Renders `role` of the video `input`, a `mime` file, into the directory `out`, and checks what it wrote. None
    /// when the original already is that rendition: R1 of a complete video that plays everywhere.
    pub async fn render(
        &self,
        role: &str,
        input: &Path,
        mime: &str,
        out: &Path,
    ) -> Result<Option<Vec<Output>>, Failure> {
        let recipe = recipe(role).ok_or_else(|| Failure::Unsupported(format!("no rendition {role}")))?;
        let probe = self.probe(input).await?;
        let (size, duration) = (probe.size(), probe.duration());
        if size.0 == 0 || size.1 == 0 {
            return Err(Failure::Unsupported("no picture".into()));
        }
        let conversion = self
            .conversion(probe.tone().as_ref(), matches!(recipe, Recipe::Proxy(_)))
            .await?;
        let (frame, filters, encode, name, sheets) = match recipe {
            Recipe::Proxy(ladder) => {
                let complete = self.complete(input, &probe).await?;
                if complete && plays_everywhere(&probe, mime).is_ok() {
                    return Ok(None);
                }
                return self
                    .proxy(&ladder, &probe, &conversion, input, out, complete)
                    .await
                    .map(Some);
            }
            Recipe::Poster {
                format,
                short,
                long,
                quality,
            } => {
                let frame = fit(size, short, long);
                // Past a fade-in, the frame closest to three seconds' average. Decoded, not sought: an MPEG-TS seek
                // lands past the key frame.
                let start = (duration / 10.0).min(10.0);
                let filters = format!(
                    "trim=start={start:.3},fps=10,thumbnail=30,{}",
                    picture(&conversion, frame)
                );
                let (encode, name) = match format {
                    Still::Webp => (format!("-c:v libwebp -quality {quality} -f webp"), "poster.webp"),
                    // FFmpeg's JPEG scale runs from 2, the best, to 31.
                    Still::Jpeg => (
                        format!("-c:v mjpeg -q:v {} -f image2", (100 - quality) / 5),
                        "poster.jpg",
                    ),
                };
                (frame, filters, format!("-frames:v 1 {encode}"), name, None)
            }
            Recipe::Sprite {
                long,
                columns,
                rows,
                every_ms,
                max_frames,
                quality,
            } => {
                let frame = fit(size, u32::MAX, long);
                let every = f64::from(every_ms)
                    .max(duration * 1000.0 / f64::from(max_frames))
                    .round() as u32;
                let filters = format!("fps=1000/{every},{},tile={columns}x{rows}", picture(&conversion, frame));
                let encode = format!("-c:v libwebp -quality {quality} -f image2");
                let about = json!({"every_ms": every, "columns": columns, "rows": rows, "width": frame.0,
                    "height": frame.1});
                (
                    (frame.0 * columns, frame.1 * rows),
                    filters,
                    encode,
                    "sprite-%03d.webp",
                    Some(about),
                )
            }
        };
        let mut args = self.reading(input, 0.0, conversion.vulkan);
        args.extend(words("-map 0:v:0 -map_metadata -1 -sn -dn -vf"));
        args.push(filters);
        args.extend(words(&format!("{encode} -threads {}", self.threads)));
        args.push(out.join(name).display().to_string());
        self.sandboxed("ffmpeg", input, Some(out), limits(duration, &conversion), &args)
            .await?;
        let mut written: Vec<PathBuf> = (std::fs::read_dir(out).map_err(|e| Failure::Transient(e.to_string()))?)
            .filter_map(|entry| Some(entry.ok()?.path()))
            .collect();
        written.sort();
        if written.is_empty() {
            return Err(Failure::DecoderCrash("FFmpeg wrote nothing".into()));
        }
        let mut outputs = vec![];
        for (n, path) in written.into_iter().enumerate() {
            let made = self.probe(&path).await?;
            if made.size() != frame {
                return Err(Failure::DecoderCrash(format!("made {:?}, not {frame:?}", made.size())));
            }
            let mime = match path.extension().and_then(|e| e.to_str()) {
                Some("webp") => "image/webp",
                _ => "image/jpeg",
            };
            let mut about = sheets.clone().unwrap_or(json!({}));
            if sheets.is_some() {
                about["sheet"] = json!(n);
            }
            outputs.push(Output { path, mime, about });
        }
        Ok(Some(outputs))
    }

    /// R1 of `input` in `out`: `proxy.mp4`, one fMP4 file that plays progressively, and in its render spec what the
    /// ladder needs: the source's facts and the index of its pieces, which HLS serves as byte ranges (docs/08 §5.1).
    async fn proxy(
        &self,
        ladder: &Ladder,
        probe: &Probe,
        conversion: &Conversion,
        input: &Path,
        out: &Path,
        complete: bool,
    ) -> Result<Vec<Output>, Failure> {
        let source = probe.source();
        let (file, playlist) = (out.join("proxy.mp4"), out.join("proxy.m3u8"));
        let mut args = self.ladder(ladder, &source, conversion, input, 0);
        args.extend(words("-hls_flags single_file -hls_segment_filename"));
        args.extend([file.display().to_string(), playlist.display().to_string()]);
        self.sandboxed("ffmpeg", input, Some(out), limits(source.duration, conversion), &args)
            .await?;
        let size = std::fs::metadata(&file).map_or(0, |m| m.len());
        let index = std::fs::read_to_string(&playlist)
            .ok()
            .and_then(|text| index(&text, size));
        let made = self.probe(&file).await?;
        let frame = fit((source.width, source.height), ladder.short, u32::MAX);
        let lost = probe.duration() - made.duration();
        let broken = if made.size() != frame {
            Some(format!("made {:?}, not {frame:?}", made.size()))
        } else if index.is_none() {
            Some("R1 has no index of its pieces".into())
        } else {
            (plays_everywhere(&made, "video/mp4").err())
                .map(|rule| format!("R1 breaks the baseline: {rule}"))
                .or_else(|| (lost < -0.5 || complete && lost > 0.5).then(|| "R1 lost time".into()))
                .or_else(|| (made.audio().is_some() != source.audio).then(|| "R1 lost sound".into()))
        };
        if let Some(broken) = broken {
            return Err(Failure::DecoderCrash(broken));
        }
        let about = json!({"source": source, "hls": index});
        Ok(vec![Output {
            path: file,
            mime: "video/mp4",
            about,
        }])
    }

    /// The HDR picture of `input` as it is, copied into fMP4 pieces of about 4 s that start at its key frames, and its
    /// sound as AAC-LC, into `out`: `hdr.mp4` and the index of its pieces, which HLS serves as byte ranges as it does
    /// R1's (ADR-0390). Checked: it must last as long, keep its sound and still be HDR.
    pub async fn remux(&self, source: &Source, input: &Path, out: &Path) -> Result<Value, Failure> {
        let (file, playlist) = (out.join("hdr.mp4"), out.join("hdr.m3u8"));
        let mut args = self.reading(input, 0.0, false);
        args.extend(words(
            "-map 0:v:0 -map 0:a:0? -map_metadata -1 -map_chapters -1 -sn -dn -c:v copy",
        ));
        if source.codec == "hevc" {
            args.extend(words("-tag:v hvc1"));
        }
        args.extend(words(if source.audio_lc {
            "-c:a copy"
        } else {
            "-c:a aac -b:a 192k -ar 48000 -ac 2"
        }));
        args.extend(words(
            "-f hls -hls_segment_type fmp4 -hls_time 4 -hls_playlist_type vod -hls_list_size 0 -hls_flags single_file \
             -hls_segment_filename",
        ));
        args.extend([file.display().to_string(), playlist.display().to_string()]);
        let size = std::fs::metadata(input).map_or(0, |m| m.len());
        let limits = Limits {
            file_size: size.saturating_add(size / 8).saturating_add(256 << 20),
            ..limits(source.duration, &Conversion::default())
        };
        self.sandboxed("ffmpeg", input, Some(out), limits, &args).await?;
        let made_size = std::fs::metadata(&file).map_or(0, |m| m.len());
        let index = std::fs::read_to_string(&playlist)
            .ok()
            .and_then(|text| index(&text, made_size))
            .ok_or_else(|| Failure::DecoderCrash("the copy has no index of its pieces".into()))?;
        let made = self.probe(&file).await?;
        let lost = source.duration - made.duration();
        if !made.hdr() || lost.abs() > 1.0 || made.audio().is_some() != source.audio {
            return Err(Failure::DecoderCrash(format!(
                "the copy is not the original: hdr {}, {lost:.1} s lost, sound {}",
                made.hdr(),
                made.audio().is_some()
            )));
        }
        Ok(index)
    }

    /// The source's facts that the ladder needs, as R1 keeps them: for an original that is its own R1.
    pub async fn source(&self, input: &Path) -> Result<Source, Failure> {
        Ok(self.probe(input).await?.source())
    }

    /// FFmpeg's arguments up to the HLS muxer's output names: `input`, from the GOP `from` on, encoded as `ladder`
    /// in fMP4 pieces of one GOP, on the grid of source time every rung shares, so that any piece of any rung follows
    /// any other (docs/08 §5.4).
    fn ladder(
        &self,
        ladder: &Ladder,
        source: &Source,
        conversion: &Conversion,
        input: &Path,
        from: u32,
    ) -> Vec<String> {
        let gop = f64::from(ladder.gop_ms) / 1000.0;
        let start = f64::from(from) * gop;
        let frame = fit((source.width, source.height), ladder.short, u32::MAX);
        let rate = match ratio(&source.rate, '/') {
            Some(fps) if fps <= f64::from(ladder.fps) => source.rate.clone(),
            _ => ladder.fps.to_string(),
        };
        let kbps = ladder.bit_rate / 1000;
        let video = match self.h264 {
            "libx264" => format!(
                "-c:v libx264 -preset veryfast -profile:v high -level:v 4.1 -crf 23 -maxrate {kbps}k -bufsize {}k",
                2 * kbps
            ),
            _ => format!("-c:v libopenh264 -profile:v high -b:v {kbps}k -maxrate {kbps}k"),
        };
        let mut args = self.reading(input, start, conversion.vulkan);
        args.extend(words(
            "-map 0:v:0 -map 0:a:0? -map_metadata -1 -map_chapters -1 -sn -dn -vf",
        ));
        args.push(format!("fps={rate},{}", picture(conversion, frame)));
        // The AAC encoder's priming would start the sound before the picture, and the muxer would then shift a
        // session from the start, but no other, by as much: every rung and session starts that much later instead.
        args.extend(words(&format!(
            "{video} -force_key_frames expr:gte(t,n_forced*{gop}) -c:a aac -b:a {}k -ar 48000 -ac 2 -threads {} \
             -output_ts_offset {:.6} -f hls -hls_segment_options movflags=+frag_discont -hls_segment_type fmp4 \
             -hls_time {gop} -hls_playlist_type vod -hls_list_size 0",
            ladder.audio_bit_rate / 1000,
            self.threads,
            start + PRIMING,
        )));
        args
    }

    /// FFmpeg's arguments that read `input` from `start` seconds on, each step on this render's share of the cores.
    fn reading(&self, input: &Path, start: f64, vulkan: bool) -> Vec<String> {
        // Unless told, the decoders, the filters and the encoder each take a thread per core.
        let threads = self.threads;
        let mut args = words(&format!(
            "-nostdin -protocol_whitelist file -filter_threads {threads} -threads {threads}"
        ));
        if vulkan {
            args.extend(words("-init_hw_device vulkan=vk -filter_hw_device vk"));
        }
        if start > 0.0 {
            args.extend(["-ss".into(), format!("{start:.3}")]);
        }
        args.extend(["-i".into(), input.display().to_string()]);
        args
    }

    /// Starts encoding `input` as `ladder` from the GOP `from` on into `out`, a piece `<n>.m4s` at a time, each
    /// renamed into place once whole, and `init-<from>.mp4`; returns the sandboxed child, which runs until the end
    /// unless stopped (docs/08 §5.4).
    pub async fn rung(
        &self,
        ladder: &Ladder,
        source: &Source,
        input: &Path,
        from: u32,
        out: &Path,
    ) -> Result<tokio::process::Child, Failure> {
        let conversion = self.conversion(source.hdr_tone().as_ref(), true).await?;
        let mut args = self.ladder(ladder, source, &conversion, input, from);
        // Not a frame past the input's end, which the frame rate's rounding of R1's adds.
        let left = source.duration - f64::from(from) * f64::from(ladder.gop_ms) / 1000.0;
        args.extend(words(&format!(
            "-t {left:.3} -hls_flags temp_file -start_number {from} -hls_fmp4_init_filename init-{from}.mp4 -hls_segment_filename"
        )));
        args.push(out.join("%d.m4s").display().to_string());
        args.push(out.join(format!("{from}.m3u8")).display().to_string());
        let policy = Policy {
            read: vec![input.to_owned()],
            write: Some(out.to_owned()),
            limits: limits(source.duration, &conversion),
        };
        let mut tool = vec![self.dir.join("ffmpeg").into_os_string()];
        tool.extend(["-hide_banner", "-loglevel", "error"].map(OsString::from));
        tool.extend(args.iter().map(OsString::from));
        tokio::process::Command::from(photolib_media::command(&self.photolibd, &policy, &tool))
            .stdin(std::process::Stdio::null())
            .stdout(std::process::Stdio::null())
            .stderr(std::process::Stdio::piped())
            .kill_on_drop(true)
            .spawn()
            .map_err(|e| Failure::Transient(format!("cannot start {}: {e}", self.photolibd.display())))
    }
}

/// How long the AAC encoder's priming lasts: 1,024 samples at 48 kHz.
const PRIMING: f64 = 1024.0 / 48000.0;

/// What an encode of `duration` seconds may use.
fn limits(duration: f64, conversion: &Conversion) -> Limits {
    let vulkan = conversion.vulkan;
    let wall = 3.0 * duration + 60.0;
    let cores = std::thread::available_parallelism().map_or(1, usize::from) as f64;
    Limits {
        // zimg's float frames of a large picture, one set for each thread of the filter graph, need more than 3 GiB.
        memory: if vulkan {
            VULKAN_MEMORY
        } else if conversion.hdr {
            HDR_MEMORY
        } else {
            3 << 30
        },
        cpu_secs: (wall * cores) as u64,
        wall: Duration::from_secs_f64(wall),
        // 1.5 times what R1's caps allow (docs/08 §8.2), and room for the stills.
        file_size: ((1.5 * duration * 2_700_000.0 / 8.0) as u64 + (64 << 20)).max(if vulkan {
            VULKAN_FILES
        } else {
            0
        }),
        ..Limits::IMAGE
    }
}

/// The index of R1's pieces that FFmpeg's single-file HLS `playlist` lists, for a file of `size` bytes: the length
/// of its header, then each piece's offset, length and milliseconds, end to end to the last byte.
fn index(playlist: &str, size: u64) -> Option<Value> {
    let range = |text: &str| -> Option<(u64, u64)> {
        let (length, offset) = text.trim_matches('"').split_once('@')?;
        Some((length.parse().ok()?, offset.parse().ok()?))
    };
    let (mut init, mut pieces, mut ms) = (None, vec![], None);
    for line in playlist.lines() {
        if let Some(map) = line.strip_prefix("#EXT-X-MAP:") {
            let (length, 0) = range(map.split_once("BYTERANGE=")?.1)? else {
                return None;
            };
            init = Some(length);
        } else if let Some(seconds) = line.strip_prefix("#EXTINF:") {
            let seconds = seconds.trim_end_matches(',').parse::<f64>().ok()?;
            ms = u64::try_from(Duration::try_from_secs_f64(seconds + 0.0005).ok()?.as_millis()).ok();
        } else if let Some(text) = line.strip_prefix("#EXT-X-BYTERANGE:") {
            let (length, offset) = range(text)?;
            pieces.push([offset, length, ms.take()?]);
        }
    }
    let init = init?;
    let end = pieces.iter().try_fold(init, |at, [offset, length, _]| {
        at.checked_add(*length).filter(|_| *offset == at)
    })?;
    (end == size && !pieces.is_empty()).then(|| json!({"init": init, "pieces": pieces}))
}

fn words(text: &str) -> Vec<String> {
    text.split_whitespace().map(String::from).collect()
}

/// The filters that turn the picture into `frame`: deinterlaced, upright (FFmpeg applies the display matrix),
/// limited-range 4:2:0 BT.709 with square pixels, tone-mapped if HDR after scaling, which keeps zimg's float frames
/// small.
fn picture(conversion: &Conversion, (width, height): (u32, u32)) -> String {
    let colour = &conversion.colour;
    format!(
        "bwdif=mode=send_frame:deint=interlaced,scale={width}:{height}:out_range=tv,{colour},format=yuv420p,setsar=1"
    )
}

/// What the ladder needs to know of a video, kept in R1's render spec so that a rung starts without probing it.
#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub struct Source {
    /// The picture's width as shown.
    pub width: u32,
    /// The picture's height as shown.
    pub height: u32,
    /// Seconds of picture.
    pub duration: f64,
    /// Its average frame rate, as ffprobe writes it.
    pub rate: String,
    /// PQ, HLG or Dolby Vision.
    pub hdr: bool,
    /// How its HDR is signalled, for the tone mapping; rows rendered before ADR-0390 have none.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub tone: Option<Tone>,
    /// Whether it has sound.
    pub audio: bool,
    /// Its picture's codec as ffprobe names it, and as HLS says it (`hvc1.2.4.L153.B0`, `av01.0.08M.10`); empty when
    /// the picture cannot be copied into HLS pieces. Rows rendered before ADR-0390 have neither.
    #[serde(default)]
    pub codec: String,
    #[serde(default)]
    /// The video's codec string for an HLS playlist.
    pub hls_codec: String,
    /// Whether its sound is AAC-LC, which HLS pieces take as it is.
    #[serde(default)]
    pub audio_lc: bool,
}

impl Source {
    /// How its HDR picture reaches an HDR display as it is, when it can: PQ or HLG (Dolby Vision's base layers
    /// included) in a codec HLS carries.
    pub fn hdr_range(&self) -> Option<&'static str> {
        match self.hdr_tone()?.transfer {
            Transfer::Pq if !self.hls_codec.is_empty() => Some("PQ"),
            Transfer::Hlg if !self.hls_codec.is_empty() => Some("HLG"),
            _ => None,
        }
    }

    /// How its HDR is signalled, None for SDR; a row that has only the flag is taken as HDR10 with blank colours.
    pub fn hdr_tone(&self) -> Option<Tone> {
        self.hdr.then(|| {
            (self.tone.clone()).unwrap_or(Tone {
                transfer: Transfer::Pq,
                primaries: String::new(),
                matrix: String::new(),
                range: String::new(),
            })
        })
    }
}

/// The codec of `video` as an HLS playlist says it, for the pictures this copies: HEVC Main 10 (`hvc1`, which Apple's
/// players need) and AV1 Main at 8 or 10 bits; empty for anything else.
fn hls_codec(video: &Stream) -> String {
    let bits = if video.pix_fmt.contains("10") { 10 } else { 8 };
    match (video.codec_name.as_str(), video.profile.as_str()) {
        ("hevc", "Main 10") if video.level > 0 => format!("hvc1.2.4.L{}.B0", video.level),
        ("av1", "Main") if (0..=31).contains(&video.level) => format!("av01.0.{:02}M.{bits:02}", video.level),
        _ => String::new(),
    }
}

/// What ffprobe says about a file.
#[derive(Debug, Default, Deserialize)]
pub struct Probe {
    #[serde(default)]
    streams: Vec<Stream>,
    #[serde(default)]
    format: Format,
}

#[derive(Debug, Default, Deserialize)]
#[serde(default)]
struct Stream {
    codec_type: String,
    codec_name: String,
    profile: String,
    level: i32,
    pix_fmt: String,
    width: u32,
    height: u32,
    sample_aspect_ratio: String,
    color_transfer: String,
    color_primaries: String,
    color_space: String,
    color_range: String,
    field_order: String,
    avg_frame_rate: String,
    duration: String,
    disposition: Disposition,
    side_data_list: Vec<SideData>,
}

#[derive(Debug, Default, Deserialize)]
#[serde(default)]
struct Disposition {
    attached_pic: u8,
}

#[derive(Debug, Default, Deserialize)]
#[serde(default)]
struct SideData {
    #[serde(rename = "side_data_type")]
    kind: String,
    rotation: f64,
    dv_profile: u32,
    dv_bl_signal_compatibility_id: u32,
}

#[derive(Debug, Default, Deserialize)]
#[serde(default)]
struct Format {
    duration: String,
    bit_rate: String,
}

impl Probe {
    /// The picture: the first video stream that is not cover art.
    fn video(&self) -> Option<&Stream> {
        (self.streams.iter()).find(|s| s.codec_type == "video" && s.disposition.attached_pic == 0)
    }

    fn audio(&self) -> Option<&Stream> {
        self.streams.iter().find(|s| s.codec_type == "audio")
    }

    /// Seconds, 0 when the container does not say.
    pub fn duration(&self) -> f64 {
        self.format.duration.parse().unwrap_or(0.0)
    }

    /// The picture as shown: square pixels, turned by its display matrix.
    fn size(&self) -> (u32, u32) {
        let Some(video) = self.video() else {
            return (0, 0);
        };
        let aspect = ratio(&video.sample_aspect_ratio, ':').unwrap_or(1.0);
        let width = (f64::from(video.width) * aspect).round() as u32;
        match self.turns() % 2 {
            0 => (width, video.height),
            _ => (video.height, width),
        }
    }

    /// Quarter turns of the display matrix.
    fn turns(&self) -> i64 {
        let rotation = (self.video().into_iter())
            .flat_map(|v| &v.side_data_list)
            .find(|d| d.kind == "Display Matrix")
            .map_or(0.0, |d| d.rotation);
        ((rotation / 90.0).round() as i64).rem_euclid(4)
    }

    /// PQ, HLG or Dolby Vision.
    fn hdr(&self) -> bool {
        self.tone().is_some()
    }

    /// How the picture's HDR is signalled, None for SDR. The transfer says it; failing that, Dolby Vision's base layer
    /// does: profile 8.1 is HDR10, 8.4 HLG, 8.2 SDR, and profile 5 (no compatibility) its own IPT-PQ-c2.
    fn tone(&self) -> Option<Tone> {
        let video = self.video()?;
        let dolby = (video.side_data_list.iter()).find(|d| d.kind == "DOVI configuration record");
        let transfer = match (video.color_transfer.as_str(), dolby) {
            ("smpte2084", _) => Transfer::Pq,
            ("arib-std-b67", _) => Transfer::Hlg,
            (_, Some(d)) => match (d.dv_profile, d.dv_bl_signal_compatibility_id) {
                (_, 1 | 6) => Transfer::Pq,
                (_, 4) => Transfer::Hlg,
                (_, 2) => return None,
                _ => Transfer::Dv5,
            },
            _ => return None,
        };
        Some(Tone {
            transfer,
            primaries: video.color_primaries.clone(),
            matrix: video.color_space.clone(),
            range: video.color_range.clone(),
        })
    }

    /// The facts the ladder needs; the picture lasts as long as its stream says, else as the file.
    fn source(&self) -> Source {
        let (width, height) = self.size();
        let video = self.video().map(|v| v.duration.parse::<f64>().unwrap_or(0.0));
        Source {
            width,
            height,
            duration: video.filter(|d| *d > 0.0).unwrap_or_else(|| self.duration()),
            rate: self.video().map(|v| v.avg_frame_rate.clone()).unwrap_or_default(),
            hdr: self.hdr(),
            tone: self.tone(),
            audio: self.audio().is_some(),
            codec: self.video().map(|v| v.codec_name.clone()).unwrap_or_default(),
            hls_codec: self.video().map(hls_codec).unwrap_or_default(),
            audio_lc: self.audio().is_some_and(|a| a.codec_name == "aac" && a.profile == "LC"),
        }
    }

    /// Average frames per second, 0 when unknown.
    fn fps(&self) -> f64 {
        self.video().and_then(|v| ratio(&v.avg_frame_rate, '/')).unwrap_or(0.0)
    }
}

/// `n<separator>d` as a number, when both are and it is neither 0 nor infinite.
pub(crate) fn ratio(text: &str, separator: char) -> Option<f64> {
    let (n, d) = text.split_once(separator)?;
    Some(n.parse::<f64>().ok()? / d.parse::<f64>().ok()?).filter(|r| r.is_normal())
}

/// Whether a video in `mime` meets the baseline every browser and player decodes (docs/08 §5.1): H.264 High at most
/// level 4.1, 8-bit 4:2:0, SDR, progressive, at most 1080p, 60 fps and 5 Mb/s, with AAC-LC, MP3 or no audio, in MP4 or
/// MOV. Otherwise, the first rule it breaks.
pub fn plays_everywhere(probe: &Probe, mime: &str) -> Result<(), &'static str> {
    let video = probe.video().ok_or("no video")?;
    let (width, height) = probe.size();
    let rules = [
        (["video/mp4", "video/quicktime"].contains(&mime), "container"),
        (video.codec_name == "h264", "codec"),
        (
            ["Constrained Baseline", "Baseline", "Main", "High"].contains(&video.profile.as_str()),
            "profile",
        ),
        ((1..=41).contains(&video.level), "level"),
        (
            ["yuv420p", "yuvj420p"].contains(&video.pix_fmt.as_str()),
            "pixel format",
        ),
        (!probe.hdr(), "hdr"),
        (width.max(height) <= 1920 && width.min(height) <= 1080, "size"),
        (probe.fps() <= 60.0, "frame rate"),
        (probe.format.bit_rate.parse().unwrap_or(0) <= 5_000_000, "bit rate"),
        (
            ["progressive", "unknown", ""].contains(&video.field_order.as_str()),
            "interlaced",
        ),
        (
            probe
                .audio()
                .is_none_or(|a| (a.codec_name == "aac" && a.profile == "LC") || a.codec_name == "mp3"),
            "audio",
        ),
    ];
    match rules.into_iter().find(|(met, _)| !met) {
        Some((_, broken)) => Err(broken),
        None => Ok(()),
    }
}

/// `size` scaled down, never up, to a short side of at most `short` and a long side of at most `long`, in even
/// pixels as 4:2:0 pictures need.
pub(crate) fn fit((width, height): (u32, u32), short: u32, long: u32) -> (u32, u32) {
    let scale = (f64::from(short) / f64::from(width.min(height)))
        .min(f64::from(long) / f64::from(width.max(height)))
        .min(1.0);
    let scaled = |side: u32| ((f64::from(side) * scale / 2.0).round() as u32 * 2).max(2);
    (scaled(width), scaled(height))
}

#[cfg(test)]
mod tests {
    use serde_json::{Value, json};

    use super::*;

    type Edit = fn(&mut Value);

    /// A 1080p H.264 High 4.0 MP4 with AAC-LC audio, at 30 fps and 4 Mb/s, changed by `edit`.
    fn probe(edit: impl FnOnce(&mut Value)) -> Probe {
        let mut probe = json!({
            "streams": [
                {"codec_type": "video", "codec_name": "h264", "profile": "High", "level": 40, "pix_fmt": "yuv420p",
                 "width": 1920, "height": 1080, "color_transfer": "bt709", "field_order": "progressive",
                 "avg_frame_rate": "30000/1001"},
                {"codec_type": "audio", "codec_name": "aac", "profile": "LC"}
            ],
            "format": {"duration": "3.000000", "bit_rate": "4000000"}
        });
        edit(&mut probe);
        serde_json::from_value(probe).unwrap()
    }

    #[test]
    fn only_the_baseline_plays_everywhere() {
        let mp4 = "video/mp4";
        assert_eq!(plays_everywhere(&probe(|_| {}), mp4), Ok(()));
        assert_eq!(plays_everywhere(&probe(|_| {}), "video/quicktime"), Ok(()));
        let cases: [(&str, Edit, &str); 17] = [
            ("video/webm", |_| {}, "container"),
            (mp4, |p| p["streams"][0]["codec_name"] = json!("hevc"), "codec"),
            (mp4, |p| p["streams"][0]["profile"] = json!("High 10"), "profile"),
            (mp4, |p| p["streams"][0]["level"] = json!(42), "level"),
            (mp4, |p| p["streams"][0]["level"] = json!(-99), "level"),
            (mp4, |p| p["streams"][0]["pix_fmt"] = json!("yuv422p"), "pixel format"),
            (
                mp4,
                |p| p["streams"][0]["color_transfer"] = json!("arib-std-b67"),
                "hdr",
            ),
            (mp4, |p| p["streams"][0]["color_transfer"] = json!("smpte2084"), "hdr"),
            (
                mp4,
                |p| p["streams"][0]["side_data_list"] = json!([{"side_data_type": "DOVI configuration record"}]),
                "hdr",
            ),
            (mp4, |p| p["streams"][0]["width"] = json!(1922), "size"),
            (mp4, |p| p["streams"][0]["height"] = json!(1082), "size"),
            (
                mp4,
                |p| p["streams"][0]["avg_frame_rate"] = json!("120/1"),
                "frame rate",
            ),
            (mp4, |p| p["format"]["bit_rate"] = json!("5000001"), "bit rate"),
            (mp4, |p| p["streams"][0]["field_order"] = json!("tt"), "interlaced"),
            (mp4, |p| p["streams"][1]["codec_name"] = json!("pcm_s16le"), "audio"),
            (mp4, |p| p["streams"][1]["profile"] = json!("HE-AAC"), "audio"),
            (mp4, |p| p["streams"] = json!([p["streams"][1]]), "no video"),
        ];
        for (mime, edit, reason) in cases {
            assert_eq!(plays_everywhere(&probe(edit), mime), Err(reason), "{reason}");
        }
        let fine: [Edit; 5] = [
            |p| p["streams"][0]["profile"] = json!("Constrained Baseline"),
            |p| p["streams"][0]["pix_fmt"] = json!("yuvj420p"),
            |p| p["streams"][1] = json!({"codec_type": "audio", "codec_name": "mp3"}),
            |p| p["streams"] = json!([p["streams"][0]]),
            // A portrait 1080p video, stored on its side with a display matrix.
            |p| {
                p["streams"][0]["side_data_list"] = json!([{"side_data_type": "Display Matrix", "rotation": -90}]);
                p["streams"][0]["width"] = json!(1080);
                p["streams"][0]["height"] = json!(1920);
            },
        ];
        for edit in fine {
            assert_eq!(plays_everywhere(&probe(edit), mp4), Ok(()));
        }
    }

    /// A DOVI configuration record of `profile` with `compat` as its base layer's signal compatibility.
    fn dolby(profile: u32, compat: u32) -> Value {
        json!([{"side_data_type": "DOVI configuration record", "dv_profile": profile,
                "dv_bl_signal_compatibility_id": compat}])
    }

    #[test]
    fn hdr_is_read_from_the_transfer_and_from_dolby_visions_signal_compatibility() {
        use crate::tone::Transfer::{Dv5, Hlg, Pq};
        let kind = |edit: Edit| probe(edit).tone().map(|tone| tone.transfer);
        assert_eq!(kind(|_| {}), None, "SDR");
        assert_eq!(
            kind(|p| p["streams"][0]["color_transfer"] = json!("smpte2084")),
            Some(Pq)
        );
        assert_eq!(
            kind(|p| p["streams"][0]["color_transfer"] = json!("arib-std-b67")),
            Some(Hlg)
        );
        // Profile 8.1 and 8.4 carry HDR10 and HLG in their base layer, tagged or not.
        assert_eq!(kind(|p| p["streams"][0]["side_data_list"] = dolby(8, 1)), Some(Pq));
        assert_eq!(kind(|p| p["streams"][0]["side_data_list"] = dolby(8, 4)), Some(Hlg));
        assert_eq!(kind(|p| p["streams"][0]["side_data_list"] = dolby(7, 6)), Some(Pq));
        let tagged = |p: &mut Value| {
            p["streams"][0]["color_transfer"] = json!("arib-std-b67");
            p["streams"][0]["side_data_list"] = dolby(8, 4);
        };
        assert_eq!(kind(tagged), Some(Hlg));
        // Profile 8.2's base layer is SDR, which plays as it is; profile 5 is neither SDR nor HDR10.
        assert_eq!(kind(|p| p["streams"][0]["side_data_list"] = dolby(8, 2)), None);
        let p5 = |p: &mut Value| {
            p["streams"][0]["color_transfer"] = json!("unknown");
            p["streams"][0]["side_data_list"] = dolby(5, 0);
        };
        assert_eq!(kind(p5), Some(Dv5));
        assert!(probe(p5).source().hdr);
    }

    #[test]
    fn only_hdr_pictures_hls_carries_as_they_are_are_offered_to_clients_that_show_hdr() {
        let range = |edit: &dyn Fn(&mut Value)| probe(|p| edit(p)).source().hdr_range();
        let hevc = |p: &mut Value| {
            p["streams"][0]["codec_name"] = json!("hevc");
            p["streams"][0]["profile"] = json!("Main 10");
            p["streams"][0]["level"] = json!(153);
            p["streams"][0]["pix_fmt"] = json!("yuv420p10le");
        };
        assert_eq!(
            probe(hevc).source().hdr_range(),
            None,
            "10-bit HEVC with no HDR transfer is SDR"
        );
        let pq = |p: &mut Value| {
            hevc(p);
            p["streams"][0]["color_transfer"] = json!("smpte2084");
        };
        let source = probe(pq).source();
        assert_eq!(
            (source.hls_codec.as_str(), source.hdr_range()),
            ("hvc1.2.4.L153.B0", Some("PQ"))
        );
        let hlg = |p: &mut Value| {
            hevc(p);
            p["streams"][0]["color_transfer"] = json!("arib-std-b67");
        };
        assert_eq!(range(&hlg), Some("HLG"));
        // Dolby Vision 8.4 is HLG to a player that has no Dolby Vision; profile 5 is no picture to copy.
        let dv84 = |p: &mut Value| {
            hevc(p);
            p["streams"][0]["side_data_list"] = dolby(8, 4);
        };
        assert_eq!(range(&dv84), Some("HLG"));
        let dv5 = |p: &mut Value| {
            hevc(p);
            p["streams"][0]["side_data_list"] = dolby(5, 0);
        };
        assert_eq!(range(&dv5), None);
        // Codecs this does not put into HLS pieces, and 8-bit HEVC, are not offered, nor is SDR.
        let vp9 = |p: &mut Value| {
            pq(p);
            p["streams"][0]["codec_name"] = json!("vp9");
        };
        assert_eq!(range(&vp9), None);
        let main = |p: &mut Value| {
            pq(p);
            p["streams"][0]["profile"] = json!("Main");
        };
        assert_eq!(range(&main), None);
        let av1 = |p: &mut Value| {
            p["streams"][0]["codec_name"] = json!("av1");
            p["streams"][0]["profile"] = json!("Main");
            p["streams"][0]["level"] = json!(8);
            p["streams"][0]["pix_fmt"] = json!("yuv420p10le");
            p["streams"][0]["color_transfer"] = json!("smpte2084");
        };
        assert_eq!(probe(av1).source().hls_codec, "av01.0.08M.10");
        assert_eq!(range(&|_| {}), None);
        // A row rendered before the codecs were kept offers nothing.
        let old: Source = serde_json::from_value(
            json!({"width": 2, "height": 2, "duration": 1.0, "rate": "30/1", "hdr": true, "audio": false}),
        )
        .unwrap();
        assert_eq!(old.hdr_range(), None);
    }

    #[test]
    fn the_colours_a_file_says_travel_with_its_hdr_and_what_it_leaves_out_is_blank() {
        let said = probe(|p| {
            p["streams"][0]["color_transfer"] = json!("smpte2084");
            p["streams"][0]["color_primaries"] = json!("bt2020");
            p["streams"][0]["color_space"] = json!("bt2020nc");
            p["streams"][0]["color_range"] = json!("tv");
        })
        .tone()
        .unwrap();
        assert_eq!(
            (&said.primaries[..], &said.matrix[..], &said.range[..]),
            ("bt2020", "bt2020nc", "tv")
        );
        let blank = probe(|p| p["streams"][0]["color_transfer"] = json!("smpte2084"))
            .tone()
            .unwrap();
        assert_eq!(
            (&blank.primaries[..], &blank.matrix[..], &blank.range[..]),
            ("", "", "")
        );
        let source = probe(|p| p["streams"][0]["color_transfer"] = json!("smpte2084")).source();
        assert_eq!(source.tone, Some(blank));
        // Rows rendered before the colours were kept have a flag only.
        let old: Source = serde_json::from_value(
            json!({"width": 2, "height": 2, "duration": 1.0, "rate": "30/1", "hdr": true, "audio": false}),
        )
        .unwrap();
        assert_eq!(old.tone, None);
        assert!(old.hdr);
    }

    #[test]
    fn r1_keeps_the_index_of_its_pieces_only_when_they_cover_the_file_end_to_end() {
        let playlist = "#EXTM3U\n#EXT-X-MAP:URI=\"proxy.mp4\",BYTERANGE=\"1351@0\"\n#EXTINF:2.000000,\n\
                        #EXT-X-BYTERANGE:1000@1351\nproxy.mp4\n#EXTINF:0.533333,\n#EXT-X-BYTERANGE:500@2351\n\
                        proxy.mp4\n#EXT-X-ENDLIST\n";
        let index = json!({"init": 1351, "pieces": [[1351, 1000, 2000], [2351, 500, 533]]});
        assert_eq!(super::index(playlist, 2851), Some(index));
        for size in [2850, 2852] {
            assert_eq!(super::index(playlist, size), None, "a file of {size} bytes");
        }
        let gap = playlist.replace("500@2351", "500@2352");
        assert_eq!(super::index(&gap, 2852), None, "a gap between pieces");
        let late = playlist.replace("1351@0", "1351@1");
        assert_eq!(super::index(&late, 2851), None, "a header that is not at the start");
        assert_eq!(
            super::index("#EXTM3U\n#EXT-X-MAP:URI=\"proxy.mp4\",BYTERANGE=\"1351@0\"\n", 1351),
            None
        );
    }

    #[test]
    fn renditions_fit_the_displayed_picture_and_are_never_upscaled() {
        assert_eq!(fit((1920, 1080), 720, u32::MAX), (1280, 720));
        assert_eq!(fit((1080, 1920), 720, u32::MAX), (720, 1280));
        assert_eq!(fit((3840, 1920), 256, 1024), (512, 256));
        assert_eq!(fit((7680, 1080), 256, 1024), (1024, 144));
        assert_eq!(fit((640, 480), 720, 2048), (640, 480));
        assert_eq!(fit((5312, 2988), 2160, 2160), (2160, 1216));
        assert_eq!(fit((1920, 1080), 256, 1024), (456, 256));
        let portrait = probe(|p| {
            p["streams"][0]["side_data_list"] = json!([{"side_data_type": "Display Matrix", "rotation": 90}]);
        });
        assert_eq!(portrait.size(), (1080, 1920));
        // PAL DV: 720 × 576 stored, 16:9 shown.
        let dv = probe(|p| {
            p["streams"][0]["width"] = json!(720);
            p["streams"][0]["height"] = json!(576);
            p["streams"][0]["sample_aspect_ratio"] = json!("64:45");
        });
        assert_eq!(dv.size(), (1024, 576));
    }
}
