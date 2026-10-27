#!/usr/bin/env bash
# Quality gate: runs every check for each part of the repository that exists. Exit code 0 means all of them pass.
#
#   bash tools/check.sh                every part (the full gate; CI runs it, split, on the merge queue's branches)
#   bash tools/check.sh <part>...      those parts
#   bash tools/check.sh --since <rev>  the parts the diff <rev>...HEAD touches (SINCE), an item's own gate
#   CHECK_STEPS=<regex> ...            only the steps whose "[dir] command" matches, and CHECK_STEPS_EXCEPT=<regex> none
#                                      of those that match it (CI splits a part over machines; downloads and builds
#                                      that later steps need always run)
#   CHECK_ADVISORY=<regex> ...         a failed step matching it is reported, not counted (CI cannot measure time)
#   CHECK_RETRIES=<n> ...              a failed test or network step runs again up to n times (shell tests, Rust doc
#                                      tests, the steps with a browser or a server, Connect conformance), and a pass
#                                      then is flaky (CI: 3)
#   CHECK_BUDGET_ATTEMPTS=<n> ...      a step that measures time is measured up to n times (3; CI, advisory there: 1)
#   CHECK_REPEAT=<n> ...               with --since, the tests the diff changes run n times (10) with no retry, by
#                                      tools/repeat.sh, after the parts; 0 skips it
#
# A part that exists but whose toolchain is missing is a failure, never a silent skip. Add a step here in the same
# change that introduces a new kind of code (see AGENTS.md).
# shellcheck disable=SC2329 # the parts run as check_$part, and steps as "$run"
set -uo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT" || exit 1
# A crashing browser or VM wrote gigabytes of core.<pid> into checkouts (photolib-design#435); attempt names the signal.
ulimit -c 0
# Python writes through to a step's pipe as it goes: attempt hears it, and a step it kills keeps what it wrote.
export PYTHONUNBUFFERED=1

PARTS=(repo commits rust msrv dart web proto node docs lint perf)
# Lanes run CHECK_JOBS at a time, the longest first, each its parts one after another; perf and the budget steps run
# alone after them. Side by side, web waits for dart to resolve and generate the packages both use (dart_prepared).
LANES=(dart web rust repo msrv node proto docs lint commits)
# By default a quarter of the cores, one to four (photolib-design#543): an agent's gate beside eleven others runs one.
CORES=$(getconf _NPROCESSORS_ONLN 2>/dev/null) || CORES=1
CHECK_JOBS=${CHECK_JOBS:-$((CORES / 4 > 4 ? 4 : CORES / 4 < 1 ? 1 : CORES / 4))}
CHECK_SILENCE=${CHECK_SILENCE:-1200} # the seconds a step may write nothing (attempt)
# Packages whose tests hold frame budgets, in the VM and in browsers: budget steps, as perf is.
FRAME_BUDGETS=" app/packages/photolib_data app/packages/photolib_workers "
# --since: the parts a changed path needs, from every row with a glob that matches it; repo and commits always run.
# A path no row matches, or an `all` row, needs every part: the full gate, the only one with msrv.
SINCE=(
  'all: proto/* kernel/* tools/check.sh tools/lint/* *.lock *package-lock.json'
  'all: *.fvmrc *.nvmrc rust-toolchain.toml server/Cargo.toml tools/synthlib/Cargo.toml'
  'dart web perf: app/*'
  'rust perf: server/* tools/synthlib/* tools/perf/harness.rs'
  'rust: deploy/* tools/migrations.sh tools/squawk.sh tools/garage.sh tools/connect_conformance.sh tools/postgres.sh'
  'rust: tools/advisories.py'
  'rust dart web: tools/video/*'
  'dart web: tools/data/* tools/hls/* tools/ml/* tools/web_probe/*'
  'dart: tools/dart_licenses.py tools/web_requests.py'
  'web: tools/playback/* tools/download/* tools/web_e2e/* tools/playwright.sh tools/timeline_bench.py'
  'web: server/crates/photolib-server/src/web.rs server/crates/photolib-server/src/web/* server/crates/photolib-server/src/relay.rs'
  'node: viewer/* tools/node_licenses.py'
  'proto: */gen/* docs/dev/api/* tools/buf.sh tools/proto_breaking.sh tools/codegen.sh'
  'docs: docs/* *.md mkdocs.yml tools/docs.sh tools/docs-requirements.txt'
  'perf: tools/perf/*'
  'repo: tools/tests/* tools/repeat.sh tools/commitlint.sh tools/flutter_upgrade_gate.py .github/* justfile'
  'repo: .gitignore .gitattributes .editorconfig .gitleaks.toml .devcontainer.json .pre-commit-config.yaml'
  'repo: tools/prequeue.sh'
  'lint: *.sh *.py *.js *.mjs *.ts *.swift *.kt *.kts *.cc *.cpp *.h .editorconfig .shellcheckrc ruff.toml'
  'lint: eslint.config.mjs .swiftlint.yml .clang-tidy'
)
# The playback code whose change the seek benchmark measures (photolib-design#363): MediaProxy, the kernel's blob
# decryption and the benchmark. Seek timings on a loaded machine would make every gate flaky.
PLAYBACK=(app/packages/photolib_api/lib/media_proxy.dart app/packages/photolib_api/tool/decrypting_proxy.dart
  kernel/src/blob.rs 'tools/playback/*')
# The remote that holds dev (tools/remote.sh: $PHOTOLIB_REMOTE, else the only one, else origin), asked when needed.
remote() { bash "$ROOT/tools/remote.sh"; }
BASE=

STATE=$(mktemp -d) || exit 1
trap 'rm -rf "$STATE"' EXIT
PART_NO=0 SEQ=0 DEFER="" SETUP="" RETRY=""

# record <file> <seq> <line>: a line filed under the part and the position in it, so that any schedule sorts it as a
# sequential run does.
record() { echo "$PART_NO $2 $3" >>"$STATE/$1"; }

fail_at() {
  echo "check.sh: $2" >&2
  record problems "$1" "$2"
}

note_failure() {
  SEQ=$((SEQ + 1))
  fail_at "$SEQ" "$*"
}

# need <tool> <why>: true when the tool is on PATH; otherwise records a failure.
need() {
  command -v "$1" >/dev/null 2>&1 && return 0
  note_failure "'$1' is required for $2 but is not on PATH"
  return 1
}

duration() { if (($1 < 60)); then echo "${1}s"; else printf '%dm%02ds\n' $(($1 / 60)) $(($1 % 60)); fi; }

# step <dir> <command...>: run a command inside a directory, record a failure if it fails, and time it; returns 1 when
# it failed.
step() { run_step "" "$@"; }

# setup <dir> <command...>: a step the checks after it need (a download, a build): CHECK_STEPS never skips it.
setup() { SETUP=1 run_step "" "$@"; }

# retried <dir> <command...>: a test that runs again up to CHECK_RETRIES times while it fails (one that hung does not);
# a pass on a later attempt is flaky, not a failure. For what is a test or flaky by nature (a browser, a server it
# starts, the network, a timing) and that no tool repeats: not for what is deterministic (build, lint, format, deny),
# nor for what repeats itself (nextest --retries 3, dart's retry: 3 in dart_test.yaml, budget's attempts).
retried() { RETRY=1 run_step "" "$@"; }

# budget <dir> <command...>: a step that measures wall time. While parts run side by side it waits until they are
# done; it is measured up to three times, run.sh each time only the series that failed the time before (PERF_FAILED),
# as load only ever slows a measurement down (photolib-design#749), and a pass on a later attempt is flaky.
budget() { run_step budget "$@"; }

