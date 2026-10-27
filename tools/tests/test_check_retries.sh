#!/usr/bin/env bash
# The gate promises "every test gets three retries" (ci.yml): shell tests by CHECK_RETRIES=3, Dart's by retry: 3, Rust's
# by nextest --retries 3. A step that is a test or depends on the network, a browser or a server it starts, and that
# nothing else repeats, runs through `retried`: it runs again up to CHECK_RETRIES times, a pass then is flaky, a step
# that hung or timed out is not run again. The steps that are deterministic or already repeated are not (the table is
# in the pull request that introduced this test, and in AGENTS.md). Fast: no real tools, stubs that fail on demand.
# shellcheck disable=SC2016,SC2153 # stubs are literal scripts; SANDBOX is set by new_sandbox
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

sandbox_tools bash env find sort mkdir cat rm dirname basename sed ln uname mktemp sleep mkfifo grep tail tee id

# The stub of lib.sh, plus: the invocation "<name> <arguments>" that FLAKY_ON equals fails with FLAKY_CODE (1) the
# first FLAKY_FAILS (1) times it runs; FAIL_ON still fails every time.
stub_command() {
  local path=$1 name=$2
  cat >"$path" <<STUB
#!/bin/bash
echo "$name \$* @\${PWD#$SANDBOX}" >> "$SANDBOX/calls.log"
[[ "\$*" == "--version --machine" ]] && echo "{ \"frameworkVersion\": \"\${FLUTTER_VERSION:-3.47.7}\" }"
[[ "\$FAIL_ON" == "$name \$*" ]] && exit 1
if [[ "\$FLAKY_ON" == "$name \$*" ]]; then
  seen=\$(cat "$SANDBOX/seen" 2>/dev/null || echo 0)
  echo \$((seen + 1)) >"$SANDBOX/seen"
  ((seen < \${FLAKY_FAILS:-1})) && exit \${FLAKY_CODE:-1}
fi
exit 0
STUB
  chmod +x "$path"
}

gate_sandbox() {
  new_sandbox tools/check.sh "$@"
  printf '#!/bin/bash\necho 12\n' >"$SANDBOX/stubs/getconf"
  chmod +x "$SANDBOX/stubs/getconf"
  stub_command "$SANDBOX/tools/offline.sh" offline.sh
  mkdir -p "$SANDBOX/tools/lint"
  stub_command "$SANDBOX/tools/lint/ratchet.sh" ratchet.sh
}

unset CHECK_JOBS CHECK_STEPS CHECK_STEPS_EXCEPT CHECK_ADVISORY CHECK_PARTITION CHECK_REPORT CHECK_RETRIES \
  CHECK_BUDGET_ATTEMPTS FLAKY_ON FLAKY_FAILS FLAKY_CODE FAIL_ON
# run_gate <part> [steps regex]: only that step runs, CHECK_RETRIES as the caller sets it (CI: 3)
run_gate() {
  OUT=$(cd "$SANDBOX" && CHECK_JOBS=1 CHECK_STEPS=${2:-} PATH="$SANDBOX/stubs:$BASE_BIN" bash tools/check.sh "$1" 2>&1)
  # shellcheck disable=SC2034 # expect_result reads it
  STATUS=$?
}

# attempts <invocation>: how often the stub ran it
attempts() { grep -cF -- "$1 @" "$SANDBOX/calls.log"; }

