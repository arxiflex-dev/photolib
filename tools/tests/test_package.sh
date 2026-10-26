#!/usr/bin/env bash
# tools/package.sh builds the desktop packages (M1-20, ADR-0154): an AppImage it starts, a DMG and an MSIX, and
# the debs of the app and of photolibd (ADR-0249), which dpkg installs and upgrades here in a directory of its own. The
# build tools are stubs here; the smoke jobs build each package on its desktop.
# shellcheck disable=SC2016 # the stubs expand their own $variables when they run
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_tool dpkg
cd "$REPO_ROOT" || exit 1

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin" "$TMP/repo/tools" "$TMP/repo/server" "$TMP/cache"
cp tools/package.sh tools/scan_libre.py "$TMP/repo/tools/"
printf 'import os, sys\nopen(os.environ["CALLS"], "a").write("page_size.py %%s\\n" %% " ".join(sys.argv[1:]))\n' \
  >"$TMP/repo/tools/page_size.py"
cp -R deploy "$TMP/repo/"
APP=$TMP/repo/app
mkdir -p "$APP/linux/packaging" "$APP/windows/packaging"
cp app/pubspec.yaml app/pubspec.lock "$APP/"
cp -R app/linux/packaging/. "$APP/linux/packaging/"
cp app/windows/packaging/AppxManifest.xml "$APP/windows/packaging/"
HICOLOR=app/linux/packaging/icons/hicolor
ICON=$HICOLOR/256x256/apps/org.photolib.photolib.png
arch=$(uname -m)
version=$(sed -n 's/^version: *\([0-9.]*\).*/\1/p' app/pubspec.yaml)

log() { printf '#!/usr/bin/env bash\necho "%s $*" >>"$CALLS"\n%s\n' "$1" "${2:-}" >"$TMP/bin/$1"; chmod +x "$TMP/bin/$1"; }
log flutter 'case "$2" in
  linux) mkdir -p "build/linux/x64/${3#--}/bundle/lib" && echo app >"build/linux/x64/${3#--}/bundle/photolib" ;;
  macos) mkdir -p build/macos/Build/Products/Release/photolib.app ;;
  windows) mkdir -p build/windows/x64/runner/Release && echo exe >build/windows/x64/runner/Release/photolib.exe ;;
  apk) mkdir -p build/app/outputs/flutter-apk && for abi in armeabi-v7a arm64-v8a x86_64; do
    python3 -c "import sys, zipfile; zipfile.ZipFile(sys.argv[1], \"w\").writestr(\"classes.dex\", sys.argv[2])" \
      "build/app/outputs/flutter-apk/app-$abi-libre-release.apk" "${DEX:-androidx}"; done ;;
esac'
log hdiutil 'if [[ $1 == create ]]; then echo dmg >"${@: -1}"; fi'
log makeappx 'echo msix >"${@: -1}"'
log xcrun
log signtool
log cargo 'mkdir -p "$CARGO_TARGET_DIR/release" && echo "photolibd $VERSION" >"$CARGO_TARGET_DIR/release/photolibd"'
export CARGO_TARGET_DIR=$TMP/target
log xvfb-run 'shift; exec "$@"'
# The AppImage alone either stays up until timeout ends it (124), or ends by itself, as $APP_EXIT says.
log timeout 'echo "APPIMAGE_EXTRACT_AND_RUN=$APPIMAGE_EXTRACT_AND_RUN" >>"$CALLS"; exit "${APP_EXIT:-124}"'
# The hand-over to a running app, which passes or fails as $HANDOVER_EXIT says.
mkdir -p "$TMP/repo/tools/desktop"
printf '#!/usr/bin/env bash\necho "single_instance.sh $*" >>"$CALLS"\n%s\n' 'exit "${HANDOVER_EXIT:-0}"' \
  >"$TMP/repo/tools/desktop/single_instance.sh"
