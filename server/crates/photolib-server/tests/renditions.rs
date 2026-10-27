//! Image renditions (photolib-design docs/08 §4, ADR-0084): the sandboxed libvips renderer.

// Test pictures and file sizes are far smaller than the integers they are counted in.
#![allow(clippy::cast_possible_wrap, clippy::cast_precision_loss, clippy::cast_sign_loss)]

mod common;

use std::{
    path::{Path, PathBuf},
    sync::Arc,
    time::Duration,
};

use common::{ffmpeg, tools};
use photolib_db::{
    migrate::{Upgrade, embedded, upgrade},
    testpg,
};
use photolib_jobs::{
    Timing, Worker as JobWorker,
    reconcile::{Profile, reconcile},
};
use photolib_media::{
    Failure, Worker,
    render::{Format, Output, Rendered, Request},
};
use photolib_server::{
    edits::{FOLLOW, Follow},
    export::{EXPORT, Export},
    external::Libraries,
    ingest::{self, INGEST, Ingest},
    render::{self, RENDER, Render, Spec},
};
use photolib_storage::{
    Hash,
    fs::FsStore,
    journal::Journal,
    marker::{Candidate, Stores},
};
use serde_json::Value;
use tokio_util::sync::CancellationToken;
use uuid::Uuid;

const PHOTOLIBD: &str = env!("CARGO_BIN_EXE_photolibd");

fn corpus(path: &str) -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../../../testdata/corpus/files")
        .join(path)
}

fn fixture(name: &str) -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR")).join("tests/fixtures").join(name)
}

fn output(file: &str, format: Format, short: u32, long: u32, quality: u8, wide: bool) -> Output {
    Output {
        file: file.into(),
        format,
        short,
        long,
        quality,
        wide,
    }
}

/// The rendition set of docs/08 §4.1: `thumb_s`, `thumb_m` and `preview`.
fn set() -> Vec<Output> {
    vec![
        output("s", Format::Webp, 256, 1024, 70, false),
        output("m", Format::Webp, 720, 2048, 75, false),
        output("p", Format::Jpeg, 0, 2160, 85, true),
    ]
}

/// Renders `data` as `mime` in a sandboxed child; returns its answer and the bytes of each output.
async fn render(
    data: &[u8],
    mime: &str,
    orientation: Option<u8>,
    outputs: Vec<Output>,
) -> (Result<Rendered, Failure>, Vec<Vec<u8>>) {
    let dir = tempfile::tempdir_in(env!("CARGO_TARGET_TMPDIR")).unwrap();
    let (input, out) = (dir.path().join("in"), dir.path().join("out"));
    std::fs::create_dir_all(&input).unwrap();
    std::fs::create_dir_all(&out).unwrap();
    std::fs::write(input.join("original"), data).unwrap();
    let mut worker = Worker::renderer(PHOTOLIBD.into(), input.clone(), out.clone());
    let request = Request {
        input: input.join("original"),
        mime: mime.into(),
        orientation,
        edit: None,
        outputs: outputs.clone(),
    };
    let rendered = worker.render(&request).await;
    let files = (outputs.iter())
        .map(|o| std::fs::read(out.join(&o.file)).unwrap_or_default())
        .collect();
    (rendered, files)
}

async fn render_file(path: &Path, mime: &str, outputs: Vec<Output>) -> (Result<Rendered, Failure>, Vec<Vec<u8>>) {
    render(&std::fs::read(path).unwrap(), mime, None, outputs).await
}

/// A JPEG's marker segments before its scan: (marker, payload).
fn segments(jpeg: &[u8]) -> Vec<(u8, Vec<u8>)> {
    assert!(jpeg.starts_with(&[0xff, 0xd8]), "not a JPEG");
    let (mut at, mut found) = (2, vec![]);
    while jpeg[at] == 0xff && jpeg[at + 1] != 0xda {
        let length = u16::from_be_bytes([jpeg[at + 2], jpeg[at + 3]]) as usize;
        found.push((jpeg[at + 1], jpeg[at + 4..at + 2 + length].to_vec()));
        at += 2 + length;
    }
    found
}

/// A WebP's chunk types.
fn chunks(webp: &[u8]) -> Vec<String> {
    assert!(webp.starts_with(b"RIFF") && &webp[8..12] == b"WEBP", "not a WebP");
    let (mut at, mut found) = (12, vec![]);
    while at + 8 <= webp.len() {
        let size = u32::from_le_bytes(webp[at + 4..at + 8].try_into().unwrap()) as usize;
        found.push(String::from_utf8_lossy(&webp[at..at + 4]).into_owned());
        at += 8 + size + size % 2;
    }
    found
}

/// `jpeg` with an XMP packet (APP1) and IPTC (APP13) after its start, as cameras and editors write them.
fn with_xmp_and_iptc(jpeg: &[u8]) -> Vec<u8> {
    let segment = |marker: u8, payload: &[u8]| {
        let mut bytes = vec![0xff, marker];
        bytes.extend(((payload.len() + 2) as u16).to_be_bytes());
        bytes.extend(payload);
        bytes
    };
    let xmp = b"http://ns.adobe.com/xap/1.0/\0<x:xmpmeta xmlns:x='adobe:ns:meta/'><rdf:RDF \
        xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'><rdf:Description \
        xmlns:exif='http://ns.adobe.com/exif/1.0/' exif:GPSLatitude='33,52.0S'/></rdf:RDF></x:xmpmeta>";
    let iptc = b"Photoshop 3.0\08BIM\x04\x04\0\0\0\0\0\x0e\x1c\x02\x5a\0\x06Sydney\0";
    [&jpeg[..2], &segment(0xe1, xmp), &segment(0xed, iptc), &jpeg[2..]].concat()
}

#[tokio::test]
async fn a_12_mp_jpeg_becomes_webp_thumbnails_a_jpeg_preview_and_a_thumbhash() {
    let (rendered, files) = render_file(&corpus("compound/edited/IMG_E3001.JPG"), "image/jpeg", set()).await;
    let rendered = rendered.unwrap();
    assert_eq!(
        rendered.outputs,
        [
            (Format::Webp, 341, 256),
            (Format::Webp, 960, 720),
            (Format::Jpeg, 2160, 1620)
        ]
    );
    assert_eq!(chunks(&files[0])[0], "VP8 ");
    assert_eq!(chunks(&files[1])[0], "VP8 ");
    assert!(files[2].starts_with(&[0xff, 0xd8, 0xff]));
    let ratio = thumbhash::thumb_hash_to_approximate_aspect_ratio(&rendered.thumbhash).unwrap();
    assert!((ratio - 4.0 / 3.0).abs() < 0.1, "{ratio}");
}

/// An Ultra HDR JPEG's preview keeps its gain map (ADR-0390), scaled with the picture and described by an XMP that
/// holds only the gain map's own metadata; the WebP thumbnails, which cannot carry one, show the SDR picture, and a
/// JPEG without a map gets none.
#[tokio::test]
async fn an_ultra_hdr_preview_keeps_its_scaled_gain_map() {
    let (rendered, files) = render_file(&corpus("hdr/ultra-hdr.jpg"), "image/jpeg", set()).await;
    assert_eq!(rendered.unwrap().outputs[2], (Format::Jpeg, 2160, 1620));
    let preview = &files[2];
    if let Some(review) = std::env::var_os("PHOTOLIB_HDR_REVIEW") {
        // For `ultrahdr_app -m 1`, libultrahdr's own decoder, which docs/dev/hdr.md has read the preview with.
        std::fs::create_dir_all(&review).unwrap();
        std::fs::write(Path::new(&review).join("ultra-hdr-preview.jpg"), preview).unwrap();
    }
    let parts = segments(preview);
    let xmp = parts
        .iter()
        .find(|(marker, payload)| *marker == 0xe1 && payload.starts_with(b"http://ns.adobe.com/xap/1.0/\0"))
        .expect("the preview says it has a gain map");
    let xmp = String::from_utf8_lossy(&xmp.1).into_owned();
    assert!(xmp.contains("hdrgm:Version=\"1.0\""), "{xmp}");
    assert!(
        parts
            .iter()
            .any(|(marker, payload)| *marker == 0xe2 && payload.starts_with(b"MPF\0"))
    );
    let file = tempfile::NamedTempFile::new_in(env!("CARGO_TARGET_TMPDIR")).unwrap();
    std::fs::write(file.path(), preview).unwrap();
    let map = photolib_media::gainmap::read(file.path()).expect("the preview's gain map reads back");
    assert!(
        xmp.contains(&format!(
            "Item:Semantic=\"GainMap\" Item:Length=\"{}\"",
            map.image.len()
        )),
        "{xmp}"
    );
    // 1,008 × 756 beside the 4,032 × 3,024 picture, so 540 × 405 beside 2,160 × 1,620.
    let size = photolib_media::probe::probe(&map.image, u64::MAX).unwrap();
    assert_eq!((size.width, size.height), (540, 405));
    let (first, last) = (preview.len() - map.image.len(), preview.len());
    assert_eq!(&preview[first..last], &map.image[..]);
    for thumbnail in &files[..2] {
        assert!(
            !thumbnail.windows(7).any(|w| w == b"hdrgm:V"),
            "a WebP thumbnail has no gain map"
        );
    }
    let (_, plain) = render_file(&corpus("stills/baseline.jpg"), "image/jpeg", set()).await;
    assert!(
        !segments(&plain[2])
            .iter()
            .any(|(marker, payload)| *marker == 0xe2 && payload.starts_with(b"MPF\0")),
        "a picture without a gain map gets none"
    );
}

/// How a HEIC carries its gain map.
#[derive(Clone, Copy, PartialEq)]
enum Maps {
    None,
    /// An auxiliary image of Apple's type and a maker note that says its strength.
    Apple,
    /// A `tmap` item of ISO 21496-1 that derives from the picture and the map, as Samsung's.
    Iso,
}

/// The metadata of a real Samsung HEIC's `tmap` item: 2.3 stops, one channel.
const SAMSUNG_TMAP: &str = "0000000000400000000000000001009333330040000000000000000000010093333300400000000000010000\
                            000100000000000000010000000000000001";

/// An EXIF item with Apple's maker note: tag 0x21 as 22307 / 25388, as a real phone's, and no tag 0x30.
fn apple_exif() -> Vec<u8> {
    let mut note = b"Apple iOS\0\0\x01MM\0\x01".to_vec();
    note.extend([0, 0x21, 0, 10, 0, 0, 0, 1]);
    note.extend((14u32 + 2 + 12 + 4).to_be_bytes());
    note.extend([0; 4]);
    note.extend(22307i32.to_be_bytes());
    note.extend(25388i32.to_be_bytes());
    let mut tiff = b"MM\0*\0\0\0\x08".to_vec();
    tiff.extend([0, 1, 0x87, 0x69, 0, 4, 0, 0, 0, 1, 0, 0, 0, 26, 0, 0, 0, 0]);
    tiff.extend([0, 1, 0x92, 0x7c, 0, 7]);
    tiff.extend((note.len() as u32).to_be_bytes());
    tiff.extend(44u32.to_be_bytes());
    tiff.extend([0; 4]);
    tiff.extend(note);
    [&6u32.to_be_bytes()[..], b"Exif\0\0", &tiff].concat()
}

