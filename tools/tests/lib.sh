# Shared helpers for tools/tests/test_*.sh. Source it; do not run it.
# shellcheck shell=bash
# A test reports every failed assertion as "FAIL: ..." and exits non-zero at the end (call `finish`).

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
FAILURES=0

# Sandboxes' commits run none of the caller's git hooks (a global or session core.hooksPath); the last entry wins.
export GIT_CONFIG_COUNT=$((${GIT_CONFIG_COUNT:-0} + 1))
export "GIT_CONFIG_KEY_$((GIT_CONFIG_COUNT - 1))=core.hooksPath" "GIT_CONFIG_VALUE_$((GIT_CONFIG_COUNT - 1))=/dev/null"

fail() {
  echo "FAIL: $*" >&2
  FAILURES=$((FAILURES + 1))
}

ok() {
  echo "ok: $*"
}

# check <description> <command...>: passes when the command exits 0.
check() {
  local description=$1
  shift
  if "$@" >/dev/null 2>&1; then ok "$description"; else fail "$description"; fi
}

# assert_file <path>: the file exists relative to the repository root.
assert_file() {
  if [[ -f "$REPO_ROOT/$1" ]]; then ok "file $1 exists"; else fail "missing file $1"; fi
}

# assert_matches <path> <extended-regex> <description>: the file contains a line matching the regex.
assert_matches() {
  local path=$1 pattern=$2 description=$3
  if [[ -f "$REPO_ROOT/$path" ]] && grep -Eqi -- "$pattern" "$REPO_ROOT/$path"; then
    ok "$path: $description"
  else
    fail "$path: $description (no line matches /$pattern/)"
  fi
}

# assert_prose <path> <extended-regex> <description>: like assert_matches over the whole file joined into one line,
# so line wrapping cannot hide a sentence.
assert_prose() {
  local path=$1 pattern=$2 description=$3
  if [[ -f "$REPO_ROOT/$path" ]] && tr '\n' ' ' <"$REPO_ROOT/$path" | tr -s ' ' | grep -Eqi -- "$pattern"; then
    ok "$path: $description"
  else
    fail "$path: $description (no match for /$pattern/)"
  fi
}

