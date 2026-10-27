# HEIC and HEVC without a system decoder (M1-44)

Where a HEIC photo or an HEVC video has no decoder in standalone mode, what main does there today, what each way out
costs, and a proposal per cell. Measured on 2026-10-21 at `818b5be` on Linux x86-64 (a shared 8-vCPU machine
without a GPU, load average 6-15), with Chrome for Testing 155.0.8059.84 and Firefox 158.0.1. M1-43 covers the
browsers whose system decodes HEVC ([ADR-0387](../adr/0387-heic-in-the-browser-with-webcodecs.md): the kernel's
`ReadHeif` finds the tiles and WebCodecs decodes them in the thumbnail worker); the decisions are
[ADR-0214](../adr/0214-heic-and-hevc-without-a-system-decoder.md), as the owner answered the
[questions](#questions-for-the-owner) on 2026-10-21.

## How it is measured

`node tools/heic/bench.mjs [chrome|firefox]...` prints the tables below (`HEIC_JSON=<file>` keeps every number). In
each headless browser it:

* runs the thumbnail worker's script of `app/lib/features/library/timeline/browser_thumbnails.dart`, read from that
  file, on every twin as a browser folder hands it a file, and asks the browser's own checks (`ImageDecoder`,
  `MediaSource.isTypeSupported`, `canPlayType`, WebCodecs' `VideoDecoder`) and a `<video>` per codec, from clips the
  pinned LGPL FFmpeg codes (kvazaar, OpenH264, SVT-AV1); Firefox gets that FFmpeg's libraries as a Linux desktop's
  system FFmpeg, as `tools/video/play.mjs` does;
* loads [libheif-js](https://github.com/catdad-experiments/libheif-js) 1.23.5 from npm, checked against its pinned
  integrity: libheif 1.23.5 and libde265 built with Emscripten, without an AV1 decoder. A worker loads it twice, cold
  in a fresh profile, then from the HTTP cache, and decodes each twin three times: the primary image to RGBA, the
  512-pixel tile `browser_thumbnails.dart` would make of it, and the `thmb` item alone. Times are the fastest run;
  the heap is the WASM memory after the decode, which never shrinks; browser memory is the growth of all its
  processes' resident memory over the probe phase.

The corpus' HEIC payloads are placeholders, so `tools/heic/twins.py` makes a decodable twin of each of its 18 HEIC
records: the record's size, bit depth and `irot`, `imir` or `clap`, laid out as an iPhone writes it (48 HEVC tiles
of 512 pixels in a grid and a 320-pixel `thmb` item; one image for the Pixel), coded by x265 at about 2.4 MB per
12 MP, which is what an iPhone photo weighs. Its picture is the record's corpus picture with grain; *Upright* says
whether the colours at 30-36 probe points are where ISO/IEC 23008-12:2022 puts them after the transforms.

## The cells

*On main* is what the code does today: **run** where `bench.mjs` or a command here did it, **read** from the code
path named where this machine cannot run it (†: confirm on that platform). Options are those of the issue: (a)
accept with a placeholder that names the way out, (b) a WASM decoder for the web, (c) the system's codecs or a codec
plugin on desktops, (d) the kernel's embedded preview, (e) conversion on import, (f) dual-encoded renditions.

| Cell | Formats | On main | Options | Proposal |
|---|---|---|---|---|
| Chrome and Edge on Linux | HEIC/HEIF stills, bursts, Live Photo stills | **Run**: a folder library works, but the worker refuses every twin (`InvalidStateError: The source image could not be decoded`), so each cell is a broken-image mark with that cause; `ImageDecoder` and `VideoDecoder` refuse HEVC, so M1-43 cannot help: Chrome has no software HEVC, only VA-API hardware it finds itself | (a); (b) 1.2-2.0 s per 12 MP photo, 2-3 ms per grid tile from `thmb`, 0.38 MB; (d) none, `thmb` is HEVC; (f) only through a server | (a); not (b) (question 1) |
| Firefox, every desktop | HEIC stills | **Run** on Linux: no `showDirectoryPicker`, so no folder library at all ("This browser cannot keep a folder as your library…"); its worker refuses HEIC as Chrome's does, and `VideoDecoder` takes no HEVC | (a) as today; (b) has nothing to decode without a folder; (f) | Connected mode; no folders (question 3) |
| Safari on macOS | HEIC decodes natively since Safari 17 | **Read**: `browserFolders` is null without `showDirectoryPicker` (`photolib_data/browser_folders.dart`), so the empty library says folders are unsupported † | A `webkitdirectory` folder per visit (question 3) | No folder library; connected mode |
| Chrome and Edge on Windows without the HEVC Video Extension | HEIC stills | **Read**: as on Linux today; with M1-43, `VideoDecoder.isConfigSupported` has no Media Foundation HEVC decoder to report † | (a) naming the extension; (b) | (a); not (b) (question 1) |
| Windows app without the HEVC Video Extension | HEIC stills, Live Photo stills | **Read**: `thumbnail_channel.cpp`'s shell factory and WIC need the HEVC Video Extension besides the free HEIF Image Extension; no libvips sits beside the app before M10-04; Flutter's codecs refuse; the cell is a mark and the viewer finds no screen-size image † | (a) naming the Store's extension; (c) an LGPL plugin outside the store build | (a) naming connected mode or a Mac; no plugin (question 2) |
| Linux app without libheif | HEIC stills, Live Photo stills | **Run**: libvips 8.15 with libheif 1.17 but without `libheif-plugin-libde265` (its plugins hidden with `LIBHEIF_PLUGIN_PATH`), as Debian and Ubuntu install it (`libheif1` only suggests the plugin): `vips_thumbnail` fails with `heif: Unsupported feature: Unsupported codec (4.3000)`, the cell is a mark; without libvips Flutter's codecs refuse; the freedesktop cache helps only when a file manager with HEVC made a thumbnail | (a) naming the package; (c) | (a) naming connected mode or a Mac; no plugin (question 2) |
| Android below API 28 | HEIF | **Read**: no such phone runs Photolib: `minSdk = 30` (`app/android/app/build.gradle.kts`) | — | Nothing to do |
| Android 11 (API 30), AVIF | AVIF stills | **Read**: MediaStore's `loadThumbnail` and `BitmapRegionDecoder` decode AVIF from Android 12 (API 31) on, so the cell is a mark † | (a); (f) | (a); connected mode |
| HEVC video in Chrome on Linux | HEVC 8- and 10-bit, Live Photo and motion-photo clips | **Run**: `<video>` fails (`DEMUXER_ERROR_NO_SUPPORTED_STREAMS`), MSE, `canPlayType` and `VideoDecoder` refuse HEVC, so the poster is "Can't play in this browser" | (a); FFmpeg's HEVC decoder in WASM; (f) | (a); connected mode (R1) |
| HEVC video in Firefox | HEVC 8- and 10-bit | **Run** on Linux with a system FFmpeg that has HEVC: `<video>` plays it and MSE takes Main and Main 10, `VideoDecoder` does not. Fedora's `ffmpeg-free` and openSUSE's FFmpeg have no HEVC decoder, so it fails there †; on Windows Firefox 134+ uses the HEVC Video Extension † | (a); (f) | (a); connected mode (R1) |
| 10-bit HEVC video | HEVC Main 10: HLG, PQ, Dolby Vision 8.4 | **Run**: as 8-bit in both browsers; the desktop apps play it through libmpv's FFmpeg (the bundled LGPL build on Windows, M1-39; the distribution's on Linux, without HEVC on Fedora) | (f) | Connected mode: R1 in SDR; the original where the display and decoder take HDR |
| HEIC bursts | One HEIC per shot (`BurstUUID`) | **Read**: each shot is its own file, so its still's cell applies; HEIF image sequences (`msf1`) are not in the corpus and libheif-js' wrapper decodes items, not sequences | As stills | As stills |
| Live Photo stills | HEIC still and HEVC MOV | **Run**: the still is a still's cell, its clip a video's (the twins `compound/live/IMG_2001.HEIC`, the HEVC clip) | As both | As both |
| Apple ProRAW (DNG 1.7, JPEG XL tiles) | DNG | **Read**: on desktops the tile is the kernel's largest embedded JPEG, turned as the DNG is (ADR-0247), and no decoder reads the JPEG XL tiles †; on the web `embeddedPreview` reads only `file:` URIs and the browser refuses the DNG, so the cell is a mark | (d) on the web through the kernel's WASM (M1-42) | (d) with M1-42; connected mode for the full picture |
| Connected mode (server renditions) | Every format above | **Read**: the server renders WebP thumbnails and a JPEG preview through libheif and libde265 (ADR-0084) and an H.264 R1 proxy (ADR-0085); the app shows server renditions from M2-42 and the web client from M2-25 | (f) | Closes every cell: the original where it decodes, the universal JPEG or H.264 elsewhere |