// The boxes of a file in the order they sit, which reads best in one piece.
#[allow(clippy::too_many_lines)]
/// A HEIC of the picture in `primary` (Annex B HEVC, `size`) with the gain map in `map` (`map_size`) as `maps` says.
fn heic_with_map(primary: &[u8], size: (u32, u32), map: &[u8], map_size: (u32, u32), maps: Maps) -> Vec<u8> {
    let ispe = |(w, h): (u32, u32)| full(*b"ispe", 0, 0, &[w.to_be_bytes(), h.to_be_bytes()].concat());
    let ((hvcc, data), (map_hvcc, map_data)) = (hevc(primary), hevc(map));
    let mut props = vec![hvcc, ispe(size)];
    let mut items = vec![(1u16, *b"hvc1", vec![0x81u8, 2])];
    let mut mdat = vec![data];
    let mut idat = vec![];
    let mut refs = vec![];
    if maps != Maps::None {
        props.extend([map_hvcc, ispe(map_size)]);
        let mut listed = vec![0x83, 4];
        if maps == Maps::Apple {
            props.push(full(*b"auxC", 0, 0, b"urn:com:apple:photo:2020:aux:hdrgainmap\0"));
            listed.push(5);
        }
        items.push((2, *b"hvc1", listed));
        mdat.push(map_data);
    }
    // Item ids and where their bytes are: (id, construction method, offset in its store, length).
    let mut places: Vec<(u16, u8, usize, usize)> = vec![];
    match maps {
        Maps::Apple => {
            items.push((3, *b"Exif", vec![]));
            mdat.push(apple_exif());
            refs.push(boxed(*b"auxl", &[0, 2, 0, 1, 0, 1]));
            refs.push(boxed(*b"cdsc", &[0, 3, 0, 1, 0, 1]));
        }
        Maps::Iso => {
            items.push((3, *b"tmap", vec![]));
            let payload: Vec<u8> = (0..SAMSUNG_TMAP.len())
                .step_by(2)
                .map(|n| u8::from_str_radix(&SAMSUNG_TMAP[n..n + 2], 16).unwrap())
                .collect();
            idat = payload;
            refs.push(boxed(*b"dimg", &[0, 3, 0, 2, 0, 1, 0, 2]));
        }
        Maps::None => {}
    }
    let mut at = 0;
    for (n, bytes) in mdat.iter().enumerate() {
        let id = match (n, maps) {
            (0, _) => 1,
            (1, _) => 2,
            _ => 3,
        };
        places.push((id, 0, at, bytes.len()));
        at += bytes.len();
    }
    if maps == Maps::Iso {
        places.push((3, 1, 0, idat.len()));
    }
    let infos: Vec<u8> = (items.iter())
        .flat_map(|(id, kind, _)| full(*b"infe", 2, 0, &[&id.to_be_bytes()[..], &[0, 0], kind, &[0]].concat()))
        .collect();
    let associations: Vec<u8> = (items.iter())
        .filter(|(.., listed)| !listed.is_empty())
        .flat_map(|(id, _, listed)| [&id.to_be_bytes()[..], &[listed.len() as u8], listed].concat())
        .collect();
    let with_properties = items.iter().filter(|(.., listed)| !listed.is_empty()).count() as u32;
    let ftyp = boxed(*b"ftyp", b"heic\0\0\0\0mif1heic");
    let meta = |offset: u32| {
        let mut iloc = [&[0x44, 0][..], &(places.len() as u16).to_be_bytes()].concat();
        for (id, method, start, length) in &places {
            let start = if *method == 0 {
                offset + *start as u32
            } else {
                *start as u32
            };
            iloc.extend([&id.to_be_bytes()[..], &[0, *method, 0, 0, 0, 1]].concat());
            iloc.extend(start.to_be_bytes());
            iloc.extend((*length as u32).to_be_bytes());
        }
        let ipma = full(
            *b"ipma",
            0,
            0,
            &[&with_properties.to_be_bytes()[..], &associations].concat(),
        );
        let mut body = vec![
            full(*b"hdlr", 0, 0, &[&[0; 4][..], b"pict", &[0; 13]].concat()),
            full(*b"pitm", 0, 0, &1u16.to_be_bytes()),
            full(*b"iloc", 1, 0, &iloc),
            full(
                *b"iinf",
                0,
                0,
                &[&(items.len() as u16).to_be_bytes()[..], &infos].concat(),
            ),
            boxed(*b"iprp", &[boxed(*b"ipco", &props.concat()), ipma].concat()),
        ];
        if !refs.is_empty() {
            body.push(full(*b"iref", 0, 0, &refs.concat()));
        }
        if !idat.is_empty() {
            body.push(boxed(*b"idat", &idat));
        }
        full(*b"meta", 0, 0, &body.concat())
    };
    let offset = (ftyp.len() + meta(0).len() + 8) as u32;
    [ftyp, meta(offset), boxed(*b"mdat", &mdat.concat())].concat()
}

/// The pictures a HEIC with a gain map is made of: a test picture and a gradient, in HEVC.
fn hevc_pair(tools: &Path) -> (Vec<u8>, Vec<u8>) {
    let dir = tempfile::tempdir_in(env!("CARGO_TARGET_TMPDIR")).unwrap();
    let encode = |source: &str, name: &str| {
        let out = dir.path().join(name);
        let args = [
            "-f",
            "lavfi",
            "-i",
            source,
            "-frames:v",
            "1",
            "-threads",
            "1",
            "-c:v",
            "libkvazaar",
            "-kvazaar-params",
            "preset=ultrafast,threads=0",
            "-f",
            "hevc",
            out.to_str().unwrap(),
        ];
        ffmpeg(tools, &args);
        std::fs::read(out).unwrap()
    };
    (
        encode("testsrc2=s=256x192:r=1:d=1", "primary"),
        encode(
            "nullsrc=s=64x48:r=1:d=1,format=yuv420p,geq=lum_expr=X*4:cb_expr=128:cr_expr=128",
            "map",
        ),
    )
}

/// A HEIC's gain map survives into its JPEG preview (ADR-0390), as Apple's and as ISO 21496-1's, scaled with the
/// picture and told in both XMP and ISO 21496-1; without one the preview has none.
#[tokio::test]
async fn a_heic_previews_keep_their_gain_maps_apples_and_isos() {
    let tools = tools();
    let (primary, map) = hevc_pair(&tools);
    for (maps, stops) in [(Maps::Apple, "1.8"), (Maps::Iso, "2.29")] {
        let heic = heic_with_map(&primary, (256, 192), &map, (64, 48), maps);
        let (rendered, files) = render(&heic, "image/heic", None, set()).await;
        assert_eq!(rendered.unwrap().outputs[2], (Format::Jpeg, 256, 192));
        let preview = &files[2];
        let file = tempfile::NamedTempFile::new_in(env!("CARGO_TARGET_TMPDIR")).unwrap();
        std::fs::write(file.path(), preview).unwrap();
        let found = photolib_media::gainmap::read(file.path()).expect("the preview keeps its gain map");
        let size = photolib_media::probe::probe(&found.image, u64::MAX).unwrap();
        assert_eq!((size.width, size.height), (64, 48));
        let text = String::from_utf8_lossy(&found.image).into_owned();
        assert!(text.contains(&format!("hdrgm:GainMapMax=\"{stops}")), "{text:?}");
        assert!(found.image.windows(27).any(|w| w == b"urn:iso:std:iso:ts:21496:-1"));
        assert_eq!(found.carried.version.as_deref(), Some("1.0"));
        if std::env::var_os("PHOTOLIB_HDR_REVIEW").is_some() {
            let name = if maps == Maps::Apple { "apple" } else { "iso" };
            let dir = PathBuf::from(std::env::var_os("PHOTOLIB_HDR_REVIEW").unwrap());
            std::fs::write(dir.join(format!("heic-{name}-preview.jpg")), preview).unwrap();
        }
    }
    let plain = heic_with_map(&primary, (256, 192), &map, (64, 48), Maps::None);
    let (rendered, files) = render(&plain, "image/heic", None, set()).await;
    assert_eq!(rendered.unwrap().outputs[2], (Format::Jpeg, 256, 192));
    assert!(
        !segments(&files[2])
            .iter()
            .any(|(m, p)| *m == 0xe2 && p.starts_with(b"MPF\0"))
    );
}

/// The previews of real phones' HEIF files with gain maps, which the repository does not hold: every file in the
/// directory `PHOTOLIB_HEIF_SAMPLES` names renders, and its preview is written into `PHOTOLIB_HDR_REVIEW` for
/// libultrahdr's `ultrahdr_app -m 1` to decode. By hand: `docs/dev/hdr.md` says how.
#[tokio::test]
#[ignore = "reads the files of PHOTOLIB_HEIF_SAMPLES"]
async fn real_heif_files_keep_their_gain_maps_in_their_previews() {
    let samples = PathBuf::from(std::env::var_os("PHOTOLIB_HEIF_SAMPLES").expect("a directory of HEIF files"));
    let review = PathBuf::from(std::env::var_os("PHOTOLIB_HDR_REVIEW").expect("a directory for the previews"));
    std::fs::create_dir_all(&review).unwrap();
    let mut names: Vec<_> = std::fs::read_dir(&samples)
        .unwrap()
        .map(|e| e.unwrap().file_name())
        .collect();
    names.sort();
    for name in names {
        let path = samples.join(&name);
        let data = std::fs::read(&path).unwrap();
        let mime = ingest::sniff::sniff(&data[..data.len().min(4096)]).mime;
        let (rendered, files) = render(&data, mime, None, set()).await;
        let rendered = rendered.unwrap();
        let preview = &files[2];
        // A picture with transparency is a WebP, which has no gain map.
        let has_map = preview.starts_with(&[0xff, 0xd8])
            && segments(preview)
                .iter()
                .any(|(m, p)| *m == 0xe2 && p.starts_with(b"MPF\0"));
        let out = review.join(format!("{}.jpg", name.to_string_lossy()));
        std::fs::write(&out, preview).unwrap();
        let kind = if has_map { "gain map kept" } else { "SDR only" };
        eprintln!(
            "{}: {mime}, preview {:?}, {} bytes, {kind}",
            name.to_string_lossy(),
            rendered.outputs[2],
            preview.len()
        );
    }
}

/// Renditions carry colour information only (docs/08 §1.9): no EXIF, XMP, IPTC or GPS, whatever the source holds.
#[tokio::test]
async fn renditions_carry_no_exif_xmp_iptc_or_gps() {
    let tagged = with_xmp_and_iptc(&std::fs::read(corpus("stills/gps-sydney.jpg")).unwrap());
    let sources = [
        (tagged, "image/jpeg"),
        (std::fs::read(corpus("stills/exif-chunk.webp")).unwrap(), "image/webp"),
        (std::fs::read(corpus("stills/exif-chunk.png")).unwrap(), "image/png"),
        (std::fs::read(corpus("stills/xmp-itxt.png")).unwrap(), "image/png"),
    ];
    for (data, mime) in sources {
        let (rendered, files) = render(&data, mime, None, set()).await;
        assert!(rendered.is_ok(), "{mime}: {rendered:?}");
        for webp in &files[..2] {
            assert_eq!(chunks(webp), ["VP8 "], "{mime}");
        }
        let markers: Vec<u8> = segments(&files[2]).into_iter().map(|(marker, _)| marker).collect();
        assert!(
            markers.iter().all(|m| [0xdb, 0xc0, 0xc2, 0xc4, 0xdd].contains(m)),
            "{mime}: the preview has segments {markers:x?}"
        );
        for file in &files {
            for needle in [&b"Exif"[..], b"xmpmeta", b"8BIM", b"GPS", b"Sydney"] {
                assert!(!file.windows(needle.len()).any(|w| w == needle), "{mime}: {needle:?}");
            }
        }
    }
}

