#!/usr/bin/env bash
# The Windows app's libmpv and FFmpeg (M1-39, ADR-0229): tools/video/libmpv.sh builds them LGPL-only from pinned
# sources, app/windows/libmpv.json pins the result, and app/windows/libmpv.cmake takes it by that hash.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT" || exit 1
require_tool cmake

SCRIPT=tools/video/libmpv.sh
CHECK=tools/video/lgpl_check.py
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# --- app/windows/libmpv.cmake, run by CMake in script mode over a stand-in archive
mkdir -p "$TMP/archive/libmpv/include" "$TMP/archive/ANGLE/lib" "$TMP/repo/app/windows" "$TMP/release"
for file in libmpv/libmpv-2.dll libmpv/avcodec-62.dll libmpv/libmpv.dll.a libmpv/include/client.h \
  libmpv/libmpv-notices.txt ANGLE/lib/libEGL.dll.lib; do
  echo "$file" >"$TMP/archive/$file"
done
tar -C "$TMP/archive" -cJf "$TMP/release/libmpv-test.tar.xz" ANGLE libmpv
SHA=$(sha256sum "$TMP/release/libmpv-test.tar.xz" | cut -d' ' -f1)
cp app/windows/libmpv.cmake "$TMP/repo/app/windows/"
cat >"$TMP/probe.cmake" <<EOF
include("$TMP/repo/app/windows/libmpv.cmake")
message("available=\${MEDIA_KIT_LIBS_AVAILABLE}")
message("bundled=\${LIBMPV_BUNDLED_LIBRARIES}")
EOF
# configure <url>: CMake in a fresh binary directory, the pins naming the stand-in by its hash and <url>.
configure() {
  printf '{"archive": "libmpv-test.tar.xz", "sha256": "%s", "url": "%s"}\n' "$SHA" "$1" \
    >"$TMP/repo/app/windows/libmpv.json"
  rm -rf "$TMP/out" && mkdir "$TMP/out"
  capture bash -c "cd '$TMP/out' && cmake -P '$TMP/probe.cmake'"
  OUT=$(tr -s ' \n' ' ' <<<"$OUT") # CMake wraps its messages
}
extracted() {
  [[ -f $TMP/out/libmpv/libmpv.dll.a && -f $TMP/out/libmpv/include/client.h && -f $TMP/out/ANGLE/lib/libEGL.dll.lib ]]
}

mkdir -p "$TMP/repo/app/build/libmpv"
cp "$TMP/release/libmpv-test.tar.xz" "$TMP/repo/app/build/libmpv/"
configure "file://$TMP/nowhere/libmpv-test.tar.xz"
expect_result "the pinned archive in app/build/libmpv is taken without a download" 0 "available=ON" \
  "bundled=$TMP/out/libmpv/avcodec-62.dll;$TMP/out/libmpv/libmpv-2.dll;$TMP/out/libmpv/libmpv-notices.txt"
extracted && ok "it is extracted where media_kit_video looks: libmpv/ and ANGLE/ in the binary directory" ||
  fail "nothing extracted: $(ls -R "$TMP/out")"

echo tampered >>"$TMP/repo/app/build/libmpv/libmpv-test.tar.xz"
configure "file://$TMP/nowhere/libmpv-test.tar.xz"
expect_result "an archive that is not the pinned one fails the build" failure "libmpv-test.tar.xz has SHA-256" \
  "libmpv.json pins $SHA"
extracted && fail "the tampered archive was extracted" || ok "and nothing of it is extracted"

rm "$TMP/repo/app/build/libmpv/libmpv-test.tar.xz"
configure "file://$TMP/release/libmpv-test.tar.xz"
expect_result "a missing archive is downloaded from the pinned release" 0 "available=ON"
extracted && ok "and extracted" || fail "the download was not extracted: $(ls -R "$TMP/out")"
[[ -f $TMP/repo/app/build/libmpv/libmpv-test.tar.xz ]] && ok "and kept in app/build/libmpv" ||
  fail "the download is not kept"

rm "$TMP/repo/app/build/libmpv/libmpv-test.tar.xz"
configure "file://$TMP/nowhere/libmpv-test.tar.xz"
expect_result "a missing archive the release does not have fails, naming the script that builds it" failure \
  "bash tools/video/libmpv.sh"
