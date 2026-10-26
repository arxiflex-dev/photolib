#!/usr/bin/env bash
# Builds photolibd's image for this machine (deploy/Dockerfile) and checks what needs a Docker daemon, which the gate
# runs without: the image stays under 1 GB, runs as any user on a read-only root filesystem, has no nonfree FFmpeg,
# and the all-in-one compose bundle that setup.sh starts serves photolibd through Caddy over TLS, as the caller's
# PUID:PGID on read-only root filesystems. It prints the image's codecs and what its FFmpeg and ExifTool read in every corpus file, which the
# weekly workflow compares between amd64 and arm64.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
image=ghcr.io/arxiflex-dev/photolib:check
scratch=$(mktemp -d)
compose() { docker compose --project-directory "$scratch/compose" "$@"; }
trap 'compose down >/dev/null 2>&1 || true; rm -rf "$scratch"' EXIT
fail() {
  echo "image.sh: $*" >&2
  exit 1
}

docker buildx build --load -t "$image" -f deploy/Dockerfile . >&2
size=$(docker image inspect -f '{{.Size}}' "$image")
((size < 1000000000)) || fail "the image is $size bytes, not under 1 GB"
docker run --rm --read-only --user 4321:4321 "$image" --version >&2

docker run --rm --read-only --user 4321:4321 -v "$PWD/testdata/corpus/files:/corpus:ro" --entrypoint sh "$image" -c '
  set -e
  if ffmpeg -hide_banner -buildconf | grep -q -e --enable-nonfree; then echo "FFmpeg is nonfree" >&2; exit 1; fi
  for list in decoders encoders demuxers muxers; do
    ffmpeg -hide_banner -$list | grep -Ev "_(amf|cuvid|mediacodec|nvenc|qsv|rkmpp|v4l2m2m|vaapi|vulkan)( |$)"
  done
  find /corpus -type f | sort | while read -r file; do ffprobe -v quiet -show_format -show_streams -of json "$file"; done
  find /corpus -type f | sort | exiftool -json -n -x File:all -@ -'

cp -r deploy/compose "$scratch/compose"
PHOTOLIB_VERSION=check sh "$scratch/compose/setup.sh" localhost >&2
for _ in $(seq 60); do
  curl -fsk https://localhost/readyz >/dev/null && break
  sleep 2
done
curl -fsSk https://localhost/readyz >/dev/null || { compose logs >&2; fail "photolibd is not ready behind Caddy"; }
owner=$(stat -c %u:%g "$scratch/compose/data/.photolib/instance.json")
[[ $owner == "$(id -u):$(id -g)" ]] || fail "photolibd's files belong to $owner, not to PUID:PGID"