The placeholder M1-43's unsupported case shows, per cell (English; translations follow the strings rule):

| Cell | Placeholder |
|---|---|
| Chrome and Edge on Linux | "Chrome and Edge on Linux can't show HEIC photos. Open this folder in the Photolib app, or connect a Photolib server." |
| Firefox, every desktop | none: Firefox keeps no folder library, and the empty library says so |
| Safari on macOS | none: as Firefox |
| Chrome and Edge on Windows without the HEVC Video Extension | "Windows needs the HEVC Video Extensions from the Microsoft Store to show HEIC photos here." |
| Windows app without the HEVC Video Extension | "Photolib can't show HEIC photos on this PC. Connect a Photolib server to see its copy, or open them on a Mac." |
| Linux app without libheif | "Photolib can't show HEIC photos on this computer. Connect a Photolib server to see its copy, or open them on a Mac." |
| Android below API 28 | none: Photolib needs Android 11 |
| Android 11 (API 30), AVIF | "Android 11 can't show AVIF photos. Android 12 or a connected Photolib server can." |
| HEVC video in Chrome on Linux | "Chrome and Edge on Linux can't play HEVC video. Play it in the Photolib app, or connect a Photolib server." |
| HEVC video in Firefox | "This Firefox can't play HEVC video. Install FFmpeg with HEVC, or connect a Photolib server." |
| 10-bit HEVC video | "This device can't play 10-bit HEVC video. A connected Photolib server can." |
| HEIC bursts | none: each shot shows its still's placeholder |
| Live Photo stills | none: the still and the clip show their own |
| Apple ProRAW | "Showing the photo's preview. The Photolib app or a connected server shows the RAW." |
| Connected mode | "Preparing the server's copy…" |

