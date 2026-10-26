# Flutter app

The app in `app/` is one Flutter project for Android, iOS, macOS, Windows, Linux and the web. The shell has the
Library, Collections, Search and Settings tabs, go_router navigation, Riverpod state, design-token theming,
structured logging, an error boundary and local feature flags. It needs Android 11 (API 30), iOS 16 or
macOS 13. The choices are in [ADR-0023](../adr/0023-flutter-app-shell.md).

## Running it

`just run-app -d linux` (or `-d chrome`, `-d android`, …) runs the shell; it needs no server. Until a kernel release
is pinned, it bundles the kernel from `app/build/kernel/`, which `python3 tools/kernel/build.py --out app/build/kernel
<target>` writes (Rust; [ADR-0057](../adr/0057-encrypted-local-store.md)). On the web it needs
`bash tools/data/web.sh app/web`, `bash tools/kernel/wasm.sh app/web/kernel` and `bash tools/hls/web.sh app/web` (hls.js,
loaded only when a video plays) first, for the local store (below).
On Linux the store's keystore is the Secret Service (gnome-keyring, KWallet, KeePassXC), else a passphrase
(ADR-0154); a store whose keys the Secret Service holds does not open while it is away, and the library says so.
Feature flags are compile-time: `just run-app --dart-define=PHOTOLIB_FLAGS=diagnostics` turns the `diagnostics` flag
on, and `-name` turns a flag off. Test builds set it: Settings then shows the log and the timeline benchmark, whose
JSON it copies.
The Android project has two flavours, `play` and `libre`; only `libre` is free of proprietary dependencies, and
`tools/scan_libre.py` checks it in the weekly CI run.

## The pinned Flutter version