run_step() {
  SEQ=$((SEQ + 1))
  if [[ -n ${CHECK_STEPS:-}${CHECK_STEPS_EXCEPT:-} && -z $SETUP ]]; then
    [[ -z ${CHECK_STEPS:-} || "[$2] ${*:3}" =~ $CHECK_STEPS ]] || return 0
    [[ -z ${CHECK_STEPS_EXCEPT:-} || ! "[$2] ${*:3}" =~ $CHECK_STEPS_EXCEPT ]] || return 0
    : >"$STATE/matched"
  fi
  if [[ $1 == budget && -n $DEFER ]]; then
    echo "check.sh: [$2] ${*:3} measures time: it runs alone after the other parts"
    record deferred "$SEQ" "$(printf '%q ' "${@:2}")"
  else
    run_now "$SEQ" "$@"
  fi
}

# run_now <seq> <kind> <dir> <command...>: a step that hung or timed out is not run again; the why of its failure goes
# before ` (in <dir>)`, where the merge train's driver reads it as part of the command, never as a timing step's. One
# that failed after the gate was stopped runs once more: the merge train's quiet mode SIGSTOPs agents' gates for
# minutes and resumes their steps first, whose timers run out meanwhile (photolib-design#648).
run_now() {
  local seq=$1 kind=$2 dir=$3 start=$SECONDS failed=0 stop n=1 most=1 of='' noisy='' result=pass
  shift 3
  [[ $kind != budget ]] || most=${CHECK_BUDGET_ATTEMPTS:-3}
  [[ -z $RETRY ]] || most=$((1 + ${CHECK_RETRIES:-0}))
  echo "==> [$dir] $*"
  until attempt "$dir" "$@"; do
    stop=
    ((STOPPED)) && stop="; the gate was stopped for $STOPPED s meanwhile"
    [[ -n $stop ]] || noisy=1
    ((most == 1)) || of=" attempt $n of $most"
    if [[ -n $WHY ]] || { ((n >= most)) && [[ -z $stop || $n != 1 ]]; }; then
      if [[ -n ${CHECK_ADVISORY:-} && "[$dir] $*" =~ $CHECK_ADVISORY ]]; then
        echo "check.sh: advisory, not counted: failed: $*${WHY:+: $WHY} (in $dir)" >&2
        result=advisory
      else
        fail_at "$seq" "failed: $*${WHY:+: $WHY} (in $dir)"
        failed=1 result=fail
      fi
      break
    fi
    echo "check.sh: [$dir] $* failed$of$stop: once more"
    n=$((n + 1))
  done
  if ((!failed && n > 1)) && [[ -n $noisy && $result == pass ]]; then
    record flaky "$seq" "(passed on attempt $n of $most): [$dir] $*"
    result=flaky
  fi
  echo "<== $(duration $((SECONDS - start))) [$dir] $*"
  echo "$((SECONDS - start)) [$dir] $*" >>"$STATE/times"
  record report "$seq" "$result $((SECONDS - start)) [$dir] $*"
  return $failed
}

# attempt <dir> <command...>: runs it in <dir> as a process group of its own (set -m), its output passed through; once
# it writes nothing for CHECK_SILENCE seconds, kills that group and sets WHY (photolib-design#529), as it does when the
# step exits 124, as timeout(1) does (run.sh when a benchmark app hung). When a signal ended it otherwise, says which.
# STOPPED: the seconds the gate was stopped (or starved) meanwhile, in turns of 5 s or more, which are no silence.
attempt() {
  local out=$STATE/out.$BASHPID fd pid chunk got last=$SECONDS tick=$SECONDS status signal
  WHY="" STOPPED=0
  mkfifo "$out" || return
  set -m
  (cd "$1" && exec "${@:2}") </dev/null >"$out" 2>&1 &
  pid=$!
  # The driver's SIGTERM to the gate's process group, or Ctrl-C, reaches the step only so; the step waits in the open
  # of $out until the gate reads it, so the trap is in place before the step runs.
  trap 'kill -KILL -- -$pid 2>/dev/null; exit 143' TERM HUP INT
  set +m
  exec {fd}<"$out"
  rm "$out"
  # Byte by byte (no -N) in the C locale, read keeps no byte back between calls: read -N did, which a timer that ran
  # out first (a freeze, starvation) lost at a step's end or left to the next step's output (photolib-design#648).
  while :; do
    LC_ALL=C IFS= read -r -d '' -t 1 -u "$fd" chunk
    got=$?
    ((SECONDS - tick < 5)) || STOPPED=$((STOPPED + SECONDS - tick)) last=$((last + SECONDS - tick))
    tick=$SECONDS
    [[ -z $chunk ]] || printf '%s' "$chunk"
    ((got > 128)) || ((got == 0)) || break
    [[ -z $chunk ]] || { last=$SECONDS && continue; }
    # A step that ended may leave a process holding its output open: what is there is read, with no timer.
    if ! kill -0 "$pid" 2>/dev/null; then
      while read -t 0 -u "$fd" && LC_ALL=C IFS= read -r -d '' -n 1 -u "$fd" chunk; do printf '%s' "$chunk"; done
      break
    fi
    if ((SECONDS - last >= CHECK_SILENCE)); then
      kill -KILL -- -"$pid"
      WHY="no output for $CHECK_SILENCE s"
      ((CHECK_SILENCE % 60)) || WHY="no output for $((CHECK_SILENCE / 60)) min"
      break
    fi
  done
  exec {fd}<&-
  wait "$pid" 2>/dev/null
  status=$?
  trap - TERM HUP INT
  ((status != 124)) || WHY="timed out"
  signal=$( ((status > 128)) && [[ -z $WHY ]] && kill -l $((status - 128)) 2>/dev/null) &&
    echo "check.sh: [$1] ${*:2} was killed by SIG$signal"
  return $status
}

# offline <dir> <command...>: a product test suite, run with egress blocked (tools/offline.sh): it must pass air-gapped.
offline() {
  local dir=$1
  shift
  step "$dir" bash "$ROOT/tools/offline.sh" "$@"
}

# offline_retried <dir> <command...>: the same, for a suite no tool repeats (the doc tests, a node:test run).
offline_retried() {
  local dir=$1
  shift
  retried "$dir" bash "$ROOT/tools/offline.sh" "$@"
}