[[ -e $TMP/repo/app/build/libmpv/libmpv-test.tar.xz ]] && fail "a failed download left a file" ||
  ok "and leaves no file behind"

# --- tools/video/lgpl_check.py: ADR-0013's licence check, on what the build makes
# dlls <avutil configuration> <avcodec licence> <libmpv features>: stand-ins holding the strings the real ones do.
dlls() {
  rm -rf "$TMP/dlls" && mkdir "$TMP/dlls"
  printf '\0\0%s\0LGPL version 2.1 or later\0' "$1" >"$TMP/dlls/avutil-60.dll"
  printf '\0%s\0\0%s\0' "$1" "$2" >"$TMP/dlls/avcodec-62.dll"
  printf '\0mpv v0.41.0\0List of enabled features: %s\n\0' "$3" >"$TMP/dlls/libmpv-2.dll"
  capture python3 "$CHECK" "$TMP/dlls"
}
LGPL="--prefix=/photolib --enable-shared --enable-libdav1d --disable-autodetect"
FEATURES="d3d-hwaccel ffmpeg gl libass libplacebo plain-gl wasapi win32-threads zlib"
dlls "$LGPL" "LGPL version 2.1 or later" "$FEATURES"
expect_result "an LGPL FFmpeg and a libmpv built with -Dgpl=false pass" 0
dlls "$LGPL --enable-gpl" "LGPL version 2.1 or later" "$FEATURES"
expect_result "an FFmpeg configured with --enable-gpl fails" failure "avutil-60.dll" "--enable-gpl"
dlls "$LGPL --enable-nonfree" "LGPL version 2.1 or later" "$FEATURES"
expect_result "an FFmpeg configured with --enable-nonfree fails" failure "--enable-nonfree"
dlls "$LGPL" "GPL version 2 or later" "$FEATURES"
expect_result "a library under the GPL fails" failure "avcodec-62.dll" "LGPL version 2.1 or later"
dlls "$LGPL" "LGPL version 2.1 or later" "d3d-hwaccel ffmpeg gl gpl libass win32-threads"
expect_result "a libmpv built with its GPL parts fails" failure "libmpv-2.dll" "gpl"
dlls "$LGPL" "LGPL version 2.1 or later" ""
expect_result "a libmpv whose features cannot be read fails, as unknown is not LGPL" failure "libmpv-2.dll"

# --- the build script and its pins
# shellcheck disable=SC2016 # patterns, not expansions
assert_patterns assert_matches "$SCRIPT" \
  '--disable-autodetect' "configures FFmpeg with only what it names" \
  '-Dgpl=false' "builds libmpv without its GPL parts" \
  'python3 "\$root/tools/video/lgpl_check.py"' "runs the licence check on its output" \
  'SOURCE_DATE_EPOCH=[0-9]+' "dates the build by a constant" \
  'no-insert-timestamp' "links without timestamps" \
  'ffile-prefix-map' "keeps the build's paths out of the output"
grep -Eq -- '--enable-(gpl|nonfree|version3)|--enable-lib(x264|x265|xvid|fdk|vidstab|rubberband)' "$SCRIPT" &&
  fail "$SCRIPT enables a GPL, nonfree or LGPLv3 part of FFmpeg" || ok "$SCRIPT enables no GPL or nonfree part"
# Each source: pinned by SHA-256 or by a commit, and named in the notices unless only a build tool.
while read -r name pinned noticed; do
  [[ $pinned == pinned ]] && ok "$SCRIPT pins $name" || fail "$SCRIPT pins $name neither by SHA-256 nor by a commit"
  [[ $noticed == noticed ]] && ok "the notices name what $name brings" ||
    fail "$SCRIPT bundles $name but its notices do not name it"
done < <(python3 - "$SCRIPT" <<'EOF'
import re, shlex, sys
text = open(sys.argv[1]).read()
array = lambda name: shlex.split(re.search(rf"^{name}=\((.*?)^\)", text, re.M | re.S).group(1), comments=True)
noticed = {entry.split("|")[2] for entry in array("NOTICES")} | {"nasm", "meson"}
for entry in array("SOURCES"):
    name, _, url, *pin = entry.split()
    pinned = re.fullmatch(r"[0-9a-f]{64}", pin[0]) or url.endswith(".git") and re.fullmatch(r"[0-9a-f]{40}", pin[-1])
    print(name, "pinned" if pinned else "unpinned", "noticed" if name in noticed else "unnoticed")
EOF
)

