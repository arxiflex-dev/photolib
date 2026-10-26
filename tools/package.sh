#!/usr/bin/env bash
# Builds one package from a release build (docs/10 §8.2, ADR-0154, ADR-0249), unsigned as the smoke builds are unless
# a release's keys are set (docs/dev/releasing.md):
#
#   bash tools/package.sh appimage   app/build/Photolib-<arch>.AppImage, started under xvfb-run (Linux)
#   bash tools/package.sh deb        app/build/photolib_<version>_<arch>.deb (Debian, Ubuntu)
#   bash tools/package.sh dmg        app/build/Photolib.dmg of the sandboxed app, verified by hdiutil (macOS)
#   bash tools/package.sh msix       app/build/Photolib.msix, by the Windows SDK's makeappx (Windows)
#   bash tools/package.sh photolibd  $CARGO_TARGET_DIR/photolibd_<version>_<arch>.deb, the server as a service
#   bash tools/package.sh apk        app/build/app/outputs/flutter-apk/: the libre APKs, one per ABI (F-Droid)
#   bash tools/package.sh aab        app/build/app/outputs/bundle/: the play flavour's bundle (Google Play)
#   bash tools/package.sh ipa        app/build/ios/ipa/: the App Store's archive (iOS)
#
# tools/smoke.sh runs it after each desktop's smoke test, which builds the kernel the app bundles first. The AppImage
# is made by appimagetool with AppImage's runtime, each fetched once into the tools cache at the pinned SHA-256.
set -euo pipefail

APPIMAGETOOL=1.9.1
RUNTIME=20251108
declare -A SHA256=(
  [appimagetool-x86_64]=ed4ce84f0d9caff66f50bcca6ff6f35aae54ce8135408b3fa33abfc3cb384eb0
  [appimagetool-aarch64]=f0837e7448a0c1e4e650a93bb3e85802546e60654ef287576f46c71c126a9158
  [runtime-x86_64]=2fca8b443c92510f1483a883f60061ad09b46b978b2631c807cd873a47ec260d
  [runtime-aarch64]=00cbdfcf917cc6c0ff6d3347d59e0ca1f7f45a6df1a428a0d6d8a78664d87444
)
ICONS=linux/packaging/icons
ICON=$ICONS/hicolor/256x256/apps/org.photolib.photolib.png

tools=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$tools/../app"
version=$(sed -n 's/^version: *\([0-9.]*\).*/\1/p' pubspec.yaml)

RELEASES=https://github.com/arxiflex-dev/photolib/releases/download
sha256() { if command -v sha256sum >/dev/null; then sha256sum <"$1"; else shasum -a 256 <"$1"; fi | cut -d' ' -f1; }

# fetch <file in the cache> <url> <sha256>: the cached file, downloaded once.
fetch() {
  local cache=${PHOTOLIB_TOOLS_CACHE:-${TMPDIR:-/tmp}/photolib-tools-$(id -u)}
  [[ -f $cache/$1 ]] || bash "$tools/fetch_release.sh" "$2" "$3" "$cache" "$1"
  echo "$cache/$1"
}

# deb <root> <file> <name> <depends> <summary>: builds the package of the files under <root>, as the release's version.
deb() {
  mkdir -p "$1/DEBIAN"
  cat >"$1/DEBIAN/control" <<EOF
Package: $3
Version: $version
Architecture: $(dpkg --print-architecture)
Maintainer: Photolib <https://github.com/arxiflex-dev/photolib/issues>
Homepage: https://github.com/arxiflex-dev/photolib
Depends: $4
Description: $5
 Photolib keeps photos and videos on a server of your own; its apps browse, back up and share them.
EOF
  dpkg-deb --root-owner-group --build "$1" "$2"
}

