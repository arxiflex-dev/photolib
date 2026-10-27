#!/usr/bin/env bash
# The standalone Windows package on a machine with nothing installed (ADR-0404): unpacks the zip tools/windows/
# standalone.sh made into a new directory, scans it for any DLL it needs from outside, then runs its photolib.exe in an
# environment with only Windows' own directories on the PATH and plays a corpus video with the libmpv in the package
# (--self-test-play), headless. Fails unless the video played; the app's own words are printed either way.
#
#   bash tools/windows/smoke.sh <zip> [<video>]
#
# The video defaults to the corpus' decodable testdata/corpus/files/video/mjpeg.mov.
#
# SMOKE_TIMEOUT (seconds, 120) is how long the app has; SMOKE_RUNNER is a command put before the exe (wine, or the
# stub the repo test uses); SMOKE_PATH is the PATH the app gets (Windows' directories).
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
[[ $# -ge 1 && $# -le 2 ]] || { echo "usage: tools/windows/smoke.sh <zip> [<video>]" >&2; exit 2; }
zip=$1
video=${2:-$root/testdata/corpus/files/video/mjpeg.mov}
for file in "$zip" "$video"; do
  [[ -f $file ]] || { echo "smoke.sh: $file does not exist" >&2; exit 1; }
done
timeout=${SMOKE_TIMEOUT:-120}
python=$(command -v python3 || command -v python)
native() { if command -v cygpath >/dev/null 2>&1; then cygpath -w "$1"; else echo "$1"; fi; }

dest=$(mktemp -d)
pid=
cleanup() {
  [[ -z $pid ]] || kill -9 "$pid" 2>/dev/null || true
  rm -rf "$dest"
}
trap cleanup EXIT
"$python" -I -m zipfile -e "$zip" "$dest"
package=$dest/photolib

"$python" -I "$root/tools/windows/deps_scan.py" "$package" ||
  { echo "smoke.sh: the package needs files outside itself" >&2; exit 1; }
shopt -s nullglob
for file in photolib.exe libmpv-2.dll libmpv-notices.txt LICENSE SOURCE.txt; do
  [[ -f $package/$file ]] || { echo "smoke.sh: the package has no $file" >&2; exit 1; }
done
ffmpeg=("$package"/avcodec-*.dll)
[[ ${#ffmpeg[@]} -gt 0 ]] || { echo "smoke.sh: the package has no FFmpeg (avcodec-*.dll)" >&2; exit 1; }

# Nothing of the runner's environment but what Windows itself sets: no Flutter, Visual Studio or toolchain on the PATH.
bare=("PATH=${SMOKE_PATH:-/c/Windows/System32:/c/Windows}")
for name in SystemRoot SystemDrive windir TEMP TMP USERPROFILE APPDATA LOCALAPPDATA ProgramData ProgramFiles COMSPEC \
  PROCESSOR_ARCHITECTURE NUMBER_OF_PROCESSORS; do
  [[ -z ${!name:-} ]] || bare+=("$name=${!name}")
done
result=$dest/result.txt
# From outside the package: the app finds its DLLs beside its exe, never in the directory it was started from.
(
  cd "$dest"
  # shellcheck disable=SC2086 # the runner is a command line
  exec env -i "${bare[@]}" ${SMOKE_RUNNER:-} "$package/photolib.exe" --self-test-play \
    "$(native "$video")" "$(native "$result")"
) &
pid=$!
waited=0
while kill -0 "$pid" 2>/dev/null && ((waited < timeout)); do
  sleep 1
  waited=$((waited + 1))
done
if kill -0 "$pid" 2>/dev/null; then
  kill -9 "$pid" 2>/dev/null || true
  command -v taskkill >/dev/null 2>&1 && taskkill //F //T //PID "$pid" >/dev/null 2>&1 || true
  if [[ -s $result ]]; then
    echo "smoke.sh: the app wrote its result but did not exit in $timeout s: $(cat "$result")" >&2
  else
    echo "smoke.sh: no result in $timeout s" >&2
  fi
  pid=
  exit 1
fi
status=0
wait "$pid" || status=$?
pid=
if [[ ! -s $result ]]; then
  echo "smoke.sh: the app exited with $status and wrote no result" >&2
  exit 1
fi
cat "$result"
if [[ $status -ne 0 || $(head -n 1 "$result") != played* ]]; then
  echo "smoke.sh: the video did not play (exit $status)" >&2
  exit 1
fi
echo "smoke.sh: $(basename "$video") played from $(basename "$zip") with only Windows around it"