PINS=app/windows/libmpv.json
python3 - "$PINS" <<'EOF' && ok "$PINS pins the archive, its files and the toolchain" || fail "$PINS is incomplete"
import json, re, sys
pins = json.load(open(sys.argv[1]))
assert re.fullmatch(r"[0-9a-f]{64}", pins["sha256"])
assert pins["url"].startswith("https://github.com/arxiflex-dev/photolib/releases/download/")
assert pins["url"].endswith("/" + pins["archive"])
for f in ("libmpv/libmpv-2.dll", "libmpv/libmpv.dll.a", "libmpv/include/client.h", "libmpv/libmpv-notices.txt",
          "ANGLE/lib/libEGL.dll.lib", "ANGLE/lib/libGLESv2.dll.lib", "ANGLE/include/EGL/eglext.h"):
    assert re.fullmatch(r"[0-9a-f]{64}", pins["files"][f]), f
assert pins["toolchain"]["llvm-mingw"].startswith("llvm-mingw-") and pins["toolchain"]["clang"]
EOF

# --- the Windows app takes it, and nothing else
CMAKE=app/windows/CMakeLists.txt
grep -n 'include(libmpv.cmake)\|include(flutter/generated_plugins.cmake)' "$CMAKE" | head -1 |
  grep -q libmpv && ok "$CMAKE takes libmpv before media_kit_video looks for it" ||
  fail "$CMAKE does not include libmpv.cmake before the plugins"
assert_patterns assert_matches "$CMAKE" \
  'PLUGIN_BUNDLED_LIBRARIES .*LIBMPV_BUNDLED_LIBRARIES' "bundles the DLLs and their notices" \
  '/DELAYLOAD:libEGL\.dll /DELAYLOAD:libGLESv2\.dll' "loads ANGLE only if called, which it never is"
grep -q media_kit_libs app/pubspec.yaml app/pubspec.lock && fail "the app depends on a media_kit_libs package" ||
  ok "no media_kit_libs package fetches a prebuilt libmpv"
assert_prose docs/adr/0112-video-and-motion-photo-playback.md \
  'Follow-ups: an LGPL libmpv for Windows \(M1-39\), built by \[ADR-0229\]\(0229-windows-libmpv\.md\);' \
  "ADR-0112's follow-up names what M1-39 built"
# The owner kept all four choices (photolib-design#701): software rendering, this repository's release, the
# llvm-mingw cross-build and a build that fails without the archive.
assert_prose docs/adr/0229-windows-libmpv.md \
  '\* \*\*Status\*\*: Accepted — 2026-10-23\. The owner kept [^*]*photolib-design#701' \
  "ADR-0229 is Accepted, recording the owner's answer (#701)"
assert_matches docs/adr/README.md '\(0229-windows-libmpv\.md\) \| [^|]* \| Accepted \(owner confirmed, 2026-10-23\)' \
  "the index lists ADR-0229 as Accepted"
# Every ANGLE function media_kit_video calls is in the import libraries the build makes.
version=$(sed -n '/^  media_kit_video:/,/version:/s/^ *version: "\(.*\)"/\1/p' app/pubspec.lock)
plugin=${PUB_CACHE:-$HOME/.pub-cache}/hosted/pub.dev/media_kit_video-$version/windows
if [[ ! -d $plugin ]]; then
  fail "media_kit_video $version is not in the pub cache: run flutter pub get in app/"
else
  imports=" $(sed -n '/^\(EGL\|GLES\)_IMPORTS=(/,/)$/p' "$SCRIPT" | tr -d '()' | sed 's/^[A-Z]*_IMPORTS=//' | xargs) "
  for call in $(grep -ohE '\b(egl|gl)[A-Z][A-Za-z0-9]*\(' "$plugin"/*.cc "$plugin"/*.h | tr -d '(' | sort -u); do
    [[ $imports == *" $call "* ]] && ok "the import libraries have $call" ||
      fail "media_kit_video $version calls $call, which $SCRIPT does not import"
  done
fi

finish