# codesign shows the entitlements the release build signed the app with, as XML on one line.
log codesign 'tr -d "\n\t" <"$ENTITLEMENTS"'
# appimagetool and its runtime as the tools cache holds them once fetched.
tool=$(sed -n 's/^APPIMAGETOOL=//p' tools/package.sh)
runtime=$(sed -n 's/^RUNTIME=//p' tools/package.sh)
printf '#!/usr/bin/env bash\necho "appimagetool ARCH=$ARCH $*" >>"$CALLS"\necho image >"${@: -1}"\n' \
  >"$TMP/cache/appimagetool-$tool-$arch.AppImage"
chmod +x "$TMP/cache/appimagetool-$tool-$arch.AppImage"
echo runtime >"$TMP/cache/appimage-runtime-$runtime-$arch"

package() {
  export CALLS=$TMP/calls ENTITLEMENTS=${ENTITLEMENTS:-$REPO_ROOT/app/macos/Runner/Release.entitlements}
  : >"$CALLS"
  rm -rf "$APP/build"
  PATH="$TMP/bin:$PATH" PHOTOLIB_TOOLS_CACHE=$TMP/cache bash "$TMP/repo/tools/package.sh" "$@" >"$TMP/out" 2>&1
  STATUS=$?
  LOG=$(<"$CALLS")
}
has() { [[ $LOG == *"$2"* ]] && ok "$1" || fail "$1: no '$2' in $LOG $(<"$TMP/out")"; }

package
[[ $STATUS == 2 && $(<"$TMP/out") == *"usage: package.sh <appimage|deb|dmg|msix|photolibd|apk|aab|ipa>"* ]] && ok "no package: usage" ||
  fail "no package: exit $STATUS $(<"$TMP/out")"

package appimage
[[ $STATUS == 0 ]] && ok "an AppImage builds" || fail "appimage failed ($STATUS): $(<"$TMP/out")"
has "from a release build" "flutter build linux --release"
dir=$APP/build/AppDir
[[ -f $dir/photolib && -d $dir/lib && $(readlink "$dir/AppRun") == photolib ]] && ok "of the bundle, AppRun its binary" ||
  fail "the AppDir holds no bundle run by AppRun: $(ls -l "$dir")"
cmp -s "$dir/org.photolib.photolib.desktop" app/linux/packaging/org.photolib.photolib.desktop &&
  cmp -s "$dir/org.photolib.photolib.png" "$ICON" && diff -r "$HICOLOR" "$dir/usr/share/icons/hicolor" &&
  [[ -f $dir/usr/share/metainfo/org.photolib.photolib.metainfo.xml ]] &&
  ok "with the desktop entry, its icon in hicolor and AppStream metadata" || fail "no desktop entry, icon or metadata"
has "by the pinned appimagetool and runtime, offline" \
  "appimagetool ARCH=$arch --runtime-file $TMP/cache/appimage-runtime-$runtime-$arch build/AppDir build/Photolib-$arch.AppImage"
has "and a profile build" "flutter build linux --profile"
has "which, its log plain, a start of the app hands a photo and a link (ADR-0206)" \
  "single_instance.sh build/linux/x64/profile/bundle/photolib build/AppDir/AppRun"
has "it starts the AppImage on a display of its own" "xvfb-run -a timeout 15 build/Photolib-$arch.AppImage"
has "without FUSE" "APPIMAGE_EXTRACT_AND_RUN=1"

APP_EXIT=1 package appimage
[[ $STATUS != 0 && $(<"$TMP/out") == *"Photolib-$arch.AppImage ended by itself (exit 1)"* ]] &&
  ok "an AppImage that does not stay up fails" || fail "an AppImage that ends at once passes: $(<"$TMP/out")"

HANDOVER_EXIT=1 package appimage
[[ $STATUS != 0 ]] && ok "an app that takes no later start's photo or link fails" ||
  fail "a failed hand-over passes: $(<"$TMP/out")"

package dmg
[[ $STATUS == 0 ]] && ok "a DMG builds" || fail "dmg failed ($STATUS): $(<"$TMP/out")"
has "of the release app" "flutter build macos --release"
has "by hdiutil" \
  "hdiutil create -volname Photolib -srcfolder build/macos/Build/Products/Release/photolib.app -ov -format UDZO build/Photolib.dmg"
