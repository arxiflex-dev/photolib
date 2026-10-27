#!/usr/bin/env bash
# Exercise the gate with isolated tool stubs, including missing and failing tools.
# shellcheck disable=SC2016 # stubs are literal scripts
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

GATE="$REPO_ROOT/tools/check.sh"
sandbox_tools bash env find sort mkdir cat rm dirname basename sed ln uname mktemp sleep mkfifo

# Each sandbox records the test suites tools/offline.sh would run with egress blocked, on CORES cores (12: three lanes).
gate_sandbox() {
  new_sandbox tools/check.sh "$@"
  printf '#!/bin/bash\necho "${CORES:-12}"\n' >"$SANDBOX/stubs/getconf"
  chmod +x "$SANDBOX/stubs/getconf"
  stub_command "$SANDBOX/tools/offline.sh" offline.sh
  mkdir -p "$SANDBOX/tools/lint"
  stub_command "$SANDBOX/tools/lint/ratchet.sh" ratchet.sh
}

# One part after another (CHECK_JOBS=1), so that calls.log keeps their order; CHECK_JOBS= runs the default. The tools
# not stubbed come from BASE_PATH (the real ones of sandbox_tools).
unset CHECK_JOBS # not the CHECK_JOBS of a gate that runs this test
# nor the filters and the report of a CI job that runs it
unset CI CHECK_ADVISORY_CI CHECK_STEPS CHECK_STEPS_EXCEPT CHECK_ADVISORY CHECK_PARTITION CHECK_REPORT CHECK_RETRIES CHECK_BUDGET_ATTEMPTS
run_gate() {
  OUT=$(cd "$SANDBOX" && CHECK_JOBS=${CHECK_JOBS-1} PATH="$SANDBOX/stubs:${BASE_PATH:-$BASE_BIN}" bash tools/check.sh "$@" 2>&1)
  STATUS=$?
}

# driver_reads <command> <description>: the gate failed with the line the merge train's driver (photolib-design
# tools/agent/workitem.py) reads a failed step from, `^check\.sh: failed: (.*) \(in (.*)\)$`, with that command. It takes
# a command that ends in tools/perf/run.sh for timing alone, so a step's why goes inside, before ` (in `.
driver_reads() {
  if [[ $STATUS -ne 0 ]] && grep -qxF "check.sh: failed: $1 (in .)" <<<"$OUT"; then ok "$2"; else
    fail "$2: no line 'check.sh: failed: $1 (in .)' in: $OUT"
  fi
}

# missing_tools <fixture> <part or empty for all> <subject> <fail|fails> <tool...>
missing_tools() {
  local fixture=$1 part=$2 subject=$3 verb=$4 missing
  shift 4
  for missing in "$@"; do
    "$fixture"
    rm "$SANDBOX/stubs/$missing"
    if [[ -n $part ]]; then
      run_gate "$part"
    else
      run_gate
    fi
    expect_result "$subject without $missing $verb loudly" failure "'$missing' is required"
  done
}

[[ -f "$GATE" ]] || fail "tools/check.sh does not exist"

gate_sandbox
run_gate
expect_result "empty repository passes" 0
[[ $OUT == *"with CHECK_JOBS=1"* ]] && ok "a sandbox gate runs one part at a time, whatever CHECK_JOBS this test inherits" ||
  fail "a sandbox gate inherited this test's CHECK_JOBS: $(tail -n 1 <<<"$OUT")"

rust_sandbox() {
  gate_sandbox cargo cargo-deny cargo-machete cargo-nextest rustup python3
  cp "$REPO_ROOT/tools/advisories.py" "$SANDBOX/tools/"
  mkdir -p "$SANDBOX/server"
  echo 'rust-version = "1.85"' >"$SANDBOX/server/Cargo.toml"
}

rust_calls() {
  cat <<CALLS
cargo fmt --check @$1
ratchet.sh clippy ${1#/} @
cargo machete @$1
offline.sh python3 $SANDBOX/tools/lint/panics.py cargo nextest run --locked --no-fail-fast --retries 3 --success-output immediate @$1
offline.sh python3 $SANDBOX/tools/lint/panics.py cargo test --locked --doc -- --show-output @$1
$(deny_calls "$1")
CALLS
}

deny_calls() {
  printf 'cargo deny --locked --config %s/deny.toml check bans licenses sources @%s\n' "$SANDBOX" "$1"
  printf 'python3 %s/tools/advisories.py cargo deny --locked --config %s/deny.toml check advisories @%s\n' \
    "$SANDBOX" "$SANDBOX" "$1"
}

msrv_calls() {
  printf 'rustup toolchain install %s --profile minimal @%s\ncargo +%s check --locked --workspace @%s\n' \
    "$2" "$1" "$2" "$1"
}

rust_sandbox
run_gate
expect_result "Rust workspace passes with a toolchain" 0
expect_calls "Rust workspace runs fmt, clippy, test and cargo-deny, then checks on its MSRV" "$(rust_calls /server)
$(msrv_calls /server 1.85)"

# CHECK_PARTITION=n/m runs one m-th of the tests (CI splits them over machines), and nothing else changes
rust_sandbox
CHECK_PARTITION=2/3 run_gate rust
[[ $(calls) == *"nextest run --locked --no-fail-fast --retries 3 --partition count:2/3 --success-output immediate"* ]] &&
  ok "CHECK_PARTITION gives nextest its share of the tests" || fail "no partition in the calls: $(calls)"

missing_tools rust_sandbox "" "Rust code" fails cargo cargo-deny cargo-machete cargo-nextest rustup python3

rust_sandbox
: >"$SANDBOX/server/Cargo.toml"
run_gate
expect_result "a Rust workspace without rust-version fails: the MSRV must be declared" failure "rust-version"

for failing in "cargo fmt --check" "ratchet.sh clippy server" "cargo machete" \
  "offline.sh python3 SANDBOX/tools/lint/panics.py cargo nextest run --locked --no-fail-fast --retries 3 --success-output immediate" \
  "offline.sh python3 SANDBOX/tools/lint/panics.py cargo test --locked --doc -- --show-output" \
  "cargo deny --locked --config SANDBOX/deny.toml check bans licenses sources" \
  "cargo +1.85 check --locked --workspace"; do
  rust_sandbox
  FAIL_ON=${failing//SANDBOX/$SANDBOX} run_gate
  expect_result "a failing '$failing' fails the gate" failure "${failing//SANDBOX/$SANDBOX} (in "
done

# --- A RustSec advisory is published against a locked crate whatever a branch changed (photolib-design#799): the gate
# prints it in full and names it in a warning, and passes; bans, licences and sources still fail it. The stubbed
# cargo-deny fails the check DENY_FAILS names (or every check) on a Cargo.lock holding crypto-bigint 0.5.5, printing
# what cargo-deny 0.20 prints for RUSTSEC-2026-0387.
FINDING='error[vulnerability]: Multiple timing variability issues in operations intended to be constant-time
   ┌─ Cargo.lock:20:1
   │
20 │ crypto-bigint 0.5.5 registry+https://github.com/rust-lang/crates.io-index
   │ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ security vulnerability detected
   │
   ├ ID: RUSTSEC-2026-0387
   ├ Solution: Upgrade to >=0.7.6 (try `cargo update -p crypto-bigint`)
'
deny_sandbox() {
  rust_sandbox
  ln -sf "$(command -v python3)" "$SANDBOX/stubs/python3"
  mkdir -p "$SANDBOX/kernel"
  : >"$SANDBOX/kernel/Cargo.toml"
  : >"$SANDBOX/kernel/Cargo.lock"
  printf '[[package]]\nname = "crypto-bigint"\nversion = "0.5.5"\n' >"$SANDBOX/server/Cargo.lock"
  printf '%s' "$FINDING" >"$SANDBOX/finding"
  cat >"$SANDBOX/stubs/cargo" <<STUB
#!/bin/bash
[[ \$1 == deny && (" \$* " == *" \$DENY_FAILS "* || \$* == *" check") && \$(<Cargo.lock) == *crypto-bigint* ]] || exit 0
[[ \$DENY_FAILS != advisories ]] || cat "$SANDBOX/finding"
echo "\$DENY_FAILS FAILED"
exit 1
STUB
}

deny_sandbox
DENY_FAILS=advisories run_gate rust
expect_result "a RustSec advisory fails no gate: it is printed in full and named, with its crate and workspace" 0 \
  "security vulnerability detected" "Solution: Upgrade to >=0.7.6" \
  "WARN advisories: RUSTSEC-2026-0387 crypto-bigint 0.5.5 in server"
[[ $(grep -c '^WARN advisories:' <<<"$OUT") -eq 1 ]] && ok "a workspace without the advisory gets no warning" ||
  fail "warnings for workspaces without the advisory: $(grep '^WARN' <<<"$OUT")"
for check in bans licenses sources; do
  deny_sandbox
  DENY_FAILS=$check run_gate rust
  expect_result "a failing cargo deny check of $check still fails the gate" failure "$check FAILED" \
    "check.sh: failed: cargo deny --locked --config $SANDBOX/deny.toml check"
done

# advisories <status> <output>: tools/advisories.py in server/ over a cargo-deny that prints <output> and exits <status>.
advisories() {
  printf '%s' "$2" >"$SANDBOX/out"
  OUT=$(cd "$REPO_ROOT/server" && python3 "$REPO_ROOT/tools/advisories.py" bash -c 'cat "$1"; exit "$2"' _ \
    "$SANDBOX/out" "$1" 2>&1)
  STATUS=$?
}
advisories 1 "${FINDING}error[yanked]: detected yanked crate (try \`cargo update -p spin\`)
    ┌─ Cargo.lock:120:1
    │
120 │ spin 0.9.6 registry+https://github.com/rust-lang/crates.io-index
    │ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ yanked version
"
expect_result "every finding of a run warns, a yanked crate as yanked" 0 \
  "WARN advisories: RUSTSEC-2026-0387 crypto-bigint 0.5.5 in server"$'\n'"WARN advisories: yanked spin 0.9.6 in server"
advisories 1 "[ERROR] failed to fetch advisory database: connection refused"
expect_result "an advisories run that fails naming no crate still fails" failure "failed to fetch advisory database"
advisories 1 "${FINDING}error[unknown-advisory]: advisory not found in any advisory database
  ┌─ deny.toml:9:11
  │
9 │ ignore = [\"RUSTSEC-2026-0000\"]
  │           ━━━━━━━━━━━━━━━━━━━ unknown advisory
"
expect_result "an error that names no crate (a span of deny.toml) fails the run, beside a finding too" failure \
  "WARN advisories: RUSTSEC-2026-0387 crypto-bigint 0.5.5 in server"

# The real cargo, rustfmt and clippy against a Cargo.lock that no longer matches its Cargo.toml (photolib-design#368).
if command -v cargo >/dev/null && command -v cargo-fmt >/dev/null && command -v cargo-clippy >/dev/null; then
  rust_sandbox
  for tool in cargo cargo-fmt cargo-clippy python3; do ln -sf "$(command -v "$tool")" "$SANDBOX/stubs/$tool"; done
  cp "$REPO_ROOT"/tools/lint/ratchet.{sh,py} "$SANDBOX/tools/lint/"
  mkdir -p "$SANDBOX/server/src"
  printf '[package]\nname = "stale"\nversion = "0.2.0"\nedition = "2021"\n' >"$SANDBOX/server/Cargo.toml"
  echo 'pub fn f() {}' >"$SANDBOX/server/src/lib.rs"
  printf 'version = 4\n\n[[package]]\nname = "stale"\nversion = "0.1.0"\n' >"$SANDBOX/server/Cargo.lock"
  cp "$SANDBOX/server/Cargo.lock" "$SANDBOX/lock"
  # cargo prefers the subcommands in CARGO_HOME/bin, such as the real cargo-deny, to the stubs on PATH.
  CARGO_HOME=$SANDBOX/cargo run_gate rust
  expect_result "a stale Cargo.lock fails the gate, and nothing else does" failure "because --locked was passed" \
    "check.sh: 1 problem(s):" "failed: bash tools/lint/ratchet.sh clippy server"
  cmp -s "$SANDBOX/lock" "$SANDBOX/server/Cargo.lock" && ok "the gate leaves a stale Cargo.lock as it is" ||
    fail "the gate rewrote a stale Cargo.lock"
else
  echo "skip: cargo, rustfmt or clippy is not installed; a stale Cargo.lock is not run through the real tools here"
fi

# The real cargo nextest runs the tests, each in a process of its own, and the panics lint reads its output: a test that
# passes while a thread it did not join panicked on an unwrap() fails the gate (photolib-design#542).
if command -v cargo >/dev/null && command -v cargo-nextest >/dev/null; then
  rust_sandbox
  for tool in cargo cargo-nextest python3; do ln -sf "$(command -v "$tool")" "$SANDBOX/stubs/$tool"; done
  stub_command "$SANDBOX/stubs/cargo-fmt" cargo-fmt
  printf '#!/bin/bash\nexec "$@"\n' >"$SANDBOX/tools/offline.sh"
  cp "$REPO_ROOT/tools/lint/panics.py" "$SANDBOX/tools/lint/"
  mkdir -p "$SANDBOX/server/src"
  printf '[package]\nname = "planted"\nversion = "0.0.0"\nedition = "2024"\nrust-version = "1.85"\n' \
    >"$SANDBOX/server/Cargo.toml"
  cat >"$SANDBOX/server/src/lib.rs" <<'RUST'
#[test]
fn catches_its_own_panic() {
    assert!(std::panic::catch_unwind(|| panic!("on purpose")).is_err());
}

#[test]
fn loses_a_panic_in_a_thread() {
    std::thread::spawn(|| None::<u8>.unwrap());
    std::thread::sleep(std::time::Duration::from_millis(200));
}
RUST
  (cd "$SANDBOX/server" && CARGO_HOME=$SANDBOX/cargo cargo generate-lockfile -q)
  CARGO_HOME=$SANDBOX/cargo CARGO_TARGET_DIR=$SANDBOX/target BASE_PATH=$PATH run_gate rust
  expect_result "under nextest, a test that loses an unwrap() panic in a thread fails the gate" failure \
    "Starting 2 tests across 1 binary" "panics.py: these threads panicked" \
    "loses_a_panic_in_a_thread: thread '<unnamed>' panicked at src/lib.rs:8:" "check.sh: 1 problem(s):"
  [[ $OUT != *"catches_its_own_panic: thread"* ]] && ok "a panic a test catches on its own thread is no finding" ||
    fail "the panic a test caught was reported: $OUT"
else
  echo "skip: cargo or cargo-nextest is not installed; the panics lint is not run on nextest's output here"
fi

# The scripts the gate runs build with --locked too, so none of them rewrites a stale Cargo.lock either.
assert_matches tools/connect_conformance.sh 'cargo build --locked' "the conformance server builds with --locked"
assert_matches tools/kernel/wasm.sh 'cargo build --locked' "the kernel's web build is locked"
assert_matches tools/perf/run.sh 'cargo run --locked' "the perf fixtures build with --locked"
assert_matches tools/perf/run.sh 'cargo test --locked' "the server benchmarks build with --locked"
assert_matches tools/playback/bench.mjs "'build', '--locked'" "the playback benchmark's kernel is locked"
assert_prose app/packages/photolib_kernel/lib/testing.dart "'build', '--locked'" "the Dart tests' kernel is locked"
assert_matches tools/video/play.mjs "'test', '--locked'" "the renditions' playback test builds with --locked"

gate_sandbox cargo cargo-deny cargo-machete cargo-nextest rustup python3
mkdir -p "$SANDBOX/server/crates/photolib-db" "$SANDBOX/kernel/fuzz"
echo 'rust-version = "1.85"' >"$SANDBOX/server/Cargo.toml"
: >"$SANDBOX/server/crates/photolib-db/Cargo.toml"
echo 'rust-version = "1.88"' >"$SANDBOX/kernel/Cargo.toml"
printf '[package]\nname = "fuzz"\n\n[workspace]\n' >"$SANDBOX/kernel/fuzz/Cargo.toml"
run_gate
expect_calls "nested crates are covered by their workspace; separate roots each run once, on their own MSRV; a \
workspace nested in a root's tree (kernel/fuzz, built only by nightly cargo-fuzz) gets the checks that build nothing" \
  "$(rust_calls /kernel)
$(rust_calls /server)
cargo fmt --check @/kernel/fuzz
$(deny_calls /kernel/fuzz)
$(msrv_calls /kernel 1.88)
$(msrv_calls /server 1.85)"

rust_sandbox
run_gate rust
expect_calls "'rust' runs the Rust checks but not the MSRV build" "$(rust_calls /server)"

rust_sandbox
run_gate msrv
expect_calls "'msrv' runs only the MSRV build" "$(msrv_calls /server 1.85)"

migrations_sandbox() {
  rust_sandbox
  mkdir -p "$SANDBOX/server/migrations"
  stub_command "$SANDBOX/tools/migrations.sh" migrations.sh
}

migrations_sandbox
run_gate rust
expect_calls "'rust' checks the migrations of a workspace before its Rust code" "migrations.sh server/migrations @
$(rust_calls /server)"

migrations_sandbox
FAIL_ON="migrations.sh server/migrations" run_gate rust
expect_result "an edited released migration or a squawk finding fails the gate" failure "migrations.sh"

rust_sandbox
mkdir -p "$SANDBOX/server/crates/photolib-storage"
stub_command "$SANDBOX/tools/garage.sh" garage.sh
run_gate rust
expect_calls "the Garage that the storage tests start is prefetched before any part runs" "garage.sh  @
$(rust_calls /server)"

# A prefetch that fails is run again (CHECK_RETRIES); one that still fails ends the gate with one clear message, because
# the tests run offline and cannot pass without it (run 40232538815: Garage's 503, then 20 minutes of failing tests).
rust_sandbox
mkdir -p "$SANDBOX/server/crates/photolib-storage"
# fails its first two runs, as a mirror that answers 503 twice
printf '#!/bin/bash\necho "garage.sh @" >>"%s/calls.log"\nn=$(cat "%s/n" 2>/dev/null || echo 0)\necho $((n + 1)) >"%s/n"\n[[ $n -ge 2 ]]\n' \
  "$SANDBOX" "$SANDBOX" "$SANDBOX" >"$SANDBOX/tools/garage.sh"
CHECK_RETRIES=3 run_gate rust
expect_result "a prefetch that fails twice then passes is retried, and the gate goes on" 0 "(passed on attempt 3 of 4)"
[[ $(calls) == *cargo* ]] && ok "the Rust checks ran after the retried prefetch" || fail "no cargo after it: $(calls)"

rust_sandbox
mkdir -p "$SANDBOX/server/crates/photolib-storage"
stub_command "$SANDBOX/tools/garage.sh" garage.sh
FAIL_ON="garage.sh " CHECK_RETRIES=3 run_gate rust
expect_result "a prefetch that keeps failing fails the gate with one message naming it" failure \
  "::error::prefetch failed: bash tools/garage.sh"
[[ $(grep -c 'garage.sh' "$SANDBOX/calls.log") == 4 ]] && ok "the prefetch ran 1 + CHECK_RETRIES times" ||
  fail "garage.sh ran $(grep -c 'garage.sh' "$SANDBOX/calls.log") times"
[[ $(calls) != *cargo* && $(calls) != *offline.sh* ]] && ok "no test ran offline after it" ||
  fail "the gate went on after a failed prefetch: $(calls)"

# photolibd's renderer links libvips (ADR-0084): checked before the workspace builds.
vips_sandbox() {
  rust_sandbox
  mkdir -p "$SANDBOX/server/crates/photolib-media"
  stub_command "$SANDBOX/stubs/pkg-config" pkg-config
}

vips_sandbox
run_gate rust
expect_calls "a workspace with the renderer needs libvips before it builds" "pkg-config --exists vips >= 8.15 @
$(rust_calls /server)"

vips_sandbox
FAIL_ON="pkg-config --exists vips >= 8.15" run_gate rust
expect_result "a renderer without libvips fails loudly" failure "libvips 8.15 or later is required"
[[ $(calls) != *cargo* ]] && ok "nothing builds without libvips" || fail "it built without libvips: $(calls)"

vips_sandbox
rm "$SANDBOX/stubs/pkg-config"
run_gate rust
expect_result "a renderer without pkg-config fails loudly" failure "'pkg-config' is required"

rust_sandbox
mkdir -p "$SANDBOX/server/crates/photolib-server" "$SANDBOX/tools/video"
stub_command "$SANDBOX/tools/video/ffmpeg.sh" ffmpeg.sh
stub_command "$SANDBOX/tools/proxies.sh" proxies.sh
stub_command "$SANDBOX/tools/postgres.sh" postgres.sh
run_gate rust
expect_calls "the FFmpeg of the video tests, the proxies of the proxy suite and the PostgreSQL majors of the upgrade test \
are prefetched before any part runs" "ffmpeg.sh  @
proxies.sh  @
postgres.sh  @
$(rust_calls /server)"

rust_sandbox
mkdir -p "$SANDBOX/server/crates/photolib-ml"
run_gate rust
case $(uname -sm) in
  "Linux x86_64") runtime='ort-linux-x64' ;; "Linux aarch64") runtime='ort-linux-arm64' ;; *) runtime='ort-macos-arm64' ;;