## Measurements

libheif-js loads in well under a second and decodes a 12 MP photo in about 1.4 s in either browser, or a grid tile's
`thmb` in 2-3 ms:

| Browser | Module (raw / gzip / brotli) | Cold load | Second load | Browser memory growth |
|---|---|---|---|---|
| Chrome 155 | 1.55 / 0.51 / 0.38 MB | 56 ms | 45 ms | 463 MB |
| Firefox 158 | 1.55 / 0.51 / 0.38 MB | 147 ms | 113 ms | 345 MB |

Chrome 155, libheif 1.23.5 (Firefox 158: 1.13-1.73 s a tile, the same `thmb` times and heap, every twin upright):

| Twin | Bytes | Shown | 512 tile | thmb | Wasm heap | Upright |
|---|---|---|---|---|---|---|
| `compound/depth/portrait.heic` | 2.41 MB | 4032 × 3024 | 1389 ms | 2 ms | 69 MB | yes |
| `compound/edited/IMG_3001.HEIC` | 2.41 MB | 4032 × 3024 | 1437 ms | 3 ms | 69 MB | yes |
| `compound/live/IMG_2001.HEIC` | 2.41 MB | 4032 × 3024 | 1428 ms | 2 ms | 69 MB | yes |
| `compound/motion/pixel-motion.heic` | 2.29 MB | 4032 × 3024 | 1203 ms | none | 104 MB | yes |
| `compound/odd/heic-saved-as.jpg` | 2.38 MB | 4032 × 3024 | 1388 ms | 3 ms | 104 MB | yes |
| `compound/pano/spatial.heic` | 2.00 MB | 3840 × 2160 | 1260 ms | 2 ms | 104 MB | yes |
| `hdr/apple-gain-map.heic` | 2.41 MB | 4032 × 3024 | 1571 ms | 3 ms | 104 MB | yes |
| `hdr/iso-gain-map.heic` | 2.38 MB | 4032 × 3024 | 1652 ms | 3 ms | 104 MB | yes |
| `hdr/pq-10bit.heic` | 2.39 MB | 4032 × 3024 | 2022 ms | 3 ms | 125 MB | yes |
| `names/IMG_1234.HEIC` | 2.41 MB | 4032 × 3024 | 1334 ms | 3 ms | 125 MB | yes |
| `stills/10bit.heic` | 2.39 MB | 4032 × 3024 | 1423 ms | 2 ms | 125 MB | yes |
| `stills/alpha-aux.heic` | 2.41 MB | 4032 × 3024 | 1268 ms | 2 ms | 125 MB | yes |
| `stills/clap.heic` | 2.40 MB | 4000 × 3000 | 1259 ms | 2 ms | 125 MB | yes |
| `stills/grid.heic` | 2.40 MB | 4032 × 3024 | 1554 ms | 2 ms | 125 MB | yes |
| `stills/imir.heic` | 2.40 MB | 4032 × 3024 | 1332 ms | 2 ms | 125 MB | yes |
| `stills/iphone.heic` | 2.40 MB | 4032 × 3024 | 1278 ms | 2 ms | 125 MB | yes |
| `stills/irot.heic` | 2.40 MB | 3024 × 4032 | 1420 ms | 2 ms | 125 MB | yes |
| `takeout/Google Photos/Photos from 2022/IMG_6001.HEIC` | 2.41 MB | 4032 × 3024 | 1281 ms | 3 ms | 125 MB | yes |

| Check | Chrome 155 | Firefox 158 |
|---|---|---|
| `ImageDecoder` takes `image/heic` | false | false |
| main's worker on the HEIC twins | InvalidStateError: The source image could not be decoded. | InvalidStateError: The image could not be decoded |
| main's worker on AVIF and JPEG | ImageDecoder 910x512; ImageDecoder 910x512 | ImageDecoder 910x512; ImageDecoder 910x512 |
| HEVC Main: MSE / canPlayType / VideoDecoder | false / "" / false | true / probably / false |
| HEVC Main 10: MSE / canPlayType / VideoDecoder | false / "" / false | true / probably / false |
| H.264 High: MSE / canPlayType / VideoDecoder | true / probably / true | true / probably / true |
| AV1 Main 8-bit: MSE / canPlayType / VideoDecoder | true / probably / true | true / probably / true |
| AV1 Main 10-bit: MSE / canPlayType / VideoDecoder | true / probably / true | true / probably / true |
| `<video>` plays hevc | DEMUXER_ERROR_NO_SUPPORTED_STREAMS: FFmpegDemuxer: no supported streams | 17 frames |
| `<video>` plays h264 | 19 frames | 17 frames |
| `<video>` plays av1 | 17 frames | 16 frames |
| showDirectoryPicker / webkitdirectory | true / true | false / true |