has "and verified" "hdiutil verify build/Photolib.dmg"
has "of the app as signed" "codesign -d --entitlements - --xml build/macos/Build/Products/Release/photolib.app"
[[ $LOG != *--sign* && $LOG != *xcrun* ]] && ok "unsigned without the release's Developer ID" || fail "signed: $LOG"
sha=$(sha256sum <"$APP/build/Photolib.dmg" | cut -d' ' -f1)
cask=$(<"$APP/build/photolib.rb")
[[ $cask == *"version \"$version\""* && $cask == *"sha256 \"$sha\""* && $cask == *'app "photolib.app"'* &&
  $cask == *'url "https://github.com/arxiflex-dev/photolib/releases/download/v#{version}/Photolib.dmg"'* ]] &&
  ok "with the Homebrew cask of the release's DMG" || fail "the cask: $cask"
APPLE_SIGNING_IDENTITY="Developer ID Application: Photolib (TEAM)" APPLE_NOTARY_PROFILE=photolib package dmg
[[ $STATUS == 0 ]] && ok "a signed DMG builds" || fail "signed dmg failed ($STATUS): $(<"$TMP/out")"
has "the app signed for the hardened runtime" "codesign --force --deep --options runtime --timestamp --entitlements \
macos/Runner/Release.entitlements --sign Developer ID Application: Photolib (TEAM) build/macos/Build/Products/Release/photolib.app"
has "the DMG signed" "codesign --timestamp --sign Developer ID Application: Photolib (TEAM) build/Photolib.dmg"
has "notarised" "xcrun notarytool submit build/Photolib.dmg --keychain-profile photolib --wait"
has "and stapled" "xcrun stapler staple build/Photolib.dmg"
for key in app-sandbox files.bookmarks.app-scope; do
  grep -v "com.apple.security.$key<" app/macos/Runner/Release.entitlements >"$TMP/entitlements"
  ENTITLEMENTS=$TMP/entitlements package dmg
  [[ $STATUS != 0 && $(<"$TMP/out") == *"photolib.app lacks com.apple.security.$key (ADR-0071)"* &&
    $LOG != *"hdiutil create"* ]] && ok "no DMG of an app without $key" ||
    fail "a DMG of an app without $key ($STATUS): $(<"$TMP/out")"
done

package msix
[[ $STATUS == 0 ]] && ok "an MSIX builds" || fail "msix failed ($STATUS): $(<"$TMP/out")"
[[ $LOG != *signtool* ]] && ok "unsigned without the release's certificate" || fail "signed: $LOG"
sha=$(sha256sum <"$APP/build/Photolib.msix" | cut -d' ' -f1)
winget=$APP/build/winget
grep -qx "InstallerSha256: $sha" "$winget/Photolib.Photolib.installer.yaml" &&
  grep -qx "    InstallerUrl: https://github.com/arxiflex-dev/photolib/releases/download/v$version/Photolib.msix" \
    "$winget/Photolib.Photolib.installer.yaml" && grep -qx "PackageVersion: $version" "$winget/Photolib.Photolib.yaml" &&
  grep -qx "License: AGPL-3.0-only" "$winget/Photolib.Photolib.locale.en-US.yaml" &&
  ok "with the winget manifests of the release's MSIX" || fail "the winget manifests: $(cat "$winget"/* 2>&1)"
WINDOWS_CERTIFICATE_SHA1=0123abcd MSIX_PUBLISHER="CN=Photolib, O=Photolib" package msix
has "signed with the release's certificate, timestamped" \
  "signtool sign /fd SHA256 /tr http://timestamp.digicert.com /td SHA256 /sha1 0123abcd build/Photolib.msix"
grep -q 'Publisher="CN=Photolib, O=Photolib"' "$APP/build/msix/AppxManifest.xml" &&
  ok "as the publisher its certificate names" || fail "the manifest's publisher is not the certificate's"
