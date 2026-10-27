# Agent and contributor conventions

Keep these contributor and agent conventions current when commands, folders or policies change. Each area has one
section, in a fixed order (`tools/tests/test_merge_union.sh`): add a note as new lines at the end of its area's
section, as a bullet where it has them, and a new area as a section before *Commits*. Change a line only when its
fact changes, and never re-wrap or move lines you keep, since this file merges as a union of lines (`.gitattributes`,
`tools/README.md` too): two items' additions both land without a conflict, but two edits of one line land twice,
which `tools/tests/check_union.py` fails on.

## The quality gate

```sh
bash tools/check.sh                      # the full gate, as the merge train runs it
bash tools/check.sh --since origin/dev  # an item's own gate: the parts its diff touches
```

Run before every commit. Without arguments every part runs, the independent ones `CHECK_JOBS` (default a quarter of the
cores, one to four) at a time, each part's output kept together (side by side, `web` waits until `dart` has resolved
the packages, generated their code and placed their `build/`; alone it does that itself), and the steps that measure
time (`budget`: the frame budgets of `photolib_data` and `photolib_workers`, in the VM and in browsers, a package's
tests tagged `alone` in its `dart_test.yaml`, run as `flutter test --tags alone -j 1` after the rest of its suite, then
perf's `run.sh`) alone after the rest; such a step
that fails is measured up to three times, `run.sh` each time only the series that failed the time before, which
`PERF_FAILED` carries with each attempt's value, and a pass on a later attempt is reported as flaky with its number.
`--since <rev>` runs only the parts the diff
`<rev>...HEAD` touches (then, alone, `tools/repeat.sh`: see Tests), by the `SINCE` table in `check.sh`, and says
which and why: repo and commits always; every part
(the full gate) for `proto/`, `kernel/`, `check.sh`, a lockfile, a toolchain pin or a path the table does not map; msrv
only in the full gate. `bash tools/check.sh <part>...` runs those parts. Each step prints its wall time when it ends;
the gate ends with the slowest steps and the total. The gate forbids core dumps: it and every step run with
`ulimit -c 0`, and a step a signal ends is reported by its signal (`was killed by SIG<name>`). A step that writes
nothing for 20 min (`CHECK_SILENCE` seconds) is killed with its process group and fails as `failed: <cmd>: no output
for 20 min (in <dir>)`, one that exits 124 (`timeout`'s status; `run.sh` when an app hung) as `failed: <cmd>: timed
out (in <dir>)`; neither runs again, and the rest still runs. The merge train's driver reads a failed step by
`failed: (.*) \(in .*\)` and takes a command ending in `run.sh` for timing alone: keep any why before ` (in `.
Existing parts require their toolchains: install missing tools, never skip checks.

| Part | Where | Checks |
|---|---|---|
| `repo` | `tools/tests/` | every `test_*.sh` (`test_outbound.sh`: the privacy manifest; `test_threat_model.sh`: the threat model); `test_secrets.sh` scans the history of `HEAD` with gitleaks and `.gitleaks.toml` (default rules minus the corpus' Live Photo UUIDs and the crypto vectors' hex keys); gitleaks on `PATH`, else the Docker image it pins |
| `commits` | a git checkout | `tools/commitlint.sh` and `tools/flutter_upgrade_gate.py` on `origin/dev..HEAD` (a moved Flutter pin needs the ticked checklist in `$PR_BODY`), and `tools/lint/ratchet.sh --against origin/dev` (the lint baseline grew only with a `lint-accept:` line); fails without `origin/dev` |
| `rust` | topmost `Cargo.toml`: `kernel/`, `server/`, `tools/synthlib/` | `bash tools/migrations.sh <root>/migrations` when present (squawk, released migrations unchanged against `origin/dev`), `cargo fmt --check`, then with `--locked` (a stale `Cargo.lock` fails) `tools/lint/ratchet.sh clippy <root>` (clippy against the lint baseline), `cargo machete` (no unused dependency), `cargo nextest run --no-fail-fast --success-output immediate` (each test a process of its own, side by side; tests that must run alone are `#[ignore]`d for perf's `run.sh`) and `cargo test --doc -- --show-output`, which nextest cannot run, through `tools/lint/panics.py` (egress blocked; `RUST_BACKTRACE=1`, a panic in a thread the test did not join fails it), `cargo deny --config <root>/deny.toml check`; in a workspace nested in a root (`kernel/fuzz`) only `cargo fmt --check` and `cargo deny`; libvips ≥ 8.15 for `server/` (`pkg-config`); `bash tools/connect_conformance.sh <dir>` for each crate with `connect-conformance.yaml` (official Connect suite; needs `curl` and first-run network) |
| `msrv` | the same Rust roots | `cargo +<rust-version> check --locked --workspace` with exactly the workspace's declared `rust-version`; full gate only |
| `dart` | every `pubspec.yaml` | Flutter matches `app/.fvmrc`; `flutter pub get --enforce-lockfile` in every part before any is formatted (a stale `pubspec.lock` fails, as a `Cargo.lock` does with `--locked`, and skips what would resolve that part again and rewrite the lock: its other checks, `app_play.sh`, the `web` part's tests and perf's `run.sh`, which resolve it the same way when run without the `dart` part; committed localizations that it regenerates differently (`l10n.yaml`) fail too; `dart format` reads a style an included package sets only once it resolves); with a `build.yaml` `dart run build_runner build --force-jit` and with an `l10n.yaml` `flutter gen-l10n` (each fails when the committed generated code changes), `dart format --output=none --set-exit-if-changed` in the language version of its pubspec's SDK bound (a nested package is formatted on its own), `tools/lint/ratchet.sh dart <dir>` (`flutter analyze` and dart_code_linter against the lint baseline), `python3 tools/dart_licenses.py <dir>`, `flutter test` (egress blocked; with the root-isolate, single-writer, i18n and paint lints), and for an app with `web/` `python3 tools/web_requests.py <dir>` (the WASM build in headless Chrome and the JS build in Firefox, under photolibd's CSP, must break no directive, log no error and pass the media probe in `tools/web_probe/`; needs Chrome and Firefox); the kernel binding test builds `kernel/ffi` with cargo; on Linux `bash tools/video/app_play.sh` (every corpus video and motion photo through the app's players, and every 360° twin projected at its golden frame, read off the X server with x11grab; needs `libmpv-dev` and `xvfb-run`) |
| `web` | `kernel/wasm`, `app/packages/photolib_{api,editor,ml,workers}`, `app/`, `server` | `dart test -p chrome -c dart2js -c dart2wasm test/web_vectors_test.dart` in `app/packages/photolib_kernel`, Chrome only for now (the owner, photolib-design#288, confirmed in photolib-design#303): it builds the module with `tools/kernel/wasm.sh` (needs `rustup` and `node`, and network on the first run), which fails over 1 MB brotli, and runs the vectors and the benchmark through it; `dart test -p chrome -p firefox -c dart2js -c dart2wasm test/web_test.dart test/sync_message_test.dart test/hash_url_test.dart` in `app/packages/photolib_data` (`-p safari` too on macOS; Firefox as `firefox` on `PATH` or `FIREFOX_EXECUTABLE`), the store on `sqlite3mc.wasm` from `tools/data/web.sh` (needs `curl`) and the kernel's module, and posters of corpus videos the pinned `tools/video/ffmpeg.sh` makes (Firefox decodes them with that release's libraries on Linux); the same in `app/packages/photolib_api`, the API client over fetch; in `app/packages/photolib_workers` with `-j 1` and no Safari, the worker pool hashing 2 GiB on Web Workers; in `app/packages/photolib_ml`, onnxruntime-web from `tools/ml/fetch.py` (needs `python3`, network on the first run) on wasm and, in Chrome through `tool/chrome_webgpu.sh` on Linux, WebGPU on SwiftShader; `flutter test --platform chrome [--wasm] test/web_test.dart` in `app/packages/photolib_editor`, the editor's shaders against the kernel's web build on CanvasKit and Skwasm (it compiles the shaders with the SDK's `impellerc` into the git-ignored `test/assets/`); the same in `app/` for `test/features/library/timeline/web_test.dart`, `test/core/log_web_test.dart`, `test/features/viewer/sphere_web_test.dart` and `test/features/viewer/hdr_web_test.dart`, the browser's thumbnail decoders in a worker, the log in IndexedDB across a reload, 360° videos at their golden frames and the HDR leaf's `<img>` (the panorama shader compiled into the git-ignored `assets/` beside it); `node tools/playback/bench.mjs`, only when the branch changes playback code (`PLAYBACK` in `check.sh`), seeks in a 2-hour encrypted video through the loopback proxy, MSE and a Service Worker in Chrome and Firefox, failing a median seek over 1 s ([report](docs/dev/encrypted-playback.md)); `node tools/download/test.mjs` saves downloads through `app/web/download.js` into Chrome's and Firefox's own downloads (2 GiB in Chrome, longer than 30 s, aborts leaving no file; ADR-0128); `node tools/video/play.mjs` plays what the server renders of every corpus video in Chrome and Firefox (ADR-0085); `python3 tools/timeline_bench.py chrome --wasm --check` holds the web timeline's frames over the 1M library to `timeline-scroll-web` (ADR-0385); `node tools/web_e2e/run.mjs` drives the web client against a real photolibd that serves it (`web_root`) in Chrome, Firefox and a throttled phone in Chrome's emulation, through Playwright (`tools/playwright.sh`), and in WebKit on macOS or with `WEB_E2E_WEBKIT=1`: set-up, upload by dialog and drop, timeline, viewer, video, downloads, reload, offline (ADR-0385); and `cargo test -p photolib-server --test passkeys -- --ignored` in `server/` adds a passkey through photolibd's relay page in Chrome with a virtual authenticator and signs in with it (needs `node`) |
| `proto` | every `buf.yaml` | `buf lint`, `buf format --diff --exit-code`, `bash tools/proto_breaking.sh <dir>` against the last `v*` tag, else `origin/dev`; with `proto/buf.gen.yaml`, `bash tools/codegen.sh install` (once per pin) and `--check`, which fails on stale generated code |
| `node` | any `package.json` (`viewer/`) | `npm ci --ignore-scripts --no-audit --no-fund`, `npm run typecheck`, `npm test` (`node:test`, egress blocked), `python3 tools/node_licenses.py <dir>`; CI uses the Node in `viewer/.nvmrc` |
| `docs` | `mkdocs.yml`, `docs/` | `bash tools/docs.sh`: strict MkDocs; broken links and anchors fail |
| `lint` | a git checkout | `tools/lint/ratchet.sh <linter> .` for shellcheck, ruff, eslint, swiftlint and ktlint (needs `java`), and on Linux `clang-tidy app/linux` (GTK headers, `flutter precache --linux`): each against the lint baseline, at the release `tools/lint/tool.sh` pins (fetched once; needs `curl`, `unzip`, `npm`); `tools/lint/clock.py` fails a test file that reads the clock when it is loaded (top level, `main`, `group`; PHO-235) |
| `perf` | `tools/perf/` | `bash tools/perf/instructions.sh`: Callgrind's instruction counts of the kernel's and the server's hot paths (`benches/instructions.rs`) on the branch and its merge base, failing over 10% more unless a `perf-accept: <reason>` line in `$PR_BODY` or a commit since the base says why (the table also to `$PERF_REPORT`; needs valgrind); `bash tools/perf/run.sh`: the [performance budgets](docs/dev/performance.md) of `budgets.json` on the synthlib fixtures (server idle RSS, app frame timing, scrubs and cold start; on Linux without a display under `xvfb-run` as `headless`, without a session bus in `tools/perf/keyring.sh`'s throwaway GNOME Keyring); needs the Linux desktop toolchain and PostgreSQL programs |

Egress blocked means through `tools/offline.sh` (Linux, needs `cc`): connections to anything but loopback, DNS and
name lookups fail, except in cargo, rustc and dart, so these suites pass air-gapped (the `web` part is not blocked).
The gate's prefetch fetches what they load first, one download at a time; under the block a fetcher downloads nothing
and names what is missing and the command that fetches it ([supply chain](docs/dev/supply-chain.md)).
Wire new parts/toolchains into the gate with a test. Rust, Dart and npm licence checks share `deny.toml` (ADR-0013).
See [tools/README.md](tools/README.md) for cached tool installation, code generation and corpus commands.
A step that fails after the gate was stopped while it ran, 5 s or more (the merge train's quiet mode SIGSTOPs agents'
gates for minutes and resumes their steps first), runs once more unless it hung or timed out, and the silence a step
is killed for leaves that time out; steps' output passes byte by byte, never kept back in `read -N`'s buffer
(photolib-design#648).
A step's silence counts only the time the gate ran: a stop of the gate (SIGSTOP, as agents' runs are frozen) is none
of it (photolib-design#659).
A RustSec advisory never fails the gate (the owner, photolib-design#799): `cargo deny check bans licenses sources`
fails it, but `check advisories` runs through `tools/advisories.py`, which ends with one
`WARN advisories: <id> <crate> <version> in <workspace>` line per finding; no `ignore` entry in `deny.toml` hides one
([supply chain](docs/dev/supply-chain.md)).
A step that is a test, or is flaky by nature (a browser, a server it starts, the network), and that no tool repeats
runs through `retried` in `check.sh`: the Connect conformance suite, the doc tests, the passkey test, `web_requests.py`,
`app_play.sh`, `tools/{download,video,playback}` and the viewer's `npm test`. `CHECK_RETRIES` (CI: 3) runs them again
up to that many times, a pass then is flaky, and one that hung or timed out is not run again. Build, lint, format,
`cargo deny`, nextest, Dart tests and the steps that measure time are not wrapped: they are deterministic or repeat.
A new step that is a test, or uses a browser, a server or the network, takes `retried`, with a case in
`tools/tests/test_check_retries.sh`. The Connect conformance script names the cases that failed and traces them.
`bash tools/prequeue.sh [--quick|--full|--list]` runs the checks that failed the merge queue before you ask for it:
commit subjects, the PR title with its ` (#N)`, lint counts, the repo tests, Dart and Rust steps; `--full` (7 minutes at
most, `PREQUEUE_BUDGET`) adds the CI lanes' own checks, a fresh clone, the tests of the touched packages in CI's
conditions and the PRs queued ahead. A step this machine cannot run prints `skip <name> (reason)`.
The dispatcher and the workers run `--full` and read every FAIL, warn and skip before `@mergifyio queue`; it does not
replace `bash tools/check.sh --since origin/dev`.
`INCOMPLETE` (exit 3) means the 420 s budget cut a step, which the Rust server tests do on a big diff: it is not a pass.
Run each step it names alone, `PREQUEUE_BUDGET=1800 PREQUEUE_ONLY='rust tests (4 cores)' bash tools/prequeue.sh --full`,
and paste that result with the `--full` line.
The tools that compare with `origin/dev` (`check.sh`, `prequeue.sh`, `migrations.sh`, `proto_breaking.sh`) take the remote
from `tools/remote.sh`: `$PHOTOLIB_REMOTE`, else the only remote (this repository's is `arxiflex-dev`), else `origin`.
`bash tools/e2e/server_client_smoke.sh` runs a throw-away photolibd with uploads, an external folder and (`WEB_DIR`)
browsers on its web client: [Run a server and connect the app](docs/dev/server-client.md); its step is in the `web` part.

## CI

CI never runs on pull requests: the gate is the only check before a merge, so anything CI could catch on Linux belongs
in it. [tools/README.md](tools/README.md) says what the workflows run after check-in, and that only the owner enables
them. Add no workflow file but `post-merge-builds.yml`: a new one would start enabled.
A downloaded tool is checked (SHA-256, version, or that it starts) and fetched once more before the build fails, from a
cache keyed by its version: `tools/npm_tool.sh`, `tools/fetch_release.sh`, `tools/codegen.sh install`, and for
Android SDK packages `.github/actions/android-sdk` with `tools/android_sdk.sh`.

`.github/workflows/flutter-beta.yml`, the weekly workflow, runs the costly jobs by hand and weekly, never on pull
requests: Flutter beta, the libre Android build, the `kernel-*` builds, `upgrade-large`, the upgrade-path harness
with a million assets, and `upload-large`, a 10 GB upload. Its `smoke` jobs run `bash tools/smoke.sh <target>` on
linux, web, android, ios, macos and windows (retrying only an Android emulator that does not boot) twice a day on
`main` instead, never by hand (photolib-design#294): before checking in a change under `app/`, run it
locally on every target your machine can run. A desktop's smoke run then builds its unsigned package,
`bash tools/package.sh <appimage|dmg|msix>` (ADR-0154). To publish the kernel's prebuilt libraries, push a
`kernel-v*` tag and run the workflow by hand on that tag; its `kernel-release` job publishes them with an SBOM and
`SHA256SUMS` signed keylessly by cosign (`tools/release.sh`, [supply chain](docs/dev/supply-chain.md)); outside CI it
signs only with a hardware-held key (`COSIGN_KEY=pkcs11:…`), never a personal identity.

[Flutter development](docs/dev/flutter.md) covers the shared pin installer, weekly beta run, smoke retry policy,
`app/tool/root_isolate_lint.dart`, `app/tool/i18n_lint.dart` (hard-coded UI strings, left/right layout) and
`app/tool/paint_lint.dart` (no static or changed `Paint`: one per purpose), all run by `flutter test`.
The design system is `app/lib/ui/` (ADR-0037): build on themed Material components, show every new component in
`app/lib/gallery.dart` and refresh its goldens with `flutter test --update-goldens test/gallery_test.dart`.
HDR stills and video show only through `HdrLeaf` (`app/lib/features/viewer/`, native leaves in the runners,
ADR-0060) and, for video, `video_player`'s platform view: only items whose facets hold `hdr` (extraction, ADR-0216),
only the item shown, unless `Settings.hdr` is off; `app/integration_test/hdr_probe.dart`, run with
`flutter drive --profile`, measures it; M1-14 does not wait for device numbers, which the test phase measures.
macOS keeps Impeller with a known foreground crash (flutter/flutter#185394, ADR-0252): moving `app/.fvmrc` fails
`tools/tests/test_macos_impeller.sh` until its record says whether the pin carries flutter/flutter#192522; with the
fix, run the macOS smoke and drop the known issue from `docs/user/release-notes.md`.
UI text lives only in `app/lib/l10n/app_en.arb` and its complete translations `app_<locale>.arb`, all launched
(`launchLocales`; machine-made, native speakers review them in the test phase; no translation platform), keys sorted;
`test/l10n_test.dart` fails on a missing message, placeholder or plural case. Change a string in all of them in one
pull request, then run `dart run tool/pseudo_locales.dart` and then `flutter gen-l10n` in `app/`. Refresh the
`en-XA`/`ar-XB` goldens with `flutter test --update-goldens test/pages_test.dart` and review the images. Other
user-facing text (server emails and errors, the viewer, store listings) gets every launched language the same way as
it is built; admin and developer docs stay English. See [docs/dev/translations.md](docs/dev/translations.md).
`renovate.json` groups dependency PRs on Mondays UTC, waits a week after releases, raises OSV vulnerability alerts and
auto-merges after `check` passes (schedule deferred in photolib-design#263; auto-merge chosen in
photolib-design#275); with no `check` on pull requests they wait unmerged (deferred in photolib-design#304).
Reference Actions by version tag; Renovate pins their digests.
Update `tools/tests/check_ci.py`, which pins the workflows' triggers and jobs, with workflow, Renovate or
`.gitleaks.toml` changes.
A `ListTile` on a padded page (Settings, the server pages) sets `contentPadding: EdgeInsets.zero` to start where its
headings and fields do; tests check it with `tileStarts` (`app/test/support/tiles.dart`).
`tools/package.sh` also builds `deb`, `photolibd`, `apk`, `aab` and `ipa`, signed only with a release's keys
(ADR-0249); [releasing](docs/dev/releasing.md) holds every channel's release-candidate dry run. Store listings are
`app/android/app/src/main/play/listings/` and the AppStream metainfo, in every launched language (`test_stores.sh`).
The app icon is photolib-design's `docs/brand/icon/`: `python3 app/tool/icons.py <that dir>` writes every platform's
files, never by hand (ADR-0312); `check_icons.py` checks their sizes and that no Flutter template icon is left.
The app shows `Settings.language` (`MaterialApp.locale`, ADR-0314), else the device's; a launched language is in
`launchLocales` (`app/lib/l10n/locales.dart`), `locales_config.xml` and `CFBundleLocalizations`
(`per_app_language_test.dart`).
* `.github/workflows/post-merge-builds.yml` builds the apps and the server on a push to `dev`, checks nothing, and keeps
  each target's unsigned artifact 14 days (`gh run list --workflow post-merge-builds.yml --branch dev --status success`,
  then `gh run download <id>`); `tools/tests/check_ci.py` pins its trigger, targets, artifacts and absence of checks.
* The one workflow that runs on a pull request is `.github/workflows/cancel-queue-runs.yml`: when a Mergify queue PR
  (`mergify/merge-queue/*`, this repository's) closes it cancels that branch's unfinished runs, as `ci.yml`'s
  concurrency group is per branch. Its `actions: write` token and filter are pinned by `tools/tests/check_ci.py`.
* `flutter build macos` builds the kernel itself when none is pinned and bundles Homebrew's libvips through the Runner's
  "Bundle libvips" phase (`tools/macos/bundle_vips.py`, `brew install vips`; ADR-0394, [docs/dev](docs/dev/README.md)).

## Crypto formats

`docs/dev/crypto-v1.md` is the normative spec of every encrypted or signed format (ADR-0025). The known-answer vectors
in `kernel/testvectors/crypto/` are generated: change `tools/cryptoref/` and run `python3 tools/cryptoref/vectors.py`
(`--check` is what the gate runs, `--slow` adds the real-size Argon2id). A released format never changes; a change is
a new suite or format version with its own vectors.
The recovery phrase is BIP-39's English encoding (`kernel/src/bip39-english.txt`, whose SHA-256 the kernel and
`tools/cryptoref` pin); `kernel/testvectors/crypto/recovery.json` holds its vectors.

## Layout

`proto/ kernel/ server/ app/ viewer/ deploy/ docs/ tools/ testdata/` each have an architecture README.
Other top-level folders require an ADR (`tools/tests/test_layout.sh`).

## Documentation

Site commands and publishing are in the [developer guide](docs/dev/README.md#this-documentation-site).
For a decision, copy `docs/adr/template.md` to the next number free here and in the design repository,
set *Proposed* and add the matching index row;
`tools/tests/test_adr.sh` checks completeness and status.
Design documents and the design's ADRs live only in the design repository: link them by GitHub URL, never copy
them here (ADR-0017).
Scenario ADRs await the owner's sign-off row by row, and the items they bind land no behaviour they leave open:
ADR-0200 (a photo on the device and the server) binds M2-18, M2-22, M2-24, M2-36 and M3-21; ADR-0201 (sources)
binds M1-03, M2-27, M2-28 and M3-23; ADR-0202 (albums across custody) binds M3-01, M3-02, M3-20, M6-08, M6-09,
M4-06, M9-01 and M9-02. `tools/tests/test_scenario_adrs.sh` checks each catalogue (sources, invariants, 120+ rows
from named dimensions, every row in a numbered proposal).
Images an ADR cites (screenshots cropped to what they show, mock-ups) live in `docs/adr/assets/<number>/`, PNG or JPEG
of at most 1280 px and 300 KB, each with its source; ADR-0215's survey and mock-ups are `test_tile_marks_adr.sh`'s.
The owner kept every proposal of ADR-0200 (photolib-design#576): its items build its rows and merge no duplicates.
ADR-0201 is accepted but for proposal 6, the OAuth model the owner keeps open: no connector lands it unanswered.
ADR-0202 is accepted as proposed (photolib-design#581): albums never merge near-duplicates on their own, as a
confirmed strong match becomes a `duplicate` stack and M5-14's review picks the best copy.
The administrator guides hold design 15 §12's runbooks (`docs/admin/runbooks.md`), object stores (`storage.md`) and
the admin-succession kit (`backups.md`); `test_admin_guides.sh` fails on a `photolibd` command in `docs/admin` that
`main.rs` lacks, or a store key in `storage.md` that `config.rs` refuses. A change to a command, a setting or the
compose bundle updates the runbooks in the same pull request.
`test_adr.sh` also fails on a cited ADR that is not in `docs/adr` (ADR-0001 to ADR-0016 are the design repository's).

## Development environment

Start with `just bootstrap`; [README.md](README.md#development-environment) owns prerequisites, endpoints and recipes.
The stack is in `tools/dev/`; `tools/dev/.env` holds generated secrets and is never committed.
Keep secrets out of compose/config files.
`test_devstack.sh` needs Docker Compose but no daemon; stubbed bootstrap/hooks/justfile tests need no `just` or
`pre-commit`. `.devcontainer.json` installs Docker-in-Docker, Rust, Node and PostgreSQL 17 programs for the database
tests (no cluster of its own), not Flutter.

## Kernel

Follow [kernel/README.md](kernel/README.md) for purity, conformance vectors, parser checks, bindings and builds.
Tests needing I/O explicitly allow the purity lints. Every target denies `unsafe` but `kernel/ffi` and the fuzz test's
counting allocator; a new exception is named in threat model T13 (`test_threat_model.sh`). Add typed cases for every
function in `kernel/tests/vectors.rs`, regenerate, rerun and commit their JSON. A `ReadMetadata` parser change must
pass the corpus and fuzz checks there.

* Keys cross the ABI only as handles into a `Keyring` (`keyring()` in both Dart bindings; `close()` zeroizes them);
  no response holds key bytes but a database page key from `DatabaseKey` (ADR-0057).
* `ResolveCaptureTime` ([ADR-0051](docs/adr/0051-capture-time-resolver.md)) must match every golden capture time of
  the corpus but those `kernel/tests/corpus.rs` lists in `UNMATCHED`; a file-name rule changes only with its case in
  `kernel/tests/vectors/capture_time.rs`.
* `dart test` finds Chrome as `google-chrome` on `PATH`, or through `CHROME_EXECUTABLE`; in a container without user
  namespaces it needs a wrapper that adds `--no-sandbox`.
* Apps get the kernel prebuilt (ADR-0026): `app/packages/photolib_kernel/hook/build.dart` bundles the library its
  `prebuilt.json` pins and fails on a SHA-256 mismatch; it never runs cargo, and the package's own tests switch it off
  (`bundle: false`). `python3 tools/kernel/build.py --out <dir> <target>...` builds a set an app uses through
  `hooks: user_defines: photolib_kernel: artifacts: <dir>`; `bash tools/kernel/probe.sh <dir> <flutter build args>`
  runs without Rust on `PATH` (on a `noexec` home, `apk` needs an exec-capable `GRADLE_USER_HOME`). Every Android
  library must pass `python3 tools/page_size.py`.
* Measure [budgets](docs/dev/kernel-go-no-go.md#how-it-is-measured) with the documented fastest-sample method, never
  averages. Update that report when budgets move.
* Coverage-guided fuzzing (ADR-0036) runs outside the gate: `bash tools/kernel/fuzz.sh [seconds per target]` (nightly,
  cargo-fuzz, one core, memory capped) minimizes each find into `testdata/fuzz/<target>/`; `kernel/tests/fuzz.rs`
  replays them through the same targets (`kernel/fuzz/src/lib.rs`). A find is a bug: fix it, never delete the file.
* A kernel panic fails only its call (`CALL_ERROR_CODE_PANIC`, kernel.panic): every `kernel/ffi` entry point catches
  it, and the web binding catches the trap through `photolib_kernel_guard.js` and refuses further calls on that
  instance. Parsers allocate nothing a file declares, only slices of what the host passed.
* The app's web build must reach no `dart:ffi`: native kernel calls sit behind `app/lib/core/kernel.dart`'s conditional
  import (`kernel_web.dart`), and `app/test/web_imports_test.dart` follows `lib/main.dart`'s web imports in seconds.
* The map (`app/lib/features/map/`, ADR-0384) asks the kernel's index (`kernel/src/cluster.rs`, `map.proto`, kept in a
  keyring on an isolate of its own, `openMapKernel`) for the clusters of the viewport at the camera's integer zoom;
  never cluster in Dart. `kernel/tests/cluster.rs` holds its 1M-asset budget.
* Faces in the kernel (ADR-0389): `PrepareFaceDetection`, `DecodeFaces`, `AlignFace`, `NormalizeFaceEmbedding` and
  `MapFaces` (`kernel/src/faces*`), vectors in `testvectors/faces.json`; `MapFaces` is held to `Develop`'s geometry by
  `kernel/tests/face_edits.rs`, which renders marked faces through every turn, mirror and crop.

## Android

`docs/dev/android-gallery.md` is the default-gallery matrix of Android versions, OEMs and behaviours (ADR-0039); fill
its *open* cells from a phone with `bash tools/android/gallery_probe.sh` (adb, one device) and keep it current.
The MediaStore indexer (ADR-0045) is `MediaStoreIndexer` in `photolib_data`, tested against a fake `MediaStore` with
its 100k budgets in `test/media_store_test.dart`; the gate compiles no Kotlin, so after changing `app/android/` run
`flutter build apk --debug --flavor play` in `app/` (`ANDROID_HOME` and a JDK's `JAVA_HOME` set; add
`--target-platform android-x64` when `app/build/kernel/` holds only that library).

## Photo editor

* `kernel/src/develop.rs` (`METHOD_DEVELOP`) is the CPU reference renderer and the definition of every adjustment;
  `app/packages/photolib_editor/shaders` render the preview on the GPU, and every export is the kernel's, its tiles on
  worker isolates (ADR-0054). Change both in the same commit: `flutter test` there and the `web` part compare them on
  every card and recipe of `lib/testing.dart`.
* Give each shader pass its own `FragmentShader` and dispose it once rendered (Skwasm reads uniforms lazily; an
  undisposed shader keeps its textures); keep 16-bit values in two 8-bit channels and inputs opaque.
* Measurements and their commands are in [docs/dev/editor-rendering.md](docs/dev/editor-rendering.md).
* The alpha's edits (ADR-0331) are saved as copies, never over the original: `app/lib/features/editor/` (the viewer's
  Edit, `saveCopy` beside a folder file or into MediaStore through `ViewerChannel.kt`), `photolib_editor`'s `edit.dart`
  (`Edit`, `autoEnhance`, `editCopy`) and the kernel's `METHOD_EDIT_COPY` (`kernel/src/edit.rs`: turns as EXIF
  orientation, crops as whole JPEG blocks, other edits encoded; metadata carried over, the recipe in the XMP). Tests
  decode copies with `package:image`, an independent decoder; app tests need `tools/kernel/build.py --out
  app/build/kernel <target>` after a kernel change.
* Edits are `EditRecipe`s of immutable versions (ADR-0391, [docs/dev/editor-recipes.md](docs/dev/editor-recipes.md)):
  only the kernel (`kernel/src/recipe*.rs`, methods 53 to 57) interprets one; stored masks and patches are applied,
  never recomputed. A version is a `VersionEdit` mutation and a revert a field edit of `assets.current_version_id`.
  Whatever is derived from a picture (renditions, OCR text and regions, faces, the `edit_export`) records the version
  it was made for and is made again when the current one changes: a new job that reads a picture goes through
  `Render::sandboxed`, which applies the current recipe.

## Local database

* `app/packages/photolib_data` is the replica: drift on SQLite3MultipleCiphers (the `sqlite3` build hook's
  `source: sqlite3mc`, set in every root `pubspec.yaml` that resolves it), schema in `lib/src/replica.drift`,
  conventions and pre-migration backup in ADR-0031. Commit the generated `*.g.dart`, `drift_schemas/` and
  `test/drift/`.
* To change the schema: edit `replica.drift`, bump `schemaVersion`, run `dart run drift_dev make-migrations` and
  `dart run build_runner build --force-jit` there, and write the step in `Replica.migrate` (`migrationSteps` of the
  generated `replica.steps.dart`). Never edit a released dump.
  A new table needs a `txid` column, a place in `deviceTables` or in the rebuilt set of `test/migration_test.dart`.
* Only `Vault.openReplica`, called once in `app/lib/core/replica.dart` on the root isolate, opens the database (one
  data isolate per process; a worker of its own on the web) under a page key from the device data key (ADR-0057);
  other isolates use its connection (`computeWithDatabase`) and extensions append to journals (`mergeJournal`).
  A store whose keystore lost its key opens with its local recovery code (`Vault.addRecoveryCode`,
  `unlock(recoveryCode:)`) or starts afresh (`Vault.rebuilt`); `StoreBanner` says which (ADR-0057).
  `app/tool/single_writer_lint.dart` fails `flutter test` on a second Flutter engine or database writer, or a store
  opened past the vault or unkeyed. Files go through `Vault.write`/`read` (PLB), never plaintext to disk. On Linux
  without a Secret Service the keystore keys are a `PassphraseKeystore`'s (`FallbackKeystore`, ADR-0154), whose
  passphrase `PassphraseGate` asks for.
* Until a kernel release is pinned, the app bundles the kernel from `app/build/kernel/` (`tools/kernel/build.py`,
  which the gate and `tools/smoke.sh` run) and its web build loads `app/web/kernel/` (`tools/kernel/wasm.sh`).
* On desktops the data isolate runs a `FolderWatcher` for every folder in `media_source` (ADR-0042). Folder ignore
  rules are the cases in `testdata/photolibignore.json`, matching case as the folder's volume does
  (`isCaseSensitive`); the server's scanner must run them too. The app adds folders with `folderPickerProvider`
  (desktops only) and Settings lists `folderSummary` (ADR-0071).
* In Chromium the page scans folders with the same `FolderIndexer` over File System Access handles kept in IndexedDB
  (`browserFolders`, ADR-0082); its browser tests use OPFS directories. A closing replica first stops its scan between
  directories; its close returns once the worker has rolled back what was left open and closed the database. The
  worker posts its errors with their stack (`database worker error`); an open whose worker cannot start fails.
  dart2wasm mis-compiles closures made in an async loop (one shared copy of the loop's variables) and can hang on an
  `await` inside a condition: avoid both.
* Settings and the collections layout persist as the vault's sealed `settings` and `collections` objects
  (`StoredNotifier` over `VaultText`), the desktops' download folder and the library's view options among them; a
  setting the object lacks or holds in an unknown form takes its default (no migration), and a change made before
  they are read applies over them. `runPhotolib` starts the app once the settings are read (at once if the vault
  fails, after 500 ms at most), so its first frame has the stored theme; `pumpApp` keeps them in `MemoryStore`s.
  `vaultProvider` never retries: where it cannot open (no keystore), `StoreBanner` says so on every tab and in
  Settings; its Try again reads them anew.
* A widget test that watches a drift query ends with `pumpWidget(SizedBox())` and `pump(Duration.zero)`: drift closes
  queries on a timer (`test/features/folders_test.dart`).
* Metadata extraction (ADR-0072) is `MetadataExtractor` in the data isolate, started by `extractMetadata` and steered by
  `extractFirst` and `reportDeviceHealth`; `local_asset.extracted` is NULL while an item waits, and an indexer that sees
  a file change must set it back to NULL. `test/extraction_test.dart` holds its 100k jank and restart budgets; tests
  load the kernel through `photolib_kernel/testing.dart`'s `buildKernel` (cargo), as no release is pinned yet, in a
  suite's `main`: in a test it throws, as cargo may outlast the test's timeout.
* Browsers run metadata extraction in the replica's data worker (`web/data_worker.dart`, ADR-0232), a second client of
  its drift worker whose table updates the page relays, with the kernel's module on Web Workers
  (`web/metadata_worker.dart`); `test/web_folders.dart` reads the corpus there as the native kernel does
  (`test/corpus_native.dart`) and holds the 10k frame budget.
* Sync (ADR-0120) is `SyncEngine`, run by `syncReplica` in the data isolate on its own connection: a batch is one
  transaction with its cursor, read from its bytes (`sync_message.dart`), never as messages, as their garbage stalls
  the UI's isolate too. Unreachable rows go by reachability (`_collect`), a reset drops then refetches, an epoch change
  re-verifies backups. `test/sync_test.dart` runs a stand-in photolibd (`photolib_api/testing.dart`);
  `test/sync_budget_test.dart` holds the 1M frame budget, its stand-in in a process of its own
  (`test/support/photolibd.dart`; `PHOTOLIB_SYNC_ASSETS` sets fewer while you work).
  The app syncs at start, at sign-in and every five minutes (`syncingProvider`); after each sync a desktop backs its
  folder items up through `BackupNotifier`'s run of the backup state machine (below, `backupProvider` of `sync.dart`)
  into the account's upload destination; `SyncServer` takes uploads too (`test/backup_test.dart`).
* Device folders (ADR-0210): a MediaStore item's `local_asset.folder` is its `device_folder` row, keyed by volume and
  relative path. Every query of device items the user sees filters `folder NOT IN (SELECT id FROM hidden_folder)`,
  or `app/test/device_queries_test.dart` fails; the timeline's day counts are `timeline_day`, kept by triggers.
* Real-time hints (ADR-0225): photolibd's `GET /events` (`rpc/sync/hints.rs`) names the streams a change advanced,
  never rows; `Server.hints` reads it and `followHints` syncs at each hint, which `hintsProvider` runs while the app is
  visible. `tests/hints.rs`, a binary of its own, holds the 2 s; the stand-in's `hint` drives `test/hints_test.dart`.
* Edits go through `Mutations` (`outbox.dart`, ADR-0265): each shows in the replica, ticks the `clock` and joins the
  outbox in one transaction; `SyncEngine.run` pushes first (`PushMutations`), and the answer's rows and every sync
  batch get the edits still waiting shown over them. photolibd merges them in `rpc/sync/mutations.rs` (per-field HLC,
  `album_item_states`, item ids from SHA-256 of album and asset). `test/convergence_test.dart` and that module's
  `two_devices_…` test are the randomized convergence checks: keep both in step with a new field or set.
* Local search (ADR-0086) is `searchPage` over `local_asset`, filters compiled in Dart until the kernel's (M5-06);
  `test/search_test.dart` holds its 100k budget (< 100 ms a filter combination, count and first page, fastest of 7).
* `lib/src/store_cost.dart` measures what encryption costs (ADR-0090, [report](docs/dev/local-store-spike.md)):
  `test/store_cost_test.dart` holds design 21 §8's budgets on the VM (tagged `alone`; overheads are medians of
  interleaved rounds' ratios), `test/web_test.dart` in browsers (the database in dart2js only, as `drift_worker.js`
  is; keep the worker dart2js), `app/benchmark/store_cost_test.dart` on devices.
* Its tests get 4x the default timeout (`dart_test.yaml`): a loaded machine's disk stalled the vault's first fsync
  past 30 s.
* `lib/testing.dart` is the conformance probe that the VM, browser and six-target smoke tests share. Web builds need
  `bash tools/data/web.sh app/web` (git-ignored output).
* On a `noexec` checkout the gate moves each package's `build/` (where build hooks put native libraries) to
  `${PHOTOLIB_CACHE:-${TMPDIR:-/var/tmp}/photolib-<uid>}`; use `flutter test`, as `dart test` loads them from
  `.dart_tool/`.
* Its tests that measure time or work through 100,000 items are tagged `alone`, and none sets a timeout under the
  4x (`test/suite_test.dart`): beside the rest of a loaded machine's gates they failed every item that touched it.
* Each grid's zoom level is a setting (VIEW-02): the timeline's `LibraryView.density`, which `TimelineView` takes
  from its parent and reports through `onDensity`, and search's `searchColumns`.
* A page over a replica query shows `StoreErrorView` (`app/lib/core/errors.dart`) on its error, as the library,
  search and other files do; never `.value ?? []`, an empty list where the store could not open.
* A replica query the UI watches while a scan commits (the timeline, Settings' folders and indexing progress)
  follows it through `everySecond` (`app/lib/core/replica.dart`), at most once a second; folder counts read
  `local_asset_root`, never rows.
* Date added's day counts ('Recently added') are `timeline_added`, by quarter hour of UTC and folder, kept by
  triggers as `timeline_day` is.
* Its 100k index, extraction and search cases (`media_store_test`, `photo_kit_test`, `extraction_test`, `search_test`)
  are tagged `alone`: beside the suite's other files a loaded machine stretched them past their budgets and timeouts.
* Its own files and workers import its internals as `package:photolib_data/src/…` (`always_use_package_imports`);
  `app/tool/single_writer_lint.dart` refuses that import in any other package or the app.
* Local sources are one tree on every client (ADR-0290): `sourceTree` folds `device_folder` (a MediaStore bucket's,
  a desktop or browser root's directory, or a folder above them a visibility was set on) into `SourceNode`s, which
  `app/lib/ui/source_tree.dart`'s `SourceTree` shows wherever folders are listed. A node's own `visibility` decides
  for it and what below inherits, resolved in `excluded_folder`; `source_tree_test.dart` holds every combination.
* Every device item is deleted through `DeletionService` (`photolib_data`, ADR-0245), one `MediaPlatform` per source:
  MediaStore's requests (`MediaRequests.kt`), PhotoKit's and macOS's Trash (`MediaRequests.swift` in each runner), the
  freedesktop.org trash, Windows' Recycle Bin or Photolib's own `AppBin` (`trash_native.dart`, `trash_web.dart`).
  `app/tool/deletion_lint.dart` fails `flutter test` on a platform delete call anywhere else; a file the app made
  itself says why with `// deletion-ok: <reason>`. `tools/tests/test_media_requests.sh` checks the runners as text.
* Favourites, hidden and archived are Photolib's own `local_asset` columns, which indexers never clear; triggers keep
  them by content in `kept_state` (the `fingerprint` extraction reads), and timeline queries take `veiled`.
* The backup state machine (design 05 §6, ADR-0226) is `BackupEngine` in `photolib_data`, run by `backupReplica` in
  the data isolate and scheduled by the app's `BackupNotifier` (`app/lib/features/backup/`) on the device's session,
  which `ServerNotifier.renew` rotates before it expires. Every `backup_state` reason the engine writes has a case of
  `backupWhy` (Settings › Backup) in every ARB; a refusal that every further item would get stops the run instead.
* An item's upload path is kept before its first byte goes: `test/backup_test.dart` kills a child process
  (`test/support/backup_child.dart`) mid-upload and holds the 100,000-item second device;
  `app/test/live/backup_test.dart` backs 10,000 folder items up to a real photolibd. An upload without
  `Photolib-Library` goes to the account's upload destination, made at the first (`tests/uploads.rs`).
* Each backup pass that reaches photolibd reports what waits with `AuthService.ReportBackup`, the count its `backup_run`
  row keeps, for the server's watchdog (ADR-0234); the stand-in records them in `SyncServer.backupReports`.
* An `async*` provider awaits `replicaProvider.future` before it watches anything else: a rebuild cancels it at that
  await, and Riverpod drops the cancel's future, so a failed open goes uncaught (`sourceTreeProvider`).
* Settings' indexing progress (`mlProgress`) sums `ml_count`, by folder and model, kept by triggers: `local_ml` rows
  are inserted or replaced, never upserted or ignored; `test/ml_test.dart` holds it to search's `videoOf`.
* The timeline shows one tile per photo (ADR-0267): `timeline_item` (device items) and `cloud_item` (assets no present
  device item links, with their renditions' hashes for T5), merged by page and summed by day; triggers keep
  `local_asset.tile` and `asset.on_device`, so code that changes links, presence or assets does nothing more. The app
  also syncs on every resume; signed out, `forgetServer` drops what the server sent.
* A user's delete of timeline items goes through `deleteItems` (`app/lib/features/library/deletion.dart`): signed in it
  first says what goes where (`confirmDeletion`, ADR-0200 X1–X5), then `moveToTrash` sends device copies through
  `DeletionService` and library copies as outbox `trashed_at` edits, undone together.

## Lint

[Lint rules](docs/dev/lint.md) (ADR-0129) lists every language's rules. `tools/lint/baseline.json` holds the findings
on `main` per run, file and rule; the gate fails on any it does not hold and on fewer than it holds. After cleaning a
file run `bash tools/lint/ratchet.sh --update <linter> <dir>` and commit the smaller baseline: it never grows but with
`--grow` and a `lint-accept: <reason>` line in a commit. Refactor runs burn it down, worst files first
(`bash tools/lint/ratchet.sh --top`). A file you create or move starts clean; a construct allowed on purpose carries a
comment saying why. `rust-toolchain.toml` pins the Rust release, and with it clippy's lints: bump it in a change of
its own that cleans or `lint-accept:`s what the new clippy finds. Tests fail on what they used to swallow: Rust tests
through `tools/lint/panics.py`, Dart tests through `app/packages/photolib_harness` (each package's
`flutter_test_config.dart`; take a deliberate problem with `takeProblems()`).
Users see a failure only through `ProblemView`/`showProblem` (`app/lib/core/problems.dart`): a new reason photolibd
sends gets its cause and next step there in every language, or `tools/tests/check_errors.py` fails (OPS-30).

## Tests

* Test first: observe the right failure, then make it pass. Never weaken or delete a failing case.
* `tools/tests/test_*.sh` source `lib.sh` (assertions and isolated command stubs); Python helpers use stdlib only
  (`checklib.py`, `miniyaml.py`, not PyYAML).
* The server's tests start servers with `photolib_spawn::Group::start` and run tools with `photolib_spawn::output`
  and a limit, never a bare `Command`: each runs in a process group of its own that dies with the test (`setpriv
  --pdeathsig`, util-linux) and is stopped on drop or killed at its limit (ADR-0113). A child that binds a port
  listens on port 0 and says which, or binds `free_port()`s, which no bind of port 0 takes until dropped (the child
  sets `SO_REUSEADDR`), through `on_fresh_ports`, which starts it again on fresh ones when another process took one or
  listens beside it (Caddy's `SO_REUSEPORT`); it is up once `Group::listens` on them alone (photolib-design#501).
* A network-loss test cuts or stalls the connection after a byte count, waits until the server has kept what arrived,
  and asserts the resume exactly (offsets, bytes sent again, resumes); a client's timeout passes on a fake clock
  (`network_test.dart`), never against a loaded machine's wall clock.
* Rust integration scratch files go under `env!("CARGO_TARGET_TMPDIR")`. On `noexec` mounts, use an executable
  `CARGO_TARGET_DIR` for binaries, proc macros and the library loaded by Dart.
* Never hand-edit generated code or corpus files. The [tooling guide](tools/README.md) has regeneration commands.
* Large-library tests use [tools/synthlib](tools/synthlib/README.md), seeded CSV fixtures and placeholder PNGs.
  `python3 tools/timeline_bench.py <linux|chrome|firefox> [--wasm]` measures the timeline over 1M assets, by hand
  (minutes per target, noisy without a GPU); results go in `docs/dev/timeline-spike.md`. The scenarios live in
  `app/lib/features/library/timeline/benchmark.dart`, which test builds (the `diagnostics` flag) run from Settings.
* A new benchmark appends JSON lines to `$PERF_RESULTS` for a budget of `tools/perf/budgets.json` and runs from
  `tools/perf/run.sh`, an app under `perf.py watch`, which records each `result: <json>` line it prints as it comes
  (killed when silent for 5 min or 10 min without a fixture); `test_perf.sh` pins the budgets to docs/19 §3. A kernel
  or server hot path gets a case in its `benches/instructions.rs`, setup outside `measured`. A CPU-time throughput
  budget is calibrated by a reference run beside each sample (ADR-0121; `calibration.quiet` in `budgets.json` is the
  reference machine's); a janky share less the frames an idle isolate misses meanwhile, never a raised budget, and over
  it measured again up to five times (`app/benchmark/jank.dart`); the gate's rerun of `run.sh` measures only what
  failed (ADR-0140). `perf_test.dart`'s
  tests run `bounded` (`app/benchmark/bounded.dart`): past its limit or at an uncaught error a body throws at its next
  timer and unwinds before its test fails, so it releases what it holds in `finally`, never into the next test. A
  timing over its budget is measured again, the best counting (`bestOf`); what measures no time runs beside the
  server's benchmarks, and a path that changes each run reaches the app from the environment, never a define, which
  would compile it anew (ADR-0212). `run.sh` ends with each step's time, `perf.py watch` prints each test's.
* A Rust test's time limit counts `photolib_spawn::Running` (as `output` and `Group::deadline` do), which leaves out
  the minutes the merge train's quiet mode stops a run (SIGSTOP); never a tool's own wall-clock limit (curl's
  `--max-time`), which a stop runs out.
* A `tools/tests` case that judges wall time runs through `thawed` (`lib.sh`), again when the test was stopped
  meanwhile: agents' runs are stopped for minutes while the merge train measures time (photolib-design#597).
* A test is proven stable by repetition, never by a retry. The gate retries a failing test (`CHECK_RETRIES`, `retry:` in
  `dart_test.yaml`, `nextest --retries`), so one that fails one run in five passes it. `tools/repeat.sh [-n N] <test
  file>...` (N is 10 or `REPEAT_N`) runs the tests of those files N times with every retry off and fails on the first
  failure (`-k` counts them all); `--since <rev>` takes the test files a diff adds or changes, and `bash tools/check.sh
  --since <rev>` runs that after its parts (`CHECK_REPEAT=<n>`, 0 skips it). Run it beside a busy machine to find a
  flake, then fix its cause: shared state, an order the test relies on, a sleep or a count of frames where a condition
  belongs, a port, a core count the machine decides. A test written for four cores passes `concurrency` itself.
  [Flaky tests](docs/dev/flaky-tests.md) has the causes found so far.
* The gate runs Rust tests under `cargo nextest`, each in a process of its own beside the others: a fixture a `static`
  shares is one per process, so a scratch path it writes names its process or test (`tools/synthlib/tests/fixture.rs`).
* A widget test waits for the app's real file and database work with `tester.pumpUntil` (`test/support/pump_app.dart`),
  which pumps until it is done and fails after 2 min of its own waits, never a fixed count of frames.
* The app's tests get 4x the default timeout (`app/dart_test.yaml`), as `photolib_data`'s: its loops of file I/O and
  decodes outlast 30 s on a loaded machine.
* `frozen` (`lib.sh`) stops a case as quiet.sh does, to prove that it runs through `thawed` (photolib-design#648).
* Rust tests and their support (`testing.rs`, `testpg`) wait with `Running::start()`/`elapsed()`, never an `Instant`,
  and time out a future with `photolib_spawn::within`, never `tokio::time::timeout` (but under `start_paused`); a
  Dart test's timeout starts again after a stop (`strict` of `photolib_harness`).
* A suite runs a toolchain (`flutter`, `dart test`, `cargo`) in its `main`, where package:test runs no timeout,
  through a helper that calls `untimed` (`package:photolib_harness/testing.dart`: `outcomes`, `Photolibd.build`): it
  may wait minutes on locks other checkouts share, and `setUpAll` has 12 minutes whatever `@Timeout` says.
* Inside `runAsync`, or in a test without frames, an app test waits for real file I/O with `realUntil`
  (`test/support/real_time.dart`), as `tester.pumpUntil` does between frames, never with a fixed count of short waits.
* `app/benchmark/` runs as a profile build, which drops `tester.enterText` and simulated keys: type with
  `EditableTextState.userUpdateTextEditingValue`, and run one test with `PERF_FAILED` listing its series for `run.sh`.
* `lib.sh` sets `core.hooksPath` to `/dev/null` for its tests: a sandbox's commits run none of the caller's git hooks
  (a global one, an agent session's commit lint).
* A stop runs out a live test's requests (`NetworkConfig.timeout`, 30 s), and the app's run ends offline: the test
  runs it again through `thawed`, as the app's next run would, when the process was stopped (`live/backup_test.dart`).
* A Dart test runs code that counts wall time (a client's 30 s timeout against a live photolibd) through `thawed`
  (`package:photolib_harness`), again when the process was stopped meanwhile, and bounds its own waits by their
  count, never a wall-clock deadline, which a stop runs out.
* The merge train's gate runs under a soft limit of 1,024 open files (agents' shells allow far more): code opens a
  bounded number of files at once, and a failure only the gate sees is first tried again under `ulimit -n 1024`.

## On-device ML

* `app/packages/photolib_ml` binds ONNX Runtime's C API with `dart:ffi` (`photolib_ml.dart`, any isolate, tensors in
  native memory) and onnxruntime-web with `dart:js_interop` (`photolib_ml_web.dart`); the choices are ADR-0050's.
* Product models are in `server/crates/photolib-models/registry.json` (ADR-0064): `cargo test` fails unless each is
  permissive or attribution-licensed, pinned at a commit and not a family design 09 §2.1 excludes. Re-read the
  licence page when adding or bumping one; anything else is bring-your-own, imported with `--accept-licence`.
* The spike's runtimes and models are pinned by SHA-256 in `tools/ml/artefacts.json` (models at a commit, permissive
  licences only) and fetched by `tools/ml/fetch.py` into `PHOTOLIB_TOOLS_CACHE`; never commit weights.
* Its tests compare outputs with `test/golden.json`, the fp32 models on Linux x64's CPU: cosine ≥ 0.999 on the CPU,
  ≥ 0.99 on another execution provider. `PHOTOLIB_ML_MODELS=all` adds SigLIP 2 (about 3 GB of cache);
  `PHOTOLIB_ML_GOLDEN=update` rewrites the goldens after a deliberate change.
* Devices run models only through `Runner` (`photolib_ml/lib/runner.dart`, ADR-0254): an isolate of its own, the first
  provider whose golden output reaches cosine 0.99, quarantines kept per runtime version. Image inputs come only from
  the kernel's `PrepareImage`, which the server calls too; `MlIndexer` keeps outputs in `local_ml` and pauses while
  `backgroundHold` (`app/lib/core/device_health.dart`) holds. `photolib_data/test/ml_native_test.dart` holds the
  device's path to the server's computation (SigLIP 2 fp16 with `PHOTOLIB_ML_MODELS=all`).
* Devices index only once the user agrees (ADR-0278): `onDeviceMlProvider` (`app/lib/core/on_device_ml.dart`)
  downloads the model with `installModel` (`photolib_data/ml.dart`) from photolibd's `/models`, else standalone the
  registry's mirrors, and `startMl` runs it in the data isolate with `app/lib/core/ml.dart`'s decoder; widget tests fake
  the host (`test/support/ml_host.dart`). Apps compile in the registry: after changing `registry.json` run
  `dart run tool/registry.dart` in `photolib_ml`.
* Apps bundle ONNX Runtime only through `photolib_ml`'s `hook/build.dart`: the archive `tools/ml/artefacts.json` pins,
  from `hooks.user_defines.photolib_ml.runtime` (the gate fills it with `tools/ml/fetch.py --archives`) or downloaded
  and SHA-256 checked; iOS links the xcframework. `python3 tools/ml/ort_ops.py` writes `tools/ml/ort-ops.config`
  (`test_ort_ops.sh`); `bash tools/ml/ort_android.sh` builds the operator-reduced Android library outside the gate.
* Android's one engine is `PhotolibApplication.engine` (design 10 §1.5), with the channels that need no activity;
  WorkManager's `MlWorker` asks it for `background` on `org.photolib/ml`, as iOS's `BGProcessingTask` asks the app's
  engine; `tools/tests/test_ml_native.sh` checks both against the Dart as text.
* Faces (ADR-0389) are found on a device only once the user agreed to the notice (`Settings.faceNotice` equals
  `faceNotice` of `app/lib/core/on_device_faces.dart`, the version `FaceService` asks for): `OnDeviceFaces` downloads
  YuNet and SFace and `startFaces` runs `FaceRunner` and `faceEmbed` in the data isolate, results in `local_ml` as
  `faces:<detector>+<embedder>`; `FaceConsent.withdraw` deletes them. A copy from the editor gets its original's faces
  moved by the kernel's `MapFaces` (`carryFaces`, with the crop `EditCopyResponse.crop` says it shows) until it finds
  its own. Face strings are in every language (`facesTitle` and its siblings).

## API clients

* Every request to a server — API calls, media, uploads, players — goes through the `Server` of
  `app/packages/photolib_api`, built from that server's `NetworkConfig`; never open another `http.Client` or
  `HttpClient` for it. Players read through `MediaProxy`, encrypted media through `MediaProxy.decrypted`, which opens
  whole 1 MiB windows with the kernel (ADR-0059). The viewer uses `viewer/src/api.ts`.
* Only a `CallError` whose `logsOut` is true (`unauthenticated` with a reason) may end a session; anything else is
  `Unreachable` and means offline (ADR-0032). The session goes over plain HTTP only to an address photolibd counts as
  local, else the call fails as `HttpsRequired` (ADR-0125).
* `test/network_test.dart` needs `openssl`: it makes a private CA, server and client certificates for each run, so no
  key is committed. `test/web_test.dart` runs in browsers in the `web` part.
* The app's one server and its session are `serverProvider` (`app/lib/features/servers/`, ADR-0125), kept as the
  vault's class B `server` object (ADR-0209); server features call through `sessionProvider` (calls and `media`), whose
  revocation signs the app out, and widget tests fake the network with `connectProvider` and the kernel with
  `opaqueProvider`.
  `app/test/live/photolibd_test.dart` signs in to a real photolibd: it builds it with cargo and starts a PostgreSQL
  cluster as `testpg` does.
  `app/test/support/server_app.dart` sets up both fakes.
* The map's tiles load only after the user agreed (`Settings.maps`), through `TileClient` (10 s, the app named); their
  host is a row of the privacy manifest. `app/test/features/map/map_page_test.dart` waits for the page's slide-in.
* `photolib:` links reach the app (ADR-0243) through Flutter's deep links (Android, iOS), the arguments (Linux, Windows;
  `openedArg`) and Finder's opened files (macOS) as the router's `/password-setup`, which `SetupLinks` opens over the
  library; widget tests send `pushRouteInformation` (`password_setup_link_test.dart`).
* Several accounts (ADR-0234): `accountsProvider` keeps every server, session and replica name; `serverProvider`,
  `sessionProvider`, `replicaProvider` and `syncingProvider` follow the account in use, and each tab's page is
  rebuilt per account (`AccountScope`). `test/core/account_replicas_test.dart` syncs two stand-in servers through the
  real vault and holds the < 1 s switch.
  Each account keeps its own views (`keptKey` in `app/lib/core/kept.dart`).

## Background work

* Hashing, metadata extraction, decryption and indexing run on a `WorkerPool` (`app/packages/photolib_workers`), never
  on the calling isolate: isolates natively, Web Workers on the web from a `dart compile js` script whose `main` calls
  `serveWorker` with the same `Task`s. Tasks exchange plain data and call `progress`, where a cancelled job stops.
* `test/pool_tests.dart` runs in the VM and in browsers; it hashes 2 GiB within the frame budget. Every frame budget
  (also `photolib_data`'s extraction, PhotoKit and browser folder tests) goes through `withinFrameBudget` of
  `package:photolib_workers/testing.dart`: the work may add at most its budget (1 % by default) of missed 60 Hz frames
  (a 1 ms timer, and in Chrome animation frames; headless Firefox animates at 1 Hz) to what an idle isolate misses,
  this one just before or another (a Web Worker) meanwhile, in up to three tries. A busy machine whose idle isolate
  misses more raises the budget to that, and the log says so (ADR-0098).

## Logging and diagnostics

* Log through `photolib_log` (ADR-0115): `const Logger('photolib.<subsystem>')`, never `print`; a package or isolate
  needs nothing else. Names of files, folders and URIs go in fields named `file`, `folder`, `path`, `root`, `dir`,
  `name` or `uri` (whole words of a field's name; numbers and flags stay), never into message text; release builds
  redact them and keep info and above (`Log.configure`).
* Native code logs through `NativeLog` (Kotlin, macOS Swift, Windows C++) into `listenToNativeLog` over
  `org.photolib/log`, never only into the platform's log; `tools/tests/test_native_log.sh` checks the runners as text.
* The data isolate and `onDataConnection` send their records to the isolate that opened them; tests listen to
  `Log.records`. Natively the log rotates in `<support>/logs/` (`LogFile`), in browsers it is IndexedDB's
  `photolib/log` (`BrowserLog`, `test/core/log_web_test.dart` in the `web` part); release builds seal it under the vault
  (`vaultSeal`). Settings › Diagnostics exports the bundle (`diagnosticBundle`), which in release builds must hold no
  file name (`test/features/diagnostics_test.dart`).

## Thumbnails

* Cells get images only through `Thumbnails` and `ThumbnailPipeline` (`app/lib/features/library/timeline/`,
  ADR-0070), which `thumbnailPipelineProvider` composes per platform (`native_pipeline.dart`, `web_pipeline.dart`):
  the `DiskCache` (T2), platform thumbnailers (T3) and decoders of the originals (T4, ADR-0107), named `Thumbnailer`s
  each passing what it declines (null, `Declined`) or refuses (`NoThumbnail`) to the next. A miss's `NoThumbnail.cause`
  names every answer in order; a failed cell's mark shows it as a tooltip, and the warm-up's log summary lists it.
  `disk_cache_test.dart` damages the cache at random; it must stay bounded and never lie.
  T2 holds PLB envelopes under the cache key, which `Vault.tileCipher` seals and opens on an isolate of its own.
* T4 tiles reach the disk cache as decoders hand them over, never read back from an image. macOS
  (`ThumbnailChannel.swift`) and Windows (`thumbnail_channel.cpp`) answer `org.photolib/thumbnails` for files, macOS
  keeps folders' bookmarks (`FolderAccess.swift`); keep them in step with the Dart, which
  `tools/tests/test_desktop_thumbnails.sh` checks as text. libvips (`vips.dart`, `dart:ffi` on an isolate) needs
  libvips ≥ 8.15 for `flutter test` on Linux, libmpv posters (`mpv_posters.dart`, the same way) libmpv there, FFmpeg
  posters (`ffmpeg.dart`) the pinned `tools/video/ffmpeg.sh`.
* Browsers draw video posters with their own player (`browserPoster` in `photolib_data/browser.dart`, ADR-0116) and
  keep them, with the duration a video cell shows, as sealed vault objects (`VaultCache`); at most two video decodes
  run at once. Outside Chromium an encoded tile decodes with `createImageBitmap` in the thumbnail worker
  (`browserImage`), never with CanvasKit's codec on the page (ADR-0056); tests pick the engine with
  `ui_web.browser.debugBrowserEngineOverride`.
* A failed decode marks its cell and a decode times out of its slot; a scan's end warms T2 on the cores but one and
  keeps each item's ThumbHash in `local_asset.thumbhash` (`warmup.dart`), which at start warms the items without one
  (`withoutThumbHash`). Decodes never wait for the scroll; until its tier, a cell shows another tier or the embedded
  preview `ReadMetadata` locates (`embedded.dart`, ADR-0114); each tile's stages go to the debug log. The folder
  benchmark of `perf_test.dart` scrolls 10k 12 MP JPEGs cold and warm at 1 and 3 screens a second and in a fling, and
  times a tile (`folder-scroll`, `folder-open`, `tile-latency`, `thumbnail-tile`).
* Every tier hands cells upright sRGB pixels (ADR-0040): `pipeline_test.dart` holds golden pixels of rotated, P3 and
  CMYK sources; `budgets_test.dart` holds the CPU budgets (layout time, decodes per CPU second, the queue's CPU per
  decode).
* A server item's tile (T5, ADR-0246) is the server's `thumb_s` or `thumb_m` by tier for `ThumbnailItem.remote`,
  fetched through `mediaProvider` (the session's `Link.media`, once an address answered as its instance) and kept in T2
  with its ETag, current when it is the replica's hash, else revalidated. A 404, no answer or no session is `Pending`:
  the cell keeps its ThumbHash, unmarked, and `Thumbnails` asks again with backoff. `test/live/renditions_test.dart`
  runs it against photolibd with an external library (`test/support/server_library.dart`), and
  `app/benchmark/server_tiles.dart` times it (`server-tiles`).
* Where nothing decodes HEIC or HEVC (Chrome on Linux, Windows without the HEVC Video Extension, Linux without
  libheif's HEVC plugin), the cell's placeholder names the way out, in the apps connected mode or a Mac, not a codec;
  nothing HEVC-licensed ships with the apps or the web
  (ADR-0214, [report](docs/dev/heic-without-system-decoder.md)). `node tools/heic/bench.mjs` measures libheif-js in
  Chrome and Firefox on HEIC twins of the corpus (`tools/heic/twins.py`), by hand.
* ThumbHashes are encoded only by the kernel (`EncodeThumbHash`, for the server and the device indexers) and decoded
  by the app's `ThumbHash` (ADR-0070); both run `testdata/thumbhash.json`, which `node tools/thumbhash_vectors.mjs`
  regenerates from the reference implementation (fetched from npm).
* The library is `TimelineView` over `libraryTimeline` (ADR-0094): the replica's `timeline_item` view by day, paged
  by `TimelinePages`, selections as position ranges over the snapshot they were made in. `app/benchmark/perf_test.dart`
  drives it over the synthlib fixtures (scroll, jumps to months, `drag-select-5k`).
* `libraryTimeline` follows the index at most once a second, as a scan commits a directory at a time; a widget test
  that changes the index pumps a second before it looks.
* A RAW shows as its largest embedded JPEG, turned once by the RAW's orientation, never its sensor data (ADR-0247): the
  server's renditions, and on desktops the kernel's `largest_preview` in `vips.dart` for `rawExtensions`; embedded
  previews carry their file's orientation (`oriented` in `embedded.dart`). Every corpus RAW is checked upright and in
  colour by `tests/renditions.rs` and `vips_test.dart`.
* The search grid (ADR-0261) is a `MediaGrid` of `ThumbnailAt` cells over `TimelinePages` that read
  `searchPageProvider`, its top row kept as `searchTop`. A cell is animated (badged) as `timeline_item.facets` says
  (`animated`: `isAnimated` of `photolib_data` in extraction, bit 34 of a PhotoKit row), a GIF until it has facets.
* HEIC in Chromium (M1-43, ADR-0387): when `ImageDecoder` and `createImageBitmap` refuse a HEIF still, the thumbnail
  worker asks the kernel's `ReadHeif` (WASM, `kernel/photolib_kernel_wasm.js`) where the coded images are and decodes
  them with WebCodecs where `VideoDecoder.isConfigSupported` allows (VideoToolbox, Media Foundation), composing grid,
  `clap`, `irot` and `imir` on an `OffscreenCanvas`; the web part proves it in Linux Chrome on the AVC twins of
  `tools/corpus/avc_twins.py` (`testdata/corpus/twins/`), whose palette keeps blue between red and green because
  libyuv scales BT.709's blue difference by 2.0. Change `ReadHeif` with `kernel/tests/heif*.rs` and its vectors.

## Photo viewer

* `app/lib/features/viewer/` (ADR-0106): `DeepZoom` paints the tiles `tilesOnScreen` picks over the screen-size image,
  decoded by a `Regions` (Android's `BitmapRegionDecoder` in `ViewerChannel.kt`, which also shares and copies; Flutter's
  codecs for desktop files). `deep_zoom_test.dart` holds the 200 MP memory bound; `perf_test.dart` measures the open,
  and its frames over a 10k folder warm and cold. The pager pages over a window around the item shown; the filmstrip
  asks for the grid's tier (memory, then disk) and decodes nothing until the item shown is sharp, then its cells
  (`ThumbnailAt`, a view of its own) wherever the grid looks.
* Viewer ergonomics (ADR-0208) each have a `Toggle` in `settings.dart` and a switch in *Settings › Viewing*: edge
  taps, `OneFingerZoom` and the side drags of `gestures.dart` (recognisers take the platform's
  `MediaQuery.gestureSettingsOf`), the window's brightness through `screen.dart` (`ViewerChannel.kt`,
  `ThumbnailChannel.swift`, checked as text by `tools/tests/test_viewer_native.sh`), auto-rotate, the bar's
  `ViewerAction`s, the background, audio focus, loop, auto-next and resume (`VideoPlayers`). Widget tests set them with
  `pumpViewer(settings:)` or `pumpApp(settings:)`.
* What the user looked at (VIEW-36) is `keptProvider` (`core/kept.dart`), the vault's sealed `state` object, a key per
  view; a view writes it only after restoring it, and restores positions only while it has as many items.
  `test/features/state_test.dart` restarts the app with `pumpApp(kept:)`.
* A page turn never resizes the pager: what lies beside it never depends on the item shown, so the info panel is laid
  out blank until the item's row comes, which it says only to screen readers (`page_turn_test.dart`). Widget tests
  open the viewer alone with `test/support/viewer.dart`.
* The slideshow (VIEW-21) is `SlideshowPage` (`slideshow.dart`) over any `TimelinePages` and a map from slide to
  position, opened by the viewer, `SelectionBar.onSlideshow` and search; `SlideOrder` orders it and the settings'
  `Slideshow` times it. It keeps the screen on through `keepAwakeProvider`, which `pumpApp` and `pumpViewer` fake.
* A RAW shows its largest embedded JPEG (`ThumbnailPipeline.preview`) until a larger decode comes (ADR-0216).
* Animated GIF, WebP and APNG files play through Flutter's codecs and `Frames` (`animated.dart`, FMT-13), frame n when
  the durations before it have passed since the first; `animated_test.dart` holds the corpus' speed. Their bytes come
  through `bytesOf` (`mpv.dart`): files, the viewer channel's `read` for MediaStore and PhotoKit, browser folders.
* Videos play through `video_player` (ADR-0112): ExoPlayer, AVPlayer, and on Windows and Linux libmpv through
  `MpvPlayers` (`mpv.dart`), the system's `libmpv-dev` on Linux; on Windows ours (ADR-0229), LGPL only and rendered in
  software, which `bash tools/video/libmpv.sh` builds reproducibly from the sources it pins and `app/windows/libmpv.cmake`
  takes by the SHA-256 `app/windows/libmpv.json` pins: change a pin, rebuild, commit the new pins, and the owner
  publishes the archive. The viewer's players are made, played, paused and
  disposed only by `VideoPlayers` (`video.dart`), while its route has opened and its pages rest; never in a widget's
  `initState`, `didUpdateWidget` or `dispose`. `perf_test.dart` swipes between videos (`video-swipe`). A motion photo
  plays the span extraction indexed (`local_asset.motion_offset`, `motion_length`), copied into the cache by
  `motionClipProvider` (`video.dart`). A frame step moves by `frameRateProvider`: the file's rate, else the server
  asset's (`asset.fps`), PhotoKit's from AVAsset kept in the row. Captions come from a sidecar `.vtt` or `.srt`
  (`captionsOf`). Widget tests fake the players (`test/support/fake_players.dart`); `bash tools/video/app_play.sh`
  plays a twin of every corpus video and motion photo with the real ones.
* Photo spheres and 360° videos (ADR-0146) go through `shaders/sphere.frag` from one `SphereView` (`sphere.dart`):
  photos as `SpherePhoto` with its levels of detail, videos as `SphereVideo`, which libmpv projects with `v360`,
  Impeller's `ImageFilter.shader` filters on Android and Apple, and the web feeds from `BrowserPlayers`' `<video>`
  elements. `local_asset.projection`, `crop`, `stereo` and `heading` decide, never the aspect ratio. The filter's
  input holds only the cells in view (`SpherePacking`), and a photo past its loaded picture draws 512 px tiles over it
  (ADR-0190). Change the shader with its goldens: `test/support/sphere_twins.dart` makes FFmpeg v360's golden frames
  that `sphere_golden_test.dart`, the playback probe and `sphere_web_test.dart` match within 4/255, and
  `tools/smoke.sh` serves them (`SPHERE_TWINS_OUT`, `SPHERE_TWINS`) to the probe on android, ios, macos and windows;
  the `sphere-video` perf budget holds 4K at 30 fps on `headless`, projected and flat, counting the frames a number
  burnt into the clip shows on screen.
* A file outside the library, dropped or opened with the app, has no replica row: `assetRowProvider` reads what it says
  of itself with the kernel on a worker (`readOutside` in `app/lib/core/kernel.dart`), so a sphere opens projected.
* A flat panorama, the `panorama` facet without a sphere (ADR-0238), opens as a strip the viewer's height (`_Photo`'s
  `strip`), which drags pan and its Previous and Next buttons turn; never from its shape.
* A sphere opens rotatable (ADR-0383): drags turn it, the pager is locked and keys, hover arrows and the filmstrip turn
  the page; `SphereCues` (`sphere_cues.dart`) holds its ring, slow turn and compass dial, whose long press offers its
  lenses.
* On Linux media_kit renders libmpv's frames on GTK's main thread, Flutter's UI thread, and libmpv holds that call
  until the frame's time: `MpvPlayers` sets `video-timing-offset` to 0 so it never waits there.
* Open and close are one flight (M1-52): `ViewerPage.route` lays the page out as it ends from its first frame while
  `_Flight` paints the item shown from its cell to its fitted place and the scrim, bar and strip fade with it; a swipe
  down drives the route's controller. Neighbours, spheres and the info wait for it to land; reduce motion cross-fades.
  `viewer_page_test.dart` reads the flight's pixels (`painted`).
* A video with a sound track pauses other audio unless `Toggle.mixAudio` is on; a silent one plays over it (ADR-0208).
  `VideoPlayers` makes each player through a `PlayerOf` with the options it gives (Android's takes audio focus as it was
  made) and plays it with `start()`, which sets iOS's audio session: play a viewer's video only through `start()`.
* A new viewer action (ADR-0261; move, delete, edit and slideshow too) joins `ViewerAction` at its place in `⋮`'s fixed
  order, with its label, icon and platforms in `toolbar.dart`. Rotate turns the view only; map and set-as hand the
  item over (`handoff.dart`: `view` and
  `setAs` on `org.photolib/viewer`, `view` on macOS's `org.photolib/folders`), as `animated.dart` reads an animated
  MediaStore or PhotoKit item (`bytes`); `tools/tests/test_viewer_native.sh` checks the native side as text.
* Motion control (`attitude.dart`, M1-54) reads the sensors only while the app is resumed and no route covers the
  viewer (`SphereMotion.running`); `attitude_test.dart` fakes a phone's sensors (`Phone`) through traces of it set down,
  picked up and at rest, which a change to the filter keeps within 1°.
* The viewer lays out in a transparent `Scaffold` of its own, on which its snack bars show; a test finds a message
  within `ViewerPage`, as one on the library's `Scaffold` is in the tree but under the viewer.
* The bar (`toolbar.dart`, VIEW-40) has the same slots for every item: `pinsShown` folds the last pins into `⋮`, a pin an
  item cannot run is disabled in place, and what one kind of item has never enters it. `toolbar_test.dart` holds the
  fold rule at 320, 390, 520, 760 and 1100 dp; Settings › Viewing › its toolbar is `ToolbarPage`.
* Nothing but the user's own action moves the photo or the filmstrip (docs/10 §4.6): a tap hides the bar and arrows
  only, the strip is `Settings.filmstrip`, and `chrome_test.dart` holds the photo's rectangle and the strip's offset.
* The info panel's data beyond the row comes from `InfoFacts` (`info_facts.dart`), which tests fake with
  `test/support/info_facts.dart`; a section with nothing to show is absent, Albums and Tags excepted.
* A video opens paused unless `Toggle.autoplay`; `VideoPlayers.toggle` plays one, and the viewer's chrome hides while it
  plays (`video_cues_test.dart`, fake clock). `VideoView` is `video_view.dart`.
* On the web the HDR leaf is an `<img>` of the folder file (`hdr_display_web.dart`) where `(dynamic-range: high)`
  holds, for stills; `test/features/viewer/hdr_web_test.dart` runs in the `web` part (ADR-0390).
* A click leaves the focus in the viewer, whose Escape closes it: a `MenuAnchor` there takes a `MenuController` of
  `ViewerPage`'s, which Escape closes first (`⋮`, the dial's lenses).

## Downloads

* One action, `download` of `app/lib/features/download/download_action.dart` (ADR-0128), in the viewer and every
  `SelectionBar`, which requires it: the save dialog on desktops, the browser's downloads through `app/web/download.js`
  and its Service Worker (`download_sw.js`), the share sheet on phones (`ViewerChannel.kt`, `ShareSheet.swift`, at
  most `shareLimit` items; on iOS one share at a time, copying at most 2 GiB and at most 5 % of the free space). Albums
  download with `downloadAlbums`, a folder each when several.
  Several items stream as one stored zip64 (`zip.dart`); `test/features/download/zip_test.dart` holds 2,000 files of
  10 GB in constant memory, `node tools/download/test.mjs` the browsers.

## Desktop integration

* Drag and drop with the file manager (ADR-0144) is `app/lib/features/desktop/file_drag.dart` on `org.photolib/drag`:
  the runners (`file_drag.cc`, `FileDrag.swift`, `file_drag.cpp`) hand Dart the paths of a drop (folders join the
  library, photos and videos open in the viewer) and drag a cell's files out on a mouse drag, then tell Flutter the
  button went up. `tools/tests/test_desktop_drag.sh` checks them as text; `bash tools/smoke.sh linux` drags both ways
  with `tools/desktop/xdnd.c`. Files opened with the app (ADR-0154) are taken as a drop: `main`'s arguments on Linux
  and Windows, `opened` from `FileDrag.swift` on macOS; the associations are the Linux desktop entry, macOS's
  `CFBundleDocumentTypes` and the MSIX manifest in `app/{linux,windows}/packaging/` (`file_associations_test.dart`).
  One Photolib runs over the store (ADR-0206): a later start of the Linux app (a unique `GApplication`) or the Windows
  app (a session mutex, `WM_COPYDATA`) hands the running one its files, `opened` until Dart asks, and ends; a start
  by the flutter tool (`FLUTTER_ENGINE_SWITCHES`) runs on its own. `tools/package.sh appimage` checks it with
  `tools/desktop/single_instance.sh`.
* Idle CPU, < 1 % with a 100k library open, is `app/benchmark/idle_cpu.dart` in `tools/perf/run.sh`: run with
  `flutter run`, never under a test binding, which draws frames all the time.
* A later start hands the running app its `photolib:` links as they are, never as paths (ADR-0243), and the drop's log
  only counts them, as they hold a token; `single_instance.sh` checks it on a profile build: a release build seals
  its log.

## Video editing

* One planner, many engines (ADR-0043): `app/packages/photolib_video` plans an edit decision list once (`Plan.of`,
  which picks codec and device from the `Devices`' declared `Capability`s) and runs the plan with FFmpeg, Media3 or
  AVFoundation; executors never decide anything themselves.
* Its `flutter test` runs the shared fixtures in `testdata/edl/` through FFmpeg from `tools/video/ffmpeg.sh` (the
  pinned LGPL build on Linux x86-64, fetched with `curl` and `xz` on first use; elsewhere `ffmpeg` and `ffprobe` with
  libopenh264 and libsvtav1 on `PATH`, never built with `--enable-gpl`). Apps use only LGPL encoders: no libx264 or
  libx265 outside the server.

## iOS: PhotoKit and backup

* The PhotoKit indexer (ADR-0095) is `PhotoKitIndexer` in `photolib_data`, tested against a fake `PhotoKit` with its
  100k budgets in `test/photo_kit_test.dart`. `app/ios/Runner/PhotoKitChannel.swift` and `ThumbnailChannel.swift` serve
  it: keep their methods and JSON row order in step with the Dart; `tools/tests/test_photo_kit.sh` checks them as text
  and `bash tools/smoke.sh ios` runs them on a simulator.
* The backup strategy is ADR-0049. [docs/dev/ios-backup-spike.md](docs/dev/ios-backup-spike.md) holds the numbers that
  `bash tools/ios/photokit_probe.sh` measures on a Mac (a simulator, or a phone with `--device`). Nothing here compiles
  Swift: only that run builds `app/ios/RunnerTests/PhotoKitProbe.swift`; the gate runs the probe with stubbed tools.
* "Save to Photolib" is `app/ios/ShareExtension` (ADR-0143), Swift without Flutter: it copies shared photos and videos
  into the App Group's inbox, a manifest last, as `ShareInbox.swift` does for files opened in Photolib;
  `lib/core/share_inbox.dart` saves each entry into Photos at start, on resume and on `changed`, and the library says
  what waits for access. `tools/tests/test_share_extension.sh` checks them and the Xcode target.
* Home screen widgets (`app/ios/WidgetExtension`, WidgetKit without Flutter) read only the App Group's `Widgets/`, a
  `snapshot.json` and PNGs `lib/core/widget_snapshot.dart` writes (ADR-0153), never the replica; the app has
  WidgetKit reload them when it changed (`reloadWidgets`). `tools/tests/test_widget_extension.sh` checks them and the
  Xcode target. iOS's purpose strings are in `Runner/<language>.lproj/InfoPlist.strings`, the widgets' text in
  `WidgetExtension/<language>.lproj/Localizable.strings`.

## Server (Rust)

* [server/README.md](server/README.md) maps modules and test commands;
  [configuration](docs/admin/configuration.md) covers running `photolibd`.
* Database tests use throwaway PostgreSQL clusters (`photolib_db::testpg`). PostgreSQL 16+ programs
  (`initdb`, `pg_ctl`, `pg_dump`, `pg_restore`, `psql`) must be on `PATH`, in `/usr/lib/postgresql/<major>/bin`
  or in `TEST_PG_BIN`.
* An API error is an `rpc::ApiError` (Connect code, reason code, parameters), never prose: `server/clippy.toml`
  disallows the `ConnectError` constructors. A behaviour clients feature-detect adds a name to `rpc::CAPABILITIES`;
  `tests/contract.rs` pins what clients see on the wire, and `connect-conformance.yaml` the Connect subset.
* A new table is captured for sync (`txid`, `sync_capture` trigger, `photolib_db::sync::ENTITIES`) or listed as
  server-only in that module's test (ADR-0053); sync readers go through `photolib_db::sync` (`changes`, `newest`,
  `linked`), whose visibility is one query per page of ids, never a check per row.
* Sync streams are the tables of `rpc/sync.rs` with their hidden columns (ADR-0091): a synced table joins a stream
  there, and `sync_never_returns_what_the_policy_denies` syncs every stream of the authz world
  (`photolib-authz/tests/world.sql`) as every principal. `tests/sync.rs`, a binary of its own, holds the 100k-asset
  budget, which `tools/perf/run.sh` measures in a release build. The epoch is `<instance id>.<restores>`, counted in
  the data directory's marker by `photolibd restore`.
* Schema changes are new files in `server/migrations/` ([docs/dev/migrations.md](docs/dev/migrations.md)). Never edit
  one that is on `main`; after rebasing onto `main`, run `bash tools/migrations.sh --renumber`. A migration comes with
  its upgrade fixture and recorded resolutions in `server/migrations/fixtures/`, which `tests/upgrade_path.rs` checks
  ([upgrade-path harness](docs/dev/migrations.md#upgrade-path-harness)).
* New behaviour goes behind a port (`Database`, `JobQueue`, mount-table text) with a fake in `testing.rs`.
* Authorization (ADR-0038): every procedure has a rule in `rpc::ROUTES`, applied before its handler (a test matches
  them with `proto/`); handlers never check permissions: they take the admitted `Principal` and read through
  `photolib_authz::can` and `scope`, never around them. Add a row to the API matrix (`rpc/authz.rs`) for a procedure
  and to `photolib-authz/tests/matrix.rs` for an access path, resource or stream. An API key is `Principal::Key`, its
  account within its scopes (ADR-0055); both matrices have key columns. Covers, memories, face crops, search hits and
  map pins ask `can` about their own `Resource`, and adding an asset to an album asks about `Resource::Item`.
* The `users_audit` trigger audits every change to `users`: write accounts through `accounts::Accounts`, which names
  the actor in `photolib.actor`; other audit events go through the SQL function `audit_append` (ADR-0035).
  Tests touching `PHOTOLIB_*` use `figment::Jail`; never change the process environment otherwise. Tests reading
  what shared code logs use `testing::Capture::set_default` (tracing caches a callsite's interest across threads).
  A `PHOTOLIB_` variable that is no photolibd setting (CLI, compose, tools, tests) joins `NOT_SETTINGS` in `config.rs`,
  which photolibd ignores (`test_photolib_env.sh`).
* Requests are signed in through the `rpc::Sessions` port (`Auth`; `BearerSessions` fakes it in tests). Passwords are
  OPAQUE only (ADR-0052): tokens are stored as SHA-256, the OPRF seed and server key stay in
  `opaque_key_file` (beside the configuration file, never in `data_dir`), and tests sign in with an opaque-ke client
  (`rpc/auth.rs`).
  Adding a passkey or password, removing or replacing a second factor needs a proof under 5 minutes old (`Auth::fresh`,
  `sessions.proved_at`, ADR-0242); the app runs such calls through `withStepUp`, which asks and retries once.
* Raise `rust-version` with a reason when a dependency needs it. New crates join workspace `members` and inherit
  `license.workspace = true`.
* OIDC sign-in (ADR-0087): `oidc.rs` checks every answer and claim of a provider before use, `rpc/oidc.rs` signs in,
  links (issuer, subject) and provisions. Tests run `testing::Idp`, a loopback provider (RSA keys from `openssl`), and
  replay real sign-ins from `testdata/oidc/`; `tools/oidc/signin.py` records them and drives the ignored live test.
* Parse untrusted media only through `photolib_media` (`Worker`, `ExifTool`), never in a server process.
* `photolibd` opens one port, `listen`; `/metrics` is there only for the bearer of `metrics.token` (ADR-0046). The
  dashboards and alerts in `deploy/observability` query only exported metrics (a `metrics.rs` test);
  `tools/tests/test_observability.sh` checks the bundle with `tools/promtool.sh` (the deployed Prometheus release) and
  `docker compose config`.
* Admin operations are `AdminService` procedures (`rpc/admin.rs`, ADR-0063) under `Action::ManageServer`, each change
  committed with its `audit_append`; the app's console is `app/lib/features/admin/`, tested against
  `test/support/fake_server.dart`. An installation check joins `doctor.rs` (`photolibd doctor`, `/diagnostics`).
  API keys are `Principal::Key`.
* Background work is a job (`photolib-jobs`, ADR-0034): enqueue in the transaction that needs it; a handler writes
  only through the job's transaction, anything else idempotently. Tests that measure the whole cluster (WAL, chaos)
  get a test binary of their own under `crates/photolib-jobs/tests/`.
* Put, move and delete files only through `photolib_storage::journal::Journal` (ADR-0041); a bare `BlobStore` is
  for reads and markers. Ingest places originals once by the library's template; only the `relayout` job moves them,
  and sources go by delayed deletes (`delete_after`, the `storage-purge` job; ADR-0089). Storage tests start a
  throwaway Garage (`tools/garage.sh` fetches the pinned release, which the gate does before blocking egress, or set
  `TEST_GARAGE`).
* Uploads arrive on `/upload` (`uploads`, ADR-0061), never through Connect; the Dart client is
  `Server.createUpload`/`sendUpload`. Completing one queues the `ingest` job (`ingest`, ADR-0066), which reads files
  only through the kernel's ABI calls, as clients make them, and sniffs formats by magic bytes; its tests check the
  whole corpus against `client_side`, the kernel on the whole file. Store what a file says verbatim, as data. No parser
  reads a file that is no photo or video; it stays out of albums, partner shares and links (`photolib_authz`) and
  downloads only as a file, from the app's Collections › Other files (`otherFiles` of the replica). When `sniff` learns
  a format, bump `sniff::VERSION`: the `retype` sweep re-checks older assets without a media kind and queues the ingest
  of `unsupported` external files again.
  `PHOTOLIB_UPLOAD_BYTES=10000000000 cargo test -p photolib-server --test uploads` runs the weekly 10 GB case (20 GB
  of scratch under the target directory).
* Image renditions (ADR-0084) are made only by the `render` job with libvips in the sandbox
  (`photolib_media::render`), from the specs of `render::specs()`: change a spec's output and its id changes, so the
  reconciler renders it again. Building the server needs libvips ≥ 8.15 (`libvips-dev`, with `libheif-plugin-libde265`
  for HEIC; the gate checks it). Media bytes go out only through `/media` (`media`), behind `photolib_authz::can`; a
  refusal is an empty 404. A pooled renderer reuses its memory and decodes JPEGs sequentially (ADR-0122); the
  `Pooled` tests of `tests/renditions.rs` hold its page faults and peak through `/proc`.
* A video's renditions are `transcode` jobs on `worker:transcode` (`video`, ADR-0085): FFmpeg and ffprobe from
  `ffmpeg_dir`, each run once in the sandbox (`photolib_media::run`) on its slot's share of the cores (`Ffmpeg::new`'s
  `slots`; by default each decoder and filter takes a thread per core), outputs probed before they count.
  `tests/video.rs` renders every corpus video as a decodable twin of its golden record with `tools/video/ffmpeg.sh`
  (fetched before egress is blocked, or set `TEST_FFMPEG`), each command through `run`, which kills it after `FIXTURE`
  and fails with its command line and stderr; fixtures encode on one thread each (kvazaar `threads=0`), as a thread pool
  that cannot start its threads in the shared pid limit can hang; a tool that finds no thread to start ("Resource
  temporarily unavailable", EAGAIN) fails as `Failure::Transient`, which its job and the tests' renders and fixtures
  (`AGAIN`) try again, the renders a `Timeout` too, and the tests' jobs run until done or dead, as photolibd's retry;
  `node tools/video/play.mjs` (`web` part) plays each original or R1 in Chrome and Firefox. A new video case is a corpus
  record, not a new fixture.
* `photolib upload` (`crates/photolib-cli`, ADR-0065) keeps a journal per library and walks folders with the apps'
  rules (port `ignore.dart` changes too). `tests/upload.rs` runs it against photolibd, 100,000 files in the gate
  (`PHOTOLIB_CLI_FILES` sets fewer while you work).
* Deduplication is per user (ADR-0092): find files by hash only through `dedup`, which reads the owner's own
  libraries; an upload it holds already is linked at completion, and `SyncService.CheckHashes` answers devices.
* External libraries (`external`, ADR-0093) live only under `external_roots` and are never written: a `scan` job per
  folder records new files in `library_files` and queues their `ingest` in place (`storage = 'external'`, the path as
  key), `hash` jobs come last at priority −10; read their files only through `FsStore::entries`/`with_file` within the
  library's `Limits`, and render them from `Libraries::copy` into `local`. `PHOTOLIB_SCAN_FILES=2000000 cargo test -p
  photolib-server --test external` runs the 2M case by hand (8 GB of files and about 32 GB of renditions under the
  target directory, 4 GB of database under `TMPDIR`).
* The scrub (`scrub`, ADR-0234) is the only reader of whole stores: a `scrub` job every 15 minutes moves each store's
  cursors at the pace of `scrub_days`, records `integrity_findings` once while open and never writes, marks or deletes
  objects. A new kind of finding joins the `kind` check and `FindingKind`; devices report backups with
  `AuthService.ReportBackup`, which `device_backups` keeps.
* photolibd's own pages (`relay.rs`: `/passkey`, and `/` for password setup links, ADR-0243) run their script under
  `relay::CSP`, the one policy the request middleware keeps; the setup page speaks every launched language in the apps'
  words (`tools/tests/test_setup_page.sh`, `node --test`). `<base_path>/` is the app's `/`.
* A file with an open finding holds nothing for `dedup` (ADR-0252): an upload of its bytes into its owner's library
  puts it back (`Uploads::repair`). External libraries are scrubbed as the store `external` at their rates, and their
  findings name their library (`library_id`).
* Format coverage (M7-05, [report](docs/dev/format-coverage.md)): `tests/renditions.rs` renders every corpus image,
  HEIC, AVIF and JPEG XL placeholders as twins of the pinned FFmpeg; a file that cannot render is a row of the report's
  Exceptions, which stay under 2 % of the corpus. BMP and PSD/PSB composites decode in `photolib-media`'s `raster`.
* A device's *Not backed up* badges (ADR-0200) and the silence the server reads from `ReportBackup` derive from the
  same per-item backup state, never two computations (ADR-0234, the owner for M2-18 and M2-24).
* Events (ADR-0263) come from the `asset_events` triggers on `assets`, ids only; `events::page` is the one read path of
  `EventService` and webhook deliveries (the `events` job, `worker:io`): what the reader may view now, standard
  libraries only, below the sync watermark. A new type joins the `events.type` check, `TYPES` and `EventType`; payloads
  never carry content. Webhooks reach only what `events::reachable` allows; tests deliver to `localhost` receivers.
* Server policies (ADR-0240) are `policy_switches` rows that `photolib_authz` applies in `scope` and `can` before
  roles; a capability that refuses something new adds its `OFF` lines in `photolib-authz/tests/matrix.rs`. Presets and
  the configuration's pins (`settings:`, written at every start) are `policy.rs`; the API refuses a pinned setting
  with `setting.pinned`.
* Devices download models only through `GET /models/{id@revision}/{file}` (`models.rs`): files a device runs of the
  registry models `photolibd models fetch` installed, to a session or an API key; anything else is an empty 404.
* A device's vector arrives only as the `photolib-ml-{model,runtime,vector}` headers on `POST /upload`, checked there
  (`uploads::handoff`); ingest or a dedup link keeps it in `asset_embeddings` for standard libraries, the first stays.
* Streaming (`hls`, ADR-0246): every rung cuts the same grid of 2 s pieces (`video::Ffmpeg::ladder`), so pieces of any
  session or rung line up; R1's render spec keeps its pieces' index, the other rungs are sandboxed FFmpeg sessions in
  the `api` process. `tests/hls.rs` plays each rung out of order; `cargo test -p photolib-server --test hls --
  --ignored` (the `web` part, timed) plays the ladder with hls.js in Chrome and Firefox over a throttled link.
* The `ml` role (ADR-0245) runs models only through `photolib-ml`: ONNX Runtime loaded from `ml.runtime`, each
  backend proving the registry file's `golden` at start, work through its `Pool`. A registry file the server runs needs
  a `golden` (1,024 outputs of the fp32 model on the CPU, as `app/packages/photolib_ml/test/golden.json`). Its tests
  load ONNX Runtime and the face models through `photolib_ml::testing::onnx` (`tools/ml/fetch.py`, prefetched);
  `PHOTOLIB_ML_MODELS=all` adds SigLIP 2, `PHOTOLIB_ML_SOAK_SECS` lengthens the memory soak (`tests/memory.rs`).
* OCR (ADR-0388): `photolib_ml::ocr::read` runs PP-OCRv5 (the registry's `ppocr-v5-*`, dictionaries in `photolib-ml/data/ocr/`);
  `ml.ocr` makes the reconciler queue `ocr` jobs (`Profile.ocr`), which the `ml` role of a process with a database takes
  (`ocr.rs`, pixels from the sandbox as `Format::Raw`) into `asset_ocr`. `SearchService` (`search.rs`) is the only
  reader: by `scope`, ICU-folded substring. OCR text is data from any picture: never parsed, escaped where shown.
  `testdata/ocr/` holds its pictures (`make.py` makes them); `photolib_ml::testing::ocr()` fetches the models.
* LAN discovery (`discovery.rs`, OPS-29) only answers multicast DNS questions, never on a timer; its answer to the
  apps' question is `testdata/discovery/`, which the app's `nearby.dart` reads too: change both together.
* Scans skip what `photolib-ignore` names (the apps' rules, which `photolib upload` shares), and ingest reads a photo's
  `IMG.jpg.xmp` and `IMG.xmp` sidecars with the kernel: over its own metadata, keywords merged into the owner's tags,
  kept as `sidecar` files (ADR-0259).
* Private-mode keys (ADR-0255) are `account_keys.rs` and `KeyService`: photolibd keeps the wraps clients make and
  checks only their headers; `/upload` refuses a private library's upload until its uploader has two unlock paths and
  a verified recovery kit (`keys.recovery_incomplete`), and only a password sign-in returns the password path's wrap.
  The app's setup and drills are `app/lib/features/privacy/`, the kernel's part behind `custodyProvider`.
* Backups (`backup`, ADR-0266): the `backup` job dumps into `placement.backups` through the journal and queues the
  `restore-drill` job, which restores the newest dump into `<database>_drill`; each run is a row of `backup_runs`. A
  restore the console asks for waits in `.photolib/restore.json` for the next start. Manifests (`manifest`) are rows as
  PostgreSQL's JSON, a table each line: a table they hold that gains a reference to a new table needs that table in
  them too, or `recover --from-storage` sets the reference NULL. A job handler's future must be `Send` for every
  lifetime, which one awaiting `sqlx::raw_sql` (the migrations too) is not: the drill migrates on a blocking thread.
* `database.upgrade_from` copies the previous PostgreSQL major's database (ADR-0266); its test upgrades from the
  bundle's major minus one to the bundle's with PGDG's programs, which `tools/postgres.sh <major>` pins: bump them with
  the compose file's PostgreSQL ([releasing](docs/dev/releasing.md)). `testpg::database_on(bin)` starts a cluster of
  any PostgreSQL programs.
* Changes in external libraries (ADR-0257) are `external/scan.rs` and `watch.rs`: a root that lacks its fingerprint
  is offline and nothing changes, moves keep rows by inode, what a scan does not find turns missing, never deleted.
  Whatever deletes, trashes, hides or purges in bulk goes through `guard::Dry`: over 1,000 items or 5 % of its scope
  waits for its dry run's token.
  `PHOTOLIB_RESCAN_FILES=500000 cargo test -p photolib-server --test external` measures an unchanged rescan by hand.
* The trash (`trash`, ADR-0386) is emptied only by the `trash-empty` job (`SyncService.EmptyTrash` queues it, past
  `guard::Dry` with a token) and the daily `trash-expire`: each asset's rows and its `Journal::delete` intents switch in
  one transaction; external libraries' assets stay; `trash::tests` kills it with SIGKILL at every journal step. An
  account's hiding of an album (`album_user_state`) reaches `asset_user_state.album_hides_*` by triggers, so a timeline
  query never joins albums.
* Faces (ADR-0389): the account's `face_consents` row is the one gate. `faces::sweep` (the `faces-sweep` cron job) queues
  a `faces` job per photo of an account that agreed, and for a video up to 16 FFmpeg keyframes (`Ffmpeg::keyframes`);
  `FaceJob` re-reads the row `FOR SHARE` where it writes and renders raw pixels in the sandbox (`Format::Raw`); results
  are `faces` rows and a `face_scans` marker. `FaceService` consent routes take the session, never a key; `withdraw`
  deletes faces, people, scans and jobs in one transaction. `ml.faces` and `ml.face_embedder` (`sface`, or the optional
  registry model `auraface`, installed only when named) are the settings. `tests/faces.rs` runs YuNet and SFace on
  pinned portraits (`tools/ml/fetch.py` fixtures), with `TEST_FFMPEG` for the video case.
* HDR (ADR-0390, [docs/dev/hdr.md](docs/dev/hdr.md)): videos convert to SDR through `video::Ffmpeg::conversion` (libplacebo
  where a Vulkan device works in the sandbox, else zimg; `tone_mapping`), stills through `photolib_media::hdr`, and
  both must keep `tests/hdr.rs`'s patches neutral and not washed out; a gain map (`photolib_media::gainmap`, `heif`)
  is written again, never copied, so that nothing of a source's XMP reaches a rendition. Changing what an image or
  video rendition looks like bumps its generator version (`render::specs`, `video::GENERATOR_VERSION`).

## Deployment

* `deploy/Dockerfile` builds the image (ADR-0096): base images pinned by digest, libvips without its ImageMagick or PDF
  loaders, the `pg_dump` of the compose file's PostgreSQL major (`test_image.sh`). The gate has no Docker
  daemon; `bash tools/image.sh` builds and runs the image, weekly on amd64 and arm64.
* `deploy/compose` keeps every setting a line of `.env.example`, bind mounts only, `PUID:PGID` and read-only roots
  (`test_compose.sh`, through `docker compose config`).
* Proxy templates pass `cargo test -p photolib-server --test proxies`: Caddy, Traefik and cloudflared from
  `tools/proxies.sh`, nginx and Apache httpd (`apache2-bin`) from `PATH`. Each refuses `/metrics` and `/diagnostics`
  with 403: Prometheus and the doctor reach `listen` directly (ADR-0046).
* `deploy/helm/photolib` (`test_helm.sh`, Helm from `tools/helm.sh`), `deploy/nas` (`test_nas.sh`), the AppStream
  metainfo and F-Droid's recipe (`test_stores.sh`) carry `app/pubspec.yaml`'s version: bump them together.
* `deploy/debian` is the `photolibd` deb's service and configuration: photolibd runs its own PostgreSQL cluster
  (`database.cluster`, ADR-0249); `test_package.sh` installs and upgrades both debs with dpkg into a directory.

## Folders and albums

* Collections' Folders and Albums open `FoldersPage` (`app/lib/features/folders/`, ADR-0217): device folders from
  `deviceFolders`, album folders and albums from `albumChildren` (`photolib_data`'s `albums.dart`: UUIDv7 ids, the nil
  owner, no `txid`), and a folder's, album's or the favourites' items in `ItemsPage` in its `ItemView`, which the
  viewer and the item picker reuse. Manual order, pins, folder views and recent targets are the vault's sealed
  `folders` object (`folderViewsProvider`); an album's view is its row.
* File operations (`file_ops.dart`) touch desktop folder files only: renames through temporary names, never over a
  file; copies on a worker, verified by SHA-256, with the original's time; folder deletes into the platform's trash
  (`DeletionService`). Widget tests that reach the disk tap inside `tester.runAsync`, as what a tap starts runs in
  the tap's zone (`test/features/folders/folders_page_test.dart`).
* What a device keeps of the server's library is `StoragePolicy` and `OfflinePin` (`photolib_data`, ADR-0393, sealed
  vault objects `offline-policy` and `offline-pins/<replica>`), kept by `OfflineStore` (sealed chunks, a budget reserved
  before a byte is written) and `OfflineSync` passes that `offlineKeepingProvider` runs; never write offline bytes
  anywhere else, never decrypt a private library's file to disk, and let `mediaProvider` answer from the store.
* A server asset that no device item shows is an album item of source `server` (`albumItems`); players of server
  videos read `serverVideoUrlProvider`'s loopback proxy. `test/features/offline/airplane_test.dart` holds the 5,000-item
  airplane case (`OFFLINE_ASSETS` sets fewer); [offline notes](docs/dev/offline.md).

## Commits

Use [Conventional Commits](https://www.conventionalcommits.org/) (`type(scope): summary`), sign off with
`git commit -s` (DCO), and keep one logical change per green commit.

* `type` is one of `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
* `scope` is optional, lowercase: the top-level part, or `repo` for cross-cutting changes.
* Imperative summary, no final full stop, at most 72 characters for the whole subject. A blank line, then a body that
  explains why. PR titles use the same format: they become the squash message.
* Breaking changes use `!` after type/scope (`feat(proto)!: rename the sync cursor`) and a `BREAKING CHANGE:` footer.
* `bash tools/commitlint.sh origin/main..HEAD` checks a branch's messages.
* The `Signed-off-by: Name <email>` line certifies the [Developer Certificate of Origin](DCO); the email must be the
  commit's author or committer. The gate does not require it; `bash tools/dco.sh origin/dev..HEAD` checks a branch
  (merge commits are skipped and dependency-update bot accounts are exempt).
* Contributions are AGPL-3.0-only and keep their copyright; there is no CLA. [ADR-0013](docs/adr/0013-licence.md)
  records the rules for dependency licences (the allow-list in [`deny.toml`](deny.toml)), FFmpeg builds and weights.

## Merging

Never push to `main`. PRs close their tasks and auto-merge once
`bash tools/check.sh` passes on the branch, with no human review.

## Safety

* Never commit secrets, keys, tokens or real photos; `.gitignore` blocks common secret filenames.
* New outbound dependencies, telemetry or third-party services require an accepted ADR. Every endpoint or periodic
  task in product code is a row of the [privacy manifest](docs/admin/privacy.md) (kill switch off by default, timeout,
  far-future-date test; an endpoint also a self-hosted alternative), and photolibd's `outbound: none` turns every one
  off; `test_outbound.sh` enforces it.
* Keep the [threat model](docs/dev/threat-model.md) current: a change to a component, trust boundary or control
  updates its rows, and changes to auth, crypto, parsing, files, sharing or outbound connections answer its security
  review checklist.
* AGPL-3.0-only (ADR-0013): manifests declare `license = "AGPL-3.0-only"`; no source licence headers.
  Changes to `LICENSE` or the `deny.toml` allow-list need an ADR amendment. Dependencies, FFmpeg builds and model
  weights must meet that ADR.
