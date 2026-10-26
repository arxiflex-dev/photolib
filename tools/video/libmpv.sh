#!/usr/bin/env bash
# Builds the libmpv and FFmpeg the Windows app bundles (ADR-0229): LGPL only (ADR-0013), from the sources pinned below,
# with the pinned llvm-mingw, on Linux x86-64 (on Windows, in WSL). It writes app/build/libmpv/<archive>, laid out as
# media_kit_video expects (libmpv/ with the DLLs, the import library and the headers; ANGLE/ with ANGLE's headers and
# import libraries for the ANGLE the app does not ship), and records its SHA-256, its files' and the toolchain in
# app/windows/libmpv.json, by which app/windows takes it. With --check it fails unless the build gives the hashes
# pinned there: the build is reproducible.
#
#   bash tools/video/libmpv.sh [--check]
set -euo pipefail

TOOLCHAIN=llvm-mingw-20261006-ucrt-ubuntu-22.04-x86_64
# name directory url sha256: a release tarball; name directory url tag commit: a git tag, with its submodules.
SOURCES=(
  "llvm-mingw $TOOLCHAIN https://github.com/mstorsjo/llvm-mingw/releases/download/20261006/$TOOLCHAIN.tar.xz
    5f9c6ed95b2d4bdb2869a488c5fd5857fbdabcf288a0aa3eb1da43f6a08d8ab4"
  "nasm nasm-3.02 https://www.nasm.us/pub/nasm/releasebuilds/3.02/nasm-3.02.tar.xz
    87336eba53b4acfe917424ab5d500d2b0054d9f5148d35c2273ccf2cfb712f0d"
  "meson meson-1.12.1 https://github.com/mesonbuild/meson/releases/download/1.12.1/meson-1.12.1.tar.gz
    ab0a6ca09f8ef70c564c8241fb5a23957886a0b53fb58412b5e07eaf07dba743"
  "zlib zlib-1.3.2 https://github.com/madler/zlib/releases/download/v1.3.2/zlib-1.3.2.tar.xz
    d7a0654783a4da529d1bb793b7ad9c3318020af77667bcae35f95d0e42a792f3"
  "dav1d dav1d-1.5.4 https://downloads.videolan.org/pub/videolan/dav1d/1.5.4/dav1d-1.5.4.tar.xz
    686616b7c69eb88d44459391ab25cac13b6647a3b288835c5784e71c1514a5c5"
  "freetype freetype-2.15.0 https://download.savannah.gnu.org/releases/freetype/freetype-2.15.0.tar.xz
    93cd47eb719c325107f2d3cf087d06299e944c3b48a40b55537302304dea1dd5"
  "fribidi fribidi-1.0.17 https://github.com/fribidi/fribidi/releases/download/v1.0.17/fribidi-1.0.17.tar.xz
    6949dcde27d41cebad1fd741fcafc36d55a1020d2d872d4a6eb3914caabbada2"
  "harfbuzz harfbuzz-14.6.0 https://github.com/harfbuzz/harfbuzz/releases/download/14.6.0/harfbuzz-14.6.0.tar.xz
    d07a007327277708a2a73ae437887cdbaf282937f6d03ca5467723e9099af586"
  "libass libass-0.17.5 https://github.com/libass/libass/releases/download/0.17.5/libass-0.17.5.tar.xz
    2dca25c0e0c837ddf00b52011b3f82cac1e4ddd3ad018227806b0c2288864acc"
  "libplacebo libplacebo-7.360.1 https://code.videolan.org/videolan/libplacebo.git v7.360.1
    cee9b076f2c63104ccfd497fa79c39a867293ec4"
  "ffmpeg ffmpeg-8.1.3 https://ffmpeg.org/releases/ffmpeg-8.1.3.tar.xz
    7138d28c96d9d3e3af4ee3d8cad72741f8ffb40da90c1112235dea3ecd3178a3"
  "mpv mpv-0.41.0 https://github.com/mpv-player/mpv.git v0.41.0 41f6a645068483470267271e1d09966ca3b9f413"
)
# ANGLE's headers, Khronos' with its extensions, from before it dropped the D3D9 names media_kit_video uses.
ANGLE=https://raw.githubusercontent.com/google/angle/093a0d8f75a212cb91346362f9805ca2061f3305/include
HEADERS=(
  "EGL/egl.h b9669499729432653659b99ec9e92f3defed9207c480ec7926024f424e693f9a"
  "EGL/eglext.h 92fe2e491f9374afb88e9c8d96be7288f33f27db97d06610ba5671ea732f8aae"
  "EGL/eglext_angle.h 85c92699d39526c9157c939e46e1a49c5016495713182d21ebd78fc1ef5292e4"
  "EGL/eglplatform.h b748729767798d85ecf8e1923552879328a76d572327b641ce737549b391cc9c"
  "GLES2/gl2.h 822ced52b4cb67bb36446c82b3ca049dc1df5b3f7a011c7d77085a05efb9194e"
  "GLES2/gl2ext.h 53c564985d35b7ca4b744a0a8b81f120aa0c114c319b3b98d3223bf599bc815b"
  "GLES2/gl2ext_angle.h fc79db5efea28282b30d7686215bc951140d24a89307dc7ead438c9d0d21de98"
  "GLES2/gl2platform.h f5da0747540a50be5f44aad264aae45bdf157a192c40f17487dd9a2f99c71b6c"
  "KHR/khrplatform.h e206a6931f98ffe1c5c7ece69c4f94bbe1c9279243f40cbe7782848a0d3fa2de"
)
# What media_kit_video calls in ANGLE: it links them, but with its hardware path off it never calls them.
EGL_IMPORTS=(eglBindTexImage eglChooseConfig eglCreateContext eglCreatePbufferFromClientBuffer eglDestroyContext
  eglDestroySurface eglGetPlatformDisplayEXT eglGetProcAddress eglInitialize eglMakeCurrent eglReleaseTexImage
  eglTerminate)