/// `rgba` (`width` pixels a row) shown as EXIF `orientation` says: the upright width and pixels.
fn orient(orientation: u8, width: usize, rgba: &[u8]) -> (usize, Vec<u8>) {
    let height = rgba.len() / 4 / width;
    let w = if orientation >= 5 { height } else { width };
    let (mw, mh) = (width - 1, height - 1);
    let upright = (0..rgba.len() / 4).flat_map(|i| {
        let (x, y) = (i % w, i / w);
        let (sx, sy) = match orientation {
            2 => (mw - x, y),
            3 => (mw - x, mh - y),
            4 => (x, mh - y),
            5 => (y, x),
            6 => (y, mh - x),
            7 => (mw - y, mh - x),
            8 => (mw - y, x),
            _ => (x, y),
        };
        rgba[(sy * width + sx) * 4..][..4].to_vec()
    });
    (w, upright.collect())
}

/// Of the eight ways to turn the `stored` rendition, the one that looks most like the `upright` one.
fn turned_by(upright: &Rendered, stored: &Rendered) -> Option<u8> {
    let (w, h, want) = thumbhash::thumb_hash_to_rgba(&upright.thumbhash).unwrap();
    let (sw, _, pixels) = thumbhash::thumb_hash_to_rgba(&stored.thumbhash).unwrap();
    let distance = |o: u8| match orient(o, sw, &pixels) {
        (tw, turned) if tw == w && turned.len() == w * h * 4 => turned
            .iter()
            .zip(&want)
            .map(|(a, b)| a.abs_diff(*b) as u32)
            .sum::<u32>(),
        _ => u32::MAX,
    };
    (1..=8).min_by_key(|&o| distance(o))
}

/// EXIF orientation is applied exactly once: of the eight ways to turn the stored picture, the tag's matches best.
#[tokio::test]
async fn exif_orientation_is_applied_exactly_once() {
    let thumb = || vec![output("s", Format::Webp, 256, 1024, 70, false)];
    for n in 2..=8u8 {
        let data = std::fs::read(corpus(&format!("compound/orientation/orientation-{n}.jpg"))).unwrap();
        let (upright, _) = render(&data, "image/jpeg", None, thumb()).await;
        let (stored, _) = render(&data, "image/jpeg", Some(1), thumb()).await;
        let (upright, stored) = (upright.unwrap(), stored.unwrap());
        let size = if n >= 5 { (256, 341) } else { (341, 256) };
        assert_eq!(upright.outputs, [(Format::Webp, size.0, size.1)], "orientation {n}");
        assert_eq!(turned_by(&upright, &stored), Some(n), "orientation {n}");
    }
}

/// Every RAW of the media corpus, rendered as ingest has it rendered (its sniffed type, the orientation the kernel
/// reads), shows its embedded JPEG upright and in colour, never its sensor data, which is greyscale in the corpus.
#[tokio::test]
async fn every_corpus_raw_renders_upright_and_in_colour() {
    let raws: Vec<_> = (records().into_iter())
        .filter(|r| {
            ["cr2", "cr3", "nef", "arw", "orf", "rw2", "pef", "raf", "dng"].contains(&r["format"].as_str().unwrap())
        })
        .collect();
    let formats: std::collections::BTreeSet<_> = raws.iter().map(|r| r["format"].as_str().unwrap()).collect();
    assert_eq!(formats.len(), 9, "{formats:?}");
    let thumb = || vec![output("s", Format::Webp, 256, 1024, 70, false)];
    for path in raws.iter().map(|r| r["path"].as_str().unwrap()) {
        let data = std::fs::read(corpus(path)).unwrap();
        let mime = ingest::sniff::sniff(&data).mime;
        let file = std::fs::File::open(corpus(path)).unwrap();
        let extracted = ingest::extract::extract(&file, data.len() as u64, path, 0).unwrap();
        let orientation = Some(extracted.metadata.orientation as u8)
            .filter(|&o| o > 0)
            .unwrap_or(1);
        let (upright, _) = render(&data, mime, Some(orientation), thumb()).await;
        let (stored, _) = render(&data, mime, Some(1), thumb()).await;
        let (upright, stored) = (upright.unwrap(), stored.unwrap());
        let size = if orientation >= 5 { (120, 160) } else { (160, 120) };
        assert_eq!(upright.outputs, [(Format::Webp, size.0, size.1)], "{path}");
        assert_eq!(turned_by(&upright, &stored), Some(orientation), "{path}");
        let (_, _, rgba) = thumbhash::thumb_hash_to_rgba(&upright.thumbhash).unwrap();
        let chroma = rgba
            .chunks(4)
            .map(|p| p[..3].iter().max().unwrap() - p[..3].iter().min().unwrap());
        assert!(chroma.max().unwrap() > 64, "{path}: no colour");
    }
}

/// HEIC, AVIF and JPEG XL decode with libheif and libjxl; a RAW shows its largest embedded JPEG (its preview), with
/// the RAW's orientation, never a smaller thumbnail; nothing is ever enlarged.
#[tokio::test]
async fn heic_avif_jpeg_xl_and_raw_previews_render() {
    for (file, mime) in [
        ("photo.heic", "image/heic"),
        ("photo.avif", "image/avif"),
        ("photo.jxl", "image/jxl"),
    ] {
        let (rendered, _) = render_file(&fixture(file), mime, set()).await;
        assert_eq!(
            rendered.unwrap().outputs,
            [
                (Format::Webp, 320, 240),
                (Format::Webp, 320, 240),
                (Format::Jpeg, 320, 240)
            ],
            "{file}"
        );
    }
    let preview = std::fs::read(corpus("compound/edited/IMG_E3001.JPG")).unwrap();
    let thumbnail = std::fs::read(corpus("raw/sony.arw")).unwrap();
    let raw = [&thumbnail[..], &preview].concat();
    let (rendered, _) = render(&raw, "image/x-sony-arw", Some(6), set()).await;
    assert_eq!(rendered.unwrap().outputs[2], (Format::Jpeg, 1620, 2160));
}

/// Thumbnails are sRGB without a profile; a preview keeps a wide-gamut source as Display P3 with its profile, and
/// converts CMYK.
#[tokio::test]
async fn previews_keep_a_wide_gamut_and_thumbnails_are_srgb() {
    let (rendered, files) = render_file(&fixture("wide.jpg"), "image/jpeg", set()).await;
    assert!(rendered.is_ok(), "{rendered:?}");
    assert_eq!(chunks(&files[0]), ["VP8 "]);
    let icc: Vec<u8> = (segments(&files[2]).into_iter())
        .filter(|(marker, payload)| *marker == 0xe2 && payload.starts_with(b"ICC_PROFILE\0"))
        .flat_map(|(_, payload)| payload[14..].to_vec())
        .collect();
    // libvips' Display P3 profile, described in UTF-16 as "sP3C".
    assert!(
        icc.windows(4).any(|w| w == [0, b'P', 0, b'3']),
        "the preview's profile is Display P3"
    );
    let (rendered, files) = render_file(&corpus("stills/gps-sydney.jpg"), "image/jpeg", set()).await;
    assert!(rendered.is_ok());
    assert!(
        segments(&files[2]).iter().all(|(marker, _)| *marker != 0xe2),
        "an sRGB preview has no profile"
    );
    let (rendered, files) = render_file(&corpus("stills/cmyk.jpg"), "image/jpeg", set()).await;
    assert_eq!(rendered.unwrap().outputs[2], (Format::Jpeg, 320, 240));
    assert!(
        segments(&files[2])
            .iter()
            .any(|(marker, payload)| *marker == 0xc0 && payload[5] == 3),
        "YCbCr"
    );
}

/// Whether a ThumbHash shows the corpus picture, colour or grey bars under a dark band, rather than one flat tone.
fn shows_a_picture(thumbhash: &[u8]) -> bool {
    let (_, _, rgba) = thumbhash::thumb_hash_to_rgba(thumbhash).unwrap();
    let luma = rgba
        .chunks(4)
        .map(|p| (u32::from(p[0]) * 3 + u32::from(p[1]) * 6 + u32::from(p[2])) / 10);
    let (low, high) = luma.fold((u32::MAX, 0), |(l, h), y| (l.min(y), h.max(y)));
    high - low > 64
}

/// A decompression bomb is refused on its header, before anything decodes it; formats without a renderer are
/// unsupported, and an image with alpha gets a WebP preview.
#[tokio::test]
async fn bombs_are_refused_before_decoding_and_alpha_keeps_its_transparency() {
    let mut bomb = std::fs::read(corpus("stills/gps-sydney.jpg")).unwrap();
    let sof = bomb.windows(2).position(|w| w == [0xff, 0xc0]).unwrap();
    bomb[sof + 5..sof + 9].copy_from_slice(&[0x75, 0x30, 0x75, 0x30]);
    let (rendered, files) = render(&bomb, "image/jpeg", None, set()).await;
    assert!(matches!(rendered, Err(Failure::LimitExceeded(_))), "{rendered:?}");
    assert!(files.iter().all(Vec::is_empty));
    let mut psd = std::fs::read(corpus("stills/layered.psd")).unwrap();
    psd[14..22].copy_from_slice(&[0, 0, 0x75, 0x30, 0, 0, 0x75, 0x30]);
    let (rendered, _) = render(&psd, "image/vnd.adobe.photoshop", None, set()).await;
    assert!(matches!(rendered, Err(Failure::LimitExceeded(_))), "{rendered:?}");
    let (rendered, _) = render_file(&corpus("stills/vector.svg"), "image/svg+xml", set()).await;
    assert!(matches!(rendered, Err(Failure::Unsupported(_))), "{rendered:?}");
    let (rendered, files) = render_file(&corpus("stills/rgba.png"), "image/png", set()).await;
    assert_eq!(rendered.unwrap().outputs[2].0, Format::Webp);
    assert!(chunks(&files[2]).contains(&"ALPH".to_string()));
}

/// The golden records of the media corpus.
fn records() -> Vec<Value> {
    let mut found = vec![];
    let mut dirs = vec![corpus("../golden")];
    while let Some(dir) = dirs.pop() {
        for entry in std::fs::read_dir(dir).unwrap() {
            let path = entry.unwrap().path();
            if path.is_dir() {
                dirs.push(path);
            } else {
                found.push(serde_json::from_slice(&std::fs::read(path).unwrap()).unwrap());
            }
        }
    }
    assert!(found.len() > 300, "the corpus is missing");
    found
}

/// The corpus files docs/dev/format-coverage.md lists as exceptions: the first cell of each row of its table.
fn documented() -> Vec<String> {
    let doc = std::fs::read_to_string(corpus("../../../docs/dev/format-coverage.md")).unwrap();
    let section = doc.split("\n## Exceptions\n").nth(1).unwrap_or_default();
    let section = section.split("\n## ").next().unwrap_or_default();
    (section.lines())
        .filter_map(|line| {
            line.strip_prefix("| `")?
                .split_once('`')
                .map(|(path, _)| path.to_owned())
        })
        .collect()
}

fn has(record: &Value, quirk: &str) -> bool {
    record["quirks"].as_array().unwrap().iter().any(|q| q == quirk)
}

fn boxed(kind: [u8; 4], body: &[u8]) -> Vec<u8> {
    [&(body.len() as u32 + 8).to_be_bytes()[..], &kind, body].concat()
}