grep -qx "InstallerSha256: $(sha256sum <"$APP/build/Photolib.msix" | cut -d' ' -f1)" \
  "$winget/Photolib.Photolib.installer.yaml" && ok "and winget installs the signed MSIX" || fail "winget's hash is stale"
has "of the release bundle" "flutter build windows --release"
has "by the Windows SDK's makeappx" "makeappx pack /o /d build/msix /p build/Photolib.msix"
grep -q "Version=\"$version.0\"" "$APP/build/msix/AppxManifest.xml" && ok "versioned as the pubspec ($version.0)" ||
  fail "the manifest is not versioned $version.0"
[[ -f $APP/build/msix/photolib.exe ]] && cmp -s "$APP/build/msix/logo.png" "$ICON" && ok "with the app and its logo" ||
  fail "the package holds no app or logo"

package apk
[[ $STATUS == 0 ]] && ok "the libre APKs build" || fail "apk failed ($STATUS): $(<"$TMP/out")"
has "one per ABI, of the libre flavour" "flutter build apk --release --flavor libre --split-per-abi"
has "each with Android 15's 16 KB pages" "page_size.py build/app/outputs/flutter-apk/app-arm64-v8a-libre-release.apk \
build/app/outputs/flutter-apk/app-armeabi-v7a-libre-release.apk build/app/outputs/flutter-apk/app-x86_64-libre-release.apk"
DEX=com/google/android/gms/common package apk
[[ $STATUS != 0 && $(<"$TMP/out") == *"proprietary component com/google/android/gms"* ]] &&
  ok "an APK with Google Play Services fails, as F-Droid would refuse it" || fail "a proprietary APK passes: $(<"$TMP/out")"
package aab
has "the Play bundle, of the play flavour" "flutter build appbundle --release --flavor play"
has "with 16 KB pages" "page_size.py build/app/outputs/bundle/playRelease/app-play-release.aab"
package ipa
has "the App Store archive" "flutter build ipa --release --export-options-plist ios/ExportOptions.plist"

# dpkg installs, upgrades and removes into $ROOT as on a machine, its dependencies aside, with no root needed.
ROOT=$TMP/root
mkdir -p "$ROOT/var/lib/dpkg/updates" "$ROOT/var/lib/dpkg/info" && : >"$ROOT/var/lib/dpkg/status"
dpkg_root() { dpkg --root="$ROOT" --force-not-root --force-depends --force-confold --log=/dev/null "$@" >"$TMP/dpkg" 2>&1; }
installed() { dpkg-query --root="$ROOT" -W -f='${Version}' "$1" 2>/dev/null; }
release() { sed -i "s/^version: .*/version: $1+7/" "$APP/pubspec.yaml"; }
arch=$(dpkg --print-architecture)

package deb
[[ $STATUS == 0 ]] && ok "a deb builds" || fail "deb failed ($STATUS): $(<"$TMP/out")"
has "of the release bundle" "flutter build linux --release"
deb=$APP/build/photolib_${version}_$arch.deb
[[ $(dpkg-deb -f "$deb" Depends 2>&1) == *libgtk-3-0*libmpv2*libsecret-1-0* ]] &&
  ok "it needs GTK, libmpv and libsecret" || fail "the deb's dependencies: $(dpkg-deb -f "$deb" Depends 2>&1)"
dpkg_root -i "$deb" && [[ $(installed photolib) == "$version" && -f $ROOT/opt/photolib/photolib &&
  $(readlink "$ROOT/usr/bin/photolib") == /opt/photolib/photolib &&
  -f $ROOT/usr/share/applications/org.photolib.photolib.desktop &&
  -f $ROOT/usr/share/metainfo/org.photolib.photolib.metainfo.xml ]] && diff -r "$HICOLOR" "$ROOT/usr/share/icons/hicolor" &&
  ok "it installs the bundle in /opt/photolib, started as photolib, with its desktop entry, metadata and icons" ||
  fail "the deb does not install: $(<"$TMP/dpkg") $(cd "$ROOT" && find . -path ./var -prune -o -print)"
