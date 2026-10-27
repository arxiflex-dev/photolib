# Developer guide

## Development environment

Start with `just bootstrap`; the
[README](https://github.com/arxiflex-dev/photolib/blob/main/README.md#development-environment) covers prerequisites,
endpoints, seed data and recipes. [ADR-0018](../adr/0018-dev-s3-store.md) records the dev-store choice.

## Checking your work

Run `bash tools/check.sh`: it is the only check before a merge, and CI runs it again after check-in. See
[AGENTS.md](https://github.com/arxiflex-dev/photolib/blob/main/AGENTS.md) for checks, conventions, the PR workflow and
commit rules. [Lint rules](lint.md) lists every language's rules and how the baseline of their
findings shrinks. The [pre-queue backtest](prequeue-backtest.md) replays `tools/prequeue.sh` against the red
merge-queue runs of 2026-10-25.

## Protobuf and generated code

Follow the [protobuf style guide](protobuf-style-guide.md) in `proto/`.
The [tooling guide](https://github.com/arxiflex-dev/photolib/blob/main/tools/README.md#generated-files) documents
`tools/codegen.sh`, pinned plugins and drift checks; regenerate and commit outputs with each `.proto` change.
Toolchain decisions are in
[ADR-0019](../adr/0019-protobuf-toolchain.md).

## The HTTP API

photolibd serves Connect RPC: JSON or binary protobuf over HTTP POST, so `curl` works. The services of
`photolib.api.v1` are described for third parties in one generated [OpenAPI 3.1 document](api/photolib.openapi.yaml).
Errors carry a code and a `photolib.api.v1.ErrorDetail`, never a message; clients translate them. Call
`GetServerInfo` first and check its capabilities. The decisions are in [ADR-0027](../adr/0027-connect-rpc.md).

## Database migrations

Schema changes are SQL files in `server/migrations/`, and rewrites of existing rows are data migrations; the rules
(released means merged, numbering, expand and contract, pre-scans before new constraints), the test cluster and the
upgrade-path harness with its fixtures are in [Database migrations](migrations.md). A release follows the
[release checklist](releasing.md).

## API clients

The app reaches servers through `app/packages/photolib_api`. `NetworkConfig` is a server's one network
configuration (addresses, private CA, client certificate, pinned self-signed certificate, proxy, headers), and
`Server` sends API calls (pass `server.rpc` to a generated `…ServiceApi`), media and uploads through the one client
built from it; `MediaProxy` serves players on `127.0.0.1`. Only a `CallError` that `logsOut` may end a session. The
viewer's client is `viewer/src/api.ts`, with the same rule. The Dart tests run against a stand-in reverse proxy with a
private CA and mutual TLS that `openssl` makes for each run (`flutter test` in the package) and in browsers
(`bash tools/check.sh web`); `npm test` in `viewer/` runs the TypeScript ones. The decisions are in
[ADR-0032](../adr/0032-one-network-stack.md), and what administrators see in
[Reaching photolibd from the apps](../admin/clients.md).

## Synthetic libraries

Use [tools/synthlib](https://github.com/arxiflex-dev/photolib/blob/main/tools/synthlib/README.md)
for reproducible large-library performance and client tests.

## Performance budgets

[Performance budgets](performance.md) covers `tools/perf/run.sh`, its targets, the instruction counts, the regression
rule and the dashboard.

## Flaky tests

[Flaky tests](flaky-tests.md) covers `tools/repeat.sh`, which repeats tests with every retry off, the causes found so
far and the detection runs.

## The kernel

The [kernel guide](https://github.com/arxiflex-dev/photolib/blob/main/kernel/README.md)
documents the pure Rust API, C ABI, WASM module and shared Rust/Dart conformance vectors.
`bash tools/check.sh web` runs the vectors in Chrome, initially fetching the WASM target and pinned `wasm-bindgen`.

Building the app needs no Rust where a release is pinned: the build hook of `app/packages/photolib_kernel` bundles the
prebuilt kernel for each target from the release pinned in its `prebuilt.json`, and fails the build when a library's
SHA-256 differs. With none pinned (a fresh checkout) it builds the target's library itself with `tools/kernel/build.py`
into `app/build/kernel/` (cargo from `PATH`, `~/.cargo/bin` or the pinned toolchain under `~/.rustup`), or fails with
the command that does. To run
the app on your own kernel changes, build them with `python3 tools/kernel/build.py --out <dir> <target>...` (Android
needs the NDK) and point the app at them in its `pubspec.yaml` with
`hooks: user_defines: photolib_kernel: artifacts: <dir>`. `bash tools/kernel/probe.sh <dir> <apk|ios|macos|windows|linux>`
checks that `flutter build` bundles such a set without Rust. To release, set the version in `kernel/ffi/Cargo.toml` and
push the tag `kernel-v<version>`, then run the weekly workflow (`flutter-beta.yml`) by hand on it; once it has
published the release, copy its `prebuilt.json` into `app/packages/photolib_kernel/`. The decisions are in [ADR-0026](../adr/0026-kernel-prebuilt-libraries.md).

### Building the macOS app

Needs Xcode, Rust (rustup) and Homebrew's libvips. On a fresh checkout `cd app && flutter pub get && flutter build macos
--release` does everything ([ADR-0394](../adr/0394-macos-desktop-build.md)): the hook builds the kernel for arm64 and
x86_64 (a release build is universal), and the Runner's "Bundle libvips" build phase runs `tools/macos/bundle_vips.py`,
which copies Homebrew's libvips, its dependencies and its HEIF and JPEG XL modules into `Contents/Frameworks` and signs
the app ad hoc. Without Homebrew's libvips a release build fails and says `brew install vips`; a debug build warns, and
`SKIP_VIPS_BUNDLE=1` skips the step. Only the architectures whose Homebrew has libvips get it (`/opt/homebrew` for
arm64, `/usr/local` for x86_64); the build names a missing one, and Settings says so when libvips is not found. Xcode
and CocoaPods rewrite some tracked files on the first build (`Flutter/*.xcconfig`, the project, a `Podfile`): do not
commit them. Check a built app with `codesign -d --entitlements - <app>` (network.client), `otool -L` on
`Contents/Frameworks/libvips.42.dylib` (only `@loader_path` and system paths) and `swift
tools/macos/verify_hdr_orientation.swift` (HDR orientation).

The kernel's sizes and speeds per target against ADR-0004's thresholds are in the [go/no-go report](kernel-go-no-go.md);
the Rust kernel ships on all targets ([ADR-0029](../adr/0029-kernel-go-no-go.md)).

## On-device ML

`app/packages/photolib_ml` runs ONNX Runtime's official library through its C API with `dart:ffi` and onnxruntime-web
in browsers; `tools/ml/fetch.py` downloads the pinned runtimes and models. Its tests check every output against the
CPU's golden values. The [ML runtime report](ml-runtime.md) has the sizes, speeds and parity per target, and
[ADR-0050](../adr/0050-on-device-ml-runtime.md) the runtime, model format and accelerator policy. The models the
product ships are in photolib-models' `registry.json`, behind the licence gate of
[ADR-0064](../adr/0064-model-registry-and-licence-gate.md).
Devices index with `Runner` (the ML isolate, behind the golden check) and `MlIndexer` (resumable, held back by heat,
battery and the charging option), from inputs the kernel's `PrepareImage` makes as on the server
([ADR-0254](../adr/0254-on-device-ml-runner.md)).

## Photo editor rendering

The editor renders the preview with Flutter fragment shaders (`app/packages/photolib_editor`) and every export with
the kernel's CPU reference renderer, which the shaders must match; the [spike report](editor-rendering.md) has the
measurements and [ADR-0054](../adr/0054-editor-rendering.md) the decision. `flutter test` in the package runs the
parity suite and 12 MP exports, the reference's also with its tiles on every core (`--dart-define=megapixels=200` for
more, `workers=4` for a phone's pool), and `bash tools/check.sh web` runs them in Chrome.

An edit is stored as an `EditRecipe` per immutable version, and the derived data (renditions, covers, faces, text, the
edited download) follows the current one: [edit recipes](editor-recipes.md) and
[ADR-0391](../adr/0391-edit-recipes-and-version-history.md).

## Flutter app

The [Flutter page](flutter.md) covers running, pinning/upgrading, smoke tests, root-isolate, single-writer and i18n
checks, the pseudo-locales, the web fonts, the design system and its component gallery, and the local database. The
[translations page](translations.md) covers adding strings and translations. The
[web media path report](web-media-path.md) measures the web builds in Chrome and Firefox and gives the
Content-Security-Policy photolibd sends. The [HEIC and HEVC report](heic-without-system-decoder.md) lists where no
system decoder shows them, measures libheif-js in browsers (`node tools/heic/bench.mjs`) and proposes a way out per
cell ([ADR-0214](../adr/0214-heic-and-hevc-without-a-system-decoder.md)).

The [Android default-gallery matrix](android-gallery.md) records what each Android version and OEM lets the gallery
do, and how a phone fills its open cells ([ADR-0039](../adr/0039-android-default-gallery.md)).
[Android default gallery](android-default-gallery.md) is what answers those intents, its readiness gates and the Play
declaration ([ADR-0401](../adr/0401-android-default-gallery-integration.md)).

The [timeline spike report](timeline-spike.md) measures the timeline over a million assets per target;
[ADR-0040](../adr/0040-timeline-image-pipeline.md) chose the image pipeline from it.

## Media formats

[Format coverage](format-coverage.md) says how photolibd shows every format of the media corpus, how the tests prove
it, and what the corpus does not cover. [HDR handling](hdr.md) says how tone mapping and gain maps are proved and
reviewed by eye.

## Video editing

The [video engines report](video-engines.md) has what the prototype executors of one edit decision list did on each
platform, and what WebCodecs offers; the engines per platform are in [ADR-0043](../adr/0043-video-editing-engines.md).

## iOS backup

The [iOS backup spike report](ios-backup-spike.md) records what PhotoKit and iOS's background mechanisms give a
backup and how `bash tools/ios/photokit_probe.sh` measures them on a Mac and an iPhone; the strategy is
[ADR-0049](../adr/0049-ios-backup-strategy.md).

## Cryptography

Every encrypted or signed format is specified byte for byte in [Crypto suite v1](crypto-v1.md), with the choices
behind it in [ADR-0025](../adr/0025-crypto-suite-v1-specification.md). Its known-answer vectors are in
`kernel/testvectors/crypto/`; regenerate them with `python3 tools/cryptoref/vectors.py` after a change to the
reference, never by hand. A change to a released format is a new suite or format version, never an edit.

Private media plays without a full download: the kernel opens any run of an envelope's chunks, native players read
through `MediaProxy.decrypted` and the web through MSE or a Service Worker. Seeking and CPU per path are in the
[encrypted playback report](encrypted-playback.md), which `node tools/playback/bench.mjs` re-measures in the gate's
`web` part when a branch changes playback code; the decisions are in [ADR-0059](../adr/0059-encrypted-media-playback.md).

What a device keeps offline, under a storage policy and pins, and how the budget and the encryption at rest are
proven, is in [storage policies and offline pins](offline.md).

The [local store encryption spike](local-store-spike.md) measures what encrypting every local store costs on each
target and lists the secure hardware that binds a passcode on each platform; the cipher, the Argon2id floor and the
passcode policy are in [ADR-0090](../adr/0090-local-store-cipher-and-passcode-binding.md).

## Security

The [threat model](threat-model.md) maps every threat to its control and test, and ends with the security review
checklist for changes to authentication, cryptography, parsing, files, sharing and outbound connections. The
[supply chain](supply-chain.md) page covers audits, secret scanning, egress-blocked tests, SBOMs and signatures.

## Recording a decision

Follow the [ADR index](../adr/README.md) and ADR-0001.

## This documentation site

* The pages are Markdown files under `docs/`, built with [MkDocs](https://www.mkdocs.org/) and configured in
  `mkdocs.yml`. A page that is not linked from its section's `README.md` is unreachable, so link it there.
* `bash tools/docs.sh` builds the site into `site/`. The first run needs Python 3 and network access to install the
  pinned MkDocs into `.cache/`. The build is strict: a broken link or heading anchor fails it, and so the gate.
* `docs/css/extra.css` adds the site's own styles to the theme's: a table wider than the page scrolls sideways.
* A merge to `main` that changes `docs/` or `mkdocs.yml` publishes the site to GitHub Pages
  (`.github/workflows/docs.yml`; the repository setting Pages → Source must be *GitHub Actions*, else the site is
  built but not published). The choices are in [ADR-0017](../adr/0017-documentation-site.md).
