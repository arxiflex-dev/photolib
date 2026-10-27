# ADR-0387 — HEIC in the browser: the kernel finds the HEIF tiles, WebCodecs decodes them

* **Status**: **Proposed** — owner to confirm. Becomes *Accepted — YYYY-MM-DD*; once accepted, only
  *Superseded by ADR-NNNN* may change it.
* **Requirements**: R-APP-5, R-MODE-1. **Design**: docs/08 §2.1 (the web cell for HEIC) and §2.3 (browser codecs only on
  the web), docs/10 §7.2. Builds on ADR-0004's rule (the design repository's) that the kernel parses and never decodes,
  [ADR-0214](0214-heic-and-hevc-without-a-system-decoder.md) (no codec ships with the apps or the web) and
  [ADR-0107](0107-desktop-and-web-thumbnail-decoders.md)'s browser decoders in a worker.

## Context

No browser but Safari decodes HEIC as an image. Chrome and Edge on macOS and Windows do decode HEVC *video* through
the operating system's licensed decoder (VideoToolbox, Media Foundation with the HEVC Video Extension) and expose it
to pages through WebCodecs. A HEIC file is HEVC keyframes in a HEIF container, so the web app can decode it with the
system decoder at no licence or patent cost and with no decoder bytes in the bundle: the owner's rule of 2026-10-21,
"use the system decoder where it is easy". The owner's Chrome library of iPhone photos (main `9db962179`) showed every
HEIC as a marked placeholder.

## Decision

* **The kernel's HEIF call is codec-free.** `ReadHeif` (`METHOD_READ_HEIF`, `proto/photolib/kernel/v1/heif.proto`) is
  pure parsing of the boxes `ReadMetadata` already reads (`pitm`, `iinf`, `iloc`, `iref`, `ipco`, `ipma`): for the
  primary item, and for its `thmb` item, the codec by item type (`hvc1`, `hev1`, `av01`, `avc1`), the payload of its
  `hvcC`, `av1C` or `avcC` (the WebCodecs description) with the WebCodecs codec string made from it, its `ispe` size, its
  byte ranges, and for a `grid` its rows, columns, output size and tiles in order; with `clap`, `irot` and `imir`. A
  primary that is a `tmap` gives its base image. A file whose primary item is in no such codec says so (the item type),
  one without the configuration box says so, a damaged one is not HEIF, and an image beyond the end of a file of known
  size is not offered. It decodes no pixel and links no codec (ADR-0004); it is fuzzed with the other container
  parsers (the `read_metadata` target).
* **The web decodes in the worker.** The thumbnail worker (`browser_thumbnails.dart`), when `ImageDecoder` and
  `createImageBitmap` refuse a file, loads the kernel's WASM module (`kernel/photolib_kernel_wasm.js`, as the data worker
  does), asks `ReadHeif` with the file's first 64 KiB and the ranges it names, checks
  `VideoDecoder.isConfigSupported({codec, description})` once for each codec configuration in the session, decodes each
  tile as one keyframe, draws the tiles onto an `OffscreenCanvas` in grid order, applies `clap`, then `irot` and
  `imir` (never the EXIF orientation again), and resizes to the tier. The `thmb` item is used where its short side is
  at least the tier; the viewer's screen-size image and the full picture go through the same path (tiers up to 1024
  today). Nothing runs on the page's thread but the move of the finished bitmap.
* **Where the check says unsupported** (Linux Chrome without VA-API, Windows without the HEVC Video Extension,
  Firefox), the placeholder keeps its reason: "this browser cannot decode HEVC; the desktop app and a connected server
  show it" (M1-44 covers those browsers). A decoder error on one tile marks the file, never the folder.
* **The web part proves the path with AVC twins.** Chrome decodes AVC in software on every platform and HEIF allows
  `avc1` items, so `tools/corpus/avc_twins.py` writes AVC-coded HEIF twins of the corpus' grid, `clap`, `irot` and
  `imir` HEIC files (`testdata/corpus/twins/heif-avc/`, I_PCM macroblocks, no codec in the build), and the web part
  decodes them in Linux Chrome to golden colours within 4/255. Real HEVC is proven only on the owner's Mac (Chrome run and
  `tools/smoke.sh macos`) and with Edge on Windows.
