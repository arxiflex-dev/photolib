#!/usr/bin/env bash
# Packs `flutter build windows --release`'s output into the standalone zip a user downloads (ADR-0404): the app, the
# LGPL libmpv and FFmpeg it bundles (ADR-0229), the Visual C++ runtime DLLs the build imports, Photolib's licence, the
# libraries' notices and where their source and build are. It adds nothing but those and fails, writing no zip, if the
# package would still need a DLL outside it and Windows (tools/windows/deps_scan.py). The zip's bytes depend only on
# the build's files.
#
#   [VC_REDIST_DIR=<Microsoft.VC*.CRT directory>] bash tools/windows/standalone.sh <Release directory> <zip>
#
# Without VC_REDIST_DIR the runtime comes from the newest Visual Studio vswhere finds (the Windows runners have one).
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
[[ $# == 2 && -d $1 ]] || { echo "usage: tools/windows/standalone.sh <Release directory> <zip>" >&2; exit 2; }
release=$1
zip=$2
python=$(command -v python3 || command -v python)
scan() { "$python" -I "$root/tools/windows/deps_scan.py" "$@"; }

stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
package=$stage/photolib
mkdir "$package"
cp -a "$release/." "$package/"
for file in photolib.exe libmpv-notices.txt; do
  [[ -f $package/$file ]] || { echo "standalone.sh: $release has no $file" >&2; exit 1; }
done

# Only Microsoft's own runtime may come from the Visual Studio installation: a DLL of any other toolchain is a bug.
runtime='^(vcruntime|msvcp|concrt|vcomp)140[a-z0-9_]*\.dll$'
redist=${VC_REDIST_DIR:-}
if [[ -z $redist ]] && command -v vswhere >/dev/null 2>&1; then
  redist=$(vswhere -latest -find 'VC/Redist/MSVC/*/x64/Microsoft.VC*.CRT' | tr -d '\r' | sort | tail -n 1)
fi
for round in 1 2; do
  for name in $(scan --missing "$package" | tr -d '\r'); do
    if [[ ${name,,} =~ $runtime && -n $redist ]]; then
      found=$(find "$redist" -maxdepth 1 -iname "$name" | head -n 1)
      [[ -n $found ]] && { cp "$found" "$package/$name"; continue; }
    fi
    echo "standalone.sh: the package imports $name, which is neither in $release nor a Visual C++ runtime DLL" \
      "to take from ${redist:-a Visual Studio installation (set VC_REDIST_DIR)}" >&2
    exit 1
  done
done
scan "$package" >&2 || { echo "standalone.sh: the package needs files outside it" >&2; exit 1; }

cp "$root/LICENSE" "$package/LICENSE"
pins=$root/app/windows/libmpv.json
revision=${GITHUB_SHA:-$(git -C "$root" rev-parse HEAD)}
cat >"$package/SOURCE.txt" <<EOF
Photolib for Windows, built from https://github.com/arxiflex-dev/photolib at commit $revision.

The FFmpeg DLLs (avcodec, avformat, avutil, avfilter, swresample, swscale) and libmpv-2.dll beside photolib.exe are
LGPL-2.1-or-later libraries (libmpv-notices.txt lists them all, with their licences and the source each was built
from). They are linked dynamically: replace any of them with a build of your own of the same version and photolib.exe
uses it. They were built, from the pinned sources and with no GPL component, by tools/video/libmpv.sh of this
repository, which anyone can run to get the same bytes; app/windows/libmpv.json pins the build:

$(sed -n 's/^  "\(archive\|sha256\|url\)": \(.*\),\?$/  \1: \2/p' "$pins" | sed 's/,$//')

The Visual C++ runtime DLLs (vcruntime140*.dll, msvcp140*.dll) are Microsoft's, redistributed beside the app as
Microsoft allows for Visual Studio's redistributable files.
EOF
cat >"$package/README.txt" <<EOF
Photolib needs no installation: unpack this folder anywhere and run photolib.exe. It needs nothing else on the
machine. LICENSE is Photolib's own; libmpv-notices.txt, SOURCE.txt and the app's Settings > About > View licenses give
the licences and sources of the libraries it contains.
EOF

# A zip of fixed entry order, dates and permissions, so that one build packs to the same bytes.
"$python" -I - "$stage" "$zip" <<'PY'
import os, sys, zipfile
stage, target = sys.argv[1:]
partial = target + ".part"
with zipfile.ZipFile(partial, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as z:
    for directory, dirs, files in os.walk(os.path.join(stage, "photolib")):
        dirs.sort()
        for name in sorted(files):
            path = os.path.join(directory, name)
            info = zipfile.ZipInfo(os.path.relpath(path, stage).replace(os.sep, "/"), (2026, 1, 1, 0, 0, 0))
            info.external_attr = 0o644 << 16
            info.compress_type = zipfile.ZIP_DEFLATED
            with open(path, "rb") as f:
                z.writestr(info, f.read(), compresslevel=9)
os.replace(partial, target)
PY
echo "standalone.sh: $zip $(du -h "$zip" | cut -f1), SHA-256 $(sha256sum "$zip" | cut -d' ' -f1)"