esac
expect_calls "the ONNX Runtime and face and text models and test photographs of photolib-ml's tests are prefetched before any part runs" \
  "python3 tools/ml/fetch.py $runtime yunet sface ppocr-v5-det ppocr-v5-rec-latin ppocr-v5-rec-eslav ppocr-v5-rec-chinese face-photo-armstrong-a face-photo-armstrong-b face-photo-magnus face-photo-crew @
$(rust_calls /server)"

rust_sandbox
mkdir -p "$SANDBOX/proto"
: >"$SANDBOX/proto/buf.yaml"
cp "$REPO_ROOT/tools/buf.sh" "$REPO_ROOT/tools/npm_tool.sh" "$SANDBOX/tools/"
run_gate proto
expect_result "'proto' without buf fails" failure "'buf' is required"
[[ -z "$(calls)" ]] && ok "'proto' runs no Rust check" || fail "'proto' ran other parts: $(calls)"

gate_sandbox
run_gate nonsense
expect_result "an unknown part fails and names it" failure "unknown part 'nonsense'"

dart_sandbox() {
  gate_sandbox dart flutter python3
  mkdir -p "$SANDBOX/app"
  [[ ${1:-} == test ]] && mkdir -p "$SANDBOX/app/test"
  : >"$SANDBOX/app/pubspec.yaml"
  echo '{ "flutter": "3.47.7" }' >"$SANDBOX/app/.fvmrc"
}

# dart_calls <dir> [test]: the calls of the only Dart part: its pin, its dependencies, then dart_checks.
dart_calls() {
  printf 'flutter --version --machine @/%s\nflutter pub get --enforce-lockfile @/%s\n' "$1" "$1"
  dart_checks "$@"
}

dart_checks() {
  cat <<CALLS
dart format --output=none --set-exit-if-changed . @/$1
ratchet.sh dart $1 @
python3 tools/dart_licenses.py $1 @
CALLS
  if [[ ${2:-} == test ]]; then echo "offline.sh flutter test @/$1"; fi
}

dart_sandbox test
run_gate
expect_result "Flutter app passes with a toolchain" 0
expect_calls "Flutter app checks the pinned version, resolves its dependencies, then runs format, analyze, the licence allow-list from the root, and test" "$(dart_calls app test)"

dart_sandbox
run_gate
expect_calls "a package without a test directory is formatted, analysed and licence-checked but has no tests to run" "$(dart_calls app)"

dart_sandbox
mkdir -p "$SANDBOX/app/packages/kernel/test" "$SANDBOX/app/lib" "$SANDBOX/app/packages/tool"
printf 'environment:\n  sdk: ^3.9.0\n' >"$SANDBOX/app/packages/kernel/pubspec.yaml"
: >"$SANDBOX/app/main.dart"
run_gate
# In a fresh checkout dart format took the language version of an unresolved package, the SDK's, and in app/ formatted
# the packages inside it too: every part resolves first, then formats only its own files in its pubspec's language
# version (photolib-design#360, photolib-design#481).
expect_calls "a package inside the app uses the app's pin, as FVM does, and is checked on its own, once every part has \
resolved its dependencies" "flutter --version --machine @/app
flutter --version --machine @/app/packages/kernel
flutter pub get --enforce-lockfile @/app
flutter pub get --enforce-lockfile @/app/packages/kernel
$(dart_checks app | sed 's/ \. @/ lib main.dart packages\/tool @/')
$(dart_checks app/packages/kernel test | sed 's/format /format --language-version=3.9 /')"

dart_sandbox test
printf 'hooks:\n  user_defines:\n    photolib_kernel:\n      artifacts: build/kernel/\n' >"$SANDBOX/app/pubspec.yaml"
run_gate dart
host=linux-$(uname -m | sed 's/x86_64/x64/; s/aarch64/arm64/')
expect_calls "an app whose build hook takes the kernel from a directory builds it there for this machine first" \
  "$(dart_calls app)
python3 tools/kernel/build.py --out app/build/kernel/ $host @
offline.sh flutter test @/app"

# ONNX Runtime's archive (ADR-0050): this machine's pin, verified and kept in the tools cache by tools/ml/fetch.py.
dart_sandbox test
printf 'hooks:\n  user_defines:\n    photolib_kernel:\n      artifacts: build/kernel/\n' >"$SANDBOX/app/pubspec.yaml"
printf '    photolib_ml:\n      runtime: build/onnxruntime/\n' >>"$SANDBOX/app/pubspec.yaml"
mkdir -p "$SANDBOX/tools/ml"
echo "{\"ort-$host\": {}}" >"$SANDBOX/tools/ml/artefacts.json"
run_gate dart
expect_calls "an app whose build hook takes ONNX Runtime's archive from a directory gets this machine's pin there" \
  "$(dart_calls app)
python3 tools/kernel/build.py --out app/build/kernel/ $host @
python3 tools/ml/fetch.py --archives app/build/onnxruntime/ ort-$host @
offline.sh flutter test @/app"

dart_sandbox test
printf 'hooks:\n  user_defines:\n    photolib_ml:\n      runtime: build/onnxruntime/\n' >"$SANDBOX/app/pubspec.yaml"
mkdir -p "$SANDBOX/tools/ml"
echo '{}' >"$SANDBOX/tools/ml/artefacts.json"
run_gate dart
expect_calls "a machine ONNX Runtime has no build for (an Intel Mac) needs no archive: its hook bundles none" \
  "$(dart_calls app test)"

web_app() {
  dart_sandbox test
  mkdir -p "$SANDBOX/app/web"
  : >"$SANDBOX/app/web/index.html"
}

web_app
run_gate
expect_calls "an app with a web/ folder also loads its web builds in Chrome and Firefox after its tests" "$(dart_calls app test)
python3 tools/web_requests.py app @"

web_app
FAIL_ON="python3 tools/web_requests.py app" run_gate
expect_result "a web build that requests another origin fails the gate" failure "web_requests.py"

dart_sandbox test
: >"$SANDBOX/app/build.yaml"
run_gate dart
expect_calls "a package with a build.yaml regenerates its committed code (build_runner, in JIT mode) first" \
  "flutter --version --machine @/app
flutter pub get --enforce-lockfile @/app
dart run build_runner build --force-jit --delete-conflicting-outputs @/app
dart format --output=none --set-exit-if-changed . @/app
ratchet.sh dart app @
python3 tools/dart_licenses.py app @
offline.sh flutter test @/app"

dart_sandbox test
: >"$SANDBOX/app/build.yaml"
mkdir -p "$SANDBOX/app/lib"
echo stale >"$SANDBOX/app/lib/replica.g.dart"
mv "$SANDBOX/stubs/dart" "$SANDBOX/stubs/dart-stub"
printf '#!/bin/bash\n[[ $1 == run ]] && echo fresh >lib/replica.g.dart\nexec dart-stub "$@"\n' >"$SANDBOX/stubs/dart"
chmod +x "$SANDBOX/stubs/dart"
run_gate dart
expect_result "committed generated code that a fresh build changes fails the gate" failure "generated code was stale"

