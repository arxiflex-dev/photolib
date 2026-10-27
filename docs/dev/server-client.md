# Run a server and connect the app

A runbook from a clean checkout of `dev` to a running `photolibd` with a database, the first administrator, photo
storage on a local disk, photos uploaded two ways, and the apps showing them. Every command below was run on 2026-10-27
(Linux arm64, PostgreSQL 16, libvips 8.15, FFmpeg 7); `bash tools/e2e/server_client_smoke.sh` repeats all of it on a
throw-away server ([the smoke](#repeat-it)). What works and what does not today is at the [end](#what-works-today).

## What you need

* Linux, Rust 1.99.1 (`rust-toolchain.toml`), libvips 8.15 or later with its development files, FFmpeg that encodes
  H.264 (`bash tools/video/ffmpeg.sh` prints one), PostgreSQL 16 or later (programs only), `curl` and `python3`.
* On aarch64 `photolibd` does not build until [PHO-241](https://linear.app/photolib/issue/PHO-241) lands: `rs-vips`
  0.7.0 declares `*mut i8` for what is `*mut u8` there. Until then build with a copy of the crate that says
  `*mut std::os::raw::c_char` in `src/utils.rs`: `cargo --config "patch.crates-io.rs-vips.path='<copy>'" build`.
* For the apps: Flutter (`app/.fvmrc`) and, for the desktop app on Linux, `clang`, `cmake`, `ninja`, GTK 3 and `libmpv`.

## 1. Build

```sh
cd server && cargo build -p photolib-server -p photolib-cli    # target/debug/photolibd and photolib
```

## 2. A database, a configuration and a start

```sh
W=$(mktemp -d); PGBIN=$(ls -d /usr/lib/postgresql/*/bin | sort -V | tail -n 1)
$PGBIN/initdb -U postgres -A trust -E UTF8 --locale=C -D $W/pg >/dev/null
$PGBIN/pg_ctl -w -D $W/pg -l $W/pg.log -o "-c listen_addresses='' -k $W" start
mkdir -p $W/data $W/ext                                        # photo storage, and a folder for step 7
cat > $W/photolib.yaml <<EOF
config_version: 1
listen: 127.0.0.1:8080
roles: [api, scheduler, worker:cpu, worker:io, worker:transcode]
ffmpeg_dir: $(dirname $(command -v ffmpeg))
allow_insecure_http: true               # plain HTTP on loopback only; use a proxy with TLS beyond it
data_dir: $W/data                       # photo storage: libraries/ (originals) and derived/ (thumbnails)
external_roots: [$W/ext]                # folders an administrator may index in place (step 7)
database:
  url: "postgres://postgres@localhost/postgres?host=$W"
EOF
target/debug/photolibd --config $W/photolib.yaml 2>&1 | tee $W/photolibd.log
```

photolibd logs one line with a one-time setup token and then `listening`:

```text
{"level":"WARN","fields":{"message":"no administrator exists: create the first one with this one-time setup token","setup_token":"106c…"}}
```

Photos live in `data_dir` on the `local` store; `placement.libraries` ([configuration](../admin/configuration.md)) picks
a bucket instead. Pick a free port (`listen`) when 8080 is taken.

## 3. The first administrator

```sh
TOKEN=$(grep -o '"setup_token":"[0-9a-f]*"' $W/photolibd.log | head -n 1 | cut -d'"' -f4)
curl -s -H 'Content-Type: application/json' http://127.0.0.1:8080/photolib.api.v1.SetupService/CreateFirstAdmin \
  -d "{\"setupToken\":\"$TOKEN\",\"user\":{\"handle\":\"ann\",\"displayName\":\"Ann\",\"email\":\"ann@example.org\"}}"
```

```text
{"user":{"userId":"01a17c6b-0913-…","handle":"ann","displayName":"Ann","email":"ann@example.org","role":"USER_ROLE_ADMIN","status":"USER_STATUS_ACTIVE",…},"passwordSetup":{"token":"9a8e…","expiresAt":"2026-11-03T08:12:31Z"}}
```

The token works once: a second `CreateFirstAdmin` (with any handle) fails. The apps do this step themselves (*Add a
server*, *Set up a new server*, paste the token). Ann's managed library *Photos* appears moments later on the `local` store.

## 4. A key for scripts

A script cannot sign in (OPAQUE needs a client), so the host makes it a key, shown once:

```sh
target/debug/photolibd --config $W/photolib.yaml admin api-key ann --scope view --scope download --scope contribute \
  --scope manage_server --scope manage_users
```

```text
An API key for ann, valid for 365 days; it is shown once:
plk_5be73aa4…
```

```sh
KEY=plk_…; API=http://127.0.0.1:8080/photolib.api.v1
curl -s -H "Authorization: Bearer $KEY" -H 'Content-Type: application/json' $API.AdminService/GetStatus -d '{}'
```

```text
{"accounts":[{"userId":"01a17c6b-b48a-…","handle":"ann"}],"libraries":[{"libraryId":"01a17c6b-b490-764a-9afc-1c899936ccf4","name":"Photos","ownerHandle":"ann","kind":"LIBRARY_KIND_MANAGED","state":"LIBRARY_STATE_ONLINE"}]}
```

## 5. Upload photos and videos

With `curl` (the resumable upload protocol of [ADR-0061](../adr/0061-resumable-uploads.md), a complete creation per
file; the BLAKE3 hash is `b3sum` or `python3 -c 'import blake3'`):

```sh
LIB=01a17c6b-b490-…
for f in photos/*; do
  curl -s -o /dev/null -w "%{http_code} $f\n" -X POST http://127.0.0.1:8080/upload -H "Authorization: Bearer $KEY" \
    -H 'Upload-Draft-Interop-Version: 10' -H 'Upload-Complete: ?1' -H "Photolib-Library: $LIB" \
    -H "Photolib-Hash: $(b3sum --no-names $f)" -H "Photolib-Path: trip/$(basename $f)" \
    -H 'Content-Type: application/partial-upload' --data-binary @$f
done                                                          # 200 for each file
```

With the CLI, which resumes and skips what it uploaded before:

```sh
PHOTOLIB_TOKEN=$KEY target/debug/photolib upload --server http://127.0.0.1:8080 --library $LIB ./photos
```

```text
24 uploaded, 0 duplicates, 0 skipped, 0 failed
```

The Dart client of the apps and the web client use the same endpoint (step 8).

## 6. See that the server has them

```sh
psql -h $W -U postgres -c "select role, count(*) from asset_files where state = 'present' group by 1 order by 1"
```

```text
 preview 46 · sprite 4 · thumb_m 46 · thumb_s 46 · video_proxy_720 4 · original 46     (22 curl + 24 CLI uploads)
```

```sh
find $W/data -maxdepth 3 -type d | head      # libraries/<id>/originals/<year>/<year-month>, derived/<id>/<xx>/<asset>
curl -s -o thumb.webp -H "Authorization: Bearer $KEY" http://127.0.0.1:8080/media/<asset id>/thumb_s   # 200
```

The server log has one `render` and one `transcode` job per file; `GetStatus` lists the library's `assetCount`.

## 7. Index a folder in place (external library)

Put photos in a folder under `external_roots` and give an account a read-only library of it. photolibd reads the
files where they are, never writes there and keeps no copy (only thumbnails and previews, in `derived/`):

```sh
OWNER=<userId of ann>
curl -s -H "Authorization: Bearer $KEY" -H 'Content-Type: application/json' $API.AdminService/CreateExternalLibrary \
  -d "{\"ownerUserId\":\"$OWNER\",\"name\":\"Trip\",\"root\":\"$W/ext/trip\"}"      # {"libraryId":"01a17c8e-…"}
curl -s -H "Authorization: Bearer $KEY" -H 'Content-Type: application/json' $API.AdminService/ScanLibrary \
  -d '{"libraryId":"01a17c8e-…"}'                                   # again after files change
curl -s … $API.AdminService/HintPaths -d '{"libraryId":"…","paths":["day1"]}'   # announce new files at once
curl -s … $API.AdminService/ConfirmScan -d '{"libraryId":"…","confirmationToken":"<held.token of GetStatus>"}'
```

New files show within seconds once the watcher follows the library ([PHO-244](https://linear.app/photolib/issue/PHO-244):
up to ten minutes after it was added; `HintPaths` or `ScanLibrary` do not wait). A moved file keeps its asset; a deleted
one becomes `missing` and is held for `ConfirmScan` when it is over 5 % of the library; an unmounted or empty root puts
the library `LIBRARY_STATE_OFFLINE` and changes nothing, and it comes back by itself ([configuration](../admin/configuration.md#external-libraries)).

## 8. Connect the apps and watch the photos

**Web** (photolibd serves it): build it, set `web_root`, restart.

```sh
bash tools/data/web.sh app/web && bash tools/hls/web.sh app/web && bash tools/kernel/wasm.sh app/web/kernel
(cd app && flutter build web --wasm --output $W/web)        # then web_root: $W/web in photolib.yaml
```

Open the server's address in Chrome or Firefox: *Settings*, *Add a server*, *Connect*. *Set up a new server* creates the
administrator with the setup token (step 3). For an administrator who exists, make a password link on the host and use
*Set a password* (token, sign-in name, password twice; it signs in):

```sh
target/debug/photolibd --config $W/photolib.yaml admin password-setup ann
```

Back on the library tab the timeline shows every photo of every library of the account, the managed one and the external
ones together, marked *cloud only*; a photo opens in the viewer and a video plays.

**Desktop** (Linux): `cd app && python3 ../tools/kernel/build.py --out build/kernel linux-arm64` (`linux-x64` on x86),
then `flutter run -d linux` (or `flutter build linux`) and the same *Add a server* steps. Without a desktop session the
app needs a Secret Service: `bash tools/perf/keyring.sh <command>` starts a throw-away one.

**Phone width**: the same web app in Chrome with a phone's screen, touch and a throttled CPU and network
(`tools/e2e/timeline.mjs` with `SMOKE_BROWSER=phone`). Real devices are not covered here.

Screenshots of these runs (2026-10-27): [desktop timeline](server-client/desktop-timeline.jpg),
[a photo](server-client/desktop-photo.jpg), [a playing video](server-client/desktop-video.jpg),
[Chrome](server-client/chrome-timeline.jpg), [Chrome video](server-client/chrome-video.jpg),
[Chrome, external folder video](server-client/chrome-external-video.jpg),
[Firefox](server-client/firefox-timeline.jpg), [Firefox video](server-client/firefox-video.jpg),
[phone](server-client/phone-timeline.jpg), [phone viewer](server-client/phone-viewer.jpg).

![The desktop app's timeline with the server's photos](server-client/desktop-timeline.jpg)

## Repeat it

```sh
PHOTOLIBD=target/debug/photolibd PHOTOLIB=target/debug/photolib bash tools/e2e/server_client_smoke.sh
WEB_DIR=$W/web SMOKE_BROWSERS=chromium,firefox,phone bash tools/e2e/server_client_smoke.sh   # and the browsers
```

It starts a server on a free port with a private PostgreSQL cluster and temporary storage, creates the administrator,
uploads 22 files with `curl` and 24 with the CLI, checks the library, the renditions, the thumbnails and two originals
byte for byte, indexes an external folder (originals untouched, no copy in storage, a new, moved and deleted file, the
guard, an unmounted root), and with `WEB_DIR` signs in a browser and watches the timeline, a photo and two videos. Each
wait is a poll bounded by `SMOKE_WAIT` seconds (120), `SMOKE_KEEP=1` keeps the server's log and storage. The gate's
`web` part runs it after the web client's journey; `python3 -c 'import pillow_heif'` adds a real HEIC and AVIF.

## What works today

Works: building photolibd, the database, the first administrator by setup token, local photo storage, uploads by `curl`
and by `photolib upload` and by the web client, thumbnails, previews and video proxies for photos and H.264 videos,
byte-exact downloads of originals, the unified timeline in Chrome, Firefox and a phone emulation, the viewer, video
playback on the web, and the desktop app's sign-in, timeline, viewer and video playback from a managed library;
external folders are indexed in place and followed.

Does not work or is rough (each has a sub-task of [PHO-240](https://linear.app/photolib/issue/PHO-240)):

* `photolibd` does not compile on aarch64 without a patch (PHO-241).
* No screen creates an API key; only `photolibd admin api-key` does (PHO-242).
* Concurrent renders gave photos another photo's thumbnails and previews; fixed in this change, and servers that ran the
  old build need a repair (PHO-243, PHO-245).
* New files of an external folder are not watched for up to ten minutes after the library was added (PHO-244).
* `photolib upload` sends no file name or folder (PHO-246).
* The originals of external files answer 503: no download, and the desktop app cannot play an external video; the web
  client plays it through the HLS ladder (PHO-248).
* The corpus' HEIC, AVIF, JPEG XL and video files are stubs that no decoder reads: photolibd keeps them with no
  thumbnail after five failed render attempts. Real HEIC from a phone is not covered here (the smoke makes one with
  pillow-heif when it is installed).