fn full(kind: [u8; 4], version: u8, flags: u8, body: &[u8]) -> Vec<u8> {
    boxed(kind, &[&[version, 0, 0, flags][..], body].concat())
}

/// A picture in HEVC's Annex B as a HEIF item's hvcC and data: its parameter sets in the one, its slices, each after
/// its length, in the other.
fn hevc(mut annex_b: &[u8]) -> (Vec<u8>, Vec<u8>) {
    let mut nals = vec![];
    while let Some(at) = annex_b.windows(3).position(|w| w == [0, 0, 1]) {
        nals.push(&annex_b[..at]);
        annex_b = &annex_b[at + 3..];
    }
    nals.push(annex_b);
    let nals: Vec<&[u8]> = (nals.into_iter())
        .map(|n| n.strip_suffix(&[0]).unwrap_or(n))
        .filter(|n| !n.is_empty())
        .collect();
    let kind = |nal: &[u8]| nal[0] >> 1 & 0x3f;
    // The SPS's profile, tier and level: bytes 3 to 14 of its payload, emulation prevention bytes taken out.
    let sps = nals.iter().find(|n| kind(n) == 33).unwrap();
    let payload: Vec<u8> = (sps.iter().enumerate())
        .filter(|&(i, &b)| b != 3 || i < 2 || sps[i - 2..i] != [0, 0])
        .map(|(_, &b)| b)
        .collect();
    let mut hvcc = [
        &[1][..],
        &payload[3..15],
        &[0xf0, 0, 0xfc, 0xfd, 0xf8, 0xf8, 0, 0, 0x0f, 3],
    ]
    .concat();
    let mut data = vec![];
    for nal in nals {
        match kind(nal) {
            32..=34 => hvcc.extend([&[0x80 | kind(nal), 0, 1][..], &(nal.len() as u16).to_be_bytes(), nal].concat()),
            0..=31 => data.extend([&(nal.len() as u32).to_be_bytes()[..], nal].concat()),
            _ => {}
        }
    }
    (boxed(*b"hvcC", &hvcc), data)
}

/// A HEIC of the picture in `coded` at `size`, or of a 2 × 2 grid of it, turned by `transforms`.
fn heic(coded: &[u8], (width, height): (u32, u32), grid: bool, transforms: &[Vec<u8>]) -> Vec<u8> {
    let (hvcc, data) = hevc(coded);
    let ispe = |w: u32, h: u32| full(*b"ispe", 0, 0, &[w.to_be_bytes(), h.to_be_bytes()].concat());
    let (tiles, side) = if grid { (4u16, 2) } else { (1, 1) };
    // Properties 1 to 3: hvcC, the coded picture's size and the image's; then the transforms, essential.
    let props = [
        vec![hvcc, ispe(width / side, height / side), ispe(width, height)],
        transforms.to_vec(),
    ]
    .concat();
    let turned: Vec<u8> = (4..=props.len() as u8).map(|i| 0x80 | i).collect();
    let item = |id: u16, kind: &[u8; 4], props: &[u8]| {
        let info = [&id.to_be_bytes()[..], &[0, 0], kind, &[0]].concat();
        let hidden = grid && id <= tiles;
        (
            full(*b"infe", 2, u8::from(hidden), &info),
            [&id.to_be_bytes()[..], &[props.len() as u8], props].concat(),
        )
    };
    let pictured = [&[0x81, 2][..], if grid { &[] } else { &turned }].concat();
    let mut items: Vec<_> = (1..=tiles).map(|id| item(id, b"hvc1", &pictured)).collect();
    // A grid's descriptor is in idat, and its pictures are its first four items.
    let extra = if grid {
        items.push(item(5, b"grid", &[&[3][..], &turned].concat()));
        let descriptor = [
            &[0, 0, 1, 1][..],
            &(width as u16).to_be_bytes(),
            &(height as u16).to_be_bytes(),
        ]
        .concat();
        let dimg = boxed(*b"dimg", &[0, 5, 0, 4, 0, 1, 0, 2, 0, 3, 0, 4]);
        [full(*b"iref", 0, 0, &dimg), boxed(*b"idat", &descriptor)].concat()
    } else {
        vec![]
    };
    let count = items.len() as u16;
    let (infos, associations): (Vec<_>, Vec<_>) = items.into_iter().unzip();
    let ftyp = boxed(*b"ftyp", b"heic\0\0\0\0mif1heic");
    let meta = |offset: u32| {
        // Every picture is the one coded picture, in mdat; a grid's descriptor in idat (construction method 1).
        let mut iloc = [&[0x44, 0][..], &count.to_be_bytes()].concat();
        for id in 1..=tiles {
            let extent = [offset.to_be_bytes(), (data.len() as u32).to_be_bytes()].concat();
            iloc.extend([&id.to_be_bytes()[..], &[0, 0, 0, 0, 0, 1], &extent].concat());
        }
        if grid {
            iloc.extend([0, 5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 8]);
        }
        let ipma = full(
            *b"ipma",
            0,
            0,
            &[&u32::from(count).to_be_bytes()[..], &associations.concat()].concat(),
        );
        let body = [
            full(*b"hdlr", 0, 0, &[&[0; 4][..], b"pict", &[0; 13]].concat()),
            full(*b"pitm", 0, 0, &(if grid { 5u16 } else { 1 }).to_be_bytes()),
            full(*b"iloc", 1, 0, &iloc),
            full(*b"iinf", 0, 0, &[&count.to_be_bytes()[..], &infos.concat()].concat()),
            boxed(*b"iprp", &[boxed(*b"ipco", &props.concat()), ipma].concat()),
            extra.clone(),
        ];
        full(*b"meta", 0, 0, &body.concat())
    };
    let offset = (ftyp.len() + meta(0).len() + 8) as u32;
    [ftyp, meta(offset), boxed(*b"mdat", &data)].concat()
}

/// One picture the pinned FFmpeg codes as `record`'s codec, bit depth and HDR transfer (HEVC at 8 bits only).
fn encode(tools: &Path, record: &Value, (width, height): (u32, u32), dir: &Path) -> Vec<u8> {
    let source = format!("testsrc2=s={width}x{height}:r=1:d=1");
    let out = dir.join("encoded");
    let mut args = vec!["-f", "lavfi", "-i", &source, "-frames:v", "1", "-threads", "1"];
    let codec = match record["format"].as_str().unwrap() {
        "heic" => "-c:v libkvazaar -kvazaar-params preset=ultrafast,threads=0 -f hevc",
        "avif" => "-c:v libaom-av1 -cpu-used 8 -still-picture 1 -f avif",
        _ => "-c:v libjxl -f image2 -update 1",
    };
    args.extend(codec.split(' '));
    if record["format"] == "avif" {
        let depths = [("bit_depth_10", "yuv420p10le"), ("bit_depth_12", "yuv420p12le")];
        let depth = depths.into_iter().find(|(quirk, _)| has(record, quirk));
        args.extend(["-pix_fmt", depth.map_or("yuv420p", |(_, format)| format)]);
        let transfers = [("hdr_pq", "smpte2084"), ("hdr_hlg", "arib-std-b67")];
        if let Some((_, transfer)) = transfers.into_iter().find(|(quirk, _)| has(record, quirk)) {
            args.extend([
                "-color_trc",
                transfer,
                "-color_primaries",
                "bt2020",
                "-colorspace",
                "bt2020nc",
            ]);
        }
    }
    args.push(out.to_str().unwrap());
    ffmpeg(tools, &args);
    std::fs::read(out).unwrap()
}

/// A JPEG XL container's signature box.
const JXL: [u8; 12] = [0, 0, 0, 12, b'J', b'X', b'L', b' ', 13, 10, 0x87, 10];

/// The corpus file itself when it decodes, else its twin in `dir`: the picture `encode` makes, at a quarter of a large
/// record's size, in the record's container with its HEIF transforms and grid.
fn twin(tools: &Path, record: &Value, dir: &Path) -> PathBuf {
    let path = record["path"].as_str().unwrap();
    let format = record["format"].as_str().unwrap();
    let placeholder = record["notes"].as_str().unwrap_or("").starts_with("Placeholder");
    if !placeholder || !["heic", "avif", "jxl"].contains(&format) {
        return corpus(path);
    }
    let size = |key: &str| record["metadata"][key].as_u64().unwrap();
    let quarter = if size("width") * size("height") > 1 << 20 { 4 } else { 1 };
    let side = |key| (size(key) / quarter).next_multiple_of(16) as u32;
    let (width, height) = (side("width"), side("height"));
    let grid = has(record, "heif_grid");
    let encoded = encode(
        tools,
        record,
        if grid { (width / 2, height / 2) } else { (width, height) },
        dir,
    );
    let file = match format {
        "heic" => {
            let clap: Vec<u8> = [width - 32, 1, height - 24, 1, 0, 1, 0, 1]
                .iter()
                .flat_map(|n| n.to_be_bytes())
                .collect();
            let transforms = [
                ("heif_clap", *b"clap", &clap[..]),
                ("heif_irot", *b"irot", &[3]),
                ("heif_imir", *b"imir", &[0]),
            ];
            let transforms: Vec<_> = (transforms.into_iter())
                .filter(|(quirk, ..)| has(record, quirk))
                .map(|(_, kind, body)| boxed(kind, body))
                .collect();
            heic(&encoded, (width, height), grid, &transforms)
        }
        // A container, as the corpus file is, around the codestream.
        "jxl" if std::fs::read(corpus(path)).unwrap().starts_with(&JXL) => [
            &JXL[..],
            &boxed(*b"ftyp", b"jxl \0\0\0\0jxl "),
            &boxed(*b"jxlc", &encoded),
        ]
        .concat(),
        _ => encoded,
    };
    let twin = dir.join("twin");
    std::fs::write(&twin, file).unwrap();
    twin
}