# flutter pub get regenerates an app's localizations (generate: true) in place, from its l10n.yaml (photolib-design#538).
l10n_sandbox() {
  dart_sandbox test
  mkdir -p "$SANDBOX/app/lib/strings"
  echo 'arb-dir: lib/strings' >"$SANDBOX/app/l10n.yaml"
  echo committed >"$SANDBOX/app/lib/strings/app_localizations_en.dart"
  mv "$SANDBOX/stubs/flutter" "$SANDBOX/stubs/flutter-stub"
  printf '#!/bin/bash\n[[ $1 == pub ]] && echo %s >lib/strings/app_localizations_en.dart\nexec flutter-stub "$@"\n' \
    "$1" >"$SANDBOX/stubs/flutter"
  chmod +x "$SANDBOX/stubs/flutter"
  run_gate dart
}
l10n_sandbox regenerated
expect_result "committed localizations that flutter pub get regenerates differently fail the gate" failure \
  "app: generated localizations were stale; commit what 'flutter gen-l10n' regenerated"
l10n_sandbox committed
expect_result "committed localizations that pub get regenerates unchanged pass" 0

dart_sandbox test
: >"$SANDBOX/app/l10n.yaml"
run_gate dart
expect_result "a package whose committed localizations gen-l10n leaves as they are passes" 0
expect_calls "a package with an l10n.yaml regenerates its committed localizations (gen-l10n) first" \
  "flutter --version --machine @/app
flutter pub get --enforce-lockfile @/app
flutter gen-l10n @/app
$(dart_checks app test)"

# gen-l10n's output, named after l10n.yaml's output-localization-file, which every test passes with when it is stale
# (photolib-design#552).
dart_sandbox test
echo 'output-localization-file: strings.dart' >"$SANDBOX/app/l10n.yaml"
mkdir -p "$SANDBOX/app/lib/l10n"
echo stale >"$SANDBOX/app/lib/l10n/strings_ar.dart"
mv "$SANDBOX/stubs/flutter" "$SANDBOX/stubs/flutter-stub"
printf '#!/bin/bash\n[[ $1 == gen-l10n ]] && echo fresh >lib/l10n/strings_ar.dart\nexec flutter-stub "$@"\n' \
  >"$SANDBOX/stubs/flutter"
chmod +x "$SANDBOX/stubs/flutter"
run_gate dart
expect_result "committed localizations that gen-l10n changes fail the gate" failure "generated code was stale" \
  "flutter gen-l10n"

dart_sandbox test
printf '#!/bin/bash\necho rw,nosuid,noexec\n' >"$SANDBOX/stubs/findmnt"
chmod +x "$SANDBOX/stubs/findmnt"
mkdir -p "$SANDBOX/app/build"
PHOTOLIB_CACHE=$SANDBOX/cache run_gate dart
[[ $(readlink "$SANDBOX/app/build") == "$SANDBOX/cache/build$SANDBOX/app" && -d $SANDBOX/cache/build$SANDBOX/app ]] &&
  ok "on a noexec checkout, build/ (where build hooks put native libraries) moves to the private cache" ||
  fail "build/ was not moved to the cache on a noexec checkout: $(ls -l "$SANDBOX/app")"
rm -rf "$SANDBOX/cache"
PHOTOLIB_CACHE=$SANDBOX/cache run_gate dart
[[ -d $SANDBOX/app/build/ ]] && ok "a cleared cache is made again for the build/ that links to it" ||
  fail "build/ links to a cache that is gone: $(ls -l "$SANDBOX/app")"
printf '#!/bin/bash\necho rw,nosuid\n' >"$SANDBOX/stubs/findmnt"
rm -rf "$SANDBOX/cache"
PHOTOLIB_CACHE=$SANDBOX/cache run_gate dart
[[ ! -L $SANDBOX/app/build ]] && ok "once the checkout allows exec again, build/ no longer links to the cache" ||
  fail "build/ still links to the cache on a checkout that is not noexec: $(ls -l "$SANDBOX/app")"

dart_sandbox test
mkdir -p "$SANDBOX/app/build"
PHOTOLIB_CACHE=$SANDBOX/cache run_gate dart
[[ -d $SANDBOX/app/build && ! -L $SANDBOX/app/build ]] && ok "elsewhere build/ stays where it is" ||
  fail "build/ moved although the checkout is not noexec"

dart_sandbox
FAIL_ON="python3 tools/dart_licenses.py app" run_gate
expect_result "a Dart package outside the licence allow-list fails the gate" failure "dart_licenses.py"

dart_sandbox test
FAIL_ON="flutter pub get --enforce-lockfile" run_gate
expect_result "dependencies that do not resolve from the committed pubspec.lock fail the gate" failure \
  "failed: flutter pub get --enforce-lockfile (in app)"
expect_calls "a part whose dependencies do not resolve runs no other check, which would resolve them again" \
  "flutter --version --machine @/app
flutter pub get --enforce-lockfile @/app"

# The real dart and flutter on packages without .dart_tool/: one whose style (120 columns) comes from a package its
# analysis_options.yaml includes, inside another whose dart format formats it too. Both read that style once every
# part's dependencies resolve (photolib-design#360).
if command -v dart >/dev/null && command -v flutter >/dev/null; then
  dart_sandbox
  rm "$SANDBOX/stubs/"{dart,flutter}
  cp "$REPO_ROOT/app/.fvmrc" "$SANDBOX/app/"
  pkg=$SANDBOX/app/packages/pkg style=$SANDBOX/app/packages/style
  mkdir -p "$pkg/lib" "$style/lib"
  printf 'name: app\nenvironment:\n  sdk: ^3.9.0\n' >"$SANDBOX/app/pubspec.yaml"
  printf 'name: pkg\nenvironment:\n  sdk: ^3.9.0\ndev_dependencies:\n  style:\n    path: ../style\n' >"$pkg/pubspec.yaml"
  printf 'name: style\nenvironment:\n  sdk: ^3.9.0\n' >"$style/pubspec.yaml"
  printf 'formatter:\n  page_width: 120\n' >"$style/lib/analysis_options.yaml"
  echo 'include: package:style/analysis_options.yaml' >"$pkg/analysis_options.yaml"
  printf "const greeting = '%s';\n" "$(printf 'a%.0s' {1..90})" >"$pkg/lib/main.dart"
  # Their committed pubspec.lock, without the .dart_tool/ that made it.
  for dir in "$SANDBOX/app" "$pkg" "$style"; do (cd "$dir" && flutter pub get >/dev/null && rm -r .dart_tool); done
  BASE_PATH=$PATH run_gate dart
  expect_result "the first gate in a fresh checkout formats with the configured style, in a part and around it" 0

  # A pubspec.lock that still holds a dependency its pubspec.yaml dropped, as for Cargo.lock (photolib-design#497), in
  # a package whose browser test (dart test) would resolve it again, after the dart part or alone
  # (photolib-design#531).
  for parts in "dart web" web; do
    dart_sandbox
    rm "$SANDBOX/stubs/"{dart,flutter} "$SANDBOX/app/pubspec.yaml"
    cp "$REPO_ROOT/app/.fvmrc" "$SANDBOX/app/"
    api=$SANDBOX/app/packages/photolib_api
    stale_package "$api" photolib_api
    # shellcheck disable=SC2086 # the parts
    BASE_PATH=$PATH run_gate $parts
    expect_result "'$parts': a stale pubspec.lock fails the gate, and nothing else does" failure "Unable to satisfy" \
      "check.sh: 1 problem(s):" "failed: flutter pub get --enforce-lockfile (in app/packages/photolib_api)"
    cmp -s "$api.lock" "$api/pubspec.lock" && ok "'$parts' leaves a stale pubspec.lock as it is" ||
      fail "'$parts' rewrote a stale pubspec.lock"
  done
else
  echo "skip: dart or flutter is not installed; the format of packages without .dart_tool/ and a stale pubspec.lock" \
    "are not run here"
fi

dart_sandbox
rm "$SANDBOX/stubs/python3"
run_gate
expect_result "the Dart licence check without python3 fails loudly" failure "python3"

dart_sandbox test
FLUTTER_VERSION=3.48.0 run_gate
expect_result "a Flutter other than the pinned one fails and names both versions" failure "3.48.0"
[[ "$OUT" == *"3.47.7"* ]] && ok "the failure names the pinned version" || fail "the failure does not name the pin: $OUT"
expect_calls "a wrong Flutter version stops before any other check runs" "flutter --version --machine @/app"

dart_sandbox test
rm "$SANDBOX/app/.fvmrc"
run_gate
expect_result "a Flutter app without a pinned version fails" failure ".fvmrc"

dart_sandbox
rm "$SANDBOX/stubs/flutter"
run_gate
expect_result "Flutter code without flutter fails loudly" failure "flutter"

dart_sandbox
rm "$SANDBOX/stubs/dart"
run_gate
expect_result "Dart code without dart fails loudly" failure "dart"

proto_sandbox() {
  gate_sandbox
  mkdir -p "$SANDBOX/proto"
  : >"$SANDBOX/proto/buf.yaml"
  stub_command "$SANDBOX/tools/buf.sh" buf.sh
  stub_command "$SANDBOX/tools/proto_breaking.sh" proto_breaking.sh
}

proto_sandbox
run_gate
expect_calls "protobuf module runs buf lint, buf format and the breaking-change check" "buf.sh lint @/proto
buf.sh format --diff --exit-code @/proto
proto_breaking.sh proto @"

proto_sandbox
FAIL_ON="proto_breaking.sh proto" run_gate proto
expect_result "a breaking protobuf change fails the gate" failure "proto_breaking.sh"

proto_sandbox
FAIL_ON="buf.sh format --diff --exit-code" run_gate proto
expect_result "an unformatted protobuf file fails the gate" failure "buf.sh format"

gate_sandbox
mkdir -p "$SANDBOX/proto"
: >"$SANDBOX/proto/buf.yaml"
cp "$REPO_ROOT/tools/buf.sh" "$REPO_ROOT/tools/npm_tool.sh" "$SANDBOX/tools/"
run_gate
expect_result "protobuf without buf fails loudly" failure "'buf' is required"

codegen_sandbox() {
  proto_sandbox
  : >"$SANDBOX/proto/buf.gen.yaml"
  stub_command "$SANDBOX/tools/codegen.sh" codegen.sh
}

codegen_sandbox
run_gate proto
expect_calls "a codegen template installs the pinned plugins and checks the generated code" "buf.sh lint @/proto
buf.sh format --diff --exit-code @/proto
proto_breaking.sh proto @
codegen.sh install @
codegen.sh --check @"

codegen_sandbox
FAIL_ON="codegen.sh --check" run_gate proto
expect_result "stale generated code fails the gate" failure "codegen.sh --check"

conformance_sandbox() {
  rust_sandbox
  mkdir -p "$SANDBOX/server/crates/conformance"
  : >"$SANDBOX/server/crates/conformance/connect-conformance.yaml"
  stub_command "$SANDBOX/tools/connect_conformance.sh" connect_conformance.sh
}

conformance_sandbox
run_gate rust
expect_calls "the Connect conformance suite runs after the Rust checks" "$(rust_calls /server)
connect_conformance.sh server/crates/conformance @"

conformance_sandbox
FAIL_ON="connect_conformance.sh server/crates/conformance" run_gate rust
expect_result "a failing conformance suite fails the gate" failure "connect_conformance.sh"

missing_tools conformance_sandbox rust "a conformance server" fails cargo

# Real git and scripts; the commit already on origin/dev breaks every rule but is not checked.
git_sandbox() {
  gate_sandbox
  local tool
  for tool in git python3 grep head; do ln -s "$(command -v "$tool")" "$SANDBOX/stubs/$tool"; done
  cp "$REPO_ROOT"/tools/{commitlint.sh,dco.sh,flutter_upgrade_gate.py} "$SANDBOX/tools/"
  git -C "$SANDBOX" init -q
  sandbox_commit "merged long ago"
  git -C "$SANDBOX" update-ref refs/remotes/origin/dev HEAD
}

# sandbox_commit <message> [file]: commit everything added so far, and the file if one is given, running none of the
# caller's hooks (an agent's commit-msg hook would lint these messages with the sandbox's tools)
sandbox_commit() {
  [[ -n ${2:-} ]] && git -C "$SANDBOX" add "$2"
  git -C "$SANDBOX" -c core.hooksPath=/dev/null -c user.name=Tess -c user.email=tess@example.org \
    commit -q --allow-empty -m "$1"
}

HOOKS=$(mktemp -d)
printf '#!/bin/sh\nexit 1\n' >"$HOOKS/commit-msg"
chmod +x "$HOOKS/commit-msg"
GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=$HOOKS git_sandbox
check "fixture commits pass a git whose hooks refuse them" git -C "$SANDBOX" rev-parse -q --verify HEAD
rm -rf "$HOOKS"

SIGNED_OFF=$'\n\nSigned-off-by: Tess <tess@example.org>'

git_sandbox
sandbox_commit "feat(app): add a thing$SIGNED_OFF"
run_gate commits
expect_result "conventional, signed-off commits on top of origin/dev pass" 0

git_sandbox
sandbox_commit "Add a thing"
run_gate commits
expect_result "a commit that is not a Conventional Commit fails the gate" failure "commitlint.sh origin/dev..HEAD"

git_sandbox
mkdir -p "$SANDBOX/app" "$SANDBOX/.github/PULL_REQUEST_TEMPLATE"
cp "$REPO_ROOT/.github/PULL_REQUEST_TEMPLATE/flutter-upgrade.md" "$SANDBOX/.github/PULL_REQUEST_TEMPLATE/"
echo '{ "flutter": "3.47.7" }' >"$SANDBOX/app/.fvmrc"
sandbox_commit "build(app): pin Flutter$SIGNED_OFF" app/.fvmrc
git -C "$SANDBOX" update-ref refs/remotes/origin/dev HEAD
echo '{ "flutter": "3.48.0" }' >"$SANDBOX/app/.fvmrc"
sandbox_commit "build(app): upgrade Flutter$SIGNED_OFF" app/.fvmrc
run_gate commits
expect_result "moving the Flutter pin fails without the upgrade gates ticked" failure "flutter_upgrade_gate.py"
PR_BODY=$(sed 's/^- \[ \]/- [x]/' "$REPO_ROOT/.github/PULL_REQUEST_TEMPLATE/flutter-upgrade.md") run_gate commits
expect_result "the upgrade passes with every gate ticked in PR_BODY" 0

git_sandbox
git -C "$SANDBOX" update-ref -d refs/remotes/origin/dev
run_gate commits
expect_result "a branch without origin/dev to compare with fails and says so" failure "origin/dev"