* The decode is libde265's: the twins' 48 tiles cost what one 12 MP image does; the first decodes after a load ran
  up to twice as long while the engines optimised the module. 10-bit twins decode as fast and come out as 8-bit RGBA.
* The heap grows to 125 MB and stays there until the worker ends; the RGBA picture (48 MB at 12 MP) is allocated
  again in JavaScript. A product worker would decode one photo at a time and end after a few.
* The `thmb` item (320 × 240) is enough for the grid's 128 and 256 tiers: 2-3 ms a tile, the kernel locating it
  as M1-43's call does. The 512 tier, the viewer and deep zoom need the full decode.
* FFmpeg's HEVC decoder in WASM was not measured: ffmpeg.wasm's core is 32 MB, GPL-2.0-or-later (it links x264 and
  x265) and FFmpeg 5.1 has no HEIF demuxer; a minimal LGPL build with only the HEVC decoder would still need HEIF's
  grid composed by the kernel and has no advantage over libde265 here.

## The options

* **(a) Accept, with a placeholder that names the way out.** No cost but the texts above, which M1-43's unsupported
  case shows. Every cell keeps its ThumbHash or kernel stand-in where there is one.
* **(b) A WASM decoder for the web**, loaded only when M1-43's check fails: 0.38 MB brotli, under 0.2 s to load,
  1.2-2 s and 125 MB of heap per 12 MP photo in a worker, 3 ms per grid tile from `thmb`. Grid tiers would fill at
  screen speed; the viewer would wait 1-2 s for a photo. It helps only Chrome and Edge on Linux and Windows without
  the extension: Firefox and Safari have no folder library to decode. In connected mode it is never needed.
* **(c) The system's codecs or a plugin on desktops** (docs/08 §11 (b)): on Linux the distribution's libheif HEVC
  plugin, which main already uses through libvips when installed; on Windows the HEVC Video Extension, which WIC and
  Media Foundation then use. A Photolib-built LGPL pack (libvips, libheif, libde265) for the Windows and Linux
  packages outside the stores is the plugin proper; the owner ruled it out in every build (question 2), and the
  placeholders name connected mode or a Mac rather than a codec to install.