/// Every image of the media corpus renders upright and shows its picture (docs/08 §1.7, FMT-21), but the exceptions
/// docs/dev/format-coverage.md lists, which leave at least 98 % of the supported corpus covered (M7-05); the
/// renders of its videos are `tests/video.rs`'. HEIC, AVIF and JPEG XL files, whose pictures are placeholders, render
/// as twins.
#[tokio::test]
async fn every_corpus_image_renders_upright_but_the_documented_exceptions() {
    let (tools, records) = (tools(), records());
    let scratch = tempfile::tempdir_in(env!("CARGO_TARGET_TMPDIR")).unwrap();
    let supported = |r: &&Value| r["media"]["support"] == "supported";
    let images: Vec<_> = records
        .iter()
        .filter(supported)
        .filter(|r| r["media"]["kind"] == "image")
        .collect();
    // Four pooled renderers, as the render job's, each with its share of the corpus in its input directory.
    let mut renderers = tokio::task::JoinSet::new();
    for (slot, share) in images.chunks(images.len().div_ceil(4)).enumerate() {
        let dir = scratch.path().join(slot.to_string());
        let (input, out) = (dir.join("in"), dir.join("out"));
        let mut checks = vec![];
        for (n, record) in share.iter().enumerate() {
            let made = dir.join(format!("twin-{n}"));
            std::fs::create_dir_all(&made).unwrap();
            std::fs::create_dir_all(&input).unwrap();
            let data = std::fs::read(twin(&tools, record, &made)).unwrap();
            std::fs::write(input.join(n.to_string()), &data).unwrap();
            let mime = ingest::sniff::sniff(&data[..data.len().min(4096)]).mime;
            let metadata = &record["metadata"];
            let orientation = metadata["orientation"].as_u64().unwrap_or(1);
            let size = (
                metadata["width"].as_u64().unwrap(),
                metadata["height"].as_u64().unwrap(),
            );
            let landscape = if orientation >= 5 {
                size.1 > size.0
            } else {
                size.0 > size.1
            };
            let request = Request {
                input: input.join(n.to_string()),
                mime: mime.into(),
                // A RAW's embedded preview takes the RAW's orientation, as the render job passes it.
                orientation: mime.starts_with("image/x-").then_some(orientation as u8),
                edit: None,
                outputs: set(),
            };
            checks.push((record["path"].as_str().unwrap().to_owned(), request, landscape));
        }
        std::fs::create_dir_all(&out).unwrap();
        let mut worker = Worker::renderer(PHOTOLIBD.into(), input, out);
        renderers.spawn(async move {
            let mut failed = vec![];
            for (path, request, landscape) in checks {
                match worker.render(&request).await {
                    Ok(r) if (r.outputs[0].1 > r.outputs[0].2) == landscape && shows_a_picture(&r.thumbhash) => {}
                    rendered => failed.push((path, format!("{}: {rendered:?}", request.mime))),
                }
            }
            failed
        });
    }
    let failed = renderers.join_all().await.concat();
    let documented = documented();
    let undocumented: Vec<_> = failed.iter().filter(|(path, _)| !documented.contains(path)).collect();
    assert!(undocumented.is_empty(), "{undocumented:#?}");
    let rendering: Vec<_> = documented
        .iter()
        .filter(|path| !failed.iter().any(|(p, _)| p == *path))
        .collect();
    assert!(
        rendering.is_empty(),
        "documented exceptions that render now: {rendering:?}"
    );
    let supported = records.iter().filter(supported).count();
    assert!(
        documented.len() * 50 <= supported,
        "{} of {supported} files are exceptions",
        documented.len()
    );
}

/// A new instance with Ann's library on the store `local` (a directory), and a work directory.
struct Instance {
    pool: sqlx::PgPool,
    journal: Arc<Journal>,
    owner: Uuid,
    library: Uuid,
    work: tempfile::TempDir,
    _db: testpg::TestDb,
}

async fn instance() -> Instance {
    let db = testpg::database().await;
    upgrade(&db.pool, &Upgrade::new(&embedded())).await.unwrap();
    let work = tempfile::tempdir_in(env!("CARGO_TARGET_TMPDIR")).unwrap();
    for dir in ["data", "uploads"] {
        std::fs::create_dir(work.path().join(dir)).unwrap();
    }
    let local = FsStore::open(&work.path().join("data"), Duration::from_secs(30))
        .await
        .unwrap();
    let candidate = Candidate {
        name: "local".into(),
        store: Arc::new(local),
        adopt: true,
    };
    let stores = Stores::check(&db.pool, Uuid::now_v7(), vec![candidate]).await;
    let journal = Arc::new(Journal::start(db.pool.clone(), stores).await.unwrap());
    let (owner, library) = (Uuid::now_v7(), Uuid::now_v7());
    sqlx::query("INSERT INTO users (id, handle, display_name) VALUES ($1, 'ann', 'Ann')")
        .bind(owner)
        .execute(&db.pool)
        .await
        .unwrap();
    sqlx::query("INSERT INTO libraries (id, owner_id, name, kind, root_uri) VALUES ($1, $2, 'Photos', 'managed', 'p')")
        .bind(library)
        .bind(owner)
        .execute(&db.pool)
        .await
        .unwrap();
    Instance {
        pool: db.pool.clone(),
        journal,
        owner,
        library,
        work,
        _db: db,
    }
}

impl Instance {
    /// A complete upload of `data`, stored and no longer staged, with its ingest queued.
    async fn upload(&self, path: &str, data: &[u8]) -> Uuid {
        let id = Uuid::now_v7();
        let file = self.work.path().join("uploads").join(id.to_string());
        std::fs::write(&file, data).unwrap();
        let key = format!("libraries/{}/uploads/{id}", self.library);
        let written = self.journal.put("local", &key, &file, Hash::of(data)).await.unwrap();
        let mut tx = self.pool.begin().await.unwrap();
        written.switch(&mut tx).await.unwrap();
        sqlx::query(
            "INSERT INTO uploads (id, owner_id, library_id, length, hash, received, store, key, completed_at,
               expires_at, path) VALUES ($1, $2, $3, $4, $5, $4, 'local', $6, now(), now(), $7)",
        )
        .bind(id)
        .bind(self.owner)
        .bind(self.library)
        .bind(data.len() as i64)
        .bind(Hash::of(data).0.to_vec())
        .bind(&key)
        .bind(path)
        .execute(&mut *tx)
        .await
        .unwrap();
        ingest::enqueue(&mut tx, &[id]).await.unwrap();
        tx.commit().await.unwrap();
        written.finish().await.unwrap();
        std::fs::remove_file(file).unwrap();
        id
    }

    /// Runs ingest and rendering with `specs` until no job is left.
    async fn work(&self, specs: Vec<Spec>) {
        self.work_at(specs, 4).await;
    }

    /// [`Self::work`] with `jobs` running at once.
    async fn work_at(&self, specs: Vec<Spec>, jobs: usize) {
        let photolibd = PathBuf::from(PHOTOLIBD);
        let profile = render::profile(&specs);
        let libraries = Arc::new(Libraries::new(Duration::from_secs(30)));
        let ingest = Ingest::new(
            self.journal.clone(),
            self.work.path(),
            photolibd.clone(),
            vec![],
            profile,
            libraries.clone(),
        );
        let follow = Follow(with_export(render::profile(&specs)));
        let render =
            Arc::new(Render::new(self.journal.clone(), self.work.path(), photolibd, specs, libraries).unwrap());
        let export = Export::new(render.clone());
        let timing = Timing {
            poll_min: Duration::from_millis(10),
            poll_max: Duration::from_millis(50),
            ..Timing::default()
        };
        let shutdown = CancellationToken::new();
        let worker = (JobWorker::new(self.pool.clone(), "test", jobs, timing))
            .handle(INGEST, ingest.unwrap())
            .handle(RENDER, render)
            .handle(FOLLOW, follow)
            .handle(EXPORT, export);
        let running = tokio::spawn(worker.run(shutdown.clone()));
        let open = "SELECT count(*) FROM jobs WHERE status IN ('queued', 'running')";
        while sqlx::query_scalar::<_, i64>(open).fetch_one(&self.pool).await.unwrap() > 0 {
            tokio::time::sleep(Duration::from_millis(20)).await;
        }
        shutdown.cancel();
        running.await.unwrap();
        let failed: Vec<String> = sqlx::query_scalar("SELECT error FROM jobs WHERE status <> 'done'")
            .fetch_all(&self.pool)
            .await
            .unwrap();
        assert!(failed.is_empty(), "{failed:?}");
    }

    /// Each rendition's role, spec id, size and width, by role; their files are in the store, with their hashes.
    async fn renditions(&self) -> Vec<(String, String, String)> {
        let rows: Vec<(String, String, String, Vec<u8>)> = sqlx::query_as(
            "SELECT role, render_spec ->> 'spec_id', key, content_hash FROM asset_files
             WHERE render_spec IS NOT NULL ORDER BY role",
        )
        .fetch_all(&self.pool)
        .await
        .unwrap();
        let store = self.journal.stores().get("local").unwrap();
        for (_, _, key, hash) in &rows {
            assert_eq!(
                store
                    .head(key)
                    .await
                    .unwrap()
                    .and_then(|m| m.hash)
                    .map(|h| h.0.to_vec()),
                Some(hash.clone())
            );
        }
        rows.into_iter().map(|(role, spec, key, _)| (role, spec, key)).collect()
    }
}

/// An ingested photo gets every rendition of the profile and its ThumbHash. Changing a spec gives it another id: the
/// reconciler queues the renditions of that spec again, and the job replaces the old file, which is then deleted.
#[tokio::test]
async fn changing_a_render_spec_regenerates_its_renditions_through_the_reconciler() {
    let at = instance().await;
    at.upload(
        "DCIM/IMG_E3001.JPG",
        &std::fs::read(corpus("compound/edited/IMG_E3001.JPG")).unwrap(),
    )
    .await;
    at.work(render::specs()).await;
    let before = at.renditions().await;
    let ids: Vec<String> = render::specs().iter().map(Spec::id).collect();
    assert_eq!(
        before
            .iter()
            .map(|(role, spec, _)| (role.as_str(), spec.as_str()))
            .collect::<Vec<_>>(),
        [
            ("preview", ids[2].as_str()),
            ("thumb_m", ids[1].as_str()),
            ("thumb_s", ids[0].as_str())
        ]
    );
    let thumbhash: Option<Vec<u8>> = sqlx::query_scalar("SELECT thumbhash FROM assets")
        .fetch_one(&at.pool)
        .await
        .unwrap();
    assert!(thumbhash.is_some_and(|hash| hash.len() > 20));

    let mut changed = render::specs();
    changed[0].quality = 60;
    assert_ne!(changed[0].id(), ids[0]);
    assert_eq!(reconcile(&at.pool, &render::profile(&changed)).await.unwrap(), 1);
    at.work(changed.clone()).await;
    let after = at.renditions().await;
    assert_eq!(after[..2], before[..2], "the preview and thumb_m stay");
    assert_eq!(
        (after[2].0.as_str(), after[2].1.as_str()),
        ("thumb_s", changed[0].id().as_str())
    );
    let store = at.journal.stores().get("local").unwrap();
    assert_eq!(
        store.head(&before[2].2).await.unwrap(),
        None,
        "the replaced thumbnail is deleted"
    );
    // The upload's delete waits for the purge (ADR-0089); the purge does only that one.
    assert_eq!(at.journal.purge().await.unwrap(), 1);
    let open: i64 = sqlx::query_scalar("SELECT count(*) FROM file_intents WHERE state <> 'done'")
        .fetch_one(&at.pool)
        .await
        .unwrap();
    assert_eq!(open, 0);
    assert_eq!(reconcile(&at.pool, &render::profile(&changed)).await.unwrap(), 0);
}

/// `profile` and the full-size export of an edited image's current version.
fn with_export(profile: Profile) -> Profile {
    Profile {
        export: Some(photolib_server::edits::EXPORT_SPEC.into()),
        ..profile
    }
}

/// A recipe of the right half of a picture, turned a quarter clockwise.
fn right_half_turned() -> Vec<u8> {
    use photolib_kernel::proto::model::v1::{CropOperation, EditRecipe, Operation, TurnOperation, operation::Kind};
    use prost::Message;
    let step = |id: &str, kind| Operation {
        operation_id: id.into(),
        kind: Some(kind),
        ..Default::default()
    };
    EditRecipe {
        schema_version: 1,
        operations: vec![
            step(
                "crop",
                Kind::Crop(CropOperation {
                    x: 0.5,
                    y: 0.0,
                    width: 0.5,
                    height: 1.0,
                }),
            ),
            step("turn", Kind::Turn(TurnOperation { quarter_turns: 1 })),
        ],
        ..Default::default()
    }
    .encode_to_vec()
}

/// What a rendition of `spec` is for a picture of `size`, as the renderer fits it.
fn fitted(spec: &Spec, (width, height): (u32, u32)) -> (u32, u32) {
    let (short, long) = (width.min(height), width.max(height));
    let mut scale = f64::from(spec.long) / f64::from(long);
    if spec.short > 0 {
        scale = scale.min(f64::from(spec.short) / f64::from(short));
    }
    let side = |n: u32| ((f64::from(n) * scale.min(1.0)).round() as u32).max(1);
    (side(width), side(height))
}