gate_sandbox
mkdir "$SANDBOX/.git"
run_gate commits
expect_result "a repository without git fails loudly" failure "'git' is required"

node_sandbox() {
  gate_sandbox npm node python3
  mkdir -p "$SANDBOX/viewer"
  echo '{}' >"$SANDBOX/viewer/package.json"
}

node_sandbox
run_gate
expect_result "a TypeScript package passes with a toolchain" 0
expect_calls "a TypeScript package installs its lock file without scripts, type-checks, tests and checks licences" \
  "npm ci --ignore-scripts --no-audit --no-fund @/viewer
npm run typecheck @/viewer
offline.sh npm test @/viewer
python3 tools/node_licenses.py viewer @"

node_sandbox
mkdir -p "$SANDBOX/server"
echo 'rust-version = "1.85"' >"$SANDBOX/server/Cargo.toml"
run_gate node
expect_result "'node' runs only the TypeScript checks" 0

for failing in "npm ci --ignore-scripts --no-audit --no-fund" "npm run typecheck" "offline.sh npm test" \
  "python3 tools/node_licenses.py viewer"; do
  node_sandbox
  FAIL_ON=$failing run_gate node
  expect_result "a failing '$failing' fails the gate" failure "$failing (in "
done

missing_tools node_sandbox node "TypeScript code" fails npm node python3

gate_sandbox
mkdir -p "$SANDBOX/viewer/node_modules/dep"
echo '{}' >"$SANDBOX/viewer/node_modules/dep/package.json"
run_gate
expect_result "vendored node_modules do not count as a part" 0

# locked_call <dir>: the call that resolves a package from its committed pubspec.lock before a command that would
# resolve it implicitly (photolib-design#531).
locked_call() { echo "flutter pub get --enforce-lockfile @/$1"; }

web_sandbox() {
  gate_sandbox cargo rustup node dart flutter
  mkdir -p "$SANDBOX/kernel/wasm" "$SANDBOX/app/packages/photolib_kernel"
  : >"$SANDBOX/kernel/wasm/Cargo.toml"
}

web_package_sandbox() {
  local package=$1 marker=$2
  shift 2
  gate_sandbox "$@"
  mkdir -p "$SANDBOX/app/packages/$package/$(dirname "$marker")"
  : >"$SANDBOX/app/packages/$package/$marker"
}

stub_linux() {
  printf '#!/bin/bash\necho Linux\n' >"$SANDBOX/stubs/uname"
  chmod +x "$SANDBOX/stubs/uname"
}

WEB_TEST="dart test -p chrome -c dart2js -c dart2wasm -j 1 test/web_vectors_test.dart"

web_sandbox
run_gate web
expect_result "the kernel's web build passes with a toolchain" 0
expect_calls "'web' runs the kernel vectors in Chrome only, with dart2js and dart2wasm" \
  "$(locked_call app/packages/photolib_kernel)
$WEB_TEST @/app/packages/photolib_kernel"
for record in tools/check.sh AGENTS.md; do
  assert_prose "$record" 'photolib-design#288, confirmed in photolib-design#303\)' \
    "cites the owner's confirmation of Chrome only"
done

missing_tools web_sandbox web "the kernel's web build" fails cargo rustup node dart

web_sandbox
FAIL_ON=$WEB_TEST run_gate web
expect_result "failing browser vectors fail the gate" failure "failed: $WEB_TEST"

# the kernel's timing test, tagged timing in its dart_test.yaml, is left out of that run and gets a step of its own
web_sandbox
mkdir -p "$SANDBOX/app/packages/photolib_kernel"
printf 'tags:\n  timing:\n' >"$SANDBOX/app/packages/photolib_kernel/dart_test.yaml"
run_gate web
expect_calls "the kernel's web budget test, tagged timing, runs in a step of its own" \
  "$(locked_call app/packages/photolib_kernel)
dart test -p chrome -c dart2js -c dart2wasm -j 1 --exclude-tags timing test/web_vectors_test.dart @/app/packages/photolib_kernel
dart test -p chrome -c dart2js -c dart2wasm -j 1 --tags timing test/web_vectors_test.dart @/app/packages/photolib_kernel"

gate_sandbox dart
mkdir -p "$SANDBOX/app/packages/photolib_kernel"
run_gate web
expect_result "without kernel/wasm there is nothing for 'web' to check" 0

# ffmpeg.sh --libs prints where the pinned FFmpeg's libraries are, or fails with FFMPEG_FAILS.
data_web_sandbox() {
  web_package_sandbox photolib_data test/web_test.dart dart curl cargo rustup node flutter
  stub_linux
  mkdir -p "$SANDBOX/tools/video"
  printf '[[ -z ${FFMPEG_FAILS:-} && $1 == --libs ]] && echo /ffmpeg/lib\n' >"$SANDBOX/tools/video/ffmpeg.sh"
}
SERIAL_WEB_TEST="dart test -p chrome -p firefox -c dart2js -c dart2wasm -j 1 test/web_test.dart"

data_web_sandbox
run_gate web
expect_calls "'web' runs the replica's tests in Chrome and Firefox, with dart2js and dart2wasm" \
  "$(locked_call app/packages/photolib_data)
${SERIAL_WEB_TEST} test/sync_message_test.dart test/hash_url_test.dart @/app/packages/photolib_data"

missing_tools data_web_sandbox web "the replica's browser tests" fail dart curl cargo rustup node

data_web_sandbox
FAIL_ON="$SERIAL_WEB_TEST test/sync_message_test.dart test/hash_url_test.dart" run_gate web
expect_result "failing replica tests in a browser fail the gate; Firefox decodes with the pinned FFmpeg" failure \
  "failed: env MOZ_HEADLESS=1 LD_LIBRARY_PATH=/ffmpeg/lib $SERIAL_WEB_TEST"

data_web_sandbox
FFMPEG_FAILS=1 run_gate web
expect_result "the replica's browser tests fail the gate without the pinned FFmpeg" failure "tools/video/ffmpeg.sh"

api_web_sandbox() {
  web_package_sandbox photolib_api pubspec.yaml dart flutter
  stub_linux
}
API_WEB_TEST="dart test -p chrome -p firefox -c dart2js -c dart2wasm test/web_test.dart"

api_web_sandbox
run_gate web
expect_result "the API client's browser test passes with a toolchain" 0
expect_calls "'web' runs the API client's browser test in Chrome and Firefox, with dart2js and dart2wasm" \
  "$(locked_call app/packages/photolib_api)
$API_WEB_TEST @/app/packages/photolib_api"

api_web_sandbox
FAIL_ON=$API_WEB_TEST run_gate web
expect_result "a failing browser test of the API client fails the gate" failure "failed: env MOZ_HEADLESS=1 $API_WEB_TEST"

missing_tools api_web_sandbox web "the API client's browser test" fails dart flutter

# --- the worker pool on Web Workers: its browser test runs whenever the package exists
workers_web_sandbox() {
  web_package_sandbox photolib_workers pubspec.yaml dart flutter
}

workers_web_sandbox
run_gate web
expect_result "the worker pool's browser test passes with a toolchain" 0
expect_calls "'web' runs the worker pool's browser test in Chrome and Firefox, one suite at a time" \
  "$(locked_call app/packages/photolib_workers)
$SERIAL_WEB_TEST @/app/packages/photolib_workers"

workers_web_sandbox
FAIL_ON=$SERIAL_WEB_TEST run_gate web
expect_result "a failing browser test of the worker pool fails the gate" failure \
  "failed: env MOZ_HEADLESS=1 $SERIAL_WEB_TEST"

missing_tools workers_web_sandbox web "the worker pool's browser test" fails dart

# --- the ML runtime spike on the web: its test fetches onnxruntime-web and the models with tools/ml/fetch.py; on Linux,
# headless Chrome gets a WebGPU adapter through chrome_webgpu.sh
ml_web_sandbox() {
  web_package_sandbox photolib_ml test/web_test.dart dart python3 flutter
  stub_linux
}

ml_web_sandbox
run_gate web
expect_calls "'web' runs the ML spike in Chrome and Firefox, with dart2js and dart2wasm" \
  "$(locked_call app/packages/photolib_ml)
$SERIAL_WEB_TEST @/app/packages/photolib_ml"

missing_tools ml_web_sandbox web "the ML spike's browser tests" fail dart python3

ml_web_sandbox
FAIL_ON=$SERIAL_WEB_TEST run_gate web
expect_result "failing ML tests in a browser fail the gate; Chrome runs through chrome_webgpu.sh" failure \
  "CHROME_EXECUTABLE=$SANDBOX/app/packages/photolib_ml/tool/chrome_webgpu.sh $SERIAL_WEB_TEST"
[[ $(CHROME='echo' sh "$REPO_ROOT/app/packages/photolib_ml/tool/chrome_webgpu.sh" --headless) == \
  '--enable-unsafe-webgpu --headless' ]] && ok "chrome_webgpu.sh adds the WebGPU flag to the Chrome it runs" ||
  fail "chrome_webgpu.sh does not add --enable-unsafe-webgpu"

# --- encrypted playback: seeking in a two-hour encrypted video on every path, in Chrome and Firefox
playback_sandbox() {
  gate_sandbox node cargo rustup dart flutter
  mkdir -p "$SANDBOX/tools/playback" "$SANDBOX/app/packages/photolib_api"
  : >"$SANDBOX/tools/playback/bench.mjs"
}

playback_sandbox
run_gate web
expect_calls "'web' measures seeking on every encrypted playback path, its proxy in the API client" \
  "$(locked_call app/packages/photolib_api)
node tools/playback/bench.mjs @"

missing_tools playback_sandbox web "the playback benchmark" fails node cargo rustup dart

playback_sandbox
FAIL_ON="node tools/playback/bench.mjs" run_gate web
expect_result "a seek over budget fails the gate" failure "failed: node tools/playback/bench.mjs"

# Only a branch that changes playback code measures it (photolib-design#363): seek timings on a loaded machine must not
# make every merge flaky. Without a base to diff, as above, it measures (kept in photolib-design#560).
playback_change() {
  playback_sandbox
  ln -s "$(command -v git)" "$SANDBOX/stubs/git"
  git -C "$SANDBOX" init -q
  git -C "$SANDBOX" add -A
  sandbox_commit base
  git -C "$SANDBOX" update-ref refs/remotes/origin/dev HEAD
  mkdir -p "$SANDBOX/$(dirname "$1")"
  echo changed >>"$SANDBOX/$1"
  sandbox_commit change "$1"
  run_gate "${@:2}"
}
for path in app/packages/photolib_api/lib/media_proxy.dart app/packages/photolib_api/tool/decrypting_proxy.dart \
  kernel/src/blob.rs tools/playback/web/sw.js; do
  playback_change "$path" web
  expect_calls "a change to $path measures seeking" "$(locked_call app/packages/photolib_api)
node tools/playback/bench.mjs @"
done
playback_change app/lib/main.dart web
expect_result "a branch without playback code skips the benchmark and says so" 0 \
  "no playback code changed since origin/dev"
[[ -z $(calls) ]] && ok "the benchmark does not run" || fail "the benchmark ran: $(calls)"
playback_change tools/playback/bench.mjs web
mkdir -p "$SANDBOX/app/lib" && echo changed >"$SANDBOX/app/lib/main.dart" && sandbox_commit app app/lib/main.dart
: >"$SANDBOX/calls.log"
run_gate --since HEAD~1
[[ $OUT == *"no playback code changed since HEAD~1"* && $(calls) != *bench.mjs* ]] &&
  ok "--since <rev> measures only what changed since that revision" || fail "--since HEAD~1: $OUT $(calls)"

# --- web downloads: whole files in Chrome's and Firefox's own downloads, aborts leaving none (ADR-0128)
download_sandbox() {
  gate_sandbox node
  mkdir -p "$SANDBOX/tools/download"
  : >"$SANDBOX/tools/download/test.mjs"
}

download_sandbox
FAIL_ON="node tools/download/test.mjs" run_gate web
expect_result "a download the browsers do not save whole fails the gate" failure "failed: node tools/download/test.mjs"

missing_tools download_sandbox web "the web download test" fails node

# --- video renditions: what the server renders of every corpus video plays in Chrome and Firefox
renditions_sandbox() {
  gate_sandbox node cargo
  mkdir -p "$SANDBOX/tools/video"
  : >"$SANDBOX/tools/video/play.mjs"
}

renditions_sandbox
run_gate web
expect_calls "'web' plays every corpus video's rendition in the browsers" "node tools/video/play.mjs @"

for missing in node cargo; do
  renditions_sandbox
  rm "$SANDBOX/stubs/$missing"
  run_gate web
  expect_result "the renditions' playback without $missing fails loudly" failure "'$missing' is required"
done

renditions_sandbox
FAIL_ON="node tools/video/play.mjs" run_gate web
expect_result "a rendition a browser cannot play fails the gate" failure "failed: node tools/video/play.mjs"

# --- passkeys in Chrome through the relay page (ADR-0088): the photolibd test that the rust part skips
passkey_web_sandbox() {
  gate_sandbox cargo node
  mkdir -p "$SANDBOX/server/crates/photolib-server/tests"
  : >"$SANDBOX/server/crates/photolib-server/tests/passkeys.rs"
}
PASSKEY_TEST="cargo test --locked -p photolib-server --test passkeys -- --ignored"

passkey_web_sandbox
run_gate web
expect_calls "'web' signs in with a passkey in Chrome through the relay" "$PASSKEY_TEST @/server"

missing_tools passkey_web_sandbox web "the passkey browser test" fails cargo node

passkey_web_sandbox
FAIL_ON=$PASSKEY_TEST run_gate web
expect_result "a failing passkey browser test fails the gate" failure "failed: $PASSKEY_TEST"

# --- adaptive streaming in Chrome and Firefox through hls.js (ADR-0246): the photolibd test that the rust part skips
hls_web_sandbox() {
  gate_sandbox cargo node
  mkdir -p "$SANDBOX/server/crates/photolib-server/tests"
  : >"$SANDBOX/server/crates/photolib-server/tests/hls.rs"
}
HLS_TEST="cargo test --locked -p photolib-server --test hls -- --ignored"

hls_web_sandbox
run_gate web
expect_calls "'web' streams a video's ladder with hls.js in the browsers" "$HLS_TEST @/server"