* **(d) The kernel's embedded preview.** An iPhone HEIC has none but its HEVC `thmb`; Samsung's is HEVC too. It
  serves RAW and DNG (ProRAW's preview is JPEG), so E applies to those cells only.
* **(e) Conversion on import** is rejected: originals stay immutable and complete (docs/08 §1); converting changes
  hashes, deduplication and C2PA signatures, loses 10-bit, gain maps and auxiliary images (depth, mattes), doubles
  storage or destroys the original, and formats keep coming (AVIF, JPEG XL, APV), each a new conversion.
* **(f) Dual-encoded renditions**, [below](#dual-encoded-renditions): the original where it decodes, a universal
  JPEG or H.264 elsewhere; they close every cell in connected mode.

## Licences and patents

Facts for the owner, not legal advice; sources read on 2026-10-21.

* **Licences.** libheif's library and libde265's are LGPL-3.0, their sample programs MIT
  ([libheif](https://github.com/strukturag/libheif/blob/master/COPYING),
  [libde265](https://github.com/strukturag/libde265/blob/master/COPYING)); libheif-js is LGPL-3.0. FFmpeg is
  LGPL-2.1-or-later, GPL when built with GPL parts such as x264 or x265 ([legal](https://ffmpeg.org/legal.html)).
  dav1d is BSD-2-Clause, kvazaar BSD-3-Clause, x265 GPL-2.0 with a commercial licence. LGPL lets an AGPL app ship
  the module unmodified with its notice and source, replaceable by the user.
* **HEVC pools.** [Access Advance](https://accessadvance.com/hevc-advance-patent-pool-detailed-royalty-rates/)
  charges per unit by category from 2026: mobile devices $0.50 (region 1) or $0.25, "all HEVC software" $1.00 or
  $0.50 (capped at $30M), with a $25,000 annual enterprise credit and a $60M enterprise cap; streaming is a separate
  pool. Its [FAQ](https://accessadvance.com/faq/): "In general, HEVC software downloaded by users requires a
  license", case by case. Access Advance bought Via LA's HEVC/VVC program on 2025-12-15 ([Via
  LA](https://www.via-la.com/licensing-programs/hevc-vvc/)): the first 100,000 units a year free, then $0.30 or
  $0.20 a unit, capped at $30M. [Velos Media](https://www.velosmedia.com/) publishes no rates. None of the three
  publishes an exemption for free software.
* **H.264.** [Via LA's AVC licence](https://www.via-la.com/licensing-programs/avc-h-264/): encoders and decoders
  free for the first 100,000 units a year, then $0.20 to 5M and $0.10 beyond, capped at $9.75M a year; streaming fees
  by service category (OTT, FAST, social media, cloud gaming; $100,000 a year for a small service) and titles of 12
  minutes or less free. MPEG LA's [terms
  summary](https://web.archive.org/web/20141217203048/http://www.mpegla.com/main/programs/avc/Documents/AVC_TermsSummary.pdf)
  promised no royalty "for the life of the License" on Internet Broadcast AVC Video free to end users; today's page
  no longer states it, so whether it still holds is a question for the licence text. Cisco pays the royalty only for
  its own [OpenH264 binary](https://www.openh264.org/faq.html), not for builds from its source.
* **AV1** carries the royalty-free [AOMedia patent licence](https://aomedia.org/license/patent-license/);
  [Sisvel's AV1 pool](https://www.sisvel.com/licensing-programmes/audio-and-video-coding-decoding/video-coding-platform-av1/)
  asks device makers €0.11-0.32 a device, which AOMedia disputes.
* **Distributions.** Debian keeps libheif, libde265 and `libheif-plugin-libde265` in
  [main](https://packages.debian.org/source/stable/libheif); Ubuntu 24.04 too, but `libheif1` only suggests the HEVC
  plugin (`apt-cache depends libheif1`, run here) while it depends on dav1d's; Arch has both in
  [extra](https://archlinux.org/packages/extra/x86_64/libheif/); [Fedora's
  libheif](https://packages.fedoraproject.org/pkgs/libheif/) has no libde265 plugin and its `ffmpeg-free` no HEVC
  decoder, RPM Fusion's [libheif-freeworld](https://github.com/rpmfusion/libheif-freeworld) adds it; openSUSE has
  libde265 only in Packman; the [freedesktop SDK](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/blob/freedesktop-sdk-25.08.18/elements/include/libheif.yml)
  under Flathub builds libheif with AV1 but without HEVC.
* **Windows.** The [HEIF Image Extension](https://apps.microsoft.com/detail/9pmmsr1cgpwg) is free but decodes
  `.heic` only with the [HEVC Video Extensions](https://apps.microsoft.com/detail/9nmzlz57r3t7) ($0.99); the free
  "from Device Manufacturer" variant still exists for OEM images; Media Foundation lists no HEVC of its own.
* **Browsers.** Chrome decodes HEVC with hardware only, from Chrome 107 ([chromestatus](https://chromestatus.com/feature/5186511939567616)),
  on Linux through VA-API when it finds it; Firefox from 134 on Windows, 136 on macOS and 137 on Linux through the
  system ([bug 1842838](https://bugzilla.mozilla.org/show_bug.cgi?id=1842838)); only Safari decodes HEIC images, from
  Safari 17 ([release notes](https://developer.apple.com/documentation/safari-release-notes/safari-17-release-notes)).
  WebKit opposes `showDirectoryPicker` ([standards position](https://github.com/WebKit/standards-positions/issues/28));
  `webkitdirectory` works in Firefox 50+ and Safari 11.1+.
* **Others.** Immich builds libheif with libde265 and dav1d into its [server image](https://github.com/immich-app/base-images/blob/main/server/Dockerfile),
  PhotoPrism installs libde265 and its own libheif in its [image](https://github.com/photoprism/photoprism/blob/develop/docker/develop/noble-slim/Dockerfile),
  Nextcloud disables its HEIC preview provider by default ([config.sample.php](https://github.com/nextcloud/server/blob/master/config/config.sample.php));
  Ente's web client alone ships libheif-js to browsers, through `heic-convert` in a worker (below).

The exposure each option leaves the owner with: (a) and (d) none; (c) through the distribution or Microsoft's
extension none for the project, the user holds the codec; (b) and a Photolib-built plugin distribute an HEVC decoder
to every browser or desktop that loads it, the posture docs/08 §2.3 already takes for the server image, now per
client, with no published exemption to rely on; (e) none, and rejected; (f) the server's existing HEVC decoders and
H.264 encoder, plus royalty-free AV1.

## Dual-encoded renditions

The owner's direction (brainstorm photolib-design#571): the original is never converted; one universal rendition is
made by default by the first thing that decodes it, and clients that decode the original open it, the rest the
rendition. The pair per source is therefore the original as the primary and a universal rendition as the fallback:

| Source | Primary | Fallback | Chosen by |
|---|---|---|---|
| HEIC/HEIF still, 8-bit | the original, where the client decodes it (Safari, M1-43, the apps with system codecs) | the universal JPEG: `high`, full size, q≈92-95, by default (M2-49); `standard`, today's `preview` (long side 2160, q≈85, M2-09), until then and for small disks | `<picture>` with `<source type="image/heic" srcset="…original">` before the JPEG `<img>` in the viewer; the app's capability check (M1-43's in browsers, the decoder list on devices) |
| HEIC/HEIF still, 10-bit or HDR | the original, where decoded with its gain map | the universal JPEG with its Ultra HDR gain map: the SDR base everywhere, HDR where shown (docs/08 §4.2) | as above, and the display's `dynamic-range` |
| Grid thumbnails of any still | — | `thumb_s`, `thumb_m`: WebP, which every client decodes | no choice |
| HEVC video, 8- or 10-bit | the original (R0), where the client plays it | R1 `video_proxy_720`: H.264, SDR, AAC (M2-10, today) | `<video>` with `<source type='video/mp4; codecs="hvc1…"'>` before the H.264 source; `MediaSource.isTypeSupported` in MSE players; `GetPlayback` in the app (docs/08 §5.2) |
| Live Photo and motion clips in HEVC | the clip's byte range | `video_proxy_clip`: H.264 (docs/08 §5.1) | `MediaSource.isTypeSupported` |

* **Why JPEG and H.264, not AVIF and AV1.** Every screen decodes them with little CPU; AVIF and AV1 have no universal
  decoder (Flutter on Windows and Linux decodes AVIF only through libvips with dav1d or the AV1 extension) and cost
  more to encode: on this machine the 2160-pixel JPEG of a twin took 0.14 s, AVIF 0.87 s with SVT-AV1 at preset 8
  and 2.33 s with libaom, 6-17 times as long. WebP stays for thumbnails and alpha only (8-bit, no gain map, 4:2:0,
  16,383 pixels at most); AVIF and AV1 stay docs/08's negotiated variants for later (open question 8).
* **Who makes it.** The phone at backup time with the system's encoders (an upload then carries its rendition, so the
  server needs no HEVC decoder for it, docs/08 open question 9), the server for scanned folders and uploads without
  one, and a desktop app that decodes the original, as on a Mac, for its own folders when they join a library or
  are exported.
* **Where it applies.** In connected mode the server decodes every source with libheif, libde265 and FFmpeg, so the
  renditions M2-09 and M2-10 already make close every cell above once the app shows them (M2-42) and the web client
  exists (M2-25). A private library's renditions come from the uploading device (M6-04).
* **Where it cannot.** A standalone browser library has no encoder that has seen the pixels: a page can encode only
  after decoding. It helps there only when a desktop app with codecs exports for the web (static albums, M9-01) or
  works as a trusted node for a private library (M6-11).
* **What it adds.** To docs/08 §4.1 and §5.1 nothing new in the ladder: `preview`, R1 and `video_proxy_clip` are the
  fallbacks, made for every HEIC and HEVC source as today; M2-08's ingest accepts them from the uploading device
  (docs/08 §4.3's client-made renditions, for standard libraries too), and the quality below is a library setting
  the reconciler re-renders by, `high` by default (the owner, question 4): docs/08 §4.1's "no full-size copy for
  HEIC/RAW" gives way for it.

### The rendition's quality

Measured on the twins of `stills/iphone.heic`, `stills/10bit.heic` and `compound/live/IMG_2001.HEIC` (2.4 MB each)
with libvips 8.15 and libjpeg-turbo: the twins' grain makes JPEG larger than a real photo's would be, so the owner's
estimates for real photos are beside them.

| Quality | Rendition | On the twins | Real photos (estimate) | 100k iPhone photos |
|---|---|---|---|---|
| `standard`, the per-library option for small disks | long side 2160, q≈85: today's preview | 0.74 MB, 0.14 s | ≈ 350 KB | ≈ 35 GB beside ≈ 250 GB of originals |
| `high`, the default | full size, q≈92-95, Ultra HDR kept | 4.4-6.0 MB, 0.17 s | ≈ 4-8 MB | ≈ 450-600 GB |
| `lossless`, not offered | full size, WebP lossless | 9.5-12.6 MB, 9.4 s | ≈ 12-18 MB, HDR lost | ≈ 1-1.5 TB |

### How the others do it

The owner's hypotheses (photolib-design#571), checked against each product's code or help pages on 2026-10-21:

| Product | HEIC handling | HDR | Verdict |
|---|---|---|---|
| Immich | Original kept; JPEG preview 1440 px q80 and WebP thumbnail 250 px q80 by default ([config.dto.ts](https://github.com/immich-app/immich/blob/main/server/src/dtos/config.dto.ts)), through libvips and libheif; a full-size JPEG is an option, off by default | Flat: previews drop the gain map ([#18636](https://github.com/immich-app/immich/issues/18636), its most-reacted HEIC issue) | Confirmed |
| PhotoPrism | One JPEG sidecar per HEIC through libheif, every thumbnail from it; q83 and up to 15,360 px by default ([config options](https://docs.photoprism.app/getting-started/config-options/)), so a full-size copy | SDR only ([#3840](https://github.com/photoprism/photoprism/issues/3840)) | Confirmed; the sidecar is the `high` choice |
| Nextcloud Memories | Nextcloud's HEIC provider, off by default, makes JPEG through Imagick with libheif; Memories re-encodes at q85 | Gain map dropped ([memories#1110](https://github.com/pulsejet/memories/issues/1110)) | Confirmed |
| Ente | Thumbnails made on the client; the web decodes HEIC with `heic-convert` (libheif-js) in a worker and caches the result ([heic-convert.worker.ts](https://github.com/ente/ente/blob/main/web/packages/media/heic-convert.worker.ts)); the desktop app uses vips or sips first | iPhone HEIC shows SDR in the desktop app on Linux ([#12622](https://github.com/ente/ente/issues/12622)), the native path, not the browser's | Confirmed, but #12622 is the desktop's |
| Synology Photos | DSM 7.2.2 moved HEVC decoding off the NAS; Synology Image Assistant decodes on the client ([release notes](https://www.synology.com/en-global/releaseNote/DSM)) | Not documented | Confirmed; whether the Advanced Media Extensions cost money is not stated by Synology |
| Google Photos | Keeps HEIC; Storage saver resizes above 16 MP and may convert to JPEG ([help](https://support.google.com/photos/answer/6220791)) | HDR on the web, Android and iOS ([help](https://support.google.com/photos/answer/14159275)) | Partly: the web's JPEG transcode is not documented, and HDR is not Android-only |
| Apple Photos | Native HEIC; "Most Compatible" captures JPEG and H.264 ([help](https://support.apple.com/en-us/116944)); iCloud.com downloads the most compatible format | Gain maps since 2020 (Adaptive HDR) | Confirmed |
| OneDrive | HEIC shows on the web; Windows needs the Store's extensions ([help](https://support.microsoft.com/en-us/onedrive/upload-heif-and-hevc-photos-and-videos-to-onedrive)) | Not documented | Confirmed |

Nobody converts the original in place. Ente is the precedent for a WASM HEIC decoder in a browser (question 1).
jpegli, the server's JPEG encoder in docs/08 §4.1, compresses high-quality JPEG about 35 % more than libjpeg-turbo
([Google](https://opensource.googleblog.com/2024/04/introducing-jpegli-new-jpeg-coding-library.html)), which the
quality table's twins, coded with libjpeg-turbo, do not include.

## Questions for the owner

The owner answered on 2026-10-21
(photolib-design#600).

| Question | Lean | If yes | If no | Owner's answer |
|---|---|---|---|---|
| WASM fallback on the web: ship libheif-js, loaded when M1-43's check fails? | No for now: the design keeps browsers to their own codecs (docs/08 §2.3), Firefox and Safari have no folder library to use it, and connected mode needs none; revisit for private uploads from such a browser (M6-13) | M1-47 below; an HEVC decoder goes to every browser that loads it | The placeholders of M1-43; nothing new | Kept: no; Firefox and Chrome on Linux get the server's JPEG in connected mode and a placeholder naming the way out in standalone mode |
| Desktop codec plugin: an LGPL libheif and libde265 pack for the Windows and Linux apps, outside store builds? | Yes, user-installed, as docs/08 §11 (b) and open decision 7 recommend; the distribution's package or Microsoft's extension first | M1-48 | M1-49 alone: the placeholders name the distribution's package and the Store extension | Changed: no codec pack in any build, nothing HEVC-licensed on a client; M1-48 dropped, M1-49's placeholders name connected mode or a Mac |
| Safari folders: a read-only `webkitdirectory` folder per visit as a library in Safari and Firefox? | No: nothing persists between visits (re-pick and rescan every time, no identity for favourites or albums); `webkitdirectory` stays the upload picker of connected mode | M2-50 below | Nothing new (M2-25 has the upload picker) | Kept: no |
| Quality of the universal rendition: `standard`, `high` or `lossless` by default? | `standard` by default, `high` per library: today's preview costs ≈ 35 GB per 100k photos, a full-size copy doubles the library (docs/08 §4.1); `lossless` not offered (no HDR, 1-1.5 TB, nothing gained on a lossy source) | `high` by default: M2-49 below, ≈ 450-600 GB per 100k photos | M2-49 below as an option only, or nothing if `standard` is the only quality | Changed: `high` by default, `standard` per library for small disks, no `lossless`; M2-49 is P1 |

## Roadmap entries the answers open

Keys are the next free ones on 2026-10-21 (M1-45 is retired). M1-49, M2-48 and M2-49 open as the owner answered;
M1-47 and M2-50 wait for a yes to questions 1 and 3, and M1-48, the codec pack, is dropped.

```toml
[[task]]
key = "M1-47"
epic = "E-M1-3"
seq = 520.91
title = "HEIC in browsers without a system HEVC decoder: libheif-js on demand in the thumbnail worker"
kind = "task"
area = "gallery"
size = "M"
priority = "P2"
requirements = ["R-APP-5", "R-MODE-1"]
features = ["FMT-02"]
docs = ["docs/08-media-pipeline.md"]
depends_on = ["M1-43", "M1-42"]
body = """
Opened by the owner's yes to M1-44's question 1. When M1-43's capability check fails, the thumbnail worker loads
libheif-js (pinned by integrity, served from the app's origin, LGPL notice in the licences page): `thmb` for the
128 and 256 tiers, the full decode for 512, the viewer and deep zoom, one photo at a time, the worker ended after
a few. Measured in M1-44: 0.38 MB brotli, 1.2-2 s and 125 MB per 12 MP photo, 3 ms per grid tile.
"""
acceptance = ["Every HEIC twin of tools/heic/ shows upright in Chrome on Linux, its grid tile within 10 ms from thmb"]

[[task]]
key = "M1-49"
epic = "E-M1-3"
seq = 520.93
title = "Desktop HEIC placeholders name the way out: connected mode or a Mac, never a codec to install"
kind = "task"
area = "gallery"
size = "S"
priority = "P1"
requirements = ["R-APP-5"]
features = ["FMT-02"]
docs = ["docs/08-media-pipeline.md"]
depends_on = ["M1-26"]
body = """
M1-44's placeholder texts for the Windows and Linux apps: a cell whose decoders all refused a HEIC for want of an
HEVC decoder names connected mode or a Mac, in every launched language. No codec pack in any build and no codec to
install (the owner, 2026-10-21): nothing HEVC-licensed ships on a client.
"""
acceptance = ["A HEIC with no HEVC decoder shows the cell's text on Windows and Linux, said to screen readers"]

[[task]]
key = "M2-48"
epic = "E-M2-4"
seq = 905
title = "Uploads carry the device's universal rendition: a JPEG preview of a HEIC, an H.264 clip of an HEVC video"
kind = "task"
area = "server"
size = "M"
priority = "P2"
requirements = ["R-APP-5", "R-MODE-2"]
features = ["FMT-02"]
docs = ["docs/08-media-pipeline.md"]
depends_on = ["M2-21", "M2-09", "M2-10"]
body = """
The owner's direction in M1-44: the first thing that decodes a source makes its universal rendition. A phone backing
up a HEIC or HEVC original uploads the `preview` or R1 its system encoders make, as part of the asset; the server
keeps it when its role and geometry match the profile (docs/08 §4.3) and renders only what is missing.
"""
acceptance = ["A server image without libde265 shows an uploaded HEIC's preview the phone made"]

[[task]]
key = "M2-49"
epic = "E-M2-2"
seq = 786
title = "Rendition quality per library: high (full-size JPEG with its gain map) by default, standard for small disks"
kind = "task"
area = "media"
size = "S"
priority = "P1"
requirements = ["R-APP-5"]
features = ["FMT-02"]
docs = ["docs/08-media-pipeline.md"]
depends_on = ["M2-09"]
body = """
The owner's answer to M1-44's question 4: `high` by default. Each limited-reach still's universal JPEG is full size,
at the original's resolution, jpegli q≈92-95 with the Ultra HDR gain map; `standard` (long side 2160, q≈85) is the
per-library option for small disks, `lossless` is not offered. The `preview` spec's default changes, so the
reconciler re-renders every library; docs/08 §4.1's "no full-size copy for HEIC/RAW" is amended for it.
"""
acceptance = ["A HEIC's universal JPEG is full size with its gain map, and 2160 px once its library is standard"]

[[task]]
key = "M2-50"
epic = "E-M2-5"
seq = 945
title = "Folder visits in Safari and Firefox: a read-only webkitdirectory folder per visit"
kind = "task"
area = "platform"
size = "M"
priority = "P3"
requirements = ["R-APP-1", "R-MODE-1"]
docs = ["docs/10-client-app.md"]
depends_on = ["M2-25"]
body = """
Opened by the owner's yes to M1-44's question 3: a picked folder is indexed for the visit only and picked again
next time; nothing is kept but the vault's settings.
"""
acceptance = ["A folder of the corpus shows in Safari and Firefox after a pick, and asks to be picked after a reload"]
```

## Built

M1-49 and M2-49 are built as [ADR-0405](../adr/0405-rendition-quality-and-desktop-heic-placeholders.md) says:
`libraries.rendition_quality` and the `preview` specs (`server/crates/photolib-server/src/render.rs`), and the
`noHevc` mark of `app/lib/features/library/timeline/` with its two texts in every launched language.

## Found on the way

* The kernel read `imir` the other way round from ISO/IEC 23008-12:2022, which libheif and libavif follow: axis 0
  exchanges top and bottom (EXIF orientation 4), not left and right. The kernel and the corpus' `stills/imir.heic`
  record now say 4 (photolib-design#601), as the twins and libheif-js show it.
* [Browsers](../user/browsers.md) said tier-2 browsers import a folder once, which nothing does; it now says they keep
  no folder library (photolib-design#601).