`app/.fvmrc` is the single place that names the Flutter version. [FVM](https://fvm.app/) reads it, the CI composite
action `.github/actions/flutter` installs exactly that version, and the `dart` part of `bash tools/check.sh` fails when
the installed Flutter differs. Renovate does not touch the pin.

**macOS keeps Impeller** ([ADR-0252](../adr/0252-macos-keeps-impeller.md)), though the pinned engine's back-buffer
cache can hand it a surface of the wrong size when the app comes back to the foreground, and the raster thread crashes
([flutter/flutter#185394](https://github.com/flutter/flutter/issues/185394)); the
[release notes](../user/release-notes.md) list it as a known issue. `tools/tests/test_macos_impeller.sh` names the pin
and whether it carries the fix, [flutter/flutter#192522](https://github.com/flutter/flutter/pull/192522), and fails
when the pin moves until its record (the pin, the fix, the upstream status) follows. A pin with the fix needs the macOS
smoke (hide and show the window 20 times, a 360° video plays) and the known issue dropped.

## Upgrading Flutter

1. Move the version in `app/.fvmrc` and nothing else that is unrelated, in a pull request that uses the
   [Flutter upgrade template](https://github.com/arxiflex-dev/photolib/blob/main/.github/PULL_REQUEST_TEMPLATE/flutter-upgrade.md).
2. The weekly workflow (`flutter-beta.yml`) builds, tests and smoke-tests the app on the beta channel, so a breaking
   change is known before the stable release; run it by hand (`workflow_dispatch`) when needed.
3. Tick every gate in the template with the evidence beside it: all test layers, performance within 10 %, goldens
   (panorama, video, HDR, text), low-end Android devices, and the renderer matrix.
4. The gate's `commits` part (`tools/flutter_upgrade_gate.py`) fails the branch while any gate is unticked in the
   description it is given as `PR_BODY`.

The device-lab, panorama, video and HDR gates cannot run in CI yet; a person ticks them until the performance harness
(M0-27), the synthetic library (M0-26) and the media pipelines (M1-13, M1-14) exist.

## Checks specific to the app

* **Smoke test.** `app/integration_test/app_test.dart` launches the real app, walks the four tabs and runs the local
  database's conformance probe.
  `bash tools/smoke.sh <target>` runs it on one target; the weekly workflow's `smoke` jobs run it on all six (Linux,
  web, an Android emulator, an iOS simulator, macOS and Windows) twice a day on `main`, not on pull requests, to save
  Actions minutes. Before checking in a change under `app/`, run it locally, in good faith, on every target your
  machine can run. An emulator that does not boot is retried once, on its system image fetched again; a smoke test
  that fails on a booted one is not.
* **HDR probe.** `app/integration_test/hdr_probe.dart` measures the native HDR leaf of
  [ADR-0060](../adr/0060-hdr-native-leaf-views.md): in `app/`, run `flutter drive --profile
  --driver=test_driver/integration_test.dart --target=integration_test/hdr_probe.dart -d <device>` (add `--flavor
  play` on Android, prefix `xvfb-run -a` on a headless Linux). It prints an `HDR {json}` line per sample and writes them
  to `build/integration_response_data.json`. Samples go in `hdr-probe/` under the app's support directory (on Android
  its external files directory, which `adb push` reaches), else it generates a 12 MP still.
* **Playback probe.** `app/integration_test/playback_probe.dart` plays a twin of every corpus video and motion photo
  with the app's players ([ADR-0112](../adr/0112-video-and-motion-photo-playback.md)); `bash tools/video/app_play.sh`
  runs it on this desktop, and the gate's `dart` part on Linux.
* **Root-isolate lint.** `app/tool/root_isolate_lint.dart` rejects synchronous file I/O (`readAsBytesSync` and the
  like), blocking `sleep` and native or database imports (`dart:ffi`, `drift`, `sqlite3`) in `app/lib`;
  `app/test/tool/root_isolate_lint_test.dart` runs it over the real sources, so `flutter test` is the check. Work that
  belongs off the UI isolate goes to a data isolate or to the worker pool (`app/packages/photolib_workers`). A
  justified exception carries `// root-isolate-ok: <reason>` on its line or the line above.
* **Single writer.** `app/tool/single_writer_lint.dart`, run by `flutter test`, fails when a second Flutter engine or
  database writer appears: native code starting an engine or opening a database, Dart code opening one outside
  `photolib_data`, or a package bringing either.
* **i18n lint.** `app/tool/i18n_lint.dart` rejects a literal with letters where the UI shows it (a `…Text` widget's
  first argument, `label:`, `tooltip:`, `title:`, `message:` and the like) and physical directions (`left:`,
  `EdgeInsets.fromLTRB`, `Alignment.centerRight`, `TextAlign.left`, a fixed `TextDirection`); `flutter test` runs it
  over `app/lib`. A justified exception carries `// i18n-ok: <reason>`.
* **Paint lint.** `app/tool/paint_lint.dart`, run by `flutter test` over `app/lib` and the packages' `lib/`, rejects a
  static `Paint` and one changed after it is made (`_paint..color = …`): a painter makes a paint per purpose, as an
  image draws at its paint's alpha (photolib-design#462).
* **Localisation.** Strings are ICU messages in `app/lib/l10n/app_en.arb` (see [translations](translations.md)).
  `dart run tool/pseudo_locales.dart` in `app/` derives the pseudo-locales `app_en_XA.arb` (accented, 40 % longer, in
  brackets) and `app_ar_XB.arb` (marked right to left); the Arabic `app_ar.arb` is also the base gen-l10n needs.
  The `pseudoLocales` flag offers them, picked like any language by the device locale. Dates, numbers and file sizes
  go through `Formats` (`app/lib/l10n/formats.dart`), whose `dateLocale` lets dates follow another locale.
* **Pseudo-locale pages.** `app/test/pages_test.dart` checks every page in `en-XA` and `ar-XB` against the goldens in
  `app/test/goldens/` (refresh them with `flutter test --update-goldens test/pages_test.dart` and review the images)
  and Material's accessibility guidelines; `app/test/text_scale_test.dart` fails when text is clipped at 200 %.
* **Web fonts.** `app/web/flutter_bootstrap.js` loads CanvasKit from the build and fallback fonts from `fonts/` on the
  app's origin, and the app bundles Roboto (`app/assets/fonts/`), so the web app fetches no font from a CDN. Nothing
  serves `fonts/` yet, so CJK, Arabic, Hebrew and Indic text shows boxes on the web until photolibd serves the Noto
  fallbacks.
* **Web builds.** `tools/web_requests.py` builds the app with `--wasm` and opens it in Chrome (dart2wasm) and Firefox
  (dart2js) under photolibd's Content-Security-Policy, after a probe of the media path; it fails on any violation of
  the policy, a font from another origin included ([web media path report](web-media-path.md)).

## The design system

`app/lib/ui/` is the design system ([ADR-0037](../adr/0037-design-system.md)): Material 3 components themed by
`appTheme` (light, dark, high contrast) and design tokens, plus what Material lacks. `Motion` makes every animation and
page transition instant under reduce motion. `Commands` runs labelled actions from their shortcuts, lists them on `?`
and in the Ctrl/Cmd+K palette. `SelectionBar` replaces the app bar while items are selected. `MediaGrid` pinches to
zoom and selects with a long press and drag, and `SwipeToDismiss` closes a full-screen page; both have single-pointer
and keyboard alternatives.
`just run-app -t lib/gallery.dart` runs the component gallery, which shows every component; add new ones to it.
`app/test/gallery_test.dart` checks it against goldens in light and dark, `en-XA` and `ar-XB` (refresh with
`flutter test --update-goldens test/gallery_test.dart` and review the images) and the accessibility guidelines, and
`text_scale_test.dart` at 200 % text.

## The local database

`app/packages/photolib_data` is the local store: the replica, drift on SQLite3MultipleCiphers on every target,
written only by one data isolate per process (in browsers by a worker of its own, on OPFS or else IndexedDB) and
reached from the UI and background isolates as its clients. The conventions and the pre-migration backup are in
[ADR-0031](../adr/0031-local-replica.md), the encryption in [ADR-0057](../adr/0057-encrypted-local-store.md).

* `Vault` is the key provider: `unlock` takes the device data key out of the lockbox with the keystore's key, `lock`
  closes every database and zeroizes every key, `erase` deletes the lockbox and the keystore keys (crypto-erase).
  `openReplica` keys each database with its page key and re-keys a plaintext one of an earlier build; `write` and
  `read` keep caches, offline copies and temporary files as PLB envelopes in class C, or B (readable while locked).
  `app/tool/single_writer_lint.dart` fails on a store opened outside the vault or without its key.
* The forensic tests store a marker library, lock and search every byte of the storage: `test/native_test.dart`,
  `test/web_test.dart` and the smoke test (`markerHits`).

* To change the schema, edit `lib/src/replica.drift` and bump `schemaVersion`, then in that folder run
  `dart run drift_dev make-migrations` and `dart run build_runner build --force-jit`, write the step in
  `Replica.migrate` and commit what they generate. `test/migration_test.dart` migrates every dumped schema to the
  current one and fails on a new table that is not synced (a `txid` column), device-only (`deviceTables`, kept by a
  failed migration) or rebuilt; the gate regenerates the code and fails when the committed one is stale.
* `lib/testing.dart` is the conformance probe the VM tests, the browser tests (`bash tools/check.sh web`) and the smoke
  test on six targets all run. Web builds need `bash tools/data/web.sh app/web` for `sqlite3mc.wasm` and the
  database, data, metadata and hash workers.
* Extensions never open the replica; they append to journals that `mergeJournal` applies.
* Desktop folders (`addFolder`, `media_source`) are indexed by `FolderIndexer` and watched by `FolderWatcher`, which
  the data isolate runs for every folder; identity, offline drives and polling are in
  [ADR-0042](../adr/0042-desktop-folder-sources.md), the ignore rules in `testdata/photolibignore.json`. The app adds
  them with `folderPickerProvider` and lists `folderSummary` in Settings (`lib/features/folders/`,
  [ADR-0071](../adr/0071-desktop-folders-in-the-app.md)).
* `MetadataExtractor` fills in what the indexed files say, newest and visible first, in the data isolate with the kernel
  on worker isolates, and resumes after a restart ([ADR-0072](../adr/0072-device-metadata-extraction.md)).
* In Chromium the same `FolderIndexer` scans folders through File System Access (`browser_folders.dart`, `FolderFiles`):
  handles live in IndexedDB, the page scans on open, on add and when shown again, and the app picks with
  `browserFoldersProvider` ([ADR-0082](../adr/0082-web-folders.md)); `test/web_test.dart` drives it on OPFS
  directories, 10,000 images included.

## Setting up Flutter on a machine

Install the version in `app/.fvmrc` (a Flutter SDK archive, or `fvm install` from `app/`). A mount that forbids
executing files, as some dev containers use for the home directory, cannot run the Linux desktop or Android builds;
install the SDKs and set `GRADLE_USER_HOME` outside it. The Linux desktop build plays video with the system's libmpv
(Debian and Ubuntu: `libmpv-dev`); the Windows build with the LGPL one `bash tools/video/libmpv.sh` builds, taken from
`app/build/libmpv/` or its release by the SHA-256 `app/windows/libmpv.json` pins ([ADR-0229](../adr/0229-windows-libmpv.md)).