missing_tools hls_web_sandbox web "the streaming browser test" fails cargo node

hls_web_sandbox
FAIL_ON=$HLS_TEST run_gate web
expect_result "a failing streaming browser test fails the gate" failure "failed: $HLS_TEST"

# --- the app's players: every corpus video and motion photo plays with them on this desktop, Linux's libmpv here
app_play_sandbox() {
  gate_sandbox flutter cargo pkg-config
  mkdir -p "$SANDBOX/tools/video" "$SANDBOX/app"
  stub_command "$SANDBOX/tools/video/app_play.sh" app_play.sh
}

app_play_sandbox
run_gate dart
expect_calls "'dart' plays every corpus video and motion photo with the app's players" "pkg-config --exists mpv @
$(locked_call app)
app_play.sh  @"

for missing in flutter cargo pkg-config; do
  app_play_sandbox
  rm "$SANDBOX/stubs/$missing"
  run_gate dart
  expect_result "the app's playback of the corpus without $missing fails loudly" failure "'$missing' is required"
done

app_play_sandbox
FAIL_ON="pkg-config --exists mpv" run_gate dart
expect_result "the app's playback without libmpv fails loudly" failure "libmpv is required"
[[ $(calls) != *app_play* ]] && ok "nothing plays without libmpv" || fail "it played without libmpv: $(calls)"

app_play_sandbox
FAIL_ON="app_play.sh " run_gate dart
expect_result "a corpus video the app cannot play fails the gate" failure "failed: bash tools/video/app_play.sh"

# --- the editor's shaders in Chrome: its browser test compiles them for the web and builds kernel/wasm
editor_web_sandbox() {
  web_package_sandbox photolib_editor test/web_test.dart flutter cargo rustup node
}
EDITOR_WEB_TEST="flutter test --platform chrome test/web_test.dart"

editor_web_sandbox
run_gate web
expect_calls "'web' runs the editor's shaders against the kernel in Chrome, on CanvasKit and on Skwasm" \
  "$(locked_call app/packages/photolib_editor)
$EDITOR_WEB_TEST @/app/packages/photolib_editor
flutter test --platform chrome --wasm test/web_test.dart @/app/packages/photolib_editor"

missing_tools editor_web_sandbox web "the editor's browser test" fails flutter cargo rustup node

editor_web_sandbox
FAIL_ON=$EDITOR_WEB_TEST run_gate web
expect_result "a failing browser test of the editor fails the gate" failure "failed: $EDITOR_WEB_TEST"

# --- the app in Chrome: the browser's thumbnail decoders in a worker, the log in IndexedDB and 360° videos at their
# golden frames, on CanvasKit and Skwasm
app_web_sandbox() {
  gate_sandbox flutter
  mkdir -p "$SANDBOX/app/test/features/library/timeline"
  : >"$SANDBOX/app/test/features/library/timeline/web_test.dart"
}
APP_WEB_FILES="test/features/library/timeline/web_test.dart test/core/log_web_test.dart"
APP_WEB_FILES+=" test/features/viewer/sphere_web_test.dart test/features/viewer/hdr_web_test.dart"
APP_WEB_TEST="flutter test --platform chrome $APP_WEB_FILES"

app_web_sandbox
run_gate web
expect_calls "'web' runs the app's browser tests in Chrome, on CanvasKit and on Skwasm" \
  "$(locked_call app)
$APP_WEB_TEST @/app
flutter test --platform chrome --wasm $APP_WEB_FILES @/app"

missing_tools app_web_sandbox web "the app's browser test" fails flutter

app_web_sandbox
FAIL_ON=$APP_WEB_TEST run_gate web
expect_result "a failing browser test of the app fails the gate" failure "failed: $APP_WEB_TEST"

# --- the other languages: every linter against the lint baseline, over what git tracks; clang-tidy on Linux
lint_sandbox() {
  gate_sandbox python3
  git -C "$SANDBOX" init -q
}
LINT_CALLS="ratchet.sh shellcheck . @
ratchet.sh ruff . @
ratchet.sh eslint . @
ratchet.sh swiftlint . @
ratchet.sh ktlint . @"
CLOCK_CALL="python3 tools/lint/clock.py @"

lint_sandbox
run_gate lint
expect_calls "'lint' runs shellcheck, ruff, eslint, SwiftLint and ktlint against the baseline, then the clock lint" \
  "$LINT_CALLS
$CLOCK_CALL"

lint_sandbox
stub_linux
mkdir -p "$SANDBOX/app/linux"
: >"$SANDBOX/app/linux/CMakeLists.txt"
run_gate lint
expect_calls "on Linux, clang-tidy compiles the Linux runner" "$LINT_CALLS
ratchet.sh clang-tidy app/linux @
$CLOCK_CALL"

lint_sandbox
FAIL_ON="ratchet.sh ruff ." run_gate lint
expect_result "a finding the baseline does not hold fails the gate" failure "failed: bash tools/lint/ratchet.sh ruff ."

missing_tools lint_sandbox lint "the lint ratchet" fails python3

gate_sandbox
run_gate lint
expect_result "outside a git checkout there is nothing tracked to lint" 0

docs_sandbox() {
  gate_sandbox "$@"
  : >"$SANDBOX/mkdocs.yml"
  printf 'echo docs.sh >>"%s"\n[[ $FAIL_ON == docs.sh ]] && exit 1\nexit 0\n' "$SANDBOX/calls.log" >"$SANDBOX/tools/docs.sh"
}

docs_sandbox python3
run_gate
expect_calls "a site config builds the documentation with tools/docs.sh" "docs.sh"

docs_sandbox
run_gate
expect_result "a documentation site without python3 fails loudly" failure "python3"

docs_sandbox python3
FAIL_ON=docs.sh run_gate
expect_result "a failing documentation build fails the gate" failure "docs.sh"

docs_sandbox python3 cargo
mkdir -p "$SANDBOX/server"
echo 'rust-version = "1.85"' >"$SANDBOX/server/Cargo.toml"
run_gate docs
expect_calls "'docs' runs only the documentation build" "docs.sh"

# --- performance: tools/perf/run.sh measures and checks the budgets whenever it exists, and instructions.sh compares
# the hot paths' instruction counts with the base
perf_sandbox() {
  local script
  gate_sandbox python3 cargo flutter git valgrind
  mkdir -p "$SANDBOX/tools/perf" "$SANDBOX/app"
  for script in instructions.sh run.sh; do
    printf 'echo %s >>"%s"\n[[ $FAIL_ON == %s ]] && exit 1\nexit 0\n' "$script" "$SANDBOX/calls.log" "$script" \
      >"$SANDBOX/tools/perf/$script"
  done
}

perf_sandbox
run_gate
expect_calls "the gate counts the hot paths' instructions against the base, then measures the budgets" "instructions.sh
$(locked_call app)
run.sh"

missing_tools perf_sandbox perf "the performance checks" fail python3 cargo flutter git valgrind

perf_sandbox
FAIL_ON=instructions.sh run_gate perf
expect_result "more instructions than the base fail the gate" failure "failed: bash tools/perf/instructions.sh"
expect_calls "instruction counts do not depend on timing: they are not measured twice" "instructions.sh
$(locked_call app)
run.sh"

perf_sandbox
FAIL_ON=run.sh run_gate perf
expect_result "a missed budget fails the gate" failure "failed: bash tools/perf/run.sh"
expect_calls "a missed budget is measured three times first" "instructions.sh
$(locked_call app)
run.sh
run.sh
run.sh"