impl Instance {
    /// The role, the version it was made for and its size, of each present rendition, by role.
    async fn made_for(&self) -> Vec<(String, String, u32, u32)> {
        let rows: Vec<(String, String, i32, i32)> = sqlx::query_as(
            "SELECT role, coalesce(render_spec ->> 'version_id', ''), (render_spec ->> 'width')::int,
                    (render_spec ->> 'height')::int
             FROM asset_files WHERE render_spec IS NOT NULL AND state = 'present' ORDER BY role",
        )
        .fetch_all(&self.pool)
        .await
        .unwrap();
        rows.into_iter()
            .map(|(r, v, w, h)| (r, v, w as u32, h as u32))
            .collect()
    }
}

/// The thumbnails, the preview and so the covers that show them are of the current version: an edit makes the reconciler
/// render them again from the edited picture, a revert from the original, and the edited picture is what the kernel's
/// renderer makes of the original.
#[tokio::test]
#[allow(clippy::too_many_lines)] // one story: the edit, what is rendered, the cover, the pixels, the revert
async fn an_edit_makes_the_renditions_and_the_covers_that_show_them_follow_the_current_version() {
    use rs_vips::voption::Setter;
    let at = instance().await;
    at.upload(
        "DCIM/IMG_E3001.JPG",
        &std::fs::read(corpus("compound/edited/IMG_E3001.JPG")).unwrap(),
    )
    .await;
    let specs = render::specs();
    at.work(specs.clone()).await;
    let (asset, original, (width, height), orientation): (Uuid, Uuid, (i32, i32), Option<i16>) =
        sqlx::query_as("SELECT id, current_version_id, (width, height), orientation FROM assets")
            .fetch_one(&at.pool)
            .await
            .map(
                |(id, version, size, orientation): (Uuid, Uuid, (i32, i32), Option<i16>)| {
                    (id, version, size, orientation)
                },
            )
            .unwrap();
    let upright = match orientation.unwrap_or(1) {
        5..=8 => (height as u32, width as u32),
        _ => (width as u32, height as u32),
    };
    sqlx::query("INSERT INTO albums (id, owner_id, title, cover_asset_id) VALUES (gen_random_uuid(), $1, 'Cover', $2)")
        .bind(at.owner)
        .bind(asset)
        .execute(&at.pool)
        .await
        .unwrap();
    let plain = at.made_for().await;
    assert!(
        plain.iter().all(|(_, version, ..)| *version == original.to_string()),
        "{plain:?}"
    );
    let first_preview = {
        let key: String = sqlx::query_scalar("SELECT key FROM asset_files WHERE role = 'preview'")
            .fetch_one(&at.pool)
            .await
            .unwrap();
        at.journal.stores().get("local").unwrap().get(&key, None).await.unwrap()
    };

    // The edit: the right half, turned. Its renditions are the edited picture fitted as before.
    let recipe = right_half_turned();
    let checked = photolib_server::edits::check(&recipe, upright).unwrap();
    let edited = Uuid::now_v7();
    sqlx::query(
        "INSERT INTO versions (id, asset_id, parent_id, kind, recipe, recipe_hash) VALUES ($1, $2, $3, 'edit', $4, $5)",
    )
    .bind(edited)
    .bind(asset)
    .bind(original)
    .bind(&checked.bytes)
    .bind(&checked.hash)
    .execute(&at.pool)
    .await
    .unwrap();
    sqlx::query("UPDATE assets SET current_version_id = $1")
        .bind(edited)
        .execute(&at.pool)
        .await
        .unwrap();
    let profile = render::profile(&specs);
    assert_eq!(
        reconcile(&at.pool, &profile).await.unwrap(),
        3,
        "a render job for each rendition"
    );
    at.work(specs.clone()).await;
    let after = at.made_for().await;
    for spec in &specs {
        let (w, h) = fitted(spec, checked.size);
        assert!(
            after.contains(&(spec.role.to_owned(), edited.to_string(), w, h)),
            "{} is {w}×{h} for the edit: {after:?}",
            spec.role
        );
    }
    assert_eq!(after.len(), 3, "the original's renditions are replaced");
    assert_eq!(reconcile(&at.pool, &profile).await.unwrap(), 0);

    // The cover is the asset's, so what it shows is the edit's rendition.
    let covers: Vec<(String,)> = sqlx::query_as(
        "SELECT f.render_spec ->> 'version_id' FROM albums al JOIN asset_files f ON f.asset_id = al.cover_asset_id
         WHERE f.role = 'thumb_m' AND f.state = 'present'",
    )
    .fetch_all(&at.pool)
    .await
    .unwrap();
    assert_eq!(covers, [(edited.to_string(),)]);

    // The preview is the kernel's render of the original preview, to what a JPEG's encoding changes.
    let key: String = sqlx::query_scalar("SELECT key FROM asset_files WHERE role = 'preview'")
        .fetch_one(&at.pool)
        .await
        .unwrap();
    let preview = at.journal.stores().get("local").unwrap().get(&key, None).await.unwrap();
    vips();
    let rgb = |jpeg: &[u8]| {
        let image = rs_vips::VipsImage::jpegload_buffer(jpeg).unwrap();
        (
            image.get_width() as u32,
            image.get_height() as u32,
            image.write_to_memory(),
        )
    };
    let (ow, oh, before) = rgb(&first_preview);
    let (ew, eh, edited_pixels) = rgb(&preview);
    assert_eq!((ew, eh), fitted(&specs[2], checked.size));
    let expected = {
        use photolib_kernel::proto::kernel::v1::{Image, Method, RenderRecipeRequest, RenderRecipeResponse};
        use prost::Message;
        let rgba = before.chunks(3).flat_map(|p| [p[0], p[1], p[2], 255]).collect();
        let request = RenderRecipeRequest {
            recipe: Some(Message::decode(recipe.as_slice()).unwrap()),
            image: Some(Image {
                width: ow,
                height: oh,
                rgba,
            }),
        };
        let answer = photolib_kernel::call(Method::RenderRecipe as u32, &request.encode_to_vec());
        let response = photolib_kernel::proto::kernel::v1::CallResponse::decode(answer.as_slice()).unwrap();
        let Some(photolib_kernel::proto::kernel::v1::call_response::Result::Response(bytes)) = response.result else {
            panic!("the kernel refused the recipe")
        };
        RenderRecipeResponse::decode(bytes.as_slice()).unwrap().image.unwrap()
    };
    // The old preview has fewer pixels of the half than the edited one: compare at the old preview's scale.
    let small = rs_vips::VipsImage::new_from_memory_copy(
        &edited_pixels,
        ew as i32,
        eh as i32,
        3,
        rs_vips::enums::BandFormat::Uchar,
    )
    .and_then(|image| {
        let (sx, sy) = (
            f64::from(expected.width) / f64::from(ew),
            f64::from(expected.height) / f64::from(eh),
        );
        image.resize_with_opts(sx, rs_vips::voption::VOption::new().set("vscale", sy))
    })
    .unwrap();
    assert_eq!(
        (small.get_width() as u32, small.get_height() as u32),
        (expected.width, expected.height)
    );
    let diff: u64 = small
        .write_to_memory()
        .chunks(3)
        .zip(expected.rgba.chunks(4))
        .map(|(a, b)| a.iter().zip(b).map(|(x, y)| u64::from(x.abs_diff(*y))).sum::<u64>())
        .sum();
    let mean = diff as f64 / f64::from(expected.width * expected.height * 3);
    assert!(
        mean < 4.0,
        "mean difference {mean} between the preview and the kernel's render"
    );

    // A revert renders the original's again.
    sqlx::query("UPDATE assets SET current_version_id = $1")
        .bind(original)
        .execute(&at.pool)
        .await
        .unwrap();
    assert_eq!(reconcile(&at.pool, &profile).await.unwrap(), 3);
    at.work(specs).await;
    assert_eq!(at.made_for().await, plain);
}

/// A 12 MP JPEG as a phone writes one: a natural image's 1/f spectrum (a fractal surface per channel, made as libvips'
/// fractsurf makes it from `seed`) at quality 92, about 3.3 MB, with a camera's EXIF.
fn phone_jpeg(exif: &[u8], seed: i32) -> Vec<u8> {
    use rs_vips::{
        VipsImage,
        enums::Interpretation,
        voption::{Setter, VOption},
    };
    let mask = VipsImage::mask_fractal(4000, 3000, 2.6).unwrap();
    let channel = |band| {
        let noise = VOption::new()
            .set("mean", 0.0)
            .set("sigma", 1.0)
            .set("seed", seed * 3 + band);
        (VipsImage::gaussnoise_with_opts(4000, 3000, noise))
            .and_then(|noise| noise.freqmult(&mask))
            .and_then(|surface| surface.scale())
            .unwrap()
    };
    let image = VipsImage::bandjoin(&[channel(0), channel(1), channel(2)]).unwrap();
    let image = image
        .copy_with_opts(VOption::new().set("interpretation", Interpretation::Srgb as i32))
        .unwrap();
    let jpeg = image
        .jpegsave_buffer_with_opts(VOption::new().set("Q", 92).set("keep", 0))
        .unwrap();
    [&jpeg[..2], exif, &jpeg[2..]].concat()
}

/// Starts libvips in this process, once: `vips_init` on parallel tests races with itself.
fn vips() {
    static STARTED: std::sync::Once = std::sync::Once::new();
    STARTED.call_once(|| rs_vips::Vips::init("test").unwrap());
}

/// A pooled renderer child over `photos` 12 MP JPEGs of a phone, and what /proc says of it.
struct Pooled {
    worker: Worker,
    input: PathBuf,
    _dir: tempfile::TempDir,
}

impl Pooled {
    fn new(photos: i32) -> Self {
        let dir = tempfile::tempdir_in(env!("CARGO_TARGET_TMPDIR")).unwrap();
        let (input, out) = (dir.path().join("in"), dir.path().join("out"));
        for dir in [&input, &out] {
            std::fs::create_dir_all(dir).unwrap();
        }
        vips();
        for seed in 0..photos {
            std::fs::write(input.join(seed.to_string()), phone_jpeg(&[], seed)).unwrap();
        }
        let worker = Worker::renderer(PHOTOLIBD.into(), input.clone(), out);
        Pooled {
            worker,
            input,
            _dir: dir,
        }
    }

    async fn render(&mut self, photo: i32, outputs: &[Output]) {
        let request = Request {
            input: self.input.join(photo.to_string()),
            mime: "image/jpeg".into(),
            orientation: None,
            edit: None,
            outputs: outputs.to_vec(),
        };
        self.worker.render(&request).await.unwrap();
    }

    /// `/proc/<pid>/<file>` of the child: the one whose policy names this directory.
    fn proc(&self, file: &str) -> String {
        let tasks = std::fs::read_dir("/proc/self/task").unwrap();
        // A thread may end between the listing and the reading.
        let children = tasks.map(|task| std::fs::read_to_string(task.unwrap().path().join("children")));
        let children = children.filter_map(Result::ok).collect::<Vec<_>>().join(" ");
        let child = (children.split_whitespace())
            .find(|pid| {
                let cmdline = std::fs::read(format!("/proc/{pid}/cmdline")).unwrap_or_default();
                String::from_utf8_lossy(&cmdline).contains(&*self.input.to_string_lossy())
            })
            .unwrap();
        std::fs::read_to_string(format!("/proc/{child}/{file}")).unwrap()
    }
}