GLES_IMPORTS=(glBindTexture glFinish glGenTextures glTexParameteri)
# Bundled library|licence|source|its text there.
NOTICES=(
  "FFmpeg|LGPL-2.1-or-later|ffmpeg|COPYING.LGPLv2.1"
  "mpv|LGPL-2.1-or-later|mpv|LICENSE.LGPL"
  "libplacebo|LGPL-2.1-or-later|libplacebo|LICENSE"
  "fast_float|MIT|libplacebo|3rdparty/fast_float/LICENSE-MIT"
  "glad|MIT|libplacebo|3rdparty/glad/LICENSE"
  "libass|ISC|libass|COPYING"
  "FreeType|FTL|freetype|docs/FTL.TXT"
  "HarfBuzz|MIT-Modern-Variant|harfbuzz|COPYING"
  "FriBidi|LGPL-2.1-or-later|fribidi|COPYING"
  "dav1d|BSD-2-Clause|dav1d|COPYING"
  "zlib|Zlib|zlib|LICENSE"
  "mingw-w64 runtime|ZPL-2.1|llvm-mingw|x86_64-w64-mingw32/share/mingw32/COPYING.MinGW-w64-runtime.txt"
  "LLVM libc++, libunwind and compiler-rt|Apache-2.0 WITH LLVM-exception|llvm-mingw|LICENSE.TXT"
)
HOST=x86_64-w64-mingw32
# Dated by a constant, never by the clock.
export SOURCE_DATE_EPOCH=1759276800 TZ=UTC LC_ALL=C

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
pins=$root/app/windows/libmpv.json
check=${1:-}
[[ -z $check || $check == --check ]] || { echo "usage: tools/video/libmpv.sh [--check]" >&2; exit 2; }
[[ $(uname -sm) == "Linux x86_64" ]] || { echo "libmpv.sh: runs on Linux x86-64 (on Windows, in WSL)" >&2; exit 1; }
for tool in git make cc pkg-config ninja python3 tar xz; do
  command -v "$tool" >/dev/null || { echo "libmpv.sh: $tool is missing" >&2; exit 1; }