# part_dirs <file-name>: directories (relative, "." for the root) holding a file of that name, sorted so that
# parents come before the directories they contain.
part_dirs() {
  local file dir
  while IFS= read -r file; do
    dir=${file%/*}
    echo "${dir#./}"
  done < <(find . \( -name .git -o -name node_modules -o -name target -o -name .dart_tool \) -prune \
    -o -type f -name "$1" -print) | LC_ALL=C sort
}

# rust_roots: the topmost directories holding a Cargo.toml; a nested crate belongs to its workspace.
rust_roots() {
  local dir selected=() covered root
  while IFS= read -r dir; do
    covered=0
    for root in ${selected[@]+"${selected[@]}"}; do
      if [[ $root == . || $dir == "$root"/* ]]; then covered=1; fi
    done
    [[ $covered -eq 1 ]] && continue
    selected+=("$dir")
    echo "$dir"
  done < <(part_dirs Cargo.toml)
}

# nested_workspaces: the directories below a Rust root whose Cargo.toml declares a [workspace] of its own.
nested_workspaces() {
  local roots dir
  roots=$'\n'$(rust_roots)$'\n'
  while IFS= read -r dir; do
    [[ $roots != *$'\n'"$dir"$'\n'* && -n $(sed -n '/^\[workspace\]/p' "$dir/Cargo.toml") ]] && echo "$dir"
  done < <(part_dirs Cargo.toml)
}

# cargo_deny <dir>: bans, licences and sources fail the gate; a RustSec advisory is a warning that names it
# (tools/advisories.py, photolib-design#799).
cargo_deny() {
  step "$1" cargo deny --locked --config "$ROOT/deny.toml" check bans licenses sources
  step "$1" python3 "$ROOT/tools/advisories.py" cargo deny --locked --config "$ROOT/deny.toml" check advisories
}

check_rust() {
  local dir
  while IFS= read -r dir; do
    # PostgreSQL migrations: squawk and the release rules (tools/migrations.sh).
    if [[ -d $dir/migrations ]]; then
      step . bash "$ROOT/tools/migrations.sh" "$dir/migrations"
    fi
    # photolibd's renderer links libvips (ADR-0084).
    if [[ -d $dir/crates/photolib-media ]]; then
      need pkg-config "the libvips that the renderer in ${dir} links" || continue
      if ! pkg-config --exists 'vips >= 8.15'; then
        note_failure "libvips 8.15 or later is required for the renderer in ${dir} (Debian and Ubuntu: libvips-dev)"
        continue
      fi
    fi
    need cargo "the Rust code in ${dir}/Cargo.toml" && need python3 "the lint ratchet of ${dir}" || continue
    step "$dir" cargo fmt --check
    # clippy, its findings against the lint baseline (tools/lint/ratchet.sh). --locked everywhere: a stale Cargo.lock
    # fails the gate instead of being rewritten in the checkout.
    step . bash tools/lint/ratchet.sh clippy "$dir"
    need cargo-machete "the unused dependency check of ${dir}" && step "$dir" cargo machete
    # Every test in a process of its own, side by side (cargo nextest), then the doc tests, which nextest cannot run. A
    # test that passes while a thread it did not join panicked fails (tools/lint/panics.py).
    local partition=()
    [[ -z ${CHECK_PARTITION:-} ]] || partition=(--partition "count:$CHECK_PARTITION") # CI splits the tests over machines
    need cargo-nextest "the tests of ${dir}" && offline "$dir" python3 "$ROOT/tools/lint/panics.py" \
      cargo nextest run --locked --no-fail-fast --retries 3 ${partition[@]+"${partition[@]}"} --success-output immediate
    offline_retried "$dir" python3 "$ROOT/tools/lint/panics.py" cargo test --locked --doc -- --show-output
    need cargo-deny "the licence and advisory check of ${dir}/Cargo.toml" && cargo_deny "$dir"
  done < <(rust_roots)
  # A workspace of its own inside a root's tree (kernel/fuzz) builds only with nightly cargo-fuzz: the checks that build
  # nothing. The root's cargo machete already reads it.
  while IFS= read -r dir; do
    need cargo "the Rust code in ${dir}/Cargo.toml" || continue
    step "$dir" cargo fmt --check
    need cargo-deny "the licence and advisory check of ${dir}/Cargo.toml" && cargo_deny "$dir"
  done < <(nested_workspaces)
  # A crate with a connect-conformance.yaml is a Connect server under the official conformance suite.
  while IFS= read -r dir; do
    need cargo "the Connect conformance server in $dir" || continue
    retried . bash "$ROOT/tools/connect_conformance.sh" "$dir"
  done < <(part_dirs connect-conformance.yaml)
}

# The minimum supported Rust version is the `rust-version` in the workspace Cargo.toml; it must still build.
check_msrv() {
  local dir msrv
  while IFS= read -r dir; do
    msrv=$(sed -nE '/^rust-version[[:space:]]*=/{s/.*"([0-9.]+)".*/\1/p;q}' "$dir/Cargo.toml")
    if [[ -z $msrv ]]; then
      note_failure "${dir}/Cargo.toml declares no rust-version (the minimum supported Rust version)"
      continue
    fi
    need rustup "the MSRV build of ${dir}/Cargo.toml" || continue
    step "$dir" rustup toolchain install "$msrv" --profile minimal
    step "$dir" cargo "+$msrv" check --locked --workspace
  done < <(rust_roots)
}

# flutter_pinned <dir>: true when the installed Flutter is the version pinned in the nearest .fvmrc at or above <dir>,
# the one FVM and CI read.
flutter_pinned() {
  local pin=$1 want have
  until [[ -f $pin/.fvmrc || $pin == . ]]; do pin=$(dirname "$pin"); done
  want=$(sed -nE 's/.*"flutter"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' "$pin/.fvmrc" 2>/dev/null)
  if [[ -z $want ]]; then
    note_failure "${1}/.fvmrc must pin the Flutter version, as {\"flutter\": \"x.y.z\"}"
    return 1
  fi
  have=$(cd "$1" && flutter --version --machine | sed -nE 's/.*"frameworkVersion"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p')
  [[ $have == "$want" ]] && return 0
  note_failure "Flutter $want is pinned in ${pin}/.fvmrc but ${have:-no version} is installed"
  return 1
}