# retried_step <description> <sandbox function> <part> <steps regex> <invocation, SANDBOX for its path>: the step passes
# its second attempt, fails after 1 + CHECK_RETRIES, is not run again when it timed out, nor without CHECK_RETRIES.
retried_step() {
  local description=$1 sandbox=$2 part=$3 steps=$4 on n
  "$sandbox"
  on=${5//SANDBOX/$SANDBOX}
  FLAKY_ON=$on CHECK_RETRIES=3 run_gate "$part" "$steps"
  expect_result "$description: a failure then a pass passes the gate, reported as flaky" 0 \
    "(passed on attempt 2 of 4)" "once more" "check.sh: flaky"
  n=$(attempts "$on")
  [[ $n == 2 ]] && ok "$description: it ran twice" || fail "$description: it ran $n times, not twice"

  "$sandbox"
  on=${5//SANDBOX/$SANDBOX}
  FLAKY_ON=$on FLAKY_FAILS=99 CHECK_RETRIES=3 run_gate "$part" "$steps"
  expect_result "$description: a step that always fails fails the gate" failure "attempt 3 of 4: once more" "failed: "
  n=$(attempts "$on")
  [[ $n == 4 ]] && ok "$description: it ran 1 + 3 times" || fail "$description: it ran $n times, not 4"
  [[ $OUT != *"check.sh: flaky"* ]] && ok "$description: a failure is no flake" || fail "$description: failed, yet flaky"

  "$sandbox"
  on=${5//SANDBOX/$SANDBOX}
  FLAKY_ON=$on FLAKY_CODE=124 FLAKY_FAILS=99 CHECK_RETRIES=3 run_gate "$part" "$steps"
  expect_result "$description: a step that timed out fails the gate" failure "timed out"
  n=$(attempts "$on")
  [[ $n == 1 ]] && ok "$description: a step that timed out runs once" || fail "$description: it ran $n times, not once"

  "$sandbox"
  on=${5//SANDBOX/$SANDBOX}
  FLAKY_ON=$on run_gate "$part" "$steps"
  expect_result "$description: without CHECK_RETRIES (a local run) a failure fails the gate" failure "failed: "
  n=$(attempts "$on")
  [[ $n == 1 ]] && ok "$description: without CHECK_RETRIES it runs once" || fail "$description: it ran $n times, not once"
}

# once_step <description> <sandbox function> <part> <steps regex> <invocation>: deterministic, or repeated by its own
# tool: a failure fails the gate after $6 (1) attempts, whatever CHECK_RETRIES is.
once_step() {
  local description=$1 sandbox=$2 on n
  "$sandbox"
  on=${5//SANDBOX/$SANDBOX}
  FLAKY_ON=$on FLAKY_FAILS=99 CHECK_RETRIES=3 run_gate "$3" "$4"
  expect_result "$description: a failure fails the gate" failure "failed: "
  n=$(attempts "$on")
  [[ $n == "${6:-1}" ]] && ok "$description: it runs ${6:-1} time(s), with CHECK_RETRIES=3" ||
    fail "$description: it ran $n times, not ${6:-1}"
}

rust_sandbox() {
  gate_sandbox cargo cargo-deny cargo-machete cargo-nextest rustup python3
  cp "$REPO_ROOT/tools/advisories.py" "$SANDBOX/tools/"
  mkdir -p "$SANDBOX/server"
  echo 'rust-version = "1.85"' >"$SANDBOX/server/Cargo.toml"
}
conformance_sandbox() {
  rust_sandbox
  mkdir -p "$SANDBOX/server/crates/conformance"
  : >"$SANDBOX/server/crates/conformance/connect-conformance.yaml"
  stub_command "$SANDBOX/tools/connect_conformance.sh" connect_conformance.sh
}
passkey_sandbox() {
  gate_sandbox cargo node
  mkdir -p "$SANDBOX/server/crates/photolib-server/tests"
  : >"$SANDBOX/server/crates/photolib-server/tests/passkeys.rs"
}
hls_sandbox() {
  gate_sandbox cargo node
  mkdir -p "$SANDBOX/server/crates/photolib-server/tests"
  : >"$SANDBOX/server/crates/photolib-server/tests/hls.rs"
}
download_sandbox() {
  gate_sandbox node
  mkdir -p "$SANDBOX/tools/download"
  : >"$SANDBOX/tools/download/test.mjs"
}
renditions_sandbox() {
  gate_sandbox node cargo
  mkdir -p "$SANDBOX/tools/video"
  : >"$SANDBOX/tools/video/play.mjs"
}
playback_sandbox() {
  gate_sandbox node cargo rustup dart flutter
  mkdir -p "$SANDBOX/tools/playback" "$SANDBOX/app/packages/photolib_api"
  : >"$SANDBOX/tools/playback/bench.mjs"
}
web_app_sandbox() {
  gate_sandbox dart flutter python3
  mkdir -p "$SANDBOX/app/web"
  printf 'name: app\nenvironment:\n  sdk: ^3.9.0\n' >"$SANDBOX/app/pubspec.yaml"
  : >"$SANDBOX/app/web/index.html"
  echo '{"flutter": "3.47.7"}' >"$SANDBOX/app/.fvmrc"
}
app_play_sandbox() {
  gate_sandbox dart flutter cargo pkg-config python3
  mkdir -p "$SANDBOX/tools/video" "$SANDBOX/app"
  printf 'name: app\nenvironment:\n  sdk: ^3.9.0\n' >"$SANDBOX/app/pubspec.yaml"
  echo '{"flutter": "3.47.7"}' >"$SANDBOX/app/.fvmrc"
  stub_command "$SANDBOX/tools/video/app_play.sh" app_play.sh
}
smoke_sandbox() {
  gate_sandbox cargo python3
  mkdir -p "$SANDBOX/tools/e2e"
  stub_command "$SANDBOX/tools/e2e/server_client_smoke.sh" server_client_smoke.sh
}
node_sandbox() {
  gate_sandbox npm node python3
  mkdir -p "$SANDBOX/viewer"
  echo '{}' >"$SANDBOX/viewer/package.json"
}

# The steps that are tests, or depend on the network, a browser or a server they start, and that nothing repeats
retried_step "the Connect conformance suite" conformance_sandbox rust 'connect_conformance' \
  "connect_conformance.sh server/crates/conformance"
retried_step "the passkey test in Chrome" passkey_sandbox web 'passkeys' \
  "cargo test --locked -p photolib-server --test passkeys -- --ignored"
retried_step "the web download test" download_sandbox web 'download/test\.mjs' "node tools/download/test.mjs"
retried_step "the renditions' playback" renditions_sandbox web 'video/play\.mjs' "node tools/video/play.mjs"
retried_step "the seek benchmark" playback_sandbox web 'bench\.mjs' "node tools/playback/bench.mjs"
retried_step "the web request check" web_app_sandbox dart 'web_requests\.py' "python3 tools/web_requests.py app"
retried_step "the app's playback of the corpus" app_play_sandbox dart 'app_play\.sh' "app_play.sh "
retried_step "the server and client smoke" smoke_sandbox web 'server_client_smoke' "server_client_smoke.sh "
retried_step "the Rust doc tests" rust_sandbox rust '--doc' \
  "offline.sh python3 SANDBOX/tools/lint/panics.py cargo test --locked --doc -- --show-output"
retried_step "the TypeScript tests" node_sandbox node 'npm test' "offline.sh npm test"

# Deterministic, or repeated by their own tool (nextest --retries 3, dart's retry: 3, a budget's attempts)
once_step "cargo fmt" rust_sandbox rust 'cargo fmt' "cargo fmt --check"
once_step "cargo deny's bans, licences and sources" rust_sandbox rust 'cargo deny' \
  "cargo deny --locked --config SANDBOX/deny.toml check bans licenses sources"
once_step "npm run typecheck" node_sandbox node 'typecheck' "npm run typecheck"
CHECK_BUDGET_ATTEMPTS=2 once_step "the hls.js test, a budget step with its own attempts" hls_sandbox web 'hls' \
  "cargo test --locked -p photolib-server --test hls -- --ignored" 2

# The conformance script names the cases that failed, and its runner traces them (a release of the runner with --trace)
conformance_script() {
  local cache stubs
  cache=$(mktemp -d) stubs=$(mktemp -d)
  SANDBOXES+=("$cache" "$stubs")
  mkdir -p "$cache/connectconformance-v1.0.6" "$stubs/crate"
  : >"$stubs/crate/connect-conformance.yaml"
  cat >"$cache/connectconformance-v1.0.6/connectconformance" <<RUNNER
#!/bin/bash
if [[ \$1 == --help ]]; then echo "$1"; exit 0; fi
echo "\$*" >"$stubs/args"
echo "Running 864 tests"
echo "FAILED: Timeouts/HTTPVersion:2/Protocol:PROTOCOL_CONNECT/Codec:CODEC_PROTO/TLS:false/unary"
echo "    connect error JSON: unexpected end of JSON input"
echo "    request> 0.000ms POST /connectrpc.conformance.v1.ConformanceService/Unary"
echo "    response< 1000.000ms HTTP 200"
exit 1
RUNNER
  chmod +x "$cache/connectconformance-v1.0.6/connectconformance"
  printf '#!/bin/bash\ncase $1 in -s) echo Linux ;; -m) echo x86_64 ;; esac\n' >"$stubs/uname"
  printf '#!/bin/bash\necho "{\\"executable\\":\\"/bin/true\\"}"\n' >"$stubs/cargo"
  chmod +x "$stubs/uname" "$stubs/cargo"
  CACHE=$cache STUBS=$stubs
}
for help in "--trace" "no such flag"; do
  conformance_script "$help"
  PHOTOLIB_TOOLS_CACHE=$CACHE PATH="$STUBS:$BASE_BIN" capture bash "$REPO_ROOT/tools/connect_conformance.sh" "$STUBS/crate"
  expect_result "a failing conformance case is named after the runner's output (runner help: $help)" failure \
    "failed cases: 1" "  Timeouts/HTTPVersion:2/Protocol:PROTOCOL_CONNECT/Codec:CODEC_PROTO/TLS:false/unary" \
    "request> 0.000ms POST" "response< 1000.000ms HTTP 200"
  if [[ $help == --trace ]]; then
    [[ $(<"$STUBS/args") == *" --trace -- /bin/true" ]] && ok "the runner traces the failed cases" ||
      fail "the runner got no --trace: $(<"$STUBS/args")"
  else
    [[ $(<"$STUBS/args") != *--trace* ]] && ok "a runner without --trace is not given it" ||
      fail "the runner was given --trace it does not know: $(<"$STUBS/args")"
  fi
done

# The text: the helper, the header and AGENTS.md say what is retried and what is not
assert_prose AGENTS.md 'retried.{0,200}(Connect conformance|passkey).{0,300}CHECK_RETRIES' \
  "AGENTS.md says which steps CHECK_RETRIES repeats"
assert_prose tools/check.sh 'CHECK_RETRIES=<n>[^#]*a failed test or network step runs again' \
  "check.sh's header says CHECK_RETRIES covers the steps that are tests or use the network"

finish