done
cache=${PHOTOLIB_TOOLS_CACHE:-${TMPDIR:-/tmp}/photolib-tools-$(id -u)}
src=$cache/libmpv-sources
work=$cache/libmpv-build
sys=$work/sysroot/photolib

fetch() { # name dir url sha256 | name dir url tag commit: $src/<dir>, once.
  local dir=$2 url=$3
  if [[ $# == 4 ]]; then
    [[ -d $src/$dir ]] || bash "$root/tools/fetch_release.sh" "$url" "$4" "$src" "$dir"
    return
  fi
  if [[ ! -d $src/$dir ]]; then
    rm -rf "$src/$dir.git"
    git -c advice.detachedHead=false clone -q --depth 1 --branch "$4" --recurse-submodules --shallow-submodules \
      "$url" "$src/$dir.git"
    mv "$src/$dir.git" "$src/$dir"
  fi
  [[ $(git -C "$src/$dir" rev-parse HEAD) == "$5" ]] || { echo "libmpv.sh: $dir is not $5" >&2; exit 1; }
}
rm -rf "$work"
mkdir -p "$work"/{src,build,bin,artefact/ANGLE/include,artefact/ANGLE/lib,artefact/libmpv/include} "$sys"/{include,lib}
declare -A url
for source in "${SOURCES[@]}"; do
  # shellcheck disable=SC2086 # a line of fields
  set -- $source
  fetch "$@"
  url[$1]="$3${5:+ $4}"
  case $1 in llvm-mingw) ln -s "$src/$2" "$work/src/toolchain" ;; nasm | meson) ;; *) cp -a "$src/$2" "$work/src/$1" ;; esac
done
for header in "${HEADERS[@]}"; do
  # shellcheck disable=SC2086
  set -- $header
  [[ -f $src/angle/$1 ]] || bash "$root/tools/fetch_release.sh" "$ANGLE/$1" "$2" "$src/angle/${1%/*}" "${1#*/}"
  install -D -m 644 "$src/angle/$1" "$work/artefact/ANGLE/include/$1"
done

toolchain=$src/$TOOLCHAIN
nasm=$src/nasm-3.02/nasm
if [[ ! -x $nasm ]]; then
  (cd "$src/nasm-3.02" && ./configure -q && make -s -j"$(nproc)" nasm) >"$work/nasm.log" 2>&1 ||
    { tail -n 50 "$work/nasm.log" >&2; exit 1; }
fi
ln -s "$nasm" "$work/bin/nasm"
export PATH=$toolchain/bin:$work/bin:$PATH
export PKG_CONFIG_LIBDIR=$sys/lib/pkgconfig PKG_CONFIG_SYSROOT_DIR=$work/sysroot PKG_CONFIG_PATH=
# No build path or timestamp in the output.
export CFLAGS="-ffile-prefix-map=$work=." CXXFLAGS="-ffile-prefix-map=$work=." LDFLAGS="-Wl,--no-insert-timestamp"
meson=$src/meson-1.12.1/meson.py
cat >"$work/cross.ini" <<EOF
[binaries]
c = '$HOST-clang'
cpp = '$HOST-clang++'
ar = 'llvm-ar'
strip = 'llvm-strip'
windres = '$HOST-windres'
pkg-config = 'pkg-config'
nasm = 'nasm'

[built-in options]
c_args = ['$CFLAGS']
cpp_args = ['$CXXFLAGS']
c_link_args = ['$LDFLAGS']
cpp_link_args = ['$LDFLAGS']

[properties]
pkg_config_libdir = '$sys/lib/pkgconfig'
sys_root = '$work/sysroot'

[host_machine]
system = 'windows'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'
EOF