check_dart() {
  local dir dirs=()
  while IFS= read -r dir; do
    need dart "the Dart code in ${dir}/pubspec.yaml" || continue
    need flutter "the Flutter code in ${dir}/pubspec.yaml" || continue
    flutter_pinned "$dir" && dirs+=("$dir")
  done < <(part_dirs pubspec.yaml)
  # Every part's dependencies first. dart format reads the style of an analysis_options.yaml that includes a package
  # only once it resolves, else formats in its default style (photolib-design#360). Each part formats only its own
  # files (own_dart), in its pubspec's language version.
  local resolved=()
  for dir in ${dirs[@]+"${dirs[@]}"}; do locked "$dir" && resolved+=("$dir"); done
  # Code generation rewrites what the web part compiles, and build/ moves: it waits for this.
  for dir in ${resolved[@]+"${resolved[@]}"}; do
    [[ ! -f $dir/build.yaml ]] ||
      generated_current "$dir" generated_files dart run build_runner build --force-jit --delete-conflicting-outputs
    [[ ! -f $dir/l10n.yaml ]] || generated_current "$dir" l10n_files flutter gen-l10n
    exec_capable_build "$dir"
  done
  : >"$STATE/dart_prepared"
  # With room for more than two lanes the analysis, the web request check and the app's playback run beside the tests,
  # each in the background, its output kept and printed after the tests', so that the part's output stays whole (the
  # driver reads a part's failures between its `=== <part>` and `=== <part> took`). The last two wait for the app's
  # tests, which share its build/ and .dart_tool with them, and for the analysis, which their builds beside it made
  # count findings twice. Problems sort by step number: theirs follow the tests'.
  local later='' pids=() phase
  [[ -z $DEFER ]] || ((CHECK_JOBS < 3)) || later=1
  # shellcheck disable=SC2030 # each background check numbers its own steps
  if [[ -n $later ]]; then
    : >"$STATE/dart_linting"
    (SEQ=100000 && dart_lint ${resolved[@]+"${resolved[@]}"}; : >"$STATE/dart_linted") >"$STATE/dart.lint" 2>&1 &
    pids+=($!)
    (SEQ=200000 && dart_after_tests && dart_requests ${resolved[@]+"${resolved[@]}"}) >"$STATE/dart.requests" 2>&1 &
    pids+=($!)
    (SEQ=300000 && dart_after_tests && dart_play) >"$STATE/dart.play" 2>&1 &
    pids+=($!)
  fi
  for dir in ${resolved[@]+"${resolved[@]}"}; do
    local own version
    own=$(own_dart "$dir")
    version=$(sed -n 's/^  sdk: *[\^>=]*\([0-9]*\.[0-9]*\).*/--language-version=\1/p' "$dir/pubspec.yaml")
    # shellcheck disable=SC2086 # one path a word; paths in a package have no spaces
    [[ -z $own ]] || step "$dir" dart format $version --output=none --set-exit-if-changed $own
    [[ -n $later ]] || dart_lint "$dir"
    if [[ -d $dir/test ]]; then
      local run=step alone=() flaky=()
      [[ $FRAME_BUDGETS == *" $dir "* ]] && run=budget
      # Tests tagged `alone` in dart_test.yaml measure time on the whole machine: a budget step of their own.
      [[ -n $(sed -n '/^  alone:/p' "$dir/dart_test.yaml" 2>/dev/null) ]] && alone=(--exclude-tags alone)
      # Tests tagged `timing` fail on a loaded or small machine without a fault in the code: a
      # step of their own, which CI (CHECK_ADVISORY) reports without failing on and the train fails on.
      [[ -n $(sed -n '/^  timing:/p' "$dir/dart_test.yaml" 2>/dev/null) ]] && flaky=(--exclude-tags timing)
      if exec_capable_build "$dir" && kernel_artifacts "$dir"; then
        "$run" "$dir" bash "$ROOT/tools/offline.sh" flutter test ${alone[@]+"${alone[@]}"} ${flaky[@]+"${flaky[@]}"}
        ((${#alone[@]} == 0)) || budget "$dir" bash "$ROOT/tools/offline.sh" flutter test --tags alone -j 1
        ((${#flaky[@]} == 0)) || step "$dir" bash "$ROOT/tools/offline.sh" flutter test --tags timing
      fi
    else
      echo "==> [$dir] no test/ directory: nothing for flutter test to run"
    fi
    [[ $dir != app ]] || : >"$STATE/dart_app_tested"
    [[ -n $later ]] || dart_requests "$dir"
  done
  : >"$STATE/dart_tested"
  if [[ -z $later ]]; then
    dart_play
    return 0
  fi
  wait "${pids[@]}"
  for phase in lint requests play; do cat "$STATE/dart.$phase"; done
}

# dart_lint <dir>...: flutter analyze and dart_code_linter, their findings against the lint baseline
# (tools/lint/ratchet.sh), and the licence allow-list.
dart_lint() {
  local dir
  for dir; do
    if need python3 "the lint ratchet and the licence allow-list check of ${dir}/pubspec.yaml"; then
      step . bash tools/lint/ratchet.sh dart "$dir"
      step . python3 tools/dart_licenses.py "$dir"
    fi
  done
}

# dart_after_tests: waits until the tests of app are done, or those of every package when app has none to run, and
# until the analysis check_dart runs in the background is: the builds that wait here change what it reads.
dart_after_tests() {
  until [[ -e $STATE/dart_app_tested || -e $STATE/dart_tested ]]; do sleep 1; done
  until [[ ! -e $STATE/dart_linting || -e $STATE/dart_linted ]]; do sleep 1; done
}

# dart_requests <dir>...: a web app must load nothing from another origin, fonts included (docs/dev/flutter.md); needs
# Chrome.
dart_requests() {
  local dir
  for dir; do
    if [[ -f $dir/web/index.html ]]; then
      need python3 "the web request check of ${dir}" && retried . python3 tools/web_requests.py "$dir"
    fi
  done
}

# dart_play: every corpus video and motion photo plays with the app's players on this desktop: libmpv's on Linux
# (ADR-0112).
dart_play() {
  [[ -f tools/video/app_play.sh && $(uname) == Linux ]] || return 0
  need flutter "the app's playback of the corpus" && need cargo "the kernel the app bundles" &&
    need pkg-config "the libmpv the app plays videos with" || return 0
  if ! pkg-config --exists mpv; then
    note_failure "libmpv is required for the app on Linux (Debian and Ubuntu: libmpv-dev)"
    return 0
  fi
  ready app && retried . bash tools/video/app_play.sh
}

# bundled <dir>: the kernel and ONNX Runtime its app bundles, which the dart part builds (kernel_artifacts); the web
# part, alone on a machine, builds them when they are not there.
bundled() { [[ -f $1/build/kernel/prebuilt.json ]] || kernel_artifacts "$1"; }

# ready <dir>: a Flutter package whose tests can run: its dependencies resolved and its build/ where they load from.
ready() { locked "$1" && exec_capable_build "$1"; }

# locked <dir>: true when <dir>'s Dart dependencies resolve from its committed pubspec.lock, tried once a gate: flutter
# pub get --enforce-lockfile fails a stale lock instead of rewriting it, as --locked does a Cargo.lock. The commands
# that resolve implicitly and would rewrite it (flutter analyze, test, run and drive, dart run and test) run only in a
# part it locked (photolib-design#497, photolib-design#531). With generate: true, pub get regenerates the committed
# localizations in place: it must change nothing (photolib-design#538).
locked() {
  local mark=$STATE/locked${1//\//:} before
  if [[ ! -e $mark ]]; then
    before=$(l10n_files "$1")
    need flutter "the Dart dependencies of $1" && step "$1" flutter pub get --enforce-lockfile
    echo $? >"$mark"
    [[ $(l10n_files "$1") == "$before" ]] ||
      note_failure "${1}: generated localizations were stale; commit what 'flutter gen-l10n' regenerated"
  fi
  [[ $(<"$mark") == 0 ]]
}

# own_dart <package> [<path>]: what that package's format checks, `.` unless a nested package is inside, which is
# checked on its own, in its language version: without a .dart_tool, dart format would take the latest.
own_dart() {
  local entry path=${2:-.} start=$1
  [[ $path == . ]] || start=$1/$path
  if [[ -z $(find "$start" -name '.?*' -prune -o -name pubspec.yaml ! -path "$1/pubspec.yaml" -print -quit) ]]; then
    echo "$path"
    return
  fi
  for entry in "$start"/*; do
    [[ -f $entry/pubspec.yaml ]] && continue
    entry=${entry#"$1/"}
    if [[ -d $1/$entry ]]; then own_dart "$1" "$entry"; elif [[ $entry == *.dart ]]; then echo "$entry"; fi
  done
}

# kernel_artifacts <dir>: until a kernel release is pinned (ADR-0057), a package whose build hook takes the kernel from
# a directory (hooks.user_defines.photolib_kernel.artifacts) gets it built there for this machine first. One whose hook
# takes ONNX Runtime's archive from a directory (hooks.user_defines.photolib_ml.runtime) gets this machine's pinned
# archive there, verified and kept in the tools cache (tools/ml/fetch.py), unless ONNX Runtime has no build for it
# (Intel Macs), where the hook bundles none. Here, after exec_capable_build, which may replace build/.
kernel_artifacts() {
  local out runtime os host
  out=$(sed -n '/^    photolib_kernel:/,/^    [a-z]/s/^      artifacts: *//p' "$1/pubspec.yaml")
  runtime=$(sed -n '/^    photolib_ml:/,/^    [a-z]/s/^      runtime: *//p' "$1/pubspec.yaml")
  case $(uname -s) in Darwin) os=macos ;; MINGW* | MSYS*) os=windows ;; *) os=linux ;; esac
  host=$os-$(uname -m | sed 's/x86_64/x64/; s/aarch64/arm64/')
  if [[ -n $out ]]; then
    need python3 "the kernel that ${1} bundles" &&
      setup . python3 tools/kernel/build.py --out "$1/$out" "$host" || return
  fi
  [[ -n $runtime && $(<tools/ml/artefacts.json) == *"\"ort-$host\""* ]] || return 0
  need python3 "the ONNX Runtime that ${1} bundles" &&
    setup . python3 tools/ml/fetch.py --archives "$1/$runtime" "ort-$host"
}

# generated_current <dir> <lister> <command...>: generated code is committed; regenerate it in place and fail when that
# changed what <lister> <dir> prints: build_runner's (drift; JIT, because an AOT-compiled builder cannot load from a
# noexec checkout) and gen-l10n's.
generated_current() {
  local dir=$1 list=$2 before
  shift 2
  before=$("$list" "$dir")
  step "$dir" "$@"
  [[ $("$list" "$dir") == "$before" ]] ||
    note_failure "${dir}: generated code was stale; commit what '$*' regenerated"
}

generated_files() {
  local file
  while IFS= read -r file; do
    echo "== $file"
    cat "$file"
  done < <(find "$1" -name .dart_tool -prune -o -name "${2:-*.g.dart}" -print | LC_ALL=C sort)
}

# l10n_files <dir>: the Dart that gen-l10n writes from <dir>/l10n.yaml, into its output-dir, else its arb-dir.
l10n_files() {
  [[ -f $1/l10n.yaml ]] || return 0
  local out
  out=$(sed -nE 's/^output-dir: *//p' "$1/l10n.yaml")
  out=${out:-$(sed -nE 's/^arb-dir: *//p' "$1/l10n.yaml")}
  [[ ! -d $1/${out:-lib/l10n} ]] || generated_files "$1/${out:-lib/l10n}" '*.dart'
}

# exec_capable_build <dir>: build hooks put native libraries (SQLite3MultipleCiphers) in <dir>/build, from where a
# checkout mounted noexec cannot load them; there, that git-ignored directory moves to a private cache, as
# CARGO_TARGET_DIR does for Rust. Once a gate, as a later move would pull build/ from under a running test.
exec_capable_build() {
  local mark=$STATE/build${1//\//:}
  [[ -e $mark ]] || { move_build "$1"; echo $? >"$mark"; }
  [[ $(<"$mark") == 0 ]]
}

# An earlier run's link goes first: the cache may have been cleared since, or the mount may no longer be noexec.
move_build() {
  local cache=${PHOTOLIB_CACHE:-${TMPDIR:-/var/tmp}/photolib-$UID}
  [[ ! -L $1/build ]] || rm "$1/build"
  command -v findmnt >/dev/null || return 0
  [[ $(findmnt -n -o OPTIONS --target "$1") == *noexec* ]] || return 0
  (umask 077 && mkdir -p "$cache") && mkdir -p "$cache/build$ROOT/$1"
  if [[ -L $cache || ! -O $cache ]]; then
    note_failure "$cache is not a private directory of this user; set PHOTOLIB_CACHE"
    return 1
  fi
  rm -rf "${1:?}/build" && ln -s "$cache/build$ROOT/$1" "$1/build"
}

# The web, compiled with dart2js and with dart2wasm, one suite at a time so that the first build installs its tools
# once. The API client runs over fetch in Chrome and Firefox (and on macOS in Safari, where `dart test` runs dart2js
# only). The kernel's vectors run in Chrome only for now
# (the owner, photolib-design#288, confirmed in photolib-design#303); their test builds the module with
# tools/kernel/wasm.sh, which fails over its size budget. The local store runs in the same browsers as the API client;
# its test fetches sqlite3mc.wasm and compiles the database worker with tools/data/web.sh, builds the kernel and makes
# the corpus videos whose posters the browsers draw. The
# worker pool runs in Chrome and Firefox one suite at a time, so that its 2 GiB hashes neither share a file nor compete
# for cores. The editor's shaders run in Chrome on CanvasKit (dartdevc) and Skwasm (dart2wasm) against the kernel's web
# build; their test compiles them for the web with the Flutter SDK's impellerc and builds the module with
# tools/kernel/wasm.sh. The app's thumbnails are decoded by Chrome's own decoders in a worker, and its log is kept in
# IndexedDB across reloads, on both renderers.
check_web() {
  local browsers=(-p chrome -p firefox) api=app/packages/photolib_api data=app/packages/photolib_data
  local workers=app/packages/photolib_workers ml=app/packages/photolib_ml editor=app/packages/photolib_editor
  if [[ -n $DEFER && " ${SELECTED[*]} " == *" dart "* ]]; then
    echo "check.sh: web waits for dart to resolve and generate the packages"
    until [[ -e $STATE/dart_prepared ]]; do sleep 1; done
  fi
  [[ -f $api/pubspec.yaml || -f $data/test/web_test.dart || -f $ml/test/web_test.dart ]] && [[ $(uname) == Darwin ]] &&
    browsers+=(-p safari)
  if [[ -f $api/pubspec.yaml ]] && need dart "the API client's browser tests" && ready "$api"; then
    step "$api" env MOZ_HEADLESS=1 dart test "${browsers[@]}" -c dart2js -c dart2wasm test/web_test.dart
  fi
  if [[ -f kernel/wasm/Cargo.toml ]] && need cargo "the kernel's web build (kernel/wasm)" &&
    need rustup "the kernel's web build (kernel/wasm)" && need node "the size budget of the kernel's web build" &&
    need dart "the kernel's browser tests" && ready app/packages/photolib_kernel; then
    local kernel=app/packages/photolib_kernel flaky=()
    # Its timing test is tagged timing: a step of its own, as check_dart gives the tests of that tag
    [[ -n $(sed -n '/^  timing:/p' "$kernel/dart_test.yaml" 2>/dev/null) ]] && flaky=(--exclude-tags timing)
    step "$kernel" dart test -p chrome -c dart2js -c dart2wasm -j 1 ${flaky[@]+"${flaky[@]}"} test/web_vectors_test.dart
    ((${#flaky[@]} == 0)) ||
      step "$kernel" dart test -p chrome -c dart2js -c dart2wasm -j 1 --tags timing test/web_vectors_test.dart
  fi
  if [[ -f $data/test/web_test.dart ]] && need dart "the local store's browser tests" &&
    need curl "the download of sqlite3mc.wasm (tools/data/web.sh)" && need cargo "the kernel the store's tests load" &&
    need rustup "the kernel the store's tests load" && need node "the kernel the store's tests load" &&
    ready "$data"; then
    # Its posters come from corpus videos that the pinned FFmpeg makes; on Linux, Firefox decodes their H.264 and AAC
    # with that release's libraries, as desktops do with theirs (tools/video/play.mjs).
    local libs env=(MOZ_HEADLESS=1)
    if libs=$(bash tools/video/ffmpeg.sh --libs); then
      [[ -z $libs ]] || env+=(LD_LIBRARY_PATH="$libs")
      budget "$data" env "${env[@]}" dart test "${browsers[@]}" -c dart2js -c dart2wasm -j 1 test/web_test.dart test/sync_message_test.dart test/hash_url_test.dart
    else
      note_failure "tools/video/ffmpeg.sh, which the local store's browser tests need, failed"
    fi
  fi
  if [[ -f $workers/pubspec.yaml ]] && need dart "the worker pool's browser tests" && ready "$workers"; then
    budget "$workers" env MOZ_HEADLESS=1 dart test -p chrome -p firefox -c dart2js -c dart2wasm -j 1 test/web_test.dart
  fi
  # The ML runtime spike (ADR-0050): onnxruntime-web on wasm and, where the browser has an adapter, WebGPU; on Linux,
  # headless Chrome has one (SwiftShader's) only through chrome_webgpu.sh.
  if [[ -f $ml/test/web_test.dart ]] && need dart "the ML runtime's browser tests" &&
    need python3 "the download of onnxruntime-web and the models (tools/ml/fetch.py)" && ready "$ml"; then
    local webgpu=()
    [[ $(uname) == Linux ]] &&
      webgpu=(CHROME="${CHROME_EXECUTABLE:-google-chrome}" CHROME_EXECUTABLE="$ROOT/$ml/tool/chrome_webgpu.sh")
    step "$ml" env MOZ_HEADLESS=1 ${webgpu[@]+"${webgpu[@]}"} dart test "${browsers[@]}" -c dart2js -c dart2wasm -j 1 \
      test/web_test.dart
  fi
  # Seeking in a two-hour encrypted video through the loopback proxy, MSE and a Service Worker, in Chrome and Firefox,
  # against the 1 s of design 08 §6.3 (docs/dev/encrypted-playback.md); it builds the kernel for the C ABI and WASM.
  if [[ -f tools/playback/bench.mjs ]] && playback_changed && need node "the playback benchmark" &&
    need cargo "the playback benchmark's kernel" && need rustup "the playback benchmark's kernel (WASM)" &&
    need dart "the playback benchmark's loopback proxy" && locked "$api"; then
    retried . node tools/playback/bench.mjs
  fi
  # Downloads reach the browsers' own downloads whole, streamed through the app's Service Worker in Chrome and staged in
  # Firefox, and an abort leaves no file (ADR-0128); needs Chrome and Firefox.
  if [[ -f tools/download/test.mjs ]] && need node "the web download test"; then
    retried . node tools/download/test.mjs
  fi
  # What the server renders of every corpus video, the original or R1, plays in Chrome and Firefox (design 08 §5.1);
  # it renders them with the server's video test.
  if [[ -f tools/video/play.mjs ]] && need node "the video renditions' playback" &&
    need cargo "the video renditions' playback"; then
    retried . node tools/video/play.mjs
  fi
  # The web client as a person uses it (M2-25, ADR-0385): photolibd serves the built app under its policy, and Chrome,
  # Firefox and a throttled phone in Chrome's emulation set the server up, upload by dialog and by drop, open the
  # viewer, play a video, download one photo and a zip, reload and open the app offline; WebKit too with
  # WEB_E2E_WEBKIT=1, and on macOS, where Safari's engine is what the tier needs. Needs Chrome, Firefox (Playwright's),
  # FFmpeg and PostgreSQL programs.
  if [[ -f tools/web_e2e/run.mjs ]] && need node "the web client's journey" && need npm "the web client's journey" &&
    need cargo "the web client's journey (photolibd)" && need rustup "the web client's journey (the kernel's WASM)" &&
    need flutter "the web client's journey (the app's build)" && ready app && bundled app; then
    step tools/web_e2e node --test test/lib.test.mjs
    step . node tools/web_e2e/run.mjs
    # The web's cold start budget (tools/perf/budgets.json): the engine's first frame within 2.5 s of opening the page.
    step . node tools/web_e2e/cold_start.mjs
  fi
  # The web timeline's frame budget over the 1M library (NFR-PERF-1): drag and fling in Chrome on the WASM build, which
  # times, so it runs alone.
  if [[ -f tools/timeline_bench.py ]] && need python3 "the web timeline's frame budget" &&
    need flutter "the web timeline's frame budget" && need cargo "the web timeline's library (tools/synthlib)" &&
    ready app; then
    budget . python3 tools/timeline_bench.py chrome --wasm --check
  fi
  # Passkeys in Chrome (ADR-0088): photolibd's test that registers one through the relay page with a virtual
  # authenticator and signs in with it, which the rust part skips.
  if [[ -f server/crates/photolib-server/tests/passkeys.rs ]] && need cargo "photolibd's passkey browser test" &&
    need node "the driver of photolibd's passkey browser test"; then
    retried server cargo test --locked -p photolib-server --test passkeys -- --ignored
  fi
  # Adaptive streaming (ADR-0246): hls.js in Chrome and Firefox starts photolibd's ladder within 2 s on a 3 Mbit/s link
  # and follows the link up and down without stalling; a test of photolibd's that the rust part skips, which times.
  if [[ -f server/crates/photolib-server/tests/hls.rs ]] && need cargo "photolibd's streaming browser test" &&
    need node "the driver of photolibd's streaming browser test"; then
    budget server cargo test --locked -p photolib-server --test hls -- --ignored
  fi
  if [[ -f $editor/test/web_test.dart ]] && need flutter "the editor's browser tests" &&
    need cargo "the kernel's web build (kernel/wasm)" && need rustup "the kernel's web build (kernel/wasm)" &&
    need node "the size budget of the kernel's web build" && ready "$editor" && bundled "$editor"; then
    step "$editor" flutter test --platform chrome test/web_test.dart
    step "$editor" flutter test --platform chrome --wasm test/web_test.dart
  fi
  local app_tests=(test/features/library/timeline/web_test.dart test/core/log_web_test.dart
    test/features/viewer/sphere_web_test.dart test/features/viewer/hdr_web_test.dart)
  if [[ -f app/${app_tests[0]} ]] && need flutter "the app's browser test" && ready app && bundled app; then
    step app flutter test --platform chrome "${app_tests[@]}"
    step app flutter test --platform chrome --wasm "${app_tests[@]}"
  fi
}

# playback_changed: whether the diff BASE...HEAD touches PLAYBACK; true when there is no diff to tell.
playback_changed() {
  local paths path glob
  BASE=${BASE:-$(remote)/dev}
  paths=$(git diff --name-only --no-renames "$BASE...HEAD" 2>/dev/null) || return 0
  while IFS= read -r path; do
    for glob in "${PLAYBACK[@]}"; do
      # shellcheck disable=SC2053 # a glob of PLAYBACK
      [[ $path == $glob ]] && return 0
    done
  done <<<"$paths"
  echo "check.sh: no playback code changed since $BASE: the seek benchmark does not run"
  return 1
}

check_proto() {
  local dir
  while IFS= read -r dir; do
    step "$dir" bash "$ROOT/tools/buf.sh" lint
    step "$dir" bash "$ROOT/tools/buf.sh" format --diff --exit-code
    step . bash "$ROOT/tools/proto_breaking.sh" "$dir"
  done < <(part_dirs buf.yaml)
  [[ -f proto/buf.gen.yaml ]] || return 0
  step . bash tools/codegen.sh install
  step . bash tools/codegen.sh --check
}

# What this branch adds to $REMOTE/dev: Conventional Commits and, when it moves the Flutter pin, the
# upgrade gates ticked in $PR_BODY.
check_commits() {
  [[ -e .git ]] || return 0
  need git "the checks of this branch's commits" || return 0
  local REMOTE
  REMOTE=$(remote) || { note_failure "the remote that holds dev is unknown: set PHOTOLIB_REMOTE"; return 0; }
  if ! git rev-parse -q --verify "$REMOTE/dev" >/dev/null; then
    note_failure "$REMOTE/dev is missing, so this branch's commits cannot be checked: git fetch $REMOTE dev"
    return 0
  fi
  step . bash tools/commitlint.sh "$REMOTE/dev..HEAD"
  need python3 "the Flutter upgrade gate and the lint baseline" || return 0
  step . python3 tools/flutter_upgrade_gate.py "$REMOTE/dev" HEAD
  # The lint baseline only shrinks, unless a lint-accept: <reason> line says why it grew.
  step . bash tools/lint/ratchet.sh --against "$REMOTE/dev"
}

# TypeScript: installed from the lock file without install scripts, then type-checked, tested and licence-checked.
check_node() {
  local dir
  while IFS= read -r dir; do
    need npm "the TypeScript code in ${dir}/package.json" && need node "the TypeScript code in ${dir}/package.json" ||
      continue
    step "$dir" npm ci --ignore-scripts --no-audit --no-fund
    step "$dir" npm run typecheck
    offline_retried "$dir" npm test
    need python3 "the licence allow-list check of ${dir}/package.json" &&
      step . python3 tools/node_licenses.py "$dir"
  done < <(part_dirs package.json)
}

# The other languages, their findings against the lint baseline (tools/lint/ratchet.sh), with the linters at the
# releases tools/lint/tool.sh pins, over the files git tracks; clang-tidy compiles this OS's desktop runner (app/linux).
check_lint() {
  [[ -e .git ]] || return 0
  need python3 "the lint ratchet (tools/lint/ratchet.py)" || return 0
  local linter
  for linter in shellcheck ruff eslint swiftlint ktlint; do
    step . bash tools/lint/ratchet.sh "$linter" .
  done
  [[ $(uname) != Linux || ! -f app/linux/CMakeLists.txt ]] || step . bash tools/lint/ratchet.sh clang-tidy app/linux
}

check_docs() {
  [[ -f mkdocs.yml ]] || return 0
  need python3 "the documentation site in mkdocs.yml" || return 0
  step . bash tools/docs.sh
}

# The CPU instructions of the kernel's and the server's hot paths against the base (ADR-0048), then the performance
# budgets (tools/perf/budgets.json) this machine can measure, on the synthlib fixtures.
check_perf() {
  [[ -f tools/perf/run.sh ]] || return 0
  need python3 "the performance budgets" && need cargo "the performance fixtures and benchmarks" || return 0
  need git "the base the instruction counts compare with" && need valgrind "the instruction counts (Callgrind)" &&
    step . bash tools/perf/instructions.sh
  # A rerun of run.sh measures only the budgets that failed, which the run before it left there.
  export PERF_FAILED=$STATE/perf-failed
  need flutter "the app's frame-timing benchmarks" && ready app &&
    budget . bash tools/perf/run.sh
}

# The tests the diff changes, each repeated CHECK_REPEAT times (10) with every retry off (tools/repeat.sh): a flaky test
# passes the gate on a retry, so an item's own gate (--since) is where a new or changed one is proven stable. Only
# --since runs it; the full gate has no diff, and CI retries what fails.
check_repeat() {
  [[ -f tools/repeat.sh && -n $SINCE_REV && ${CHECK_REPEAT:-10} != 0 ]] || return 0
  need git "the tests the diff changes" || return 0
  step . env "REPEAT_N=${CHECK_REPEAT:-10}" bash tools/repeat.sh --since "$SINCE_REV"
}

check_repo() {
  local test tests=() i base
  for test in tools/tests/test_*.sh; do [[ -f $test ]] && tests+=("$test"); done
  # One after another, unless the repo part has the machine to itself (CHECK_JOBS of them in a lane of its own): then
  # CHECK_JOBS at a time, each test's output kept and printed in their order once all ended, each with the step number
  # a run one after another gives it, so that problems and the report sort as that run's do
  if [[ -z $DEFER || ${#LANED[@]} != 1 ]] || ((CHECK_JOBS < 2)); then
    for test in ${tests[@]+"${tests[@]}"}; do retried . bash "$test"; done
    return
  fi
  # shellcheck disable=SC2031 # check_dart's subshells number their own steps; this is the part's own count
  base=$SEQ
  for i in "${!tests[@]}"; do
    while (($(jobs -rp | wc -l) >= CHECK_JOBS)); do wait -n; done
    # shellcheck disable=SC2030 # each test's subshell numbers its own step
    (SEQ=$((base + i)) && retried . bash "${tests[i]}") >"$STATE/repo.$i" 2>&1 &
  done
  wait
  for i in "${!tests[@]}"; do cat "$STATE/repo.$i"; done
  # shellcheck disable=SC2031 # the subshells' numbers are theirs; this one goes on after all of them
  SEQ=$((base + ${#tests[@]}))
}

# prefetch: the pinned tools and models that the suites run with egress blocked (offline) load, fetched before any part
# runs, one download at a time, so that a cold or wiped tools cache fails none of them. The ML ones are this machine's
# ONNX Runtime and the face models: photolib_ml's native_test.dart (with the int8 SFace spike.dart's `selected` picks)
# and photolib-ml's tests (photolib_ml::testing::onnx) load them.
prefetch() {
  local fetches=() fetch fetched=" " dir ort command
  case $(uname -sm) in
    "Linux x86_64") ort='ort-linux-x64' ;;
    "Linux aarch64") ort='ort-linux-arm64' ;;
    "Darwin arm64") ort='ort-macos-arm64' ;;
  esac
  if [[ " ${SELECTED[*]} " == *" rust "* ]]; then
    while IFS= read -r dir; do
      [[ ! -d $dir/crates/photolib-storage ]] || fetches+=("bash tools/garage.sh")
      [[ ! -d $dir/crates/photolib-server ]] ||
        fetches+=("bash tools/video/ffmpeg.sh" "bash tools/proxies.sh" "bash tools/postgres.sh")
      [[ ! -d $dir/crates/photolib-ml ]] || fetches+=("python3 tools/ml/fetch.py ${ort:-} yunet sface ppocr-v5-det ppocr-v5-rec-latin ppocr-v5-rec-eslav ppocr-v5-rec-chinese face-photo-armstrong-a face-photo-armstrong-b face-photo-magnus face-photo-crew")
    done < <(rust_roots)
  fi
  if [[ " ${SELECTED[*]} " == *" dart "* ]]; then
    [[ ! -d app/packages/photolib_video/test && ! -f app/test/features/library/timeline/ffmpeg_test.dart ]] ||
      fetches+=("bash tools/video/ffmpeg.sh")
    [[ ! -d app/packages/photolib_ml/test ]] || fetches+=("python3 tools/ml/fetch.py ${ort:-} yunet sface sface-int8 face-photo-armstrong-a face-photo-armstrong-b face-photo-magnus face-photo-crew")
  fi
  ((${#fetches[@]})) || return 0
  echo "=== prefetch"
  for fetch in "${fetches[@]}"; do
    [[ $fetched != *" $fetch;"* ]] || continue
    fetched+=" $fetch;"
    read -ra command <<<"$fetch"
    # A download that fails runs again (CHECK_RETRIES), as the network does; one that still fails ends the gate: the suites
    # run offline and cannot pass without it, and each would only fail on its own, after minutes of retries
    if ! need "${command[0]}" "the prefetch: $fetch" || ! SETUP=1 RETRY=1 run_step "" . "${command[@]}"; then
      echo "::error::prefetch failed: $fetch; the tests need it with egress blocked (tools/offline.sh), so none runs" \
        "(see the download's URL in the output above)" >&2
      : >"$STATE/matched" # a gate with nothing run has this failure to report, not "matched no step"
      return 1
    fi
  done
}

# since <rev>: SELECTED becomes the parts the diff <rev>...HEAD needs, by SINCE, and it says why.
since() {
  local paths path row globs glob needs part i why=(always always) skipped=()
  SELECTED=()
  need git "the diff of --since" || return
  if ! paths=$(git diff --name-only --no-renames "$1...HEAD" 2>&1); then
    note_failure "--since: cannot diff $1...HEAD: $paths"
    return
  fi
  while IFS= read -r path; do
    [[ -n $path ]] || continue
    needs=
    for row in "${SINCE[@]}"; do
      read -ra globs <<<"${row#*: }"
      for glob in "${globs[@]}"; do
        # shellcheck disable=SC2053 # a glob of SINCE
        [[ $path == $glob ]] && needs+=" ${row%%: *}" && break
      done
    done
    if [[ -z $needs || "$needs " == *" all "* ]]; then
      [[ -n $needs ]] || path+=", which no row of SINCE matches,"
      echo "check.sh: --since $1: $path needs every part"
      SELECTED=("${PARTS[@]}")
      return
    fi
    for part in $needs; do
      for i in "${!PARTS[@]}"; do [[ ${PARTS[i]} != "$part" ]] || why[i]=${why[i]:-$path}; done
    done
  done <<<"$paths"
  for i in "${!PARTS[@]}"; do
    if [[ -n ${why[i]:-} ]]; then SELECTED+=("${PARTS[i]}"); else skipped+=("${PARTS[i]}"); fi
  done
  echo "check.sh: --since $1 runs ${SELECTED[*]}; skips ${skipped[*]}"
  for i in "${!PARTS[@]}"; do [[ -z ${why[i]:-} ]] || echo "  ${PARTS[i]}: ${why[i]}"; done
}

# run_part <part>: its checks, filed under its number, then its wall time
run_part() {
  local i start=$SECONDS
  for i in "${!PARTS[@]}"; do [[ ${PARTS[i]} == "$1" ]] && PART_NO=$((i + 1)); done
  echo "=== $1"
  "check_$1"
  echo "=== $1 took $(duration $((SECONDS - start)))"
}

# run_lanes: the LANED lanes side by side, CHECK_JOBS at a time, each one's output printed whole once it ends; then the
# budget steps they deferred and perf, alone. A single lane runs in the foreground, its output as it comes, its budget
# steps deferred all the same: its own part runs its slow checks side by side then (check_dart, check_repo).
run_lanes() {
  local lane n=0 open=() seq cmd args
  DEFER=1
  ((${#LANED[@]} != 1)) || for part in ${LANED[0]}; do run_part "$part"; done
  for lane in "${LANED[@]}"; do
    ((${#LANED[@]} != 1)) || break
    while ((${#open[@]} >= CHECK_JOBS)); do flush_lanes; done
    { (for part in $lane; do run_part "$part"; done) >"$STATE/lane$n" 2>&1; : >"$STATE/lane$n.done"; } &
    open+=("$n")
    n=$((n + 1))
  done
  while ((${#open[@]})); do flush_lanes; done
  DEFER=
  if [[ -f $STATE/deferred ]]; then
    echo "=== the steps that measure time, alone"
    while read -r -u 3 PART_NO seq cmd; do
      eval "args=($cmd)"
      run_now "$seq" budget "${args[@]}"
    done 3< <(sort -n -k1,1 -k2,2 "$STATE/deferred")
  fi
  [[ " ${SELECTED[*]} " != *" perf "* ]] || run_part perf
}

flush_lanes() {
  local n still=()
  sleep 1
  for n in "${open[@]}"; do
    if [[ -f $STATE/lane$n.done ]]; then cat "$STATE/lane$n"; else still+=("$n"); fi
  done
  open=(${still[@]+"${still[@]}"})
}

SELECTED=() SINCE_REV=""
if [[ ${1:-} == --since ]]; then
  if [[ $# -eq 2 ]]; then BASE=$2 SINCE_REV=$2 && since "$2"; else note_failure "usage: tools/check.sh --since <rev>"; fi
else
  for part in "${@:-${PARTS[@]}}"; do
    if [[ " ${PARTS[*]} " == *" $part "* ]]; then
      SELECTED+=("$part")
    else
      note_failure "unknown part '$part'; the parts are: ${PARTS[*]}"
    fi
  done
fi
if ! [[ $CHECK_JOBS =~ ^[1-9][0-9]*$ && $CHECK_SILENCE =~ ^[1-9][0-9]*$ ]]; then
  note_failure "CHECK_JOBS and CHECK_SILENCE must be positive whole numbers, not '$CHECK_JOBS' and '$CHECK_SILENCE'"
  SELECTED=()
elif ! [[ ${CHECK_RETRIES:-0} =~ ^[0-9]+$ && ${CHECK_BUDGET_ATTEMPTS:-3} =~ ^[1-9][0-9]*$ ]]; then
  note_failure "CHECK_RETRIES and CHECK_BUDGET_ATTEMPTS must be whole numbers, the second positive, not \
'${CHECK_RETRIES:-}' and '${CHECK_BUDGET_ATTEMPTS:-}'"
  SELECTED=()
elif ! [[ ${CHECK_REPEAT:-10} =~ ^[0-9]+$ ]]; then
  note_failure "CHECK_REPEAT must be a whole number, not '${CHECK_REPEAT:-}'"
  SELECTED=()
fi
LANED=()
for lane in "${LANES[@]}"; do
  parts=
  for part in $lane; do [[ " ${SELECTED[*]} " != *" $part "* ]] || parts+=" $part"; done
  [[ -z $parts ]] || LANED+=("$parts")
done
prefetch || SELECTED=() LANED=()
if ((CHECK_JOBS > 1 && ${#LANED[@]})); then
  run_lanes
else
  for part in ${SELECTED[@]+"${SELECTED[@]}"}; do run_part "$part"; done
fi
# After every part, alone: the tests this diff changes, repeated (--since only, and only when a part ran).
if [[ -n $SINCE_REV ]] && ((${#SELECTED[@]})); then
  PART_NO=$((${#PARTS[@]} + 1))
  echo "=== repeat"
  repeat_start=$SECONDS
  check_repeat
  echo "=== repeat took $(duration $((SECONDS - repeat_start)))"
fi

echo
if [[ -f $STATE/times ]]; then
  echo "check.sh: slowest steps:"
  sort -rn "$STATE/times" | sed 10q | while read -r secs step; do printf '%9s  %s\n' "$(duration "$secs")" "$step"; done
fi
if [[ -f $STATE/flaky ]]; then
  sort -n -k1,1 -k2,2 "$STATE/flaky" | while read -r _ _ step; do
    echo "check.sh: flaky $step"
  done
fi
[[ -z ${CHECK_STEPS:-}${CHECK_STEPS_EXCEPT:-} || -f $STATE/matched ]] ||
  note_failure "CHECK_STEPS='${CHECK_STEPS:-}' and CHECK_STEPS_EXCEPT='${CHECK_STEPS_EXCEPT:-}' matched no step"
PROBLEMS=()
[[ ! -f $STATE/problems ]] || mapfile -t PROBLEMS < <(sort -n -k1,1 -k2,2 "$STATE/problems" | sed 's/^[0-9]* [0-9]* //')
# CHECK_REPORT=<file>: every step as "<result>\t<seconds>\t[dir] command" in the order a sequential run takes them
# (result: pass, fail, flaky or advisory), then each problem that is no step's as "problem\t0\t<problem>"; CI's report
if [[ -n ${CHECK_REPORT:-} ]]; then
  {
    [[ ! -f $STATE/report ]] || sort -n -k1,1 -k2,2 "$STATE/report" |
      while read -r _ _ result secs step; do printf '%s\t%s\t%s\n' "$result" "$secs" "$step"; done
    for problem in ${PROBLEMS[@]+"${PROBLEMS[@]}"}; do
      [[ $problem == "failed: "* ]] || printf 'problem\t0\t%s\n' "$problem"
    done
  } >"$CHECK_REPORT"
fi
if ((${#PROBLEMS[@]})); then
  echo "check.sh: ${#PROBLEMS[@]} problem(s):" >&2
  printf '  - %s\n' "${PROBLEMS[@]}" >&2
else
  echo "check.sh: all checks passed"
fi
echo "check.sh: total $(duration $SECONDS) with CHECK_JOBS=$CHECK_JOBS"
exit $((${#PROBLEMS[@]} > 0))