/// A pooled renderer serves photo after photo: it reuses what it allocated for one for the next instead of faulting
/// in fresh pages for each, a thousand per photo with glibc's defaults.
#[tokio::test]
async fn a_pooled_renderer_reuses_its_memory_photo_after_photo() {
    let mut pooled = Pooled::new(2);
    // Until each of the child's threads has met each size of buffer.
    for n in 0..8 {
        pooled.render(n % 2, &set()[..2]).await;
    }
    let faults = |pooled: &Pooled| {
        let stat = pooled.proc("stat");
        let minflt = stat.rsplit(')').next().unwrap().split_whitespace().nth(7);
        minflt.unwrap().parse::<u64>().unwrap()
    };
    let mut each = vec![];
    for n in 0..7 {
        let before = faults(&pooled);
        pooled.render(n % 2, &set()[..2]).await;
        each.push(faults(&pooled) - before);
    }
    each.sort();
    // Decoded at 1/4: 1000 × 750 RGB.
    let pages = 1000 * 750 * 3 / 4096;
    assert!(each[3] < pages, "page faults per photo {each:?}, {pages} pages decoded");
}

/// A JPEG decodes top to bottom into its first resize: making a 12 MP photo's preview, which takes all its pixels, the
/// renderer never holds them beside the preview's.
#[tokio::test]
async fn a_renderer_never_holds_a_photos_pixels_beside_its_previews() {
    let mut pooled = Pooled::new(1);
    pooled.render(0, &set()[..1]).await;
    let peak = |pooled: &Pooled| {
        let status = pooled.proc("status");
        let kb = status.lines().find_map(|line| line.strip_prefix("VmHWM:")).unwrap();
        kb.trim().trim_end_matches(" kB").parse::<u64>().unwrap() << 10
    };
    let before = peak(&pooled);
    pooled.render(0, &set()[2..]).await;
    let grown = peak(&pooled) - before;
    let pixels = (4000 * 3000 + 2160 * 1620) * 3;
    assert!(
        grown < pixels,
        "the peak grew {grown} bytes, the photo and its preview have {pixels}"
    );
}

/// The process's CPU time, all threads, in seconds.
fn cpu() -> f64 {
    let time = nix::time::clock_gettime(nix::time::ClockId::CLOCK_PROCESS_CPUTIME_ID).unwrap();
    time.tv_sec() as f64 + time.tv_nsec() as f64 / 1e9
}

/// `rate` as a quiet machine would have measured it, by the `reference` run beside it and what that takes there:
/// load that slowed the reference is credited, a reference faster than there is not, so that a quiet machine checks
/// the raw rate (ADR-0121).
fn calibrated(rate: f64, reference: f64, quiet: f64) -> f64 {
    rate * (reference / quiet).max(1.0)
}

/// The ingest benchmark's photos, its budget and its calibration (`ingest-throughput` in tools/perf/budgets.json), on
/// the fastest cores of this machine.
struct Ingest12Mp {
    photos: Vec<PathBuf>,
    /// The calibration's reference: another such photo, in memory.
    reference: Vec<u8>,
    budget: f64,
    /// The reference's CPU time on a quiet reference machine.
    quiet: f64,
    dir: tempfile::TempDir,
}

impl Ingest12Mp {
    fn new() -> Self {
        let speeds: Vec<u64> = (0..1024)
            .map_while(|n| {
                std::fs::read_to_string(format!("/sys/devices/system/cpu/cpu{n}/cpufreq/cpuinfo_max_freq")).ok()
            })
            .map(|speed| speed.trim().parse().unwrap_or(0))
            .collect();
        if let Some(top) = speeds.iter().max() {
            let mut fastest = nix::sched::CpuSet::new();
            for (n, _) in speeds.iter().enumerate().filter(|(_, speed)| *speed == top) {
                fastest.set(n).unwrap();
            }
            nix::sched::sched_setaffinity(nix::unistd::Pid::from_raw(0), &fastest).unwrap();
        }
        let budgets: Value = serde_json::from_slice(
            &std::fs::read(Path::new(env!("CARGO_MANIFEST_DIR")).join("../../../tools/perf/budgets.json")).unwrap(),
        )
        .unwrap();
        let ingest = &budgets["budgets"]["ingest-throughput"];
        vips();
        // As the renderer runs libvips, from the first sample of the reference on.
        rs_vips::Vips::concurrency_set(1);
        rs_vips::Vips::cache_set_max(0);
        let edited = std::fs::read(corpus("compound/edited/IMG_E3001.JPG")).unwrap();
        let (_, exif) = segments(&edited)
            .into_iter()
            .find(|(m, p)| *m == 0xe1 && p.starts_with(b"Exif"))
            .unwrap();
        let exif = [&[0xff, 0xe1][..], &((exif.len() + 2) as u16).to_be_bytes(), &exif].concat();
        let dir = tempfile::tempdir_in(env!("CARGO_TARGET_TMPDIR")).unwrap();
        let photos = (1..=6)
            .map(|seed| {
                let path = dir.path().join(format!("{seed}.jpg"));
                std::fs::write(&path, phone_jpeg(&exif, seed)).unwrap();
                path
            })
            .collect();
        Ingest12Mp {
            photos,
            reference: phone_jpeg(&exif, 0),
            budget: ingest["metrics"]["photos"]["min"]["server"].as_f64().unwrap(),
            quiet: ingest["calibration"]["quiet"].as_f64().unwrap(),
            dir,
        }
    }

    /// The CPU time ingest and the first render job spend on `path` for `outputs`, made `slowdown` longer.
    fn sample(&self, path: &Path, outputs: &[Output], slowdown: f64) -> f64 {
        let start = cpu();
        let file = std::fs::File::open(path).unwrap();
        let mut head = vec![0; 4096];
        std::os::unix::fs::FileExt::read_exact_at(&file, &mut head, 0).unwrap();
        assert_eq!(ingest::sniff::sniff(&head).mime, "image/jpeg");
        let size = file.metadata().unwrap().len();
        let read = ingest::extract::extract(&file, size, "DCIM/IMG.JPG", 0).unwrap();
        assert_eq!(read.metadata.model, "iPhone 13 Pro");
        let request = Request {
            input: path.into(),
            mime: "image/jpeg".into(),
            orientation: None,
            edit: None,
            outputs: outputs.to_vec(),
        };
        photolib_media::render::render(&request, self.dir.path(), &photolib_media::Limits::IMAGE).unwrap();
        let spent = cpu() - start;
        while cpu() - start < spent * (1.0 + slowdown) {}
        cpu() - start
    }

    /// The calibration's reference: the CPU time of hashing the reference photo and decoding it as ingest does, at
    /// 1/4, to the mean of its pixels. It allocates little, so that no allocator setting moves it.
    fn reference(&self) -> f64 {
        use rs_vips::{
            VipsImage,
            enums::Access,
            voption::{Setter, VOption},
        };
        let start = cpu();
        std::hint::black_box(blake3::hash(&self.reference));
        let decode = VOption::new().set("shrink", 4).set("access", Access::Sequential as i32);
        let image = VipsImage::jpegload_buffer_with_opts(&self.reference, decode).unwrap();
        std::hint::black_box(image.avg().unwrap());
        cpu() - start
    }

    /// The raw and the calibrated rate of `outputs` in photos/s/core and the fastest reference in seconds: the fastest
    /// sample per photo of three rounds, or of up to ten while the calibrated rate misses `target`, each sample after
    /// one of the reference.
    fn rate(&self, outputs: &[Output], target: f64, slowdown: f64) -> (f64, f64, f64) {
        let mut best = vec![f64::MAX; self.photos.len()];
        let (mut reference, mut raw) = (f64::MAX, 0.0);
        for round in 0..10 {
            for (best, path) in best.iter_mut().zip(&self.photos) {
                reference = reference.min(self.reference());
                *best = best.min(self.sample(path, outputs, slowdown));
            }
            raw = best.len() as f64 / best.iter().sum::<f64>();
            if round >= 2 && calibrated(raw, reference, self.quiet) >= target {
                break;
            }
        }
        (raw, calibrated(raw, reference, self.quiet), reference)
    }
}

/// The 1-minute load average.
fn load() -> f64 {
    let loadavg = std::fs::read_to_string("/proc/loadavg").unwrap();
    loadavg.split(' ').next().unwrap().parse().unwrap()
}

/// Ingest throughput (docs/19 §3, `ingest-throughput` in tools/perf/budgets.json): what ingest and the first render
/// job spend on a 12 MP JPEG for its metadata (the kernel's, as clients read it), `thumb_s`, `thumb_m` and ThumbHash,
/// in photos per second of one core. Taken as the kernel's budgets are: on the fastest cores, in CPU time, the fastest
/// sample per photo of three rounds, or of up to ten while it misses the budget, since a loaded machine only slows a
/// sample. Calibrated by a reference run before each sample on the same cores, as other load slows both (ADR-0121).
/// With the preview too, which design 08 §9 counts, it is printed beside.
#[test]
#[ignore = "a benchmark: tools/perf/run.sh runs it in a release build"]
fn ingest_throughput_of_12_mp_jpegs() {
    let ingest = Ingest12Mp::new();
    let (raw, thumbnails, reference) = ingest.rate(&set()[..2], ingest.budget, 0.0);
    let (_, everything, _) = ingest.rate(&set(), 0.0, 0.0);
    let load = load();
    eprintln!(
        "ingest: {thumbnails:.1} photos/s/core with thumbnails calibrated, {raw:.1} raw (the reference {:.2} ms, \
         quiet {:.2} ms; load average {load}); {everything:.1} with the preview too",
        reference * 1e3,
        ingest.quiet * 1e3
    );
    if let Ok(path) = std::env::var("PERF_RESULTS") {
        let tenths = |rate: f64| (rate * 10.0).round() / 10.0;
        let line = serde_json::json!({"budget": "ingest-throughput", "metric": "photos", "target": "server",
            "value": tenths(thumbnails), "raw": tenths(raw), "load": load});
        let mut file = std::fs::OpenOptions::new()
            .create(true)
            .append(true)
            .open(path)
            .unwrap();
        std::io::Write::write_all(&mut file, format!("{line}\n").as_bytes()).unwrap();
    }
}

#[test]
fn calibration_credits_only_load_that_slowed_the_reference() {
    // As fast as on a quiet machine, or faster: the raw rate, so the budget fails where the absolute check does.
    assert_eq!(calibrated(19.9, 0.020, 0.020), 19.9);
    assert_eq!(calibrated(19.9, 0.018, 0.020), 19.9);
    // A reference 10% slower than quiet: the rate as it would have been without that load.
    assert!((calibrated(19.9, 0.022, 0.020) - 21.89).abs() < 1e-9);
}

/// The calibration under load (ADR-0121): with every core busy, the calibration gives the ingest path back much of
/// what the load took, and made 10% slower it fails the budget (`saturation`).
#[test]
#[ignore = "saturates every core with stress-ng: run by hand (docs/dev/performance.md)"]
fn a_10_percent_slower_ingest_fails_the_calibrated_budget_on_a_saturated_machine() {
    use photolib_spawn::{Group, Signal, tool};
    let ingest = Ingest12Mp::new();
    let (alone, _, _) = ingest.rate(&set()[..2], f64::MAX, 0.0);
    let mut stress = tool("stress-ng");
    stress.args(["--stream", "0", "--timeout", "600", "--quiet"]);
    let stress = Group::start(stress, Signal::SIGKILL);
    std::thread::sleep(Duration::from_secs(2));
    let (raw, unchanged, _) = ingest.rate(&set()[..2], f64::MAX, 0.0);
    let (_, slower, _) = ingest.rate(&set()[..2], f64::MAX, 0.1);
    let load = load();
    drop(stress);
    eprintln!(
        "{alone:.1} photos/s/core raw alone; saturated (load average {load}): {unchanged:.1} calibrated, {raw:.1} raw; \
         10% slower: {slower:.1} calibrated"
    );
    saturation(alone, raw, unchanged, slower, ingest.budget).unwrap();
}

