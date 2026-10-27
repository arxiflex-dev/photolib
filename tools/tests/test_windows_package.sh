#!/usr/bin/env bash
# The Windows app's standalone package (ADR-0404): tools/windows/standalone.sh packs a flutter build windows output with
# the Visual C++ runtime and the licence notices into one zip, and tools/windows/deps_scan.py proves it needs nothing
# outside it. The Windows binaries here are synthetic PE files (tools/tests/windows_tests.py, which tests the scan).
# shellcheck disable=SC2016 # the stubs and the python are literal scripts, not expansions
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT" || exit 1
require_tool python3

SCRIPT=tools/windows/standalone.sh
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

python3 -m unittest discover -s tools/tests -p windows_tests.py >"$TMP/unit.log" 2>&1 &&
  ok "the dependency scan reads PE import tables and flags what the package lacks" ||
  fail "windows_tests.py: $(tail -n 20 "$TMP/unit.log")"

# make <dir> <name> [<dll>...]: a PE file importing the DLLs, in the stand-in build or runtime directory.
make() {
  python3 -I - "$@" <<'PY'
import sys
from pathlib import Path
sys.path.insert(0, "tools/tests")
import windows_tests
directory, name, *imports = sys.argv[1:]
Path(directory, name).parent.mkdir(parents=True, exist_ok=True)
Path(directory, name).write_bytes(windows_tests.pe(imports))
PY
}
build() { # <dir>: a flutter build windows output with libmpv beside it
  make "$1" photolib.exe KERNEL32.dll flutter_windows.dll VCRUNTIME140.dll MSVCP140.dll
  make "$1" flutter_windows.dll USER32.dll api-ms-win-crt-runtime-l1-1-0.dll
  make "$1" libmpv-2.dll KERNEL32.dll avcodec-62.dll
  make "$1" avcodec-62.dll KERNEL32.dll
  echo "FFmpeg" >"$1/libmpv-notices.txt"
  mkdir -p "$1/data" && echo icu >"$1/data/icudtl.dat"
}
redist="$TMP/redist"
make "$redist" vcruntime140.dll KERNEL32.dll
make "$redist" msvcp140.dll KERNEL32.dll VCRUNTIME140.dll
make "$redist" vcruntime140_1.dll KERNEL32.dll
build "$TMP/release"
pack() { # <release dir> <redist dir> <zip>
  VC_REDIST_DIR=$2 capture bash "$SCRIPT" "$1" "$3"
}

pack "$TMP/release" "$redist" "$TMP/one.zip"
[[ $STATUS -eq 0 && -f $TMP/one.zip ]] && ok "a build that imports the Visual C++ runtime is packed with it" ||
  fail "standalone.sh: exit $STATUS: $OUT"
listing=$(python3 -I -m zipfile -l "$TMP/one.zip" | awk 'NR > 1 {print $1}')
for file in photolib/photolib.exe photolib/flutter_windows.dll photolib/libmpv-2.dll photolib/avcodec-62.dll \
  photolib/libmpv-notices.txt photolib/data/icudtl.dat photolib/VCRUNTIME140.dll photolib/MSVCP140.dll \
  photolib/LICENSE photolib/SOURCE.txt photolib/README.txt; do
  grep -qxiF "$file" <<<"$listing" && ok "the zip holds $file" || fail "the zip lacks $file: $listing"
done
grep -qi 'vcruntime140_1' <<<"$listing" && fail "the zip holds a runtime DLL nothing imports" ||
  ok "and only the runtime DLLs that something imports"
unzipped=$TMP/unzipped
python3 -I -m zipfile -e "$TMP/one.zip" "$unzipped"
capture python3 -I tools/windows/deps_scan.py "$unzipped/photolib"
[[ $STATUS -eq 0 ]] && ok "the unpacked package passes the dependency scan" || fail "deps_scan on the package: $OUT"
grep -q "libmpv.json" "$unzipped/photolib/SOURCE.txt" && grep -q "ffmpeg" "$unzipped/photolib/SOURCE.txt" &&
  ok "SOURCE.txt says where the LGPL libraries' source and build are" ||
  fail "SOURCE.txt: $(cat "$unzipped/photolib/SOURCE.txt")"

pack "$TMP/release" "$redist" "$TMP/two.zip"
cmp -s "$TMP/one.zip" "$TMP/two.zip" && ok "the same build packs to the same bytes" ||
  fail "two packs of one build differ"

mkdir "$TMP/no-runtime"
pack "$TMP/release" "$TMP/no-runtime" "$TMP/none.zip"
[[ $STATUS -ne 0 && $OUT == *"VCRUNTIME140.dll"* && ! -e $TMP/none.zip ]] &&
  ok "without the Visual C++ runtime to add, it fails naming the DLL and writes no zip" ||
  fail "no runtime: exit $STATUS: $OUT"