* **docs/08 §2.1's web cell** for HEIC reads: *system decoder via WebCodecs on macOS and Windows Chromium; else R, see
  M1-44.* That document lives in the design repository (ADR-0017), not here: this ADR records the wording and the owner
  applies it there.

## Relation to ADR-0116

[ADR-0116](0116-web-video-posters.md) (Accepted) keeps video posters on the off-DOM `<video>` with no WebCodecs
`VideoDecoder`, because decoding video that way needs a demuxer per container. This ADR does not change that: posters
stay on `<video>`. The HEIF-still path uses `VideoDecoder` only for single keyframes the kernel has already located,
in the thumbnail worker, so it needs no demuxer. `tools/tests/test_web_posters_docs.sh`, which forbade `VideoDecoder`
anywhere in the app, is narrowed to allow that one file (`browser_thumbnails.dart`) and to assert it asks
`isConfigSupported`; the owner may disagree (see the PR's questions).

## Consequences

* The web shows HEIC where the system decodes HEVC, at no licence cost; the bundle gains no decoder, only the call and
  about 250 lines of worker script (the protobuf codec for two messages, the compositing).
* Every bytes range the call needs is read by the worker from the `File`, so a folder of HEIC costs the first 64 KiB
  of each file plus its tiles.
* A kernel change to `ReadHeif` is a change to a conformance vector (`kernel/testvectors/heif.json`) every binding runs.
* Not covered: HEIC bursts' and Live Photos' other frames, `iovl` overlays, auxiliary images (depth, gain maps) and the
  HDR rendering of a 10-bit image: the worker shows the base image in the browser's colour management.
* Unverified on this build's hardware: Chrome on macOS (VideoToolbox) and Edge on Windows decoding real HEVC, 8- and
  10-bit.

## Evidence

Chromium 156 (Playwright's build, which decodes AVC and AV1 but no HEVC) runs the web build under photolibd's
Content-Security-Policy, with a folder of the six AVC twins, the corpus' HEVC `iphone.heic` as `IMG_7429.HEIC` and a
JPEG in OPFS, behind a `showDirectoryPicker` that returns it (`assets/0387/`, 1280 px at most; the sources are the
screenshots of that run, taken by a Playwright script, then scaled with FFmpeg):

* `grid-chrome-desktop.jpg`: the library grid, the six twins upright as their `irot`, `imir` and `clap` say, the HEVC
  file a mark, the JPEG as ever.
* `viewer-chrome-desktop.jpg`: the viewer on the first twin, its filmstrip below.
* `placeholder-no-hevc-chrome-desktop.jpg`: the mark's tooltip, "browser: refused IMG_7429.HEIC: this browser cannot
  decode HEVC; the desktop app and a connected server show it".
* `grid-chrome-mobile-emulation.jpg`, `viewer-chrome-mobile-emulation.jpg`: the same in a Pixel 7 emulation (touch,
  device pixel ratio 2.625, CPU slowed 4 times, the network at 1.5 MB/s).

Run again on 2026-10-27 at `80a45ed7` on Linux arm64 (no GPU, no HEVC decoder): the app built with
`flutter build web --wasm` in Chromium 156 (desktop and Pixel 7 emulation with the CPU slowed 4 times) shows the six
twins upright and the HEVC file marked (`grid-chromium-156-aarch64.jpg`, `viewer-chromium-156-aarch64.jpg`,
`grid-phone-emulation-aarch64.jpg`, `viewer-phone-emulation-aarch64.jpg`). The worker's own script, read from
`browser_thumbnails.dart`, decodes the six twins in Chromium 156 (also on the phone emulation) and in Firefox 157 (which
has `VideoDecoder` and AVC) to within 3/255 at full size, asks `isConfigSupported` once per configuration, and refuses
the corpus' `iphone.heic` in all three with "this browser cannot decode HEVC; the desktop app and a connected server
show it" (`isConfigSupported(hvc1…)` is false there).

## Options considered

* **A WASM HEVC decoder** (libheif-js): 1.2 to 2.0 s per 12 MP photo and a codec in the bundle; refused by ADR-0214.
* **The kernel decoding the tiles**: a codec in the kernel, against ADR-0004.
* **Decoding in the page**: WebCodecs works there, but the item requires zero decode cost on the main thread.
* **The grid's tiles through `ImageDecoder` as video**: `ImageDecoder` takes still-image types only.