/// What a saturated run shows, from the raw rate `alone` just before and, saturated, the `raw` and calibrated rates of
/// the unchanged path and the calibrated one of a 10% `slower` path: that the load slowed the raw rate, that the
/// calibration gave back at least a quarter of that (47-49% and 68% in three runs), and that a 10% slower path fails
/// the budget. Whether the unchanged path meets the budget saturated is the machine's: memory-bandwidth contention
/// slows ingest more than the reference, so the calibrated rate stays under the rate alone, by up to 10% in the runs
/// below, where the rate has 13% to spare on a quiet machine (21.4 against 19). The budget is raised to 5% under the
/// unchanged rate where that is higher: a hidden slowdown would pass it.
fn saturation(alone: f64, raw: f64, unchanged: f64, slower: f64, budget: f64) -> Result<f64, &'static str> {
    let budget = budget.max(unchanged / 1.05);
    if raw * 1.05 > alone {
        Err("the load did not slow the raw rate")
    } else if (unchanged - raw) * 4.0 < alone - raw {
        Err("the calibration missed the load")
    } else if slower >= budget {
        Err("the calibration hid the slowdown")
    } else {
        Ok(budget)
    }
}

#[test]
fn a_saturated_run_is_judged_by_what_the_load_took_not_by_the_budget() {
    // 2026-10-19, stream workers on top of a load of 50-60: the unchanged path at 19.7 calibrated (18.2 raw), under
    // the budget before the owner lowered it; in other runs 20.0 (17.9 raw) of 21.0 raw alone, 19.8 (17.9) of 21.9,
    // 19.4 (17.4) of 21.5.
    assert_eq!(saturation(21.0, 18.2, 19.7, 18.6, 20.0), Ok(20.0));
    assert_eq!(saturation(21.0, 17.9, 20.0, 18.6, 20.0), Ok(20.0));
    assert_eq!(saturation(21.9, 17.9, 19.8, 18.1, 20.0), Ok(20.0));
    assert_eq!(saturation(21.5, 17.4, 19.4, 17.2, 20.0), Ok(20.0));
    assert_eq!(
        saturation(21.0, 20.4, 21.0, 19.0, 20.0),
        Err("the load did not slow the raw rate")
    );
    assert_eq!(
        saturation(21.0, 17.9, 18.4, 16.6, 20.0),
        Err("the calibration missed the load")
    );
    assert_eq!(
        saturation(21.0, 17.9, 21.4, 20.5, 20.0),
        Err("the calibration hid the slowdown")
    );
}

/// The kernel's reading of a JPEG's metadata.
fn metadata_of(jpeg: &[u8]) -> photolib_kernel::proto::kernel::v1::ReadMetadataResponse {
    use photolib_kernel::proto::kernel::v1::{
        CallResponse, FileRange, Method, ReadMetadataRequest, ReadMetadataResponse, call_response,
    };
    use prost::Message;
    let request = ReadMetadataRequest {
        ranges: vec![FileRange {
            offset: 0,
            data: jpeg.to_vec(),
        }],
        size: jpeg.len() as u64,
    };
    let answer = photolib_kernel::call(Method::ReadMetadata as u32, &request.encode_to_vec());
    match CallResponse::decode(answer.as_slice()).unwrap().result.unwrap() {
        call_response::Result::Response(bytes) => ReadMetadataResponse::decode(bytes.as_slice()).unwrap(),
        call_response::Result::Error(e) => panic!("{e:?}"),
    }
}

/// The only `edit_export` of the asset: its version, whether the kernel kept the original's pixels, and its bytes.
async fn exported(at: &Instance) -> Option<(String, bool, Vec<u8>)> {
    let row: Option<(String, bool, String)> = sqlx::query_as(
        "SELECT render_spec ->> 'version_id', (render_spec ->> 'lossless')::boolean, key FROM asset_files
         WHERE role = 'edit_export'",
    )
    .fetch_optional(&at.pool)
    .await
    .unwrap();
    let (version, lossless, key) = row?;
    let bytes = at.journal.stores().get("local").unwrap().get(&key, None).await.unwrap();
    Some((version, lossless, bytes))
}

/// An edited image is exported once for the version that is current: a geometry-only edit of a JPEG without decoding it,
/// any other edit rendered, both with the original's capture time and place and with how the edit was made; the export
/// of a version that is no longer current goes with the next.
#[tokio::test]
#[allow(clippy::too_many_lines)] // one story: a lossless export, then a rendered one
async fn an_edited_image_is_exported_in_full_with_its_metadata_and_how_the_edit_was_made() {
    use photolib_kernel::proto::model::v1::{AdjustOperation, EditRecipe, Operation, operation::Kind};
    use prost::Message;
    let at = instance().await;
    let data = std::fs::read(corpus("stills/gps-sydney.jpg")).unwrap();
    at.upload("DCIM/gps.jpg", &data).await;
    let specs = render::specs();
    at.work(specs.clone()).await;
    let profile = with_export(render::profile(&specs));
    let (asset, original): (Uuid, Uuid) = sqlx::query_as("SELECT id, current_version_id FROM assets")
        .fetch_one(&at.pool)
        .await
        .unwrap();
    assert_eq!(
        reconcile(&at.pool, &profile).await.unwrap(),
        0,
        "the original is the original file"
    );
    let before = metadata_of(&data);
    assert!(before.location.is_some() && !before.times.is_empty());
    let (w, h) = (before.width.max(1), before.height.max(1));

    // Half the picture, turned: no pixel of the JPEG is decoded.
    let recipe = right_half_turned();
    let checked = photolib_server::edits::check(&recipe, (w, h)).unwrap();
    let edited = Uuid::now_v7();
    sqlx::query(
        "INSERT INTO versions (id, asset_id, parent_id, kind, recipe, recipe_hash) VALUES ($1, $2, $3, 'edit', $4, $5)",
    )
    .bind(edited)
    .bind(asset)
    .bind(original)
    .bind(&checked.bytes)
    .bind(&checked.hash)
    .execute(&at.pool)
    .await
    .unwrap();
    sqlx::query("UPDATE assets SET current_version_id = $1")
        .bind(edited)
        .execute(&at.pool)
        .await
        .unwrap();
    assert_eq!(
        reconcile(&at.pool, &profile).await.unwrap(),
        4,
        "three renditions and the export"
    );
    at.work(specs.clone()).await;
    let (version, lossless, jpeg) = exported(&at).await.unwrap();
    assert_eq!(version, edited.to_string());
    assert!(lossless, "a turn and a crop of a JPEG keep its blocks");
    let after = metadata_of(&jpeg);
    assert_eq!(
        (after.location, after.times.clone()),
        (before.location, before.times.clone())
    );
    let packet = String::from_utf8_lossy(&jpeg);
    assert!(
        packet.contains("Iptc4xmpExt:DigitalSourceType=\"http://cv.iptc.org/newscodes/digitalsourcetype/humanEdits\"")
    );
    assert!(packet.contains("photolib:recipeSha256="));
    let render_file: Option<Uuid> = sqlx::query_scalar("SELECT render_file_id FROM versions WHERE id = $1")
        .bind(edited)
        .fetch_one(&at.pool)
        .await
        .unwrap();
    assert!(render_file.is_some(), "the version knows its export");
    assert_eq!(reconcile(&at.pool, &profile).await.unwrap(), 0);

    // An adjustment: the sandbox renders, the kernel gives the pixels the original's metadata.
    let lighter = {
        let mut r = EditRecipe::decode(recipe.as_slice()).unwrap();
        r.operations.push(Operation {
            operation_id: "light".into(),
            kind: Some(Kind::Adjust(AdjustOperation {
                exposure: 0.5,
                ..Default::default()
            })),
            ..Default::default()
        });
        r.encode_to_vec()
    };
    let checked = photolib_server::edits::check(&lighter, (w, h)).unwrap();
    let second = Uuid::now_v7();
    sqlx::query(
        "INSERT INTO versions (id, asset_id, parent_id, kind, recipe, recipe_hash) VALUES ($1, $2, $3, 'edit', $4, $5)",
    )
    .bind(second)
    .bind(asset)
    .bind(edited)
    .bind(&checked.bytes)
    .bind(&checked.hash)
    .execute(&at.pool)
    .await
    .unwrap();
    sqlx::query("UPDATE assets SET current_version_id = $1")
        .bind(second)
        .execute(&at.pool)
        .await
        .unwrap();
    reconcile(&at.pool, &profile).await.unwrap();
    at.work(specs).await;
    let (version, lossless, jpeg) = exported(&at).await.expect("one export, the second version's");
    assert_eq!((version, lossless), (second.to_string(), false));
    let after = metadata_of(&jpeg);
    assert_eq!(
        (after.location, after.times),
        (before.location, before.times),
        "where and when, kept"
    );
    assert_eq!(
        (after.width, after.height),
        (checked.size.0, checked.size.1),
        "the edited size, in full"
    );
}

/// A small distinct JPEG per `seed`: its own colour and gradient, so that no two photos render to the same bytes.
fn small_jpeg(seed: u8) -> Vec<u8> {
    vips();
    let pixels: Vec<u8> = (0..96 * 64)
        .flat_map(|i| {
            [
                seed.wrapping_mul(37),
                (i % 96) as u8 * 2,
                seed.wrapping_mul(91).wrapping_add((i / 96) as u8),
            ]
        })
        .collect();
    rs_vips::VipsImage::new_from_memory_copy(&pixels, 96, 64, 3, rs_vips::enums::BandFormat::Uchar)
        .and_then(|image| image.jpegsave_buffer())
        .unwrap()
}

/// Photos rendered at once each get their own renditions: a pooled renderer goes back to the pool only after its
/// output was read, so no job reads (or finds deleted) the files of another photo's job (PHO-243: 7 of 60 render jobs
/// failed once with ENOENT or an integrity error, and the previews of 21 of 60 photos were another photo's).
#[tokio::test(flavor = "multi_thread", worker_threads = 4)]
async fn photos_rendered_at_once_never_share_a_renderers_output_files() {
    let at = instance().await;
    for seed in 0..64u8 {
        at.upload(&format!("DCIM/{seed}.jpg"), &small_jpeg(seed)).await;
    }
    at.work_at(render::specs(), 8).await;
    let retried: i64 = sqlx::query_scalar("SELECT count(*) FROM jobs WHERE attempts > 1")
        .fetch_one(&at.pool)
        .await
        .unwrap();
    assert_eq!(retried, 0, "no render job needed a second attempt");
    let shared: Vec<String> = sqlx::query_scalar(
        "SELECT role || ' of ' || count(*) || ' photos' FROM asset_files WHERE render_spec IS NOT NULL
         GROUP BY role, content_hash HAVING count(*) > 1",
    )
    .fetch_all(&at.pool)
    .await
    .unwrap();
    assert!(shared.is_empty(), "photos with the same rendition bytes: {shared:?}");
}