step() { # name command...: runs a step, its output in its log, shown when it fails.
  local name=$1
  shift
  [[ -e $work/$name.log ]] || echo "libmpv.sh: $name" >&2
  "$@" >>"$work/$name.log" 2>&1 || { tail -n 80 "$work/$name.log" >&2; echo "libmpv.sh: $name failed" >&2; exit 1; }
}
meson_build() { # name options...: static unless $library says otherwise
  local name=$1
  shift
  step "$name" python3 "$meson" setup "$work/build/$name" "$work/src/$name" --cross-file "$work/cross.ini" \
    --prefix=/photolib --libdir=lib --buildtype=release -Ddefault_library="${library:-static}" -Dprefer_static=true \
    -Dauto_features=disabled -Dwrap_mode=nodownload "$@"
  # mpv keeps how meson was run, which names the cross file by its path here.
  [[ ! -f $work/build/$name/config.h ]] || sed -i "s|--cross-file=$work/|--cross-file=|" "$work/build/$name/config.h"
  step "$name" ninja -C "$work/build/$name"
  step "$name" python3 "$meson" install -C "$work/build/$name" --destdir "$work/sysroot" --no-rebuild
}

zlib() {
  mkdir -p "$work/build/zlib" && cd "$work/build/zlib"
  for file in adler32 compress crc32 deflate gzclose gzlib gzread gzwrite infback inffast inflate inftrees trees \
    uncompr zutil; do
    $HOST-clang "$CFLAGS" -O2 -c "$work/src/zlib/$file.c"
  done
  llvm-ar rcs "$sys/lib/libz.a" ./*.o
  install -m 644 "$work/src/zlib/zlib.h" "$work/src/zlib/zconf.h" "$sys/include/"
  mkdir -p "$sys/lib/pkgconfig"
  cat >"$sys/lib/pkgconfig/zlib.pc" <<'EOF'
prefix=/photolib
Name: zlib
Description: zlib
Version: 1.3.2
Libs: -L${prefix}/lib -lz
Cflags: -I${prefix}/include
EOF
}
step zlib zlib
meson_build dav1d -Denable_tools=false -Denable_tests=false -Denable_examples=false -Denable_docs=false
meson_build freetype -Dzlib=disabled
meson_build fribidi -Ddocs=false -Dbin=false -Dtests=false
meson_build harfbuzz -Dfreetype=enabled -Draster=disabled -Dvector=disabled -Dgpu=disabled -Dsubset=disabled \
  -Dtests=disabled -Dutilities=disabled
meson_build libass -Ddirectwrite=enabled -Dasm=enabled
meson_build libplacebo -Dopengl=enabled -Ddemos=false
# Its C++ needs libc++, which its pkg-config file leaves out: linked in, as the app ships no libc++.dll.
sed -i 's/^Libs: .*/& -l:libc++.a -l:libunwind.a/' "$sys/lib/pkgconfig/libplacebo.pc"
mkdir -p "$work/build/ffmpeg"
cd "$work/build/ffmpeg"
step ffmpeg "$work/src/ffmpeg/configure" --prefix=/photolib --enable-cross-compile --target-os=mingw32 --arch=x86_64 \
  --cross-prefix=$HOST- --cc=$HOST-clang --cxx=$HOST-clang++ --pkg-config=pkg-config --pkg-config-flags=--static \
  --enable-shared --disable-static --disable-programs --disable-doc --disable-debug --disable-avdevice \
  --disable-autodetect --enable-w32threads --enable-zlib --enable-libdav1d --enable-d3d11va --enable-dxva2 \
  --enable-schannel --disable-filter=gfxcapture
step ffmpeg make -j"$(nproc)"
step ffmpeg make install DESTDIR="$work/sysroot"
library=shared meson_build mpv -Dlibmpv=true -Dcplayer=false -Dgpl=false -Dbuild-date=false \
  -Dwin32-threads=enabled -Dwasapi=enabled -Dd3d-hwaccel=enabled -Dgl=enabled -Dplain-gl=enabled -Dzlib=enabled \
  -Dmanpage-build=disabled

out=$work/artefact
cp "$sys"/bin/*.dll "$out/libmpv/"
cp "$sys/lib/libmpv.dll.a" "$out/libmpv/"
cp "$sys"/include/mpv/*.h "$out/libmpv/include/"
llvm-strip --strip-all "$out"/libmpv/*.dll
for lib in EGL:"${EGL_IMPORTS[*]}" GLESv2:"${GLES_IMPORTS[*]}"; do
  printf 'LIBRARY lib%s.dll\nEXPORTS\n%s\n' "${lib%%:*}" "${lib#*:}" | tr ' ' '\n' >"$work/lib${lib%%:*}.def"
  llvm-dlltool -m i386:x86-64 -d "$work/lib${lib%%:*}.def" -l "$out/ANGLE/lib/lib${lib%%:*}.dll.lib"
done
# Flutter's NOTICES format, which the app's licence page reads.
for notice in "${NOTICES[@]}"; do
  IFS='|' read -r name licence source file <<<"$notice"
  [[ $notice == "${NOTICES[0]}" ]] || printf '%080d\n' 0 | tr 0 -
  printf '%s\n\n%s: %s, built from %s\n\n' "$name" "$name" "$licence" "${url[$source]}"
  awk 1 "$work/src/${source/llvm-mingw/toolchain}/$file"
done >"$out/libmpv/libmpv-notices.txt"

# Nothing GPL, and no runtime DLL the app does not ship.
python3 "$root/tools/video/lgpl_check.py" "$out/libmpv"
for dll in "$out"/libmpv/*.dll; do
  for import in $(llvm-readobj --coff-imports "$dll" | sed -n 's/^ *Name: \(.*\.dll\)$/\1/Ip'); do
    if [[ -e $toolchain/$HOST/bin/$import ]]; then
      echo "libmpv.sh: $(basename "$dll") imports $import, which the app does not ship" >&2
      exit 1
    fi
  done
done

archive=libmpv-0.41.0-ffmpeg-8.1.3-windows-x64.tar.xz
mkdir -p "$root/app/build/libmpv"
tar -C "$out" --sort=name --mtime=@"$SOURCE_DATE_EPOCH" --owner=0 --group=0 --numeric-owner --mode=a+rX,u+w,go-w \
  --format=gnu -cf - ANGLE libmpv | xz -9 -T1 >"$root/app/build/libmpv/$archive"
python3 - "$root/app/build/libmpv/$archive" "$out" "$pins" "$check" "$toolchain" "$meson" <<'EOF'
import hashlib, json, pathlib, platform, subprocess, sys
archive, out, pins, check, toolchain, meson = sys.argv[1:]
digest = lambda p: hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
version = lambda *cmd: subprocess.run(cmd, capture_output=True, text=True).stdout.splitlines()[0].strip()
built = {
    "archive": pathlib.Path(archive).name,
    "sha256": digest(archive),
    "files": {str(p.relative_to(out)): digest(p) for p in sorted(pathlib.Path(out).rglob("*")) if p.is_file()},
}
built["url"] = ("https://github.com/arxiflex-dev/photolib/releases/download/"
                f"libmpv-windows-{built['sha256'][:12]}/{built['archive']}")
built["toolchain"] = {
    "llvm-mingw": pathlib.Path(toolchain).name,
    "clang": version(f"{toolchain}/bin/clang", "--version"),
    "nasm": version("nasm", "-v"),
    "meson": version(sys.executable, meson, "--version"),
    "ninja": version("ninja", "--version"),
    "pkg-config": version("pkg-config", "--version"),
    "tar": version("tar", "--version"),
    "xz": version("xz", "--version"),
    "python": platform.python_version(),
    "host": f"{platform.system()} {platform.machine()}",
}
if check:
    pinned = json.loads(pathlib.Path(pins).read_text())
    differ = sorted(f for f in pinned["files"].keys() | built["files"].keys()
                    if pinned["files"].get(f) != built["files"].get(f))
    if differ or pinned["sha256"] != built["sha256"]:
        sys.exit(f"libmpv.sh: the build differs from {pins}: {', '.join(differ) or built['archive']}")
    print(f"libmpv.sh: {built['archive']} matches {pins}: {built['sha256']}")
else:
    pathlib.Path(pins).write_text(json.dumps(built, indent=2) + "\n")
    print(f"libmpv.sh: {archive} {built['sha256']}, pinned in {pins}")
EOF
