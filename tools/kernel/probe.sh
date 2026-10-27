#!/usr/bin/env bash
# Proves that `flutter build` bundles the prebuilt kernel on a machine without Rust: creates a throwaway app that
# depends on app/packages/photolib_kernel, points its build hook at <artifacts> (a tools/kernel/build.py output),
# builds it and finds the kernel in the product. An APK must hold all three ABIs and pass tools/page_size.py, a macOS
# app a universal kernel; a desktop build also runs the conformance vectors and the kernel's benchmark through the
# bundled kernel.
#
#   bash tools/kernel/probe.sh <artifacts> <apk | ios [--simulator] | macos | windows | linux> [flutter build flags]
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
ARTIFACTS=$(cd "$1" && pwd)
TARGET=$2
shift
if command -v cargo || command -v rustc; then
  echo "probe.sh: Rust is on PATH, but this probe must build without it" >&2
  exit 1
fi
native() { if command -v cygpath >/dev/null; then cygpath -m "$1"; else echo "$1"; fi; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
APP=$TMP/probe
flutter create --empty --project-name probe --platforms "${TARGET/apk/android}" "$APP" >/dev/null
cd "$APP"
flutter pub add "photolib_kernel:{path: $(native "$ROOT/app/packages/photolib_kernel")}" dev:test dev:crypto >/dev/null
printf 'hooks:\n  user_defines:\n    photolib_kernel:\n      artifacts: %s\n' "$(native "$ARTIFACTS")" >>pubspec.yaml

flutter build "$@"
if [[ $TARGET == apk ]]; then
  apk=build/app/outputs/flutter-apk/app-release.apk
  listing=$(unzip -l "$apk")
  for abi in arm64-v8a armeabi-v7a x86_64; do
    [[ $listing == *" lib/$abi/libphotolib_kernel_ffi.so"* ]] || { echo "probe.sh: no $abi kernel" >&2; exit 1; }
  done
  python3 "$ROOT/tools/page_size.py" "$apk"
else
  kernel=$(find build -type f -name '*photolib_kernel_ffi*' \( -path '*/release/bundle/*' -o -path '*/runner/Release/*' \
    -o -path '*/Products/Release/*.app/*' -o -path '*/Runner.app/*' \) -print -quit)
  [[ -n $kernel ]] || { echo "probe.sh: the $TARGET build holds no kernel" >&2; exit 1; }
  echo "probe.sh: bundled $kernel"
  [[ $TARGET != macos ]] || [[ $(lipo -archs "$kernel") == *arm64* && $(lipo -archs "$kernel") == *x86_64* ]]
fi
if [[ $TARGET =~ ^(linux|macos|windows)$ ]]; then
  mkdir -p test/vectors
  cp "$ROOT"/kernel/testvectors/*.json test/vectors/
  mkdir -p benchmark
  cp "$ROOT"/app/packages/photolib_kernel/test/{vectors_test,bench,cases}.dart test/
  cp "$ROOT"/app/packages/photolib_kernel/benchmark/kernel_bench_test.dart benchmark/
  flutter test --dart-define=vectors=test/vectors/ test/vectors_test.dart
  # Its speed is printed, not asserted: the budgets are tools/perf/measure.sh's (a hosted runner cannot measure them)
  flutter test --dart-define=vectors=test/vectors/ benchmark/kernel_bench_test.dart
fi