build "$TMP/mingw"
make "$TMP/mingw" libmpv-2.dll KERNEL32.dll libwinpthread-1.dll
make "$redist" libwinpthread-1.dll KERNEL32.dll
pack "$TMP/mingw" "$redist" "$TMP/mingw.zip"
[[ $STATUS -ne 0 && $OUT == *"libwinpthread-1.dll"* && ! -e $TMP/mingw.zip ]] &&
  ok "a toolchain DLL the build lacks is never taken from the runtime directory: it fails" ||
  fail "toolchain DLL: exit $STATUS: $OUT"

build "$TMP/bare"
rm "$TMP/bare/libmpv-notices.txt"
pack "$TMP/bare" "$redist" "$TMP/bare.zip"
[[ $STATUS -ne 0 && $OUT == *"libmpv-notices.txt"* && ! -e $TMP/bare.zip ]] &&
  ok "a build without the libmpv licence notices is refused" || fail "no notices: exit $STATUS: $OUT"

# --- tools/windows/smoke.sh unpacks the zip into a fresh directory, scans it, runs photolib.exe in a bare environment
# with --self-test-play and judges its result file. SMOKE_RUNNER stands for Windows (or wine): a stub plays the app.
SMOKE=tools/windows/smoke.sh
stub() { # <body>, @TMP@ the test's directory: a runner that gets the exe, then the app's arguments
  printf '#!/usr/bin/env bash\nexe=$1; shift; [[ $1 == --self-test-play ]] || exit 9\nvideo=$2 result=$3\n%s\n' \
    "${1//@TMP@/$TMP}" >"$TMP/runner.sh"
}
smoke() { # <zip>: SMOKE_TIMEOUT 3 s
  CANARY=leaked SMOKE_PATH=/usr/bin:/bin SMOKE_RUNNER="bash $TMP/runner.sh" SMOKE_TIMEOUT=3 \
    capture bash "$SMOKE" "$1" "$TMP/video.mov"
}
echo video >"$TMP/video.mov"
stub 'echo "$exe" >@TMP@/exe-ran; [[ -f $video ]] || exit 8
[[ -z ${CANARY:-} ]] || { echo "failed: environment leaked" >"$result"; exit 1; }
echo "played 1000 ms of 1000 ms, 640x480" >"$result"; echo "mpv 0.41.0, ffmpeg n8.1.3" >>"$result"'
smoke "$TMP/one.zip"
expect_result "a package that plays the video passes, and says what played" 0 "played 1000 ms" "ffmpeg n8.1.3"
[[ $(cat "$TMP/exe-ran") == */photolib/photolib.exe && $(cat "$TMP/exe-ran") != "$TMP/release"* ]] &&
  ok "it ran the exe of the unpacked copy, not of the build" || fail "the exe ran from $(cat "$TMP/exe-ran")"
stub 'echo "failed: no picture decoded" >"$result"; echo "mpv 0.41.0, ffmpeg n8.1.3" >>"$result"; exit 1'
smoke "$TMP/one.zip"
expect_result "a result that says failed fails the smoke, with libmpv's words" failure "failed: no picture decoded"
stub 'exec sleep 30'
START=$SECONDS
smoke "$TMP/one.zip"
expect_result "an app that writes no result is given up on after the timeout" failure "no result in 3 s"
((SECONDS - START < 20)) && ok "and killed, not waited for" || fail "the smoke waited $((SECONDS - START)) s"
stub 'echo "played 1 ms of 1 ms, 1x1" >"$result"; exec sleep 30'
smoke "$TMP/one.zip"
expect_result "an app that plays but does not exit is a failure" failure "did not exit"
rm -f "$TMP/exe-ran"
stub 'echo ran >@TMP@/exe-ran'
smoke "$TMP/none.zip"
expect_result "a zip that is not there fails" failure "none.zip"
python3 -I - "$TMP/unscanned.zip" <<'PY'
import sys, zipfile
sys.path.insert(0, "tools/tests")
import windows_tests
with zipfile.ZipFile(sys.argv[1], "w") as z:
    z.writestr("photolib/photolib.exe", windows_tests.pe(["KERNEL32.dll", "VCRUNTIME140.dll"]))
    z.writestr("photolib/libmpv-notices.txt", "x")
PY
smoke "$TMP/unscanned.zip"
expect_result "a package that needs a DLL outside itself fails before the app starts" failure "VCRUNTIME140.dll"
[[ ! -e $TMP/exe-ran ]] && ok "the app was not started" || fail "the app ran from a package that failed the scan"

finish