release 9.9.9
package deb
dpkg_root -i "$APP/build/photolib_9.9.9_$arch.deb" && [[ $(installed photolib) == 9.9.9 ]] &&
  ok "the next release's deb upgrades it" || fail "the deb does not upgrade: $(<"$TMP/dpkg")"
dpkg_root -r photolib && [[ ! -e $ROOT/opt/photolib && ! -e $ROOT/usr/bin/photolib ]] &&
  ok "and removes, leaving nothing" || fail "the deb does not remove cleanly: $(<"$TMP/dpkg")"
release "$version"

VERSION=1 package photolibd
[[ $STATUS == 0 ]] && ok "photolibd's deb builds" || fail "photolibd failed ($STATUS): $(<"$TMP/out")"
has "of a release build" "cargo build --release --locked -p photolib-server --bin photolibd"
deb=$TMP/target/photolibd_${version}_$arch.deb
[[ $(dpkg-deb -f "$deb" Depends 2>&1) == *postgresql*libvips42*ffmpeg*libimage-exiftool-perl* ]] &&
  ok "it needs PostgreSQL's programs, libvips, FFmpeg and ExifTool" ||
  fail "photolibd's dependencies: $(dpkg-deb -f "$deb" Depends 2>&1)"
dpkg_root -i "$deb" && [[ -f $ROOT/usr/bin/photolibd && -f $ROOT/etc/photolib/photolibd.yaml ]] &&
  cmp -s "$ROOT/lib/systemd/system/photolibd.service" deploy/debian/photolibd.service &&
  ok "it installs photolibd, its service and its configuration" || fail "photolibd's deb: $(<"$TMP/dpkg")"
echo "# set by the administrator" >>"$ROOT/etc/photolib/photolibd.yaml"
release 9.9.9
VERSION=2 package photolibd
dpkg_root -i "$TMP/target/photolibd_9.9.9_$arch.deb" && [[ $(installed photolibd) == 9.9.9 &&
  $(<"$ROOT/usr/bin/photolibd") == "photolibd 2" ]] && grep -q "set by the administrator" "$ROOT/etc/photolib/photolibd.yaml" &&
  ok "the next release upgrades photolibd and keeps the administrator's configuration" ||
  fail "photolibd's deb does not upgrade: $(<"$TMP/dpkg")"
release "$version"

# --- the decisions, as the owner kept them (photolib-design#553)
ADR=docs/adr/0154-desktop-open-with-packages-keyring.md
assert_prose "$ADR" '\* \*\*Status\*\*: Accepted — 2026-10-21\. The owner kept every decision [^*]*photolib-design#553' \
  "is Accepted, recording the owner's answers (#553)"
assert_matches docs/adr/README.md '\(0154-desktop-open-with-packages-keyring\.md\) \| [^|]* \| Accepted \(owner confirmed' \
  "the index lists ADR-0154 as Accepted"
assert_prose "$ADR" 'keyring that appears later[^.]*M1-24 moves the keys into it' "M1-24 moves the keys to a later keyring"
assert_matches app/windows/packaging/AppxManifest.xml 'Publisher="CN=Photolib"' \
  "the MSIX keeps its placeholder publisher until M10-04 signs it"
check "no package makes Photolib a default handler" \
  bash -c "! grep -rqE 'mimeapps\.list|xdg-mime default|<string>Owner</string>' tools/package.sh app/linux app/macos/Runner"

# --- packaging and distribution (M10-04), as the owner kept it (photolib-design#695)
ADR=docs/adr/0249-packaging-and-distribution.md
assert_prose "$ADR" '\* \*\*Status\*\*: Accepted — 2026-10-23\. The owner kept every decision [^*]*photolib-design#695' \
  "is Accepted, recording the owner's answers (#695)"
assert_matches docs/adr/README.md '\(0249-packaging-and-distribution\.md\) \| [^|]* \| Accepted \(owner confirmed' \
  "the index lists ADR-0249 as Accepted"
for doc in "$ADR" docs/dev/releasing.md; do
  assert_prose "$doc" 'names and identifiers[^.]*placeholders[^.]*name is final' \
    "package names and identifiers are placeholders until the name is final"
done

finish