# assert_patterns <assertion> <path> <pattern> <description>...
assert_patterns() {
  local assertion=$1 path=$2
  shift 2
  while [[ $# -gt 0 ]]; do
    "$assertion" "$path" "$1" "$2"
    shift 2
  done
}

require_tool() {
  command -v "$1" >/dev/null 2>&1 || { echo "FAIL: required tool '$1' is not on PATH" >&2; exit 1; }
}

# Captured commands leave their combined output in OUT and exit code in STATUS.
capture() {
  OUT=$("$@" 2>&1)
  STATUS=$?
}

# expect_result <description> <status|failure> [literal output fragment...]
expect_result() {
  local description=$1 expected=$2 fragment matches=true
  shift 2
  if [[ $expected == failure ]]; then
    [[ $STATUS -ne 0 ]] || matches=false
  else
    [[ $STATUS -eq $expected ]] || matches=false
  fi
  for fragment in "$@"; do
    [[ $OUT == *"$fragment"* ]] || matches=false
  done
  if $matches; then ok "$description"; else
    fail "$description: wanted $expected, got $STATUS: $OUT"
  fi
}

# Only these real tools are visible to a sandbox; everything else must be a stub.
sandbox_tools() {
  SANDBOXES=()
  BASE_BIN=$(mktemp -d)
  SANDBOXES+=("$BASE_BIN")
  trap 'rm -rf "${SANDBOXES[@]}"' EXIT
  local tool
  for tool in "$@"; do
    ln -s "$(command -v "$tool")" "$BASE_BIN/$tool"
  done
}

stub_command() {
  local path=$1 name=$2
  cat >"$path" <<STUB
#!/bin/bash
echo "$name \$* @\${PWD#$SANDBOX}" >> "$SANDBOX/calls.log"
[[ "\$*" == "--version --machine" ]] && echo "{ \"frameworkVersion\": \"\${FLUTTER_VERSION:-3.47.7}\" }"
[[ "\$FAIL_ON" == "$name \$*" ]] && exit 1
exit 0
STUB
  chmod +x "$path"
}

# new_sandbox <repository-relative script> <stubbed tool...>
new_sandbox() {
  local script=$1 tool
  shift
  SANDBOX=$(mktemp -d)
  SANDBOXES+=("$SANDBOX")
  mkdir -p "$SANDBOX/$(dirname "$script")" "$SANDBOX/stubs"
  cp "$REPO_ROOT/$script" "$SANDBOX/$script"
  # the tools name the remote they compare with through tools/remote.sh
  [[ $script != tools/* ]] || cp "$REPO_ROOT/tools/remote.sh" "$SANDBOX/tools/remote.sh"
  for tool in "$@"; do
    stub_command "$SANDBOX/stubs/$tool" "$tool"
  done
  : >"$SANDBOX/calls.log"
}

calls() {
  cat "$SANDBOX/calls.log"
}

# stale_package <dir> <name>: a Dart package whose pubspec.lock still holds a dependency its pubspec.yaml dropped; the
# lock is also copied to <dir>.lock, to compare with what is left of it.
stale_package() {
  mkdir -p "$1"
  printf 'name: %s\nenvironment:\n  sdk: ^3.9.0\n' "$2" >"$1/pubspec.yaml"
  printf '%s\n' 'packages:' '  style:' '    dependency: "direct main"' '    description:' '      path: style' \
    '      relative: true' '    source: path' '    version: "0.0.0"' 'sdks:' '  dart: ">=3.9.0 <4.0.0"' \
    | tee "$1.lock" >"$1/pubspec.lock"
}

expect_calls() {
  local description=$1 expected=$2
  if [[ "$(calls)" == "$expected" ]]; then ok "$description"; else
    fail "$description: expected calls
$expected
got
$(calls)"
  fi
}

finish() {
  if [[ $FAILURES -ne 0 ]]; then
    echo "$FAILURES assertion(s) failed" >&2
    exit 1
  fi
}

# thawed <command...>: a case that judges wall time; runs it again while it ran through a stop of this test of 5 s or
# more (3 runs at most). While the merge train measures time, photolib-design's tools/agent/quiet.sh stops agents' runs
# for minutes and resumes their steps 90 s before every `bash tools/check.sh`: a silent step's sleep ran out before its
# gate could kill it, and the gate passed after 6 min (photolib-design#597).
thawed() {
  local try ticker gap t last ticks
  ticks=$(mktemp)
  for try in 1 2 3; do
    # The first and last ticks are this shell's: a stop before the ticker's first tick or after its last is a gap too.
    echo "$SECONDS" >"$ticks"
    (while sleep 1; do echo "$SECONDS"; done) >>"$ticks" &
    ticker=$!
    "$@"
    kill "$ticker"
    wait "$ticker" 2>/dev/null
    echo "$SECONDS" >>"$ticks"
    gap=0 last=
    while read -r t; do ((t - ${last:-$t} > gap)) && gap=$((t - last)); last=$t; done <"$ticks"
    ((gap < 5)) && break
    echo "this test was stopped for $gap s meanwhile: once more ($try)"
  done
  rm -f "$ticks"
}

# frozen <command...>: runs it as quiet.sh stops a run: in a process group of its own, stopped 1 s in for 12 s while
# what it started in groups of their own runs on. Its failures count here.
frozen() {
  local case
  set -m
  (failed=$FAILURES; "$@"; exit $((FAILURES - failed))) &
  case=$!
  set +m
  (sleep 1 && kill -STOP -- -"$case" && sleep 12 && kill -CONT -- -"$case") &
  wait "$case"
  FAILURES=$((FAILURES + $?))
}