# Each attempt gets, in $PERF_FAILED, what the one before it left there: the series that failed with each attempt's
# value, which it measures alone. Here viewer-folder's cold open against its 16 ms, measuring $VALUES in turn.
perf_attempts() {
  perf_sandbox
  cat >"$SANDBOX/tools/perf/run.sh" <<SCRIPT
read -ra before <"\$PERF_FAILED" && rm "\$PERF_FAILED"
echo run.sh \${before[*]} >>"$SANDBOX/calls.log"
read -ra values <<<"$1"
value=\${values[\${#before[@]}]}
((value <= 16)) && echo "ok   viewer-folder cold: \$value ms" && exit 0
echo "\${before[*]} \$value" >"\$PERF_FAILED"
echo "FAIL viewer-folder cold: \$value ms, before: \${before[*]}"
exit 1
SCRIPT
  run_gate perf
}
perf_attempts "25 44 11"
expect_result "a budget that passes its third attempt is flaky" 0 \
  "flaky (passed on attempt 3 of 3): [.] bash tools/perf/run.sh"
expect_calls "each attempt learns what failed the one before" "instructions.sh
$(locked_call app)
run.sh
run.sh 25
run.sh 25 44"
perf_attempts "25 44 30"
driver_reads "bash tools/perf/run.sh" "a budget that fails three times fails the gate, as timing"
expect_result "naming each attempt's value" failure "FAIL viewer-folder cold: 30 ms, before: 25 44"

# A part whose pubspec.lock the gate refused is resolved by nothing after it, which would rewrite the lock: not by the
# app's players, its browser tests or the perf budgets (photolib-design#531).
perf_sandbox
stub_linux
for tool in dart pkg-config; do stub_command "$SANDBOX/stubs/$tool" "$tool"; done
mkdir -p "$SANDBOX/app/test/features/library/timeline" "$SANDBOX/tools/video"
: >"$SANDBOX/app/test/features/library/timeline/web_test.dart"
: >"$SANDBOX/app/pubspec.yaml"
echo '{ "flutter": "3.47.7" }' >"$SANDBOX/app/.fvmrc"
stub_command "$SANDBOX/tools/video/app_play.sh" app_play.sh
FAIL_ON="flutter pub get --enforce-lockfile" run_gate dart web perf
expect_result "a refused pubspec.lock fails the gate once" failure "check.sh: 1 problem(s):"
expect_calls "a refused part's dependencies are resolved once, and nothing resolves them again" \
  "flutter --version --machine @/app
flutter pub get --enforce-lockfile @/app
pkg-config --exists mpv @
instructions.sh"

gate_sandbox
mkdir -p "$SANDBOX/tools/tests"
printf 'echo ran-good\nexit 0\n' >"$SANDBOX/tools/tests/test_good.sh"
run_gate
expect_result "passing repository tests pass the gate" 0
[[ "$OUT" == *ran-good* ]] && ok "repository tests are executed" || fail "repository tests were not executed: $OUT"

gate_sandbox
mkdir -p "$SANDBOX/tools/tests"
printf 'exit 0\n' >"$SANDBOX/tools/tests/test_a_good.sh"
printf 'echo broken-here >&2\nexit 1\n' >"$SANDBOX/tools/tests/test_b_bad.sh"
printf 'echo ran-last\nexit 0\n' >"$SANDBOX/tools/tests/test_c_good.sh"
run_gate
expect_result "a failing repository test fails the gate and is named" failure "test_b_bad.sh"
[[ "$OUT" == *ran-last* ]] && ok "tests after a failure still run" || fail "tests after a failure were skipped: $OUT"

# --- timings: every step prints its wall time when it ends; the gate ends with the slowest steps and the total
rust_sandbox
run_gate rust
[[ $(grep -c '^==> ' <<<"$OUT") -eq 7 &&
  $(grep -cE '^<== [0-9]+s \[(server|\.)\] (cargo|bash|python3)' <<<"$OUT") -eq 7 ]] &&
  ok "every step prints its wall time when it ends" || fail "steps without their wall time: $OUT"
[[ $OUT == *"check.sh: slowest steps:"*"s  [server] cargo fmt --check"* &&
  ${OUT##*$'\n'} =~ ^check.sh:\ total\ [0-9]+s ]] &&
  ok "the gate ends with the slowest steps and the total" || fail "no slowest steps or total at the end: $OUT"

assert_patterns assert_prose AGENTS.md 'bash tools/check.sh +# the full gate' "describes the full gate" \
  'the independent ones `CHECK_JOBS` \(default a quarter of the cores, one to four\) at a time' \
  "says the full gate runs parts side by side" \
  'bash tools/check.sh --since origin/dev +# an item' "describes the --since mode" \
  'msrv only in the full gate' "says msrv runs in the full gate only"

# --- --since <rev>: a repository with every part, in git; each part leaves its mark in calls.log
whole_sandbox() {
  gate_sandbox cargo cargo-deny cargo-machete cargo-nextest rustup dart flutter python3 npm node valgrind
  ln -s "$(command -v git)" "$SANDBOX/stubs/git"
  mkdir -p "$SANDBOX"/{server,app,viewer,proto,tools/perf,tools/download,tools/tests}
  echo 'rust-version = "1.85"' >"$SANDBOX/server/Cargo.toml"
  : >"$SANDBOX/app/pubspec.yaml"
  echo '{ "flutter": "3.47.7" }' >"$SANDBOX/app/.fvmrc"
  echo '{}' >"$SANDBOX/viewer/package.json"
  : >"$SANDBOX/proto/buf.yaml"
  : >"$SANDBOX/mkdocs.yml"
  : >"$SANDBOX/tools/download/test.mjs"
  local script
  for script in commitlint.sh dco.sh docs.sh buf.sh proto_breaking.sh perf/instructions.sh perf/run.sh tests/test_x.sh; do
    stub_command "$SANDBOX/tools/$script" "${script##*/}"
  done
  git -C "$SANDBOX" init -q
  git -C "$SANDBOX" add -A
  sandbox_commit base
  git -C "$SANDBOX" update-ref refs/remotes/origin/dev HEAD
}

ALL_PARTS="repo commits rust msrv dart web proto node docs lint perf"
ran_parts() {
  local mark ran=()
  for mark in repo:test_x.sh commits:commitlint.sh "rust:cargo fmt" "msrv:cargo +1.85" "dart:ratchet.sh dart" \
    web:download/test.mjs proto:buf.sh node:npm docs:docs.sh "lint:ratchet.sh shellcheck" perf:run.sh; do
    [[ $(calls) == *"${mark#*:}"* ]] && ran+=("${mark%%:*}")
  done
  echo "${ran[*]}"
}

# since_case <description> <path the branch changes> <the parts it must run>
since_case() {
  whole_sandbox
  mkdir -p "$SANDBOX/$(dirname "$2")"
  echo '# changed' >>"$SANDBOX/$2"
  sandbox_commit change "$2"
  run_gate --since origin/dev
  [[ $STATUS -eq 0 && $(ran_parts) == "$3" ]] && ok "$1" || fail "$1: exit $STATUS, ran $(ran_parts): $OUT"
}

since_case "--since: an app-only diff skips the Rust parts and MSRV" app/lib/main.dart "repo commits dart web perf"
expect_result "--since says which parts it ran and why" 0 "dart: app/lib/main.dart" "repo: always" \
  "skips rust msrv proto node docs lint"
since_case "--since: a server-only diff skips the Dart and web parts, and MSRV (full gate only)" server/src/lib.rs \
  "repo commits rust perf"
since_case "--since: a docs-only diff runs only repo, commits and docs" docs/index.md "repo commits docs"
since_case "--since: the benchmarks' harness, compiled into the Rust workspaces, runs rust and perf" \
  tools/perf/harness.rs "repo commits rust perf"
since_case "--since: a shell script runs the linters of the other languages" tools/x.sh "repo commits lint"
since_case "--since: the pre-queue script runs the repo part, which tests it, and the linters" tools/prequeue.sh \
  "repo commits lint"
since_case "--since: a Swift file in the app runs the app's parts and the linters" app/ios/Runner/A.swift \
  "repo commits dart web lint perf"
since_case "--since: a proto/ change runs every part" proto/photolib.proto "$ALL_PARTS"
expect_result "--since names the path that needs every part" 0 "proto/photolib.proto needs every part"
for path in kernel/src/lib.rs tools/check.sh tools/lint/baseline.json server/Cargo.lock app/pubspec.lock viewer/package-lock.json app/.fvmrc \
  viewer/.nvmrc rust-toolchain.toml server/Cargo.toml testdata/new.json; do
  since_case "--since: a change to $path runs every part" "$path" "$ALL_PARTS"
done

# --- the tests a diff changes run N times with no retry (tools/repeat.sh), after the parts, with --since only
whole_sandbox
stub_command "$SANDBOX/tools/repeat.sh" repeat.sh
mkdir -p "$SANDBOX/docs" && echo "# changed" >>"$SANDBOX/docs/index.md"
sandbox_commit change docs/index.md
run_gate --since origin/dev
expect_result "--since runs the repetition of the tests it changes, after its parts" 0 "=== repeat"
[[ $(calls) == *"repeat.sh --since origin/dev"* && $(calls | tail -n 1) == "repeat.sh"* ]] &&
  ok "tools/repeat.sh --since <rev> is the last call" || fail "repeat.sh was not the last call: $(calls)"
: >"$SANDBOX/calls.log"
CHECK_REPEAT=0 run_gate --since origin/dev
[[ $(calls) != *repeat.sh* ]] && ok "CHECK_REPEAT=0 skips it" || fail "CHECK_REPEAT=0 ran it: $(calls)"
: >"$SANDBOX/calls.log"
CHECK_REPEAT=3 run_gate --since origin/dev
[[ $(calls) == *"repeat.sh --since origin/dev"* ]] && ok "CHECK_REPEAT sets REPEAT_N" || fail "no repetition: $(calls)"
: >"$SANDBOX/calls.log"
run_gate
[[ $(calls) != *repeat.sh* ]] && ok "the full gate has no diff to repeat" || fail "the full gate ran it: $(calls)"
CHECK_REPEAT=x run_gate --since origin/dev
expect_result "CHECK_REPEAT must be a whole number" failure "CHECK_REPEAT must be a whole number"

whole_sandbox
run_gate --since nonsense
expect_result "--since with a revision git cannot diff fails and runs nothing" failure "nonsense...HEAD"
[[ -z $(calls) ]] && ok "nothing ran" || fail "parts ran without a diff: $(calls)"

# --- the full gate runs independent parts side by side: three parts that each wait (20 s at most) for all three
whole_sandbox
for name in tests/test_x docs buf; do
  cat >"$SANDBOX/tools/$name.sh" <<SCRIPT
echo "arrived ${name#*/}"
: >"$SANDBOX/at.${name#*/}"
for _ in {1..200}; do
  [[ -e $SANDBOX/at.test_x && -e $SANDBOX/at.docs && -e $SANDBOX/at.buf ]] && echo "left ${name#*/}" && exit 0
  sleep 0.1
done
exit 1
SCRIPT
done
CHECK_JOBS='' run_gate
expect_result "without arguments, on 12 cores, CHECK_JOBS (3) parts run at the same time" 0 "CHECK_JOBS=3"
for name in test_x docs buf; do
  [[ $(grep -A1 -m1 "^arrived $name$" <<<"$OUT" | sed -n 2p) == "left $name" ]] &&
    ok "the output of $name's part is kept together" || fail "the output of $name's part is interleaved: $OUT"
done

# --- CHECK_JOBS follows the cores: a quarter of them, one to four (photolib-design#543)
for cores_jobs in 2:1 4:1 8:2 16:4 64:4; do
  gate_sandbox
  CORES=${cores_jobs%:*} CHECK_JOBS='' run_gate repo
  expect_result "on ${cores_jobs%:*} cores CHECK_JOBS is ${cores_jobs#*:}" 0 "with CHECK_JOBS=${cores_jobs#*:}"
done

# --- dart and web are lanes of their own: side by side, web starts once dart has resolved the packages and generated
# their code, then a dart step and a web step that each wait (20 s at most) for the other pass
lanes_sandbox() {
  dart_sandbox test
  : >"$SANDBOX/app/build.yaml"
  mkdir -p "$SANDBOX/tools/download"
  : >"$SANDBOX/tools/download/test.mjs"
  local tool mine theirs
  for tool in python3 node; do
    [[ $tool == node ]] && mine=web theirs=dart || mine=dart theirs=web
    cat >"$SANDBOX/stubs/$tool" <<STUB
#!/bin/bash
echo "$tool \$* @\${PWD#$SANDBOX}" >>"$SANDBOX/calls.log"
[[ \$* == "tools/dart_licenses.py app" || $tool == node ]] || exit 0
: >"$SANDBOX/at.$mine"
for _ in {1..200}; do [[ -e $SANDBOX/at.$theirs ]] && exit 0; sleep 0.1; done
exit 1
STUB
  done
  mv "$SANDBOX/stubs/dart" "$SANDBOX/stubs/dart-stub"
  printf '#!/bin/bash\ndart-stub "$@" || exit\n[[ $1 != run ]] || { sleep 1; echo "codegen done" >>%q/calls.log; }\n' \
    "$SANDBOX" >"$SANDBOX/stubs/dart"
  chmod +x "$SANDBOX/stubs/"{python3,node,dart}
}

lanes_sandbox
CHECK_JOBS=2 run_gate dart web
expect_result "dart and web run as two lanes at the same time" 0 "check.sh: web waits for dart" "=== dart" "=== web"
[[ $(calls | grep -n -e '^codegen done$' -e '^node tools/download/test.mjs' | cut -d: -f2-) == "codegen done
node tools/download/test.mjs @" ]] && ok "the web lane starts once dart has generated the code" ||
  fail "the web lane did not wait for the code generation: $(calls)"

# With room for more than two lanes (CHECK_JOBS 3 or more) the dart lane runs the analysis, the web request check and the
# app's playback beside its tests: the same calls, the last two after the app's tests, and the part's output whole.
dart_beside_sandbox() {
  web_app
  mkdir -p "$SANDBOX/tools/video"
  stub_command "$SANDBOX/tools/video/app_play.sh" app_play.sh
  stub_command "$SANDBOX/stubs/cargo" cargo
  stub_command "$SANDBOX/stubs/pkg-config" pkg-config
}

dart_beside_sandbox
run_gate dart
one_after_another=$(calls | sort)
dart_beside_sandbox
CHECK_JOBS=4 run_gate dart repo
expect_result "dart beside its analysis, web requests and playback passes" 0 "=== dart took"
[[ $(calls | sort) == "$one_after_another" ]] && ok "beside each other, the dart lane makes the same calls" ||
  fail "the dart lane's calls differ beside each other: $(calls | sort)"
tests_at=$(calls | grep -n -m 1 '^offline.sh flutter test' | cut -d: -f1)
for later in 'python3 tools/web_requests.py' 'app_play.sh'; do
  later_at=$(calls | grep -n -m 1 -F "$later" | cut -d: -f1)
  ((tests_at < later_at)) && ok "$later starts after the app's tests" || fail "$later started before them: $(calls)"
done
(($(grep -c '^=== dart took' <<<"$OUT") == 1)) && ok "the dart part's output ends once" ||
  fail "the dart part ended more than once: $OUT"

dart_beside_sandbox
FAIL_ON="python3 tools/web_requests.py app" CHECK_JOBS=4 run_gate dart repo
expect_result "a web request failure beside the tests fails the gate" failure "web_requests.py"
[[ $OUT == *"check.sh: failed: python3 tools/web_requests.py"*"=== dart took"* ]] &&
  ok "its failure is in the dart part's output, before it ends" || fail "the failure is outside the dart part: $OUT"

# The analysis runs while the tests do: here it waits up to 10 s for the app's tests to start, which in the part's
# order, as with two jobs, start only after it.
analysis_waits() {
  dart_beside_sandbox
  printf '#!/bin/bash\nfor _ in {1..100}; do [[ -e %q/tested ]] && exit 0; sleep 0.1; done\nexit 1\n' "$SANDBOX" \
    >"$SANDBOX/tools/lint/ratchet.sh"
  printf '#!/bin/bash\n: >%q/tested\n' "$SANDBOX" >"$SANDBOX/tools/offline.sh"
  CHECK_JOBS=$1 run_gate dart repo
}
thawed analysis_waits 4
expect_result "with four jobs the analysis runs beside the tests" 0
thawed analysis_waits 2
expect_result "with two it runs before them, as one after another" failure "failed: bash tools/lint/ratchet.sh dart app"

# One after another (CHECK_JOBS=1) the parts run in the order given: web before dart waits for nothing.
dart_sandbox test
stub_command "$SANDBOX/stubs/node" node
mkdir -p "$SANDBOX/tools/download"
: >"$SANDBOX/tools/download/test.mjs"
run_gate web dart
expect_result "one after another, web runs before dart when asked to" 0
[[ $(calls | head -n 1) == "node tools/download/test.mjs @" && $OUT != *"web waits"* ]] &&
  ok "web waits for nothing when dart has not run" || fail "web waited or ran late: $(calls)"

# The web lane alone, in a fresh checkout on a noexec mount: it resolves its packages and moves their build/ itself.
api_web_sandbox
printf '#!/bin/bash\necho rw,nosuid,noexec\n' >"$SANDBOX/stubs/findmnt"
chmod +x "$SANDBOX/stubs/findmnt"
PHOTOLIB_CACHE=$SANDBOX/cache CHECK_JOBS='' run_gate web
expect_result "the web lane passes alone in a fresh checkout" 0
[[ $(readlink "$SANDBOX/app/packages/photolib_api/build") == "$SANDBOX/cache/build$SANDBOX/app/packages/photolib_api" ]] &&
  ok "alone, the web lane moves its packages' build/ to the private cache" ||
  fail "the web lane left build/ on the noexec checkout: $(ls -l "$SANDBOX/app/packages/photolib_api")"

# --- the timing-sensitive steps (frame budgets in the VM and in browsers, perf) run alone after every other step
budget_sandbox() {
  whole_sandbox
  local package
  for package in photolib_data photolib_workers; do
    mkdir -p "$SANDBOX/app/packages/$package/test"
    : >"$SANDBOX/app/packages/$package/pubspec.yaml"
  done
  printf 'sleep 1\necho repo-done >>"%s/calls.log"\n' "$SANDBOX" >"$SANDBOX/tools/tests/test_x.sh"
}

budget_sandbox
CHECK_JOBS='' run_gate
expect_result "the full gate passes side by side" 0
[[ $(calls | tail -n 5) == "offline.sh flutter test @/app/packages/photolib_data
offline.sh flutter test @/app/packages/photolib_workers
$SERIAL_WEB_TEST @/app/packages/photolib_workers
instructions.sh  @
run.sh  @" ]] && ok "frame budgets in the VM and in browsers, then perf, start once every other step has ended" ||
  fail "the timing-sensitive steps did not run alone after the rest: $(calls)"

# Failures in five parts and in a timing-sensitive step: the same exit status and problem list either way.
budget_sandbox
rm "$SANDBOX/stubs/npm"
echo 'exit 1' >"$SANDBOX/tools/docs.sh"
echo 'exit 1' >"$SANDBOX/tools/tests/test_x.sh"
echo 'exit 1' >"$SANDBOX/tools/offline.sh"
problems() { echo "$STATUS"; grep '^  - ' <<<"$OUT"; }
FAIL_ON="cargo fmt --check" run_gate
sequential=$(problems)
FAIL_ON="cargo fmt --check" CHECK_JOBS='' run_gate
[[ $(problems) == "$sequential" && $sequential == "1
  - failed: bash tools/tests/test_x.sh (in .)
  - failed: cargo fmt --check (in server)
  - failed: bash $SANDBOX/tools/offline.sh python3 $SANDBOX/tools/lint/panics.py cargo nextest run --locked --no-fail-fast --retries 3 --success-output immediate (in server)
  - failed: bash $SANDBOX/tools/offline.sh python3 $SANDBOX/tools/lint/panics.py cargo test --locked --doc -- --show-output (in server)
  - failed: bash $SANDBOX/tools/offline.sh flutter test (in app/packages/photolib_data)
  - failed: bash $SANDBOX/tools/offline.sh flutter test (in app/packages/photolib_workers)
  - 'npm' is required for the TypeScript code in viewer/package.json but is not on PATH
  - failed: bash tools/docs.sh (in .)" ]] &&
  ok "side by side, the exit status and problem list equal a sequential run's" ||
  fail "the problem lists differ: sequential
$sequential
side by side
$(problems)"

# --- a failing timing-sensitive step is measured up to three times (photolib-design#749); a pass on a later attempt is
# flaky, not a failure. The stub measures 11 ms on its first attempt, 22 on its second and 33 on its third.
flaky_sandbox() {
  dart_sandbox
  mkdir -p "$SANDBOX/app/packages/photolib_data/test"
  : >"$SANDBOX/app/packages/photolib_data/pubspec.yaml"
  cat >"$SANDBOX/tools/offline.sh" <<SCRIPT
echo "offline.sh \$* @\${PWD#$SANDBOX}" >>"$SANDBOX/calls.log"
[[ \$PWD == */photolib_data ]] || exit 0
echo run >>"$SANDBOX/runs"
mapfile -t runs <"$SANDBOX/runs"
echo "measured \$((\${#runs[@]} * 11)) ms"
((\${#runs[@]} > FAILS))
SCRIPT
  step="[app/packages/photolib_data] bash $SANDBOX/tools/offline.sh flutter test"
}
data_runs() { grep -c "offline.sh flutter test @/app/packages/photolib_data" <<<"$(calls)"; }

flaky_sandbox
FAILS=1 run_gate dart
expect_result "a timing-sensitive step that passes on its second attempt passes the gate, reported as flaky" 0 \
  "check.sh: flaky (passed on attempt 2 of 3): $step"
[[ $(data_runs) -eq 2 ]] && ok "it ran twice" || fail "it ran $(data_runs) times"

flaky_sandbox
FAILS=2 run_gate dart
expect_result "a timing-sensitive step that fails twice and passes on its third attempt passes the gate, flaky" 0 \
  "check.sh: flaky (passed on attempt 3 of 3): $step"
[[ $(data_runs) -eq 3 ]] && ok "it ran three times" || fail "it ran $(data_runs) times"

flaky_sandbox
FAILS=3 run_gate dart
expect_result "a timing-sensitive step that fails three times fails the gate, each attempt's value in its output" \
  failure "check.sh: 1 problem(s):" \
  "failed: bash $SANDBOX/tools/offline.sh flutter test (in app/packages/photolib_data)" \
  "measured 11 ms
check.sh: $step failed attempt 1 of 3: once more
measured 22 ms
check.sh: $step failed attempt 2 of 3: once more
measured 33 ms
check.sh: failed: "
[[ $(data_runs) -eq 3 ]] && ok "it ran three times, no more" || fail "it ran $(data_runs) times"
assert_prose AGENTS.md 'step that fails is measured up to three times.{0,120}PERF_FAILED.{0,80}value.{0,80}flaky' \
  "AGENTS.md says a timing step is measured up to three times, each attempt's value kept, a late pass flaky"

dart_sandbox test
FAIL_ON="offline.sh flutter test" run_gate dart
expect_calls "no other step is rerun" "$(dart_calls app test)"

# --- tests tagged `alone` in dart_test.yaml measure time on the whole machine: a timing-sensitive step of their own
ALONE="offline.sh flutter test --tags alone -j 1"
dart_sandbox test
printf 'tags:\n  alone:\n' >"$SANDBOX/app/dart_test.yaml"
FAIL_ON=$ALONE run_gate dart
expect_calls "tests tagged alone run after the rest of their suite, one file at a time, three times when they fail" \
  "$(dart_calls app)
offline.sh flutter test --exclude-tags alone @/app
$ALONE @/app
$ALONE @/app
$ALONE @/app"

# --- tests tagged `timing` are left out of their suite's run and get a step of their own, which fails the gate here
FLAKY="offline.sh flutter test --tags timing"
dart_sandbox test
printf 'tags:\n  timing:\n' >"$SANDBOX/app/dart_test.yaml"
FAIL_ON=$FLAKY run_gate dart
expect_result "a failing flaky test fails the gate where CHECK_ADVISORY is not set" failure "offline.sh flutter test --tags timing"
expect_calls "tests tagged timing run after the rest of their suite in a step of their own" \
  "$(dart_calls app)
offline.sh flutter test --exclude-tags timing @/app
$FLAKY @/app"
CHECK_ADVISORY='--tags timing' FAIL_ON=$FLAKY run_gate dart
expect_result "and passes it where CHECK_ADVISORY names the step" 0

budget_sandbox
printf 'tags:\n  alone:\n' >"$SANDBOX/app/packages/photolib_data/dart_test.yaml"
CHECK_JOBS='' run_gate
[[ $(calls | tail -n 6) == "offline.sh flutter test --exclude-tags alone @/app/packages/photolib_data
$ALONE @/app/packages/photolib_data
offline.sh flutter test @/app/packages/photolib_workers
$SERIAL_WEB_TEST @/app/packages/photolib_workers
instructions.sh  @
run.sh  @" ]] && ok "side by side, tests tagged alone run among the timing-sensitive steps" ||
  fail "tests tagged alone did not run among the timing-sensitive steps: $(calls)"

data=$REPO_ROOT/app/packages/photolib_data
grep -qx '  alone:' "$data/dart_test.yaml" && grep -q "tags: 'alone'" "$data/test/store_cost_test.dart" &&
  ok "the local store's overhead budgets run alone" || fail "photolib_data's store_cost_test.dart is not tagged alone"
# A loaded machine's disk stalled the vault's first fsync past the default 30 s (photolib-design#530).
grep -qx 'timeout: 4x' "$data/dart_test.yaml" && ok "photolib_data's tests outlast an fsync that stalls for 30 s" ||
  fail "photolib_data's dart_test.yaml does not give its tests 4x the default timeout"
# Beside the rest of the suite, the app's loops of file I/O and decodes outlasted 30 s (photolib-design#654).
grep -qx 'timeout: 4x' "$REPO_ROOT/app/dart_test.yaml" && ok "the app's tests outlast a loaded machine's 30 s" ||
  fail "app/dart_test.yaml does not give the app's tests 4x the default timeout"
# Synced beside them, a million assets starved the suite's other tests past their timeouts (photolib-design#530).
grep -q "tags: 'alone'" "$data/test/sync_budget_test.dart" && ok "the initial sync's frame budget runs alone" ||
  fail "photolib_data's sync_budget_test.dart is not tagged alone"
# Beside the suite's other files, its 100k indexes, extractions and searches outlasted their budgets
# (photolib-design#573, photolib-design#603).
for budget in media_store_test:1 photo_kit_test:1 extraction_test:2 search_test:1; do
  [[ $(grep -c "tags: 'alone'" "$data/test/${budget%:*}.dart") == "${budget#*:}" ]] && ok "${budget%:*}'s 100k cases run alone" ||
    fail "photolib_data's ${budget%:*}.dart does not tag its ${budget#*:} 100k case(s) alone"
done

# --- the prefetch (photolib-design#441): what the suites run with egress blocked load is fetched before any part runs,
# one download at a time, so that a cold or wiped tools cache fails none of them. Here the ML package's test fetches
# what native_test.dart does through the real tools/ml/fetch.py, and offline.sh blocks egress as the fetchers see it.
case $(uname -sm) in
  "Linux x86_64") ORT=ort-linux-x64 ;; "Linux aarch64") ORT=ort-linux-arm64 ;; *) ORT=ort-macos-arm64 ;;
esac
ml_sandbox() {
  dart_sandbox
  mkdir -p "$SANDBOX/app/packages/photolib_ml/test" "$SANDBOX/tools/ml"
  : >"$SANDBOX/app/packages/photolib_ml/pubspec.yaml"
  cp "$REPO_ROOT/tools/ml/fetch.py" "$SANDBOX/tools/ml/"
  echo weights >"$SANDBOX/model.onnx"
  local sum pin
  sum=$(sha256sum <"$SANDBOX/model.onnx" | cut -c-64)
  pin="{\"url\": \"file://$SANDBOX/model.onnx\", \"sha256\": \"$sum\"}"
  echo "{\"$ORT\": $pin, \"yunet\": $pin, \"sface\": $pin, \"sface-int8\": $pin, \"face-photo-armstrong-a\": $pin, \"face-photo-armstrong-b\": $pin, \"face-photo-magnus\": $pin, \"face-photo-crew\": $pin}" >"$SANDBOX/tools/ml/artefacts.json"
  mv "$SANDBOX/stubs/python3" "$SANDBOX/stubs/python3-stub"
  printf '#!/bin/bash\npython3-stub "$@" || exit\n[[ $1 != *tools/ml/fetch.py ]] || exec %q "$@"\n' \
    "$(command -v python3)" >"$SANDBOX/stubs/python3"
  mv "$SANDBOX/stubs/flutter" "$SANDBOX/stubs/flutter-stub"
  cat >"$SANDBOX/stubs/flutter" <<EOF
#!/bin/bash
[[ -z \${WIPE:-} ]] || rm -rf "\$PHOTOLIB_TOOLS_CACHE/ml"
[[ \$1 != test ]] || python3 ../../../tools/ml/fetch.py $ORT yunet sface sface-int8 face-photo-armstrong-a face-photo-armstrong-b face-photo-magnus face-photo-crew >/dev/null || exit
exec flutter-stub "\$@"
EOF
  chmod +x "$SANDBOX/stubs/python3" "$SANDBOX/stubs/flutter"
  printf '#!/bin/bash\necho "offline.sh $* @${PWD#%s}" >>"%s/calls.log"\nEGRESS_BLOCKED=1 exec "$@"\n' \
    "$SANDBOX" "$SANDBOX" >"$SANDBOX/tools/offline.sh"
}

ml_sandbox
PHOTOLIB_TOOLS_CACHE=$SANDBOX/cache run_gate dart
expect_result "with a cold tools cache, the ML tests pass with egress blocked" 0
[[ $(calls | head -n 1) == "python3 tools/ml/fetch.py $ORT yunet sface sface-int8 face-photo-armstrong-a face-photo-armstrong-b face-photo-magnus face-photo-crew @" &&
  $(calls) == *"flutter test @/app/packages/photolib_ml"* ]] &&
  ok "the prefetch fetches the ML runtime and models first, then the dart part runs their test" ||
  fail "prefetch and ML test: $(calls)"

ml_sandbox
PHOTOLIB_TOOLS_CACHE=$SANDBOX/cache WIPE=1 run_gate dart
expect_result "a cache wiped after the prefetch fails the ML tests, naming what is missing and how to fetch it" \
  failure "egress is blocked (tools/offline.sh); fetch it first: python3 tools/ml/fetch.py $ORT"

# A package whose build hook takes ONNX Runtime's archive from a directory gets the verified archive itself there.
ml_sandbox
printf 'hooks:\n  user_defines:\n    photolib_ml:\n      runtime: build/onnxruntime/\n' \
  >"$SANDBOX/app/packages/photolib_ml/pubspec.yaml"
PHOTOLIB_TOOLS_CACHE=$SANDBOX/cache run_gate dart
expect_result "with a cold tools cache, a package gets ONNX Runtime's archive before its tests run" 0
cmp -s "$SANDBOX/model.onnx" "$SANDBOX/app/packages/photolib_ml/build/onnxruntime/model.onnx" &&
  ok "the archive in the package's runtime directory is the pinned one" ||
  fail "no pinned archive in the runtime directory: $(ls -R "$SANDBOX/app/packages/photolib_ml")"

gate_sandbox cargo cargo-deny rustup dart flutter python3
mkdir -p "$SANDBOX/server/crates/photolib-server" "$SANDBOX/app/packages/photolib_video/test" "$SANDBOX/tools/video"
echo 'rust-version = "1.85"' >"$SANDBOX/server/Cargo.toml"
: >"$SANDBOX/app/packages/photolib_video/pubspec.yaml"
echo '{ "flutter": "3.47.7" }' >"$SANDBOX/app/.fvmrc"
stub_command "$SANDBOX/tools/video/ffmpeg.sh" ffmpeg.sh
stub_command "$SANDBOX/tools/proxies.sh" proxies.sh
stub_command "$SANDBOX/tools/postgres.sh" postgres.sh
CHECK_JOBS='' run_gate rust dart
[[ $(calls | head -n 2) == "ffmpeg.sh  @
proxies.sh  @" && $(calls | grep -c ffmpeg.sh) -eq 1 ]] &&
  ok "the FFmpeg that the Rust and the Dart video tests share is prefetched once, before the parts run side by side" ||
  fail "prefetch of FFmpeg: $(calls)"

# --- a crash leaves no core dump (photolib-design#435): steps run with `ulimit -c 0`, and one a signal ends says which
gate_sandbox
mkdir -p "$SANDBOX/tools/tests"
printf 'echo "core limit $(ulimit -c)" >>"%s/calls.log"\nkill -SEGV $$\n' "$SANDBOX" >"$SANDBOX/tools/tests/test_x.sh"
# As high a limit as this process may set: an agent's driver may have lowered the hard limit to 0 already.
OUT=$(cd "$SANDBOX" && ulimit -c "$(ulimit -Hc)" && PATH="$SANDBOX/stubs:$BASE_BIN" bash tools/check.sh repo 2>&1)
STATUS=$?
expect_result "a step a signal ends fails the gate and names the signal" failure \
  "check.sh: [.] bash tools/tests/test_x.sh was killed by SIGSEGV" "failed: bash tools/tests/test_x.sh (in .)"
expect_calls "steps run with core dumps off" "core limit 0"
assert_matches tools/check.sh '^ulimit -c 0' "turns core dumps off before any step"
assert_prose AGENTS.md 'gate forbids core dumps[^.]*`ulimit -c 0`[^.]*reported by its signal' \
  "AGENTS.md says the gate forbids core dumps and reports a crash by its signal"
echo 'exit 1' >"$SANDBOX/tools/tests/test_x.sh"
run_gate repo
[[ $STATUS -ne 0 && $OUT != *killed* ]] && ok "a step that fails on its own names no signal" || fail "exit 1: $OUT"

# --- a step that writes nothing for CHECK_SILENCE seconds (20 min) is killed with its process group
# (photolib-design#529); the rest of its part and the other parts still run, side by side as the train runs them.
# silent_gate <seconds>: such a gate, its silent step asleep for that long; silent_checks: what that gate did.
silent_gate() {
  docs_sandbox python3
  mkdir -p "$SANDBOX/tools/tests"
  printf 'echo started\nsleep %s &\necho $! >%q/child\nexec %q -c "print(1); import time; time.sleep(%s)"\n' \
    "$1" "$SANDBOX" "$(command -v python3)" "$1" >"$SANDBOX/tools/tests/test_a.sh"
  printf 'for i in 1 2 3 4; do printf .; sleep 1; done\necho test_b >>%q/calls.log\n' "$SANDBOX" \
    >"$SANDBOX/tools/tests/test_b.sh"
  start=$SECONDS
  CHECK_SILENCE=3 CHECK_JOBS='' run_gate repo docs
}
silent_checks() {
  expect_result "a silent step fails the gate" failure "check.sh: 1 problem(s):"
  driver_reads "bash tools/tests/test_a.sh: no output for 3 s" "named with how long it wrote nothing"
  [[ $(calls) == *test_b* && $(calls) == *docs.sh* ]] &&
    ok "the next step of its part, which writes a dot a second and no line, and the other part run" ||
    fail "steps after a silent one did not run: $(calls)"
  ((SECONDS - start < 20)) && ok "it is killed within seconds of its limit" || fail "the gate took $((SECONDS - start)) s"
  kill -0 "$(cat "$SANDBOX/child")" 2>/dev/null && fail "a process the silent step started survived it" ||
    ok "its process group dies with it"
  [[ $OUT == *started$'\n'1$'\n'* ]] && ok "what it wrote before is kept, Python's too" || fail "its output is lost: $OUT"
}
thawed silent_gate 300
silent_checks
assert_matches tools/check.sh 'CHECK_SILENCE:-1200' "steps are silent for at most 20 min by default"
assert_prose AGENTS.md 'writes nothing for 20 min[^.]*killed with its process group' \
  "AGENTS.md says a silent step is killed"

# As quiet.sh does (lib.sh's frozen), the silent step's 8 s run out before its gate resumes, so the case runs again and
# that run is judged.
silent_frozen() { thawed silent_gate 8; silent_checks; }
frozen silent_frozen

# wait_gate <pid> <seconds>: waits for a gate started in the background, at most that long: a gate that hangs is a failure
# of this test, killed with its group, never a hang of the suite (CHECK_SILENCE is 20 min and CI retries a failed test).
wait_gate() {
  local i
  for ((i = 0; i < $2 * 5; i++)); do kill -0 "$1" 2>/dev/null && sleep 0.2 || break; done
  if kill -0 "$1" 2>/dev/null; then
    fail "the gate (pid $1) was still running after $2 s: killed"
    kill -KILL -- -"$1" 2>/dev/null
  fi
  { wait "$1"; } 2>/dev/null
}

# A gate that hangs is reported and killed within the bound, and one that ends is waited for without a report.
fail_saved=$(declare -f fail)
fail() { HANG_REPORT=$*; }
HANG_REPORT=
set -m
(exec sleep 60) &
hung=$!
set +m
wait_gate "$hung" 1
[[ $HANG_REPORT == *"still running after 1 s: killed"* ]] && ! kill -0 "$hung" 2>/dev/null &&
  RESULT=reported || RESULT="not reported ($HANG_REPORT)"
HANG_REPORT=
(exec sleep 0.2) &
wait_gate $! 5
[[ -z $HANG_REPORT ]] && ENDED=quiet || ENDED="reported: $HANG_REPORT"
eval "$fail_saved"
[[ $RESULT == reported ]] && ok "wait_gate kills a gate that hangs and says so" || fail "wait_gate: $RESULT"
[[ $ENDED == quiet ]] && ok "and says nothing of one that ends" || fail "wait_gate on a gate that ended: $ENDED"

# A freeze (quiet.sh, worker-throttle.sh) stops the gate and its steps, here for 8 s past a CHECK_SILENCE of 6, once the
# gate has read what the step wrote: none of it is the step's silence, or the thaw kills a step that writes within its
# limit of the time it ran (photolib-design#659: a gate killed test_check_sh.sh the moment a 24-min freeze ended).
# frozen_gate <what the step does once it started>: such a gate.
frozen_gate() {
  gate_sandbox
  mkdir -p "$SANDBOX/tools/tests"
  printf 'echo started\necho $$ >%q/step\n%s\n' "$SANDBOX" "$1" >"$SANDBOX/tools/tests/test_a.sh"
  start=$SECONDS
  set -m
  (cd "$SANDBOX" && CHECK_SILENCE=6 PATH="$SANDBOX/stubs:$BASE_BIN" exec bash tools/check.sh repo &>"$SANDBOX/out") &
  gate=$!
  set +m
  # The gate holds a step's output until it ends, so the step's own file says that it started.
  for _ in {1..100}; do [[ -s $SANDBOX/step ]] && break || sleep 0.1; done
  [[ -s $SANDBOX/step ]] || fail "the step did not start within 10 s"
  stepgroup=$(ps -o pgid= -p "$(cat "$SANDBOX/step")" | tr -d ' ')
  kill -0 -- -"$gate" -"${stepgroup:-0}" 2>/dev/null || fail "the gate or its step was gone before the freeze, which tests nothing"
  kill -STOP -- -"$gate" -"${stepgroup:-0}"
  sleep 8
  kill -CONT -- -"${stepgroup:-0}" -"$gate"
  wait_gate "$gate" 60
  STATUS=$? OUT=$(<"$SANDBOX/out")
}
thawed frozen_gate 'sleep 1; sleep 1; sleep 1; echo done'
expect_result "a freeze of the gate is none of its step's silence" 0 "started"$'\n'"done"
thawed frozen_gate 'sleep 300'
expect_result "a step silent for its limit of the time it ran is still killed after a freeze" failure \
  "no output for 6 s (in .)"
((SECONDS - start < 30)) && ok "within seconds of that limit" || fail "the frozen gate took $((SECONDS - start)) s"
assert_prose AGENTS.md "silence counts only the time the gate ran" "AGENTS.md says a freeze is no step's silence"

silent_perf() {
  perf_sandbox
  printf 'echo run.sh >>%q/calls.log\nsleep 300\n' "$SANDBOX" >"$SANDBOX/tools/perf/run.sh"
  CHECK_SILENCE=2 run_gate perf
}
thawed silent_perf
driver_reads "bash tools/perf/run.sh: no output for 2 s" "a silent timing-sensitive step fails, and not as timing"
expect_calls "a hang is no timing noise: it is not measured again" "instructions.sh
$(locked_call app)
run.sh"

# A step that exits 124, as timeout(1) does, timed out: run.sh when a benchmark app hung (photolib-design#536).
perf_sandbox
printf 'echo run.sh >>%q/calls.log\nexit 124\n' "$SANDBOX" >"$SANDBOX/tools/perf/run.sh"
run_gate perf
driver_reads "bash tools/perf/run.sh: timed out" "a timing-sensitive step that timed out fails, and not as timing"
expect_calls "nor is it measured again" "instructions.sh
$(locked_call app)
run.sh"
perf_sandbox
printf 'echo run.sh >>%q/calls.log\n[[ -e %q/once ]] && exit 124\n: >%q/once\nexit 1\n' "$SANDBOX" "$SANDBOX" \
  "$SANDBOX" >"$SANDBOX/tools/perf/run.sh"
run_gate perf
driver_reads "bash tools/perf/run.sh: timed out" "one that times out on its second attempt fails, and not as timing"
expect_calls "and gets no third" "instructions.sh
$(locked_call app)
run.sh
run.sh"

# The driver stops the gate with SIGTERM to its process group, a terminal with SIGINT: either takes the steps along,
# which run in process groups of their own, even as a step starts (a slow rm holds the gate there; photolib-design#538).
# stop_gate <signal> <jobs>: SURVIVED says whether the step's child outlived that signal by 5 s.
stop_gate() {
  docs_sandbox python3
  mkdir -p "$SANDBOX/tools/tests"
  printf 'sleep 300 &\necho $! >%q/child\nwait\n' "$SANDBOX" >"$SANDBOX/tools/tests/test_a.sh"
  printf '#!/bin/bash\nsleep 2\nexec %q "$@"\n' "$(command -v rm)" >"$SANDBOX/stubs/rm"
  chmod +x "$SANDBOX/stubs/rm"
  set -m
  (cd "$SANDBOX" && CHECK_JOBS=$2 PATH="$SANDBOX/stubs:$BASE_BIN" exec bash tools/check.sh repo docs &>/dev/null) &
  gate=$!
  set +m
  for _ in {1..100}; do [[ -s $SANDBOX/child ]] && break || sleep 0.1; done
  kill -"$1" -- -"$gate"
  for _ in {1..50}; do kill -0 "$(cat "$SANDBOX/child")" 2>/dev/null && sleep 0.1 || break; done
  kill -0 "$(cat "$SANDBOX/child")" 2>/dev/null && SURVIVED=1 || SURVIVED=0
  wait_gate "$gate" 60
}
for sig in TERM INT; do
  for jobs in 1 3; do
    thawed stop_gate "$sig" "$jobs"
    ((SURVIVED)) && fail "SIG$sig left a step running (CHECK_JOBS=$jobs)" ||
      ok "SIG$sig to the gate stops its steps (CHECK_JOBS=$jobs)"
  done
done

# --- what a step writes passes whole and in its place though read's timer runs out before read hands back what it
# took in (photolib-design#648): read -N kept bytes back between calls, which a step's end lost or the next step
# printed. A freeze or starvation runs the 1 s timer out so; here every timer runs out at once.
gate_sandbox
mkdir -p "$SANDBOX/tools/tests"
for t in a b c; do
  printf '%s\n' 'for i in 1 2 3 4 5 6; do echo "$0 line $i ......................................"; done' \
    "printf 'SigBlk:\t0000000000000000\n'" >"$SANDBOX/tools/tests/test_$t.sh"
done
sed -i 's/ -t 1 -u "$fd"/ -t 0.000001 -u "$fd"/' "$SANDBOX/tools/check.sh"
grep -q ' -t 0.000001 -u "$fd"' "$SANDBOX/tools/check.sh" || fail "check.sh reads no step's output with -t 1 to change"
run_gate repo
for t in a b c; do
  want=$(cd "$SANDBOX" && bash "tools/tests/test_$t.sh")
  got=$(sed -n "\|^==> \[.\] bash tools/tests/test_$t.sh\$|,/^<== /p" <<<"$OUT" | sed '1d;$d')
  [[ $got == "$want" ]] && ok "test_$t.sh's output passes whole and in its place" ||
    fail "test_$t.sh's output is not what it wrote: $OUT"
done

# --- the merge train's quiet mode (photolib-design tools/agent/quiet.sh) stops agents' gates for minutes and resumes
# their steps 90 s before them, so a step's own timers and wall-clock assertions run out meanwhile: a step that fails
# after its gate was stopped for 5 s or more runs once more, and the silence it is killed for leaves out that stop
# (photolib-design#648). stopped_gate <step> [silence]: the repo part with that test_a.sh, the gate (not the step,
# which runs in a group of its own) stopped for 8 s once the step has made the file step.
stopped_gate() {
  gate_sandbox
  mkdir -p "$SANDBOX/tools/tests"
  echo "$1" >"$SANDBOX/tools/tests/test_a.sh"
  set -m
  (cd "$SANDBOX" && CHECK_SILENCE=${2:-1200} PATH="$SANDBOX/stubs:$BASE_BIN" exec bash tools/check.sh repo \
    >"$SANDBOX/out" 2>&1) &
  gate=$!
  set +m
  for _ in {1..100}; do [[ -e $SANDBOX/step ]] && break || sleep 0.1; done
  kill -STOP -- -"$gate" && sleep 8 && kill -CONT -- -"$gate"
  wait_gate "$gate" 120
  STATUS=$? OUT=$(<"$SANDBOX/out")
}
stopped_gate 'echo run >>calls.log; [[ -e step ]] && exit 0; : >step; sleep 1; exit 1'
expect_result "a step that fails after its gate was stopped runs once more" 0 \
  "check.sh: [.] bash tools/tests/test_a.sh failed; the gate was stopped for " " s meanwhile: once more"
expect_calls "it ran twice" "run
run"
stopped_gate 'echo run >>calls.log; : >step; sleep 1; exit 1'
driver_reads "bash tools/tests/test_a.sh" "a step that fails again after a stop fails the gate"
expect_calls "it ran twice, no more" "run
run"
stopped_gate 'echo a; sleep 1.5; : >step; sleep 10; echo b' 6
expect_result "a step silent past CHECK_SILENCE (6 s) only through an 8 s stop of its gate is not killed" 0 "a
b"
assert_prose AGENTS.md 'fails after the gate was stopped while it ran[^.]*runs once more[^.]*silence[^.]*leaves' \
  "AGENTS.md says a step that fails after a stop runs once more, and that a stop is no silence"

# --- CHECK_STEPS runs only the steps whose "[dir] command" it matches, as CI splits a part over machines; a gate in
# which it matches no step fails, never passes empty.
docs_sandbox python3
mkdir -p "$SANDBOX/tools/tests"
printf 'echo test_a >>%q/calls.log\n' "$SANDBOX" >"$SANDBOX/tools/tests/test_a.sh"
CHECK_STEPS='test_a\.sh' run_gate repo docs
expect_calls "CHECK_STEPS runs the steps it matches and none of the others" "test_a"
CHECK_STEPS='matches no step' run_gate repo docs
expect_result "a CHECK_STEPS that matches no step fails" failure "CHECK_STEPS='matches no step' and CHECK_STEPS_EXCEPT=''"
: >"$SANDBOX/calls.log"
CHECK_STEPS_EXCEPT='test_a\.sh' run_gate repo docs
expect_calls "CHECK_STEPS_EXCEPT runs the steps it does not match" "docs.sh"
: >"$SANDBOX/calls.log"
run_gate repo docs
expect_calls "without CHECK_STEPS every step runs" $'test_a\ndocs.sh'

# --- CHECK_ADVISORY: a failed step it matches is reported and does not fail the gate; one it does not match still does.
printf 'echo test_a >>%q/calls.log\nexit 1\n' "$SANDBOX" >"$SANDBOX/tools/tests/test_a.sh"
: >"$SANDBOX/calls.log"
CHECK_ADVISORY='test_a\.sh' run_gate repo docs
expect_result "a failed advisory step does not fail the gate" 0 "advisory, not counted: failed: bash tools/tests/test_a.sh"
CHECK_ADVISORY='nothing matches this' run_gate repo docs
expect_result "a failed step it does not match still fails the gate" failure "failed: bash tools/tests/test_a.sh"
CI=true CHECK_ADVISORY_CI='test_a\.sh' run_gate repo docs
expect_result "on a hosted runner (CI) the steps the gate itself names are advisory too" 0 "advisory, not counted: failed: bash tools/tests/test_a.sh"
CI=true run_gate repo docs
expect_result "and any other failed step still fails the gate there" failure "failed: bash tools/tests/test_a.sh"
CI='' CHECK_ADVISORY_CI='test_a\.sh' run_gate repo docs
expect_result "off a hosted runner they fail the gate" failure "failed: bash tools/tests/test_a.sh"

finish
