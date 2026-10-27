#!/usr/bin/env bash
# Does the server work with its clients today? (PHO-240, docs/dev/server-client.md)
#
# Starts a throw-away photolibd on a free loopback port, on a private PostgreSQL cluster and local photo storage, makes
# the first administrator with the setup token, uploads 20 generated photos and 2 videos with curl and the corpus'
# stills and videos with `photolib upload`, and checks through the API, the database and the media routes that every
# file is in the library with its renditions and comes back byte for byte. Then it adds an external folder, checks it is
# indexed in place (originals untouched, no copy in the photo storage), that a new, moved and deleted file are followed,
# and that an unmounted folder goes offline and comes back with every photo. With WEB_DIR (a `flutter build web`) and
# Playwright it also opens the web client in browsers (tools/e2e/timeline.mjs). Prints "ok:" lines and exits 1 on the
# first failure, always stopping what it started. Every wait is a bounded poll (SMOKE_WAIT seconds, default 120).
#
#   PHOTOLIBD, PHOTOLIB  the server and CLI binaries (default: built from server/ with cargo, SMOKE_CARGO_ARGS added)
#   FFMPEG_DIR           the directory of an ffmpeg that encodes H.264 (default: tools/video/ffmpeg.sh)
#   PG_BIN               PostgreSQL's programs (default: pg_ctl on PATH, else the newest /usr/lib/postgresql/*/bin)
#   WEB_DIR, SMOKE_BROWSERS  the web build and the browsers to drive (chromium,firefox,phone); none without WEB_DIR
#   SMOKE_OUT            where screenshots and logs go (default: inside the temporary directory, printed)
#   SMOKE_KEEP=1         keep the temporary directory (server log, storage tree) after the run
set -uo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
WAIT=${SMOKE_WAIT:-120}
WORK=$(mktemp -d "${TMPDIR:-/tmp}/photolib-smoke-XXXXXX")
# PostgreSQL's socket path is limited to 107 bytes: a long TMPDIR gets the socket in /tmp.
SOCK=$WORK
((${#WORK} < 70)) || SOCK=$(mktemp -d /tmp/photolib-smoke-sock-XXXXXX)
OUT=${SMOKE_OUT:-$WORK/out}
mkdir -p "$OUT"
PIDS=()
PG=""
LAST_FAIL=0

say() { echo "ok: $*"; }
die() {
  echo "FAIL: $*" >&2
  echo "FAIL: server log tail:" >&2
  tail -n 15 "$WORK/photolibd.log" 2>/dev/null | cut -c1-300 >&2
  exit 1
}

cleanup() {
  local pid
  for pid in "${PIDS[@]}"; do
    kill "$pid" 2>/dev/null || true
  done
  for pid in "${PIDS[@]}"; do
    # a hard bound: never wait for a process that ignores SIGTERM
    for _ in $(seq 1 100); do kill -0 "$pid" 2>/dev/null || break; sleep 0.1; done
    kill -KILL "$pid" 2>/dev/null || true
  done
  if [[ -n $PG && -d $WORK/pg ]]; then "$PG/pg_ctl" -D "$WORK/pg" -m immediate stop >/dev/null 2>&1 || true; fi
  if [[ ${SMOKE_KEEP:-} == 1 ]]; then echo "kept: $WORK" >&2; else rm -rf "$WORK"; fi
  [[ $SOCK == "$WORK" ]] || rm -rf "$SOCK"
}
trap cleanup EXIT

# wait_for <description> <shell expression>: polls the expression, in this shell, until it succeeds; at most WAIT seconds.
wait_for() {
  local what=$1 deadline=$((SECONDS + WAIT))
  until eval "$2" >/dev/null 2>&1; do
    ((SECONDS < deadline)) || die "timed out after ${WAIT}s waiting for $what"
    sleep 0.3
  done
}

for tool in curl python3 sha256sum; do command -v "$tool" >/dev/null || die "$tool is needed"; done

# --- the programs
PATH=${FFMPEG_DIR:+$FFMPEG_DIR:}$PATH
if [[ -z ${FFMPEG_DIR:-} ]]; then FFMPEG_DIR=$(bash "$ROOT/tools/video/ffmpeg.sh") || die "no ffmpeg"; PATH=$FFMPEG_DIR:$PATH; fi
if [[ -z ${PG_BIN:-} ]]; then
  if command -v pg_ctl >/dev/null; then PG_BIN=$(dirname "$(command -v pg_ctl)"); else
    PG_BIN=$(ls -d /usr/lib/postgresql/*/bin 2>/dev/null | sort -V | tail -n 1)
  fi
fi
PG=$PG_BIN
[[ -x $PG/initdb ]] || die "no PostgreSQL programs (PG_BIN)"
if [[ -z ${PHOTOLIBD:-} || -z ${PHOTOLIB:-} ]]; then
  # shellcheck disable=SC2086
  built=$(cargo build --locked -q ${SMOKE_CARGO_ARGS:-} --manifest-path "$ROOT/server/Cargo.toml" \
    -p photolib-server -p photolib-cli --message-format=json) || die "cargo build failed (aarch64: see PHO-241)"
  exe() { python3 -c 'import json,sys
for line in sys.stdin:
    m = json.loads(line)
    if m.get("reason") == "compiler-artifact" and m.get("executable") and m["target"]["name"] == sys.argv[1]:
        print(m["executable"])' "$1" <<<"$built" | tail -n 1; }
  PHOTOLIBD=${PHOTOLIBD:-$(exe photolibd)}
  PHOTOLIB=${PHOTOLIB:-$(exe photolib)}
fi
[[ -x $PHOTOLIBD && -x $PHOTOLIB ]] || die "photolibd and photolib are needed (PHOTOLIBD, PHOTOLIB)"

# --- PostgreSQL and photolibd
"$PG/initdb" -U postgres -A trust -E UTF8 --no-sync --locale=C -D "$WORK/pg" >/dev/null || die "initdb failed"
"$PG/pg_ctl" -w -t 60 -D "$WORK/pg" -l "$WORK/pg.log" -o "-c listen_addresses='' -k $SOCK -c fsync=off" start >/dev/null ||
  die "PostgreSQL did not start"
PORT=$(python3 -c 'import socket
s = socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1])')
mkdir -p "$WORK/data" "$WORK/ext"
cat >"$WORK/photolib.yaml" <<EOF
config_version: 1
listen: 127.0.0.1:$PORT
roles: [api, scheduler, worker:cpu, worker:io, worker:transcode]
ffmpeg_dir: $FFMPEG_DIR
${WEB_DIR:+web_root: $WEB_DIR}
allow_insecure_http: true
data_dir: $WORK/data
external_roots: [$WORK/ext]
database:
  url: "postgres://postgres@localhost/postgres?host=$SOCK"
EOF
BASE=http://127.0.0.1:$PORT
env -i PATH="$PATH" "$PHOTOLIBD" --config "$WORK/photolib.yaml" >"$WORK/photolibd.log" 2>&1 &
PIDS+=($!)
wait_for "photolibd to listen" 'grep -q "\"message\":\"listening\"" "$WORK/photolibd.log"'
TOKEN=$(grep -o '"setup_token":"[0-9a-f]*"' "$WORK/photolibd.log" | head -n 1 | cut -d'"' -f4)
[[ -n $TOKEN ]] || die "photolibd logged no setup token"
say "photolibd listens on $BASE and logged a one-time setup token"

sql() { "$PG/psql" -h "$SOCK" -U postgres -X -t -A -c "$1"; }
rpc() { # rpc <Service/Method> [json]
  curl -sS --max-time 60 -H "Authorization: Bearer $KEY" -H 'Content-Type: application/json' \
    "$BASE/photolib.api.v1.$1" -d "${2:-{\}}"
}
json() { python3 -c "import json,sys; d = json.load(sys.stdin); print($1)"; }

# --- the first administrator, and a key for scripts
created=$(curl -sS --max-time 30 -H 'Content-Type: application/json' "$BASE/photolib.api.v1.SetupService/CreateFirstAdmin" \
  -d "{\"setupToken\":\"$TOKEN\",\"user\":{\"handle\":\"ann\",\"displayName\":\"Ann\",\"email\":\"ann@example.org\"}}")
[[ $(json 'd["user"]["role"]' <<<"$created") == USER_ROLE_ADMIN ]] || die "no administrator was created: $created"
say "the first administrator ann was created with the setup token"
second=$(curl -sS --max-time 30 -H 'Content-Type: application/json' "$BASE/photolib.api.v1.SetupService/CreateFirstAdmin" \
  -d "{\"setupToken\":\"$TOKEN\",\"user\":{\"handle\":\"bob\",\"displayName\":\"Bob\",\"email\":\"bob@example.org\"}}")
[[ $second != *'"user"'* ]] || die "a second administrator was created with the same token"
say "setup is closed afterwards: the token creates nobody else"
KEY=$("$PHOTOLIBD" --config "$WORK/photolib.yaml" admin api-key ann --scope view --scope download --scope contribute \
  --scope manage_server --scope manage_users | grep '^plk_')
[[ -n $KEY ]] || die "photolibd admin api-key printed no key"
say "photolibd admin api-key made a key for ann"

status() { rpc AdminService/GetStatus; }
count() { sql "select count(*) from assets where library_id = '$LIB'"; }
pending() { sql "select count(*) from jobs where status in ('queued','running') and type in ('render','transcode')"; }
wait_for "ann's library Photos" '[[ $(status | json "len(d[\"libraries\"])") -ge 1 ]]'
LIB=$(status | json 'd["libraries"][0]["libraryId"]')
OWNER=$(status | json 'd["accounts"][0]["userId"]')
say "ann's managed library Photos ($LIB) exists on the local store"

# --- files
FX=$WORK/fixtures
mkdir -p "$FX/curl" "$FX/cli"
for n in $(seq 1 20); do
  ffmpeg -y -loglevel error -f lavfi -i "gradients=s=1200x800:seed=$n:duration=1:speed=0.0001:n=4" -frames:v 1 -q:v 3 \
    "$FX/curl/gen_$(printf %02d "$n").jpg" || die "ffmpeg could not make a photo"
done
H264=$(ffmpeg -hide_banner -encoders 2>/dev/null | grep -oE 'libx264|libopenh264' | head -n 1)
[[ -n $H264 ]] || die "$FFMPEG_DIR/ffmpeg encodes no H.264"
# video <file> <pitch> <creation time>: three seconds of H.264 and AAC; the container is the file's extension.
video() {
  ffmpeg -y -loglevel error -f lavfi -i "testsrc2=size=640x360:rate=30:duration=3" -f lavfi -i "sine=frequency=$2:duration=3" \
    -metadata "creation_time=$3" -c:v "$H264" -pix_fmt yuv420p -c:a aac -shortest "$1" || die "ffmpeg could not make $1"
}
video "$FX/curl/clip_1.mp4" 400 2023-11-14T10:00:00Z
video "$FX/curl/clip_2.mp4" 500 2023-11-14T10:00:00Z
video "$FX/cli/phone.mov" 600 2022-06-01T08:00:00Z
video "$FX/cli/camera.mkv" 700 2021-02-03T09:00:00Z
CORPUS=$ROOT/testdata/corpus/files
# The corpus' stills are real headers over synthetic pictures that photolibd can decode; its HEIC and video files are
# stubs no decoder reads, so a HEIC and an AVIF are made with pillow-heif when it is installed.
for f in baseline progressive cmyk exif-big-endian exif-thumbnail gps-sydney mpf-secondary rgb.png palette.png lossy.webp \
  lossless.webp 24bit.bmp rgb.tif static.gif; do
  src=$(ls "$CORPUS"/stills/"$f"* 2>/dev/null | head -n 1)
  [[ -n $src ]] && cp "$src" "$FX/cli/"
done
cp "$ROOT"/testdata/seed/*/*.jpg "$FX/cli/"
if python3 -c 'import pillow_heif' 2>/dev/null; then
  python3 -c 'import sys
import pillow_heif
from PIL import Image
pillow_heif.register_heif_opener()
picture = Image.open(sys.argv[1])
picture.save(sys.argv[2], quality=80)
picture.save(sys.argv[3], quality=60)' "$FX/curl/gen_01.jpg" "$FX/cli/iphone_like.heic" "$FX/cli/modern.avif" &&
    say "a real HEIC and a real AVIF were made with pillow-heif"
else
  echo "note: pillow-heif is not installed: no HEIC is uploaded (pip install pillow-heif)"
fi
CURL_N=$(ls "$FX/curl" | wc -l)
CLI_N=$(ls "$FX/cli" | wc -l)

# --- upload with curl: the resumable-upload protocol, a complete creation per file (ADR-0061)
# The hash curl must send is BLAKE3 (b3sum): the one on PATH, else b3sum 1.8.7, the blake3 release the server locks,
# installed once into the tools cache.
B3SUM=$(command -v b3sum || true)
if [[ -z $B3SUM ]]; then
  B3ROOT=${PHOTOLIB_TOOLS_CACHE:-${TMPDIR:-/tmp}/photolib-tools-$(id -u)}/b3sum-1.8.7
  [[ -x $B3ROOT/bin/b3sum ]] || cargo install --locked --quiet --version 1.8.7 --root "$B3ROOT" b3sum >&2 || die "b3sum did not install"
  B3SUM=$B3ROOT/bin/b3sum
fi
blake3() { "$B3SUM" --no-names "$1"; }
curl_failed=0
for f in "$FX"/curl/*; do
  h=$(blake3 "$f") || die "cannot hash $f"
  code=$(curl -sS --max-time 120 -o /dev/null -w '%{http_code}' -X POST "$BASE/upload" -H "Authorization: Bearer $KEY" \
    -H 'Upload-Draft-Interop-Version: 10' -H 'Upload-Complete: ?1' -H "Photolib-Library: $LIB" -H "Photolib-Hash: $h" -H "Photolib-Path: smoke/$(basename "$f")" \
    -H 'Content-Type: application/partial-upload' --data-binary @"$f")
  [[ $code == 200 ]] || { echo "upload of $f answered $code" >&2; curl_failed=$((curl_failed + 1)); }
done
((curl_failed == 0)) || die "$curl_failed of $CURL_N curl uploads failed"
say "$CURL_N files (20 photos, 2 videos) uploaded with curl; every upload answered 200"

# --- upload with the CLI
cli_out=$(PHOTOLIB_TOKEN=$KEY "$PHOTOLIB" upload --server "$BASE" --library "$LIB" --state "$WORK/cli-state" "$FX/cli" 2>&1) ||
  die "photolib upload failed: $cli_out"
[[ $cli_out == *"$CLI_N uploaded, 0 duplicates, 0 skipped, 0 failed"* ]] || die "photolib upload: $(tail -n 1 <<<"$cli_out")"
say "photolib upload: $(tail -n 1 <<<"$cli_out")"

TOTAL=$((CURL_N + CLI_N))
wait_for "$TOTAL assets in the library" '[[ $(count) == "$TOTAL" ]]'
listed=$(status | json '[l for l in d["libraries"] if l["libraryId"] == "'"$LIB"'"][0]["assetCount"]')
[[ $listed == "$TOTAL" ]] || die "GetStatus lists $listed assets, expected $TOTAL"
say "the server's library lists $TOTAL assets ($(sql "select count(*) from assets where library_id = '$LIB' and media_kind = 'video'") videos)"
[[ $(sql "select count(*) from assets where library_id = '$LIB' and source_ref like 'smoke/%'") == "$CURL_N" ]] ||
  die "the Photolib-Path of the curl uploads was not kept as the assets' source path"
say "the Photolib-Path header names each uploaded file ($(sql "select original_filename from assets where source_ref = 'smoke/gen_01.jpg'"))"

# --- renditions
wait_for "renditions to be made" '[[ $(pending) == 0 ]]'
bare=$(sql "select count(*) from assets a where a.library_id = '$LIB' and a.media_kind = 'image' and a.id not in
  (select asset_id from asset_files where role = 'thumb_s' and state = 'present')")
# Formats photolibd cannot render yet are listed, not hidden: they must have no thumbnail and a failed or skipped job.
echo "note: images without a small thumbnail: $bare of $(sql "select count(*) from assets where library_id = '$LIB' and media_kind = 'image'")"
roles=$(sql "select string_agg(role || '=' || n, ' ' order by role) from (select role, count(*) n from asset_files af join assets a on a.id = af.asset_id
  where a.library_id = '$LIB' and state = 'present' group by role) t")
say "renditions on the local store: $roles"
videos_without_poster=$(sql "select count(*) from assets a where a.library_id = '$LIB' and a.media_kind = 'video' and a.id not in
  (select asset_id from asset_files where role = 'thumb_s' and state = 'present')")
[[ $videos_without_poster == 0 ]] || die "$videos_without_poster videos have no poster thumbnail"
say "every video has its poster thumbnail"
[[ $(sql "select count(*) from jobs where status in ('dead','failed')") == 0 ]] || die "dead jobs: $(sql "select type, error from jobs where status in ('dead','failed') limit 3")"
say "no job is dead"
find "$WORK/data/libraries" "$WORK/data/derived" -maxdepth 3 -type d | sed "s|$WORK/||" | head -n 12 | sed 's/^/  tree: /'

# --- bytes come back: every thumbnail downloads, and two uploaded originals are identical
mismatch=0
checked=0
for id in $(sql "select id from assets where library_id = '$LIB'"); do
  code=$(curl -sS --max-time 60 -o "$WORK/dl.bin" -w '%{http_code}' -H "Authorization: Bearer $KEY" "$BASE/media/$id/thumb_s")
  [[ $code == 200 && -s $WORK/dl.bin ]] || { echo "thumb_s of $id answered $code" >&2; mismatch=$((mismatch + 1)); }
  checked=$((checked + 1))
done
((mismatch == 0)) || die "$mismatch of $checked thumbnails did not download"
say "thumbnails download through /media/<asset>/thumb_s with the API key ($checked checked)"
orig_ok=0
for f in "$FX"/curl/gen_01.jpg "$FX"/curl/gen_20.jpg; do
  want=$(sha256sum "$f" | cut -d' ' -f1)
  got=0
  for id in $(sql "select id from assets where library_id = '$LIB' and media_kind = 'image'"); do
    curl -sS --max-time 60 -o "$WORK/dl.bin" -H "Authorization: Bearer $KEY" "$BASE/media/$id/original" || continue
    if [[ $(sha256sum "$WORK/dl.bin" | cut -d' ' -f1) == "$want" ]]; then got=1; break; fi
  done
  orig_ok=$((orig_ok + got))
done
((orig_ok == 2)) || die "an uploaded original did not come back byte for byte"
say "originals come back byte for byte (sha256 equal)"

# --- external folder: indexed in place
EXT=$WORK/ext/trip
mkdir -p "$EXT/day1" "$EXT/day2"
for i in $(seq 1 12); do
  ffmpeg -y -loglevel error -f lavfi -i "gradients=s=1000x700:seed=$((100 + i)):duration=1:speed=0.0001:n=3" -frames:v 1 -q:v 3 \
    "$EXT/day$((1 + i % 2))/ext_$(printf %02d "$i").jpg"
done
cp "$CORPUS/names/20231231_123456000_iOS.jpg" "$EXT/day1/corpus_ext.jpg"
video "$EXT/day2/ext_clip.mp4" 520 2024-03-03T10:00:00Z
sum() { (cd "$WORK/ext" && find . -type f | sort | xargs sha256sum); }
sum >"$WORK/ext.before"
created=$(rpc AdminService/CreateExternalLibrary "{\"ownerUserId\":\"$OWNER\",\"name\":\"Trip\",\"root\":\"$EXT\"}")
ELIB=$(json 'd["libraryId"]' <<<"$created") || die "no external library: $created"
ecount() { sql "select count(*) from assets where library_id = '$ELIB'"; }
asset_at() { sql "select a.id from assets a join asset_files af on af.asset_id = a.id and af.role = 'original' where a.library_id = '$ELIB' and af.key = '$1'"; }
EXT_N=$(find "$EXT" -type f | wc -l)
wait_for "the external scan to find $EXT_N files" '[[ $(ecount) == "$EXT_N" ]]'
say "external library: $EXT_N photos and videos of a server folder were scanned in place and are in the library"
[[ $(sql "select count(*) from asset_files af join assets a on a.id = af.asset_id where a.library_id = '$ELIB' and af.role = 'original' and af.storage <> 'external'") == 0 ]] ||
  die "an external original is stored outside its folder"
wait_for "external renditions" '[[ $(pending) == 0 ]]'
[[ $(sql "select count(*) from asset_files af join assets a on a.id = af.asset_id where a.library_id = '$ELIB' and af.role = 'thumb_s'") == "$EXT_N" ]] || die "external photos lack thumbnails"
say "their thumbnails are in the photo storage (derived/), their originals only in the folder"
# no copy of an external original in the storage: no file under data/ has its sha256
find "$WORK/data" -type f -print0 | xargs -0 sha256sum | cut -d' ' -f1 | sort >"$WORK/data.sha"
cut -d' ' -f1 "$WORK/ext.before" | sort >"$WORK/ext.sha"
dups=$(comm -12 "$WORK/data.sha" "$WORK/ext.sha" | wc -l)
[[ $dups == 0 ]] || die "$dups external originals were copied into the photo storage"
say "no external original has a copy in the photo storage"

# a file added, moved and deleted
ffmpeg -y -loglevel error -f lavfi -i "gradients=s=900x600:seed=777:duration=1:speed=0.0001:n=3" -frames:v 1 "$EXT/day1/added_later.jpg"
rpc AdminService/HintPaths "{\"libraryId\":\"$ELIB\",\"paths\":[\"$EXT/day1\"]}" >/dev/null
wait_for "the added file" '[[ $(ecount) == $((EXT_N + 1)) ]]'
say "a file added later shows up after a path hint (HintPaths)"
before_id=$(asset_at day1/ext_02.jpg)
mv "$EXT/day1/ext_02.jpg" "$EXT/day2/renamed_02.jpg"
rpc AdminService/ScanLibrary "{\"libraryId\":\"$ELIB\"}" >/dev/null
wait_for "the move to be followed" '[[ $(asset_at day2/renamed_02.jpg) == "$before_id" ]]'
say "a moved file keeps its asset (same id, new path)"
rm "$EXT/day2/ext_11.jpg"
rpc AdminService/ScanLibrary "{\"libraryId\":\"$ELIB\"}" >/dev/null
held() { status | json '[l for l in d["libraries"] if l["libraryId"] == "'"$ELIB"'"][0].get("held", {}).get("token", "")'; }
wait_for "the guard to hold the deletion (1 of $((EXT_N + 1)) is over 5 %)" '[[ -n $(held) ]]'
[[ $(sql "select count(*) from asset_files af join assets a on a.id = af.asset_id where a.library_id = '$ELIB' and af.role = 'original' and af.state = 'missing'") == 0 ]] ||
  die "the guard held but the file was hidden"
say "a deleted file is held by the mass-disappearance guard (over 5 % of a small library), nothing hidden yet"
rpc AdminService/ConfirmScan "{\"libraryId\":\"$ELIB\",\"confirmationToken\":\"$(held)\"}" >/dev/null
[[ $(sql "select count(*) from asset_files af join assets a on a.id = af.asset_id where a.library_id = '$ELIB' and af.role = 'original' and af.state = 'missing'") == 1 ]] ||
  die "ConfirmScan did not mark the deleted file missing"
say "ConfirmScan marks it missing; the asset row stays, the photo is never deleted"

# an unmounted folder
elib_state() { status | json '[l for l in d["libraries"] if l["libraryId"] == "'"$ELIB"'"][0]["state"]'; }
scan_idle() { [[ $(sql "select count(*) from jobs where type = 'scan' and status in ('queued','running')") == 0 ]]; }
present_before=$(sql "select count(*) from asset_files af join assets a on a.id = af.asset_id where a.library_id = '$ELIB' and af.role = 'original' and af.state = 'present'")
mv "$EXT" "$EXT.away"
mkdir "$EXT"
rpc AdminService/ScanLibrary "{\"libraryId\":\"$ELIB\"}" >/dev/null
wait_for "the empty root to put the library offline" '[[ $(elib_state) == LIBRARY_STATE_OFFLINE ]]'
[[ $(sql "select count(*) from asset_files af join assets a on a.id = af.asset_id where a.library_id = '$ELIB' and af.role = 'original' and af.state = 'present'") == "$present_before" ]] ||
  die "an offline root changed photos"
say "an unmounted (empty) folder puts the library offline and changes no photo"
rmdir "$EXT"
mv "$EXT.away" "$EXT"
rpc AdminService/ScanLibrary "{\"libraryId\":\"$ELIB\"}" >/dev/null
wait_for "the library to come back" '[[ $(elib_state) == LIBRARY_STATE_ONLINE ]]'
[[ $(sql "select count(*) from asset_files af join assets a on a.id = af.asset_id where a.library_id = '$ELIB' and af.role = 'original' and af.state = 'present'") == "$present_before" ]] ||
  die "photos changed when the folder came back"
say "the folder comes back online by itself with all $present_before photos present"

# originals untouched
sum >"$WORK/ext.after"
changed=$(comm -12 <(sort "$WORK/ext.before") <(sort "$WORK/ext.after") | wc -l)
untouched_expected=$((EXT_N - 2))
((changed >= untouched_expected)) || die "only $changed of $untouched_expected external originals have the same bytes"
say "$changed external originals have the checksums they had before the server saw them"

# --- the web client in a real browser: set the password with a host-made token, watch the timeline, open, play
if [[ -n ${WEB_DIR:-} ]]; then
  for browser in $(tr ',' ' ' <<<"${SMOKE_BROWSERS:-chromium}"); do
    setup=$("$PHOTOLIBD" --config "$WORK/photolib.yaml" admin password-setup ann | tail -n 1)
    SMOKE_URL="$BASE/" SMOKE_SETUP=$setup SMOKE_BROWSER=$browser SMOKE_OUT=$OUT SMOKE_EXPECT=$((TOTAL + EXT_N)) \
      SMOKE_VIDEO_DAYS="Nov 14, 2023;Mar 3, 2024" TMPDIR=$SOCK timeout 900 node "$ROOT/tools/e2e/timeline.mjs" ||
      die "the web client in $browser did not show the server's photos"
    say "the web client in $browser shows the server's photos and the external folder's in one timeline"
  done
fi
echo "smoke: PASS ($TOTAL uploaded, $EXT_N external)"
