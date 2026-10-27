# tools/

Checks, generators, dev tools, [performance harness](../docs/dev/performance.md) (`perf/`) and `playback/` benchmark.

## Architecture

Scripts wrap toolchains or stdlib-only Python. Only `.github/workflows/ci.yml` runs, on the branches Mergify's merge
queue pushes (`dev` plus the queued pull requests), never on a pull request or another push: the gate, split by
`CHECK_STEPS` over twenty machines, one `gate` job for the queue; `cancel-queue-runs.yml`, `post-merge-builds.yml` aside.

## Contents

* `check.sh`: the [quality gate](../AGENTS.md#the-quality-gate), with `*_licenses.py`, `cargo deny`, [`lint/`](../docs/dev/lint.md) (ratchet, `clock.py`).
* `tests/`: per-concern `test_*.sh`; `lib.sh` assertions, pattern/description tables (`assert_patterns`) and isolated stubs;
  `checklib.py` reporting, `miniyaml.py` YAML, `mdlint.py` Markdown; corpus schema/capture-time cases use `unittest.subTest`.
* `commitlint.sh`: the [commit rules](../AGENTS.md#commits); `dco.sh`: sign-offs; `repeat.sh`: [flaky-test guard](../docs/dev/flaky-tests.md);[`prequeue.sh`](../AGENTS.md#the-quality-gate).
* `docs.sh`: [site builder](../docs/dev/README.md#this-documentation-site), pinned by `docs-requirements.txt`, for gate/publishing.
* `scan_libre.py`: Gradle listings, `pubspec.lock`, APKs free of Google/Huawei services (weekly `libre-android` job).
* `dev/`: `compose.yaml`, Garage/Caddy configs, `bootstrap.sh` and the stdlib `seed.py` uploader, wrapped by `justfile`.
* `buf.sh`, `squawk.sh`, `garage.sh`, `postgres.sh`: pinned releases cached per user (`PHOTOLIB_TOOLS_CACHE`) outside
  the checkout, the first two via `npm_tool.sh` unless on `PATH`, again if broken. `migrations.sh`: squawk, rules for
  released migrations/fixtures on `origin/dev`, `--renumber` after a rebase; `proto_breaking.sh` needs history/tags.
* `connect_conformance.sh <dir>`: official Connect suite for the crate's `connect-conformance.yaml`, in the rust gate.
  It, `codegen.sh`, `promtool.sh`, `proxies.sh`, `video/ffmpeg.sh` (LGPL FFmpeg; `--libs` for Firefox in `video/play.mjs`)
  and `ml/fetch.py` (ONNX Runtime, models of `ml/artefacts.json`) cache pinned tools via `fetch_release.sh` (SHA-256).
* `android_sdk.sh <package>...`: Android SDK packages, fetched again if broken, for `.github/actions/android-sdk`.
* `smoke.sh`, then `package.sh` (AppImage, DMG, MSIX), `flutter_upgrade_gate.py` (gate `commits` part), `web_requests.py`
  (`dart` part: web builds in Chrome and Firefox under photolibd's CSP, after `web_probe/`): [Flutter checks](../docs/dev/flutter.md).
* `synthlib/`: [seeded test libraries](synthlib/README.md); `timeline_bench.py` times the [timeline](../docs/dev/timeline-spike.md).
* `ios/photokit_probe.sh`, `ios/probe.py`: measure the [iOS backup spike](../docs/dev/ios-backup-spike.md) on a Mac.
* `cryptoref/`: stdlib [crypto v1 reference](../docs/dev/crypto-v1.md); `prims.py` and `opaque.py` check `standards.json`.
  `python3 tools/cryptoref/vectors.py` generates `kernel/testvectors/crypto/` from `formats.py`; `--check` in the gate,
  `--slow` for real-size Argon2id. Not constant-time: never use real keys.
* `kernel/build.py`, `kernel/probe.sh`, `page_size.py`: [11 native builds](../docs/dev/README.md#the-kernel), SHA-256 pins,
  Rust-free Flutter builds and Android 16 KB pages. `kernel/wasm.sh <dir>`: `kernel/wasm` as one ES module, 1 MB
  brotli at most (`kernel/budget.mjs`); `kernel/fuzz.sh`: nightly cargo-fuzz beside the gate, finds to `testdata/fuzz/`.
* `data/web.sh <dir>`: the store's three workers and `sqlite3mc.wasm` (hash-checked, cached like buf) for browsers.
* `oidc/signin.py`: the browser of the server's ignored live OIDC test (Keycloak, Authelia); `--record`: `testdata/oidc/`.
* `android/gallery_probe.sh [package]`: a phone's cells of the [Android gallery matrix](../docs/dev/android-gallery.md).
* `offline.sh` (the gate's air-gapped test runs), `sbom.py`, `release.sh` (signed SBOMs): [supply chain](../docs/dev/supply-chain.md).

## Generated files

Never hand-edit generated files. After a `.proto` change (API, contracts and code generation):

```sh
bash tools/codegen.sh install   # once per pin (a no-op after; plugins cached like buf): needs cargo, dart, npm and curl
bash tools/codegen.sh           # regenerate Rust, Dart, TypeScript and OpenAPI (docs/dev/api/); commit the result
bash tools/codegen.sh --check   # fail on drift; the gate's `proto` part runs `install` and this
```

The stdlib-only `corpus/` catalogs produce `testdata/corpus/`: `python3 tools/corpus/build.py` regenerates it (commit
the result), `--check` compares bytes, and `corpus/validate.py` checks schema, files and coverage. The gate runs both
through `tests/test_corpus.sh`, then decodes every decodable file with the Pillow of `corpus/decode-requirements.txt`
in a venv (network on first use) in `${PHOTOLIB_CACHE:-${TMPDIR:-/var/tmp}/photolib-<uid>}`, beside a noexec checkout.
`heic/twins.py` makes decodable twins of its HEIC files for `heic/bench.mjs` to measure [libheif-js](../docs/dev/heic-without-system-decoder.md).

## Design

* Quality and testing