case ${1:-} in
  appimage)
    # The app a later start hands its files and links (ADR-0206), a profile build: a release build seals its log.
    flutter build linux --profile
    running=(build/linux/*/profile/bundle/photolib)
    flutter build linux --release
    arch=$(uname -m)
    dir=build/AppDir
    rm -rf "$dir" && mkdir -p "$dir"
    cp -R build/linux/*/release/bundle/. "$dir/"
    ln -s photolib "$dir/AppRun"
    cp linux/packaging/org.photolib.photolib.desktop "$dir/"
    cp "$ICON" "$dir/org.photolib.photolib.png"
    install -Dm644 -t "$dir/usr/share/metainfo" linux/packaging/org.photolib.photolib.metainfo.xml
    cp -R "$ICONS" "$dir/usr/share/"
    tool=$(fetch "appimagetool-$APPIMAGETOOL-$arch.AppImage" \
      "https://github.com/AppImage/appimagetool/releases/download/$APPIMAGETOOL/appimagetool-$arch.AppImage" \
      "${SHA256[appimagetool-$arch]}")
    runtime=$(fetch "appimage-runtime-$RUNTIME-$arch" \
      "https://github.com/AppImage/type2-runtime/releases/download/$RUNTIME/runtime-$arch" "${SHA256[runtime-$arch]}")
    image=build/Photolib-$arch.AppImage
    # Neither needs FUSE, which containers lack.
    export APPIMAGE_EXTRACT_AND_RUN=1
    ARCH=$arch "$tool" --runtime-file "$runtime" "$dir" "$image"
    bash ../tools/desktop/single_instance.sh "${running[0]}" "$dir/AppRun"
    # Alone it starts and stays up until timeout ends it.
    status=0
    xvfb-run -a timeout 15 "$image" || status=$?
    if ((status != 124)); then
      echo "package.sh: $image ended by itself (exit $status)" >&2
      exit 1
    fi
    ;;
  deb)
    flutter build linux --release
    root=build/deb
    rm -rf "$root" && mkdir -p "$root/opt/photolib" "$root/usr/bin"
    cp -R build/linux/*/release/bundle/. "$root/opt/photolib/"
    ln -s /opt/photolib/photolib "$root/usr/bin/photolib"
    install -Dm644 -t "$root/usr/share/applications" linux/packaging/org.photolib.photolib.desktop
    install -Dm644 -t "$root/usr/share/metainfo" linux/packaging/org.photolib.photolib.metainfo.xml
    for icon in "$ICONS"/hicolor/*/apps/*; do install -Dm644 "$icon" "$root/usr/share/icons/${icon#"$ICONS"/}"; done
    deb "$root" "build/photolib_${version}_$(dpkg --print-architecture).deb" photolib \
      "libgtk-3-0t64 | libgtk-3-0, libmpv2, libsecret-1-0" "Photolib, your own photo and video library"
    ;;
  photolibd)
    cd ../server
    cargo build --release --locked -p photolib-server --bin photolibd
    target=${CARGO_TARGET_DIR:-$PWD/target}
    root=$target/deb
    rm -rf "$root"
    install -Dm755 -t "$root/usr/bin" "$target/release/photolibd"
    install -Dm644 -t "$root/lib/systemd/system" ../deploy/debian/photolibd.service
    install -Dm644 -t "$root/etc/photolib" ../deploy/debian/photolibd.yaml
    mkdir -p "$root/DEBIAN" && echo /etc/photolib/photolibd.yaml >"$root/DEBIAN/conffiles"
    # The cluster's programs, of a major photolibd supports; the distribution's own libvips, FFmpeg and ExifTool.
    deb "$root" "$target/photolibd_${version}_$(dpkg --print-architecture).deb" photolibd \
      "postgresql (>= 16), libvips42t64 (>= 8.15) | libvips42 (>= 8.15), ffmpeg, libimage-exiftool-perl" \
      "Photolib's server, photolibd, with its own PostgreSQL"
    ;;
  apk)
    flutter build apk --release --flavor libre --split-per-abi
    apks=(build/app/outputs/flutter-apk/app-*-libre-release.apk)
    python3 ../tools/scan_libre.py pubspec.lock "${apks[@]}"
    python3 ../tools/page_size.py "${apks[@]}"
    ;;
  aab)
    flutter build appbundle --release --flavor play
    python3 ../tools/page_size.py build/app/outputs/bundle/playRelease/app-play-release.aab
    ;;
  ipa) flutter build ipa --release --export-options-plist ios/ExportOptions.plist ;;
  dmg)
    flutter build macos --release
    app=build/macos/Build/Products/Release/photolib.app
    dmg=build/Photolib.dmg
    # A release signs with its Developer ID and notarises with notarytool's stored credentials.
    id=${APPLE_SIGNING_IDENTITY:-}
    [[ -z $id ]] || codesign --force --deep --options runtime --timestamp \
      --entitlements macos/Runner/Release.entitlements --sign "$id" "$app"
    # The DMG ships the App Sandbox and the folders' bookmarks (ADR-0071), which M10-04 signs and notarises.
    entitlements=$(codesign -d --entitlements - --xml "$app")
    for key in app-sandbox files.bookmarks.app-scope; do
      granted="<key>com\.apple\.security\.$key</key>[[:space:]]*<true/>"
      if [[ ! $entitlements =~ $granted ]]; then
        echo "package.sh: $app lacks com.apple.security.$key (ADR-0071)" >&2
        exit 1
      fi
    done
    hdiutil create -volname Photolib -srcfolder "$app" -ov -format UDZO "$dmg"
    hdiutil verify "$dmg"
    if [[ -n $id ]]; then
      codesign --timestamp --sign "$id" "$dmg"
      xcrun notarytool submit "$dmg" --keychain-profile "${APPLE_NOTARY_PROFILE:?set APPLE_NOTARY_PROFILE}" --wait
      xcrun stapler staple "$dmg"
    fi
    cat >build/photolib.rb <<EOF
cask "photolib" do
  version "$version"
  sha256 "$(sha256 "$dmg")"

  url "$RELEASES/v#{version}/Photolib.dmg"
  name "Photolib"
  desc "Your own photo and video library"
  homepage "https://github.com/arxiflex-dev/photolib"

  depends_on macos: ">= :ventura"

  app "photolib.app"
end
EOF
    ;;
  msix)
    flutter build windows --release
    dir=build/msix
    rm -rf "$dir" && mkdir -p "$dir"
    cp -R build/windows/x64/runner/Release/. "$dir/"
    sed "s/VERSION/$version.0/; s/CN=Photolib/${MSIX_PUBLISHER:-CN=Photolib}/" windows/packaging/AppxManifest.xml \
      >"$dir/AppxManifest.xml"
    cp "$ICON" "$dir/logo.png"
    makeappx=$(command -v makeappx ||
      find "/c/Program Files (x86)/Windows Kits/10/bin" -path '*/x64/makeappx.exe' 2>/dev/null | sort -V | tail -n 1)
    [[ -n $makeappx ]] || { echo "package.sh: makeappx is missing: install the Windows SDK" >&2; exit 1; }
    # Git Bash would take makeappx's switches for paths.
    MSYS_NO_PATHCONV=1 "$makeappx" pack /o /d "$dir" /p build/Photolib.msix
    # A release signs with the certificate whose subject is MSIX_PUBLISHER, by thumbprint: its key stays on hardware.
    [[ -z ${WINDOWS_CERTIFICATE_SHA1:-} ]] || MSYS_NO_PATHCONV=1 signtool sign /fd SHA256 \
      /tr http://timestamp.digicert.com /td SHA256 /sha1 "$WINDOWS_CERTIFICATE_SHA1" build/Photolib.msix
    mkdir -p build/winget
    manifest() {
      printf 'PackageIdentifier: Photolib.Photolib\nPackageVersion: %s\n' "$version"
      cat
      printf 'ManifestType: %s\nManifestVersion: 1.10.0\n' "$1"
    }
    manifest version >build/winget/Photolib.Photolib.yaml <<<"DefaultLocale: en-US"
    manifest installer >build/winget/Photolib.Photolib.installer.yaml <<EOF
InstallerType: msix
InstallerSha256: $(sha256 build/Photolib.msix)
Installers:
  - Architecture: x64
    InstallerUrl: $RELEASES/v$version/Photolib.msix
EOF
    manifest defaultLocale >build/winget/Photolib.Photolib.locale.en-US.yaml <<EOF
PackageLocale: en-US
Publisher: Photolib
PackageName: Photolib
License: AGPL-3.0-only
ShortDescription: Your own photo and video library
EOF
    ;;
  *)
    echo "usage: package.sh <appimage|deb|dmg|msix|photolibd|apk|aab|ipa>" >&2
    exit 2
    ;;
esac
