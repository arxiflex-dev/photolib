#!/usr/bin/env bash
# The clock lint (tools/lint/clock.py, docs/dev/lint.md): a test file that reads the clock when it is loaded fails, the
# same read inside a function or a test passes; then the baseline that lists the reads that are left.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_tool python3
require_tool git

SANDBOX=$(mktemp -d)
trap 'rm -rf "$SANDBOX"' EXIT
mkdir -p "$SANDBOX/tools/lint" "$SANDBOX/fixtures/test"
cp "$REPO_ROOT/tools/lint/clock.py" "$SANDBOX/tools/lint/"
CLOCK="$SANDBOX/tools/lint/clock.py"
F="$SANDBOX/fixtures/test"

lint() { capture python3 -I "$CLOCK" "$@"; }
# flagged <file name> <content>: one file, linted alone
flagged() {
  printf '%s\n' "$2" >"$F/$1"
  lint "$F/$1"
  expect_result "$3" failure "$1:${4:-1}"
}
clean() {
  printf '%s\n' "$2" >"$F/$1"
  lint "$F/$1"
  expect_result "$3" 0
}

flagged top.test.mjs "const today = new Date().toLocaleDateString('en-US');" "JavaScript: new Date() at top level fails"
flagged now.test.mjs "const started = Date.now();" "JavaScript: Date.now() at top level fails"
flagged call.test.mjs "const text = Date();" "JavaScript: Date() at top level fails"
flagged perf.test.mjs "const t0 = performance.now();" "JavaScript: performance.now() at top level fails"
flagged multi.test.mjs $'const options = {\n};\nconst day = new Date()\n  .toISOString();' \
  "JavaScript: a read on a later line is found at its line" 3
flagged describe.test.mjs $'describe("x", () => {\n  const now = Date.now();\n  it("y", () => {});\n});' \
  "JavaScript: a read in a describe body, which runs while tests register, fails" 2
clean in-fn.test.mjs $'function today() {\n  return new Date().toISOString();\n}\ntest("x", async () => {\n  const t = Date.now();\n});' \
  "JavaScript: the same reads inside a function and a test pass"
clean arrow.test.mjs $'const now = () => Date.now();\nconst day = async () => new Date().getDay();' \
  "JavaScript: an arrow function that reads the clock passes"
clean dated.test.mjs "const d = new Date(2026, 9, 26); const s = 'Date.now()'; // new Date()" \
  "JavaScript: a fixed date, a string and a comment pass"

flagged top_test.dart "final started = DateTime.now();" "Dart: DateTime.now() at top level fails"
flagged main_test.dart $'void main() {\n  final now = DateTime.now();\n  test(\'x\', () {});\n}' \
  "Dart: a read in the body of main, which runs while tests register, fails" 2
flagged group_test.dart $'void main() {\n  group(\'g\', () {\n    final now = DateTime.now();\n  });\n}' \
  "Dart: a read in a group body fails" 3
clean setup_test.dart $'void main() {\n  group(\'g\', () {\n    late DateTime now;\n    setUp(() {\n      now = DateTime.now();\n    });\n    test(\'x\', () {\n      DateTime.now();\n    });\n  });\n}' \
  "Dart: reads in setUp and in a test pass"
clean getter_test.dart $'DateTime get now => DateTime.now();\nvoid main() {\n  test(\'x\', () => DateTime.now());\n}' \
  "Dart: a getter and an expression body pass"

flagged top_test.py $'import datetime\nSTART = datetime.datetime.now()' "Python: datetime.now() at module level fails" 2
flagged time_test.py $'import time\nSTART = time.time()' "Python: time.time() at module level fails" 2
flagged class_test.py $'import time\nclass T:\n    started = time.time()' "Python: a read in a class body fails" 3
flagged default_test.py $'import time\ndef f(at=time.time()):\n    return at' "Python: a read in a default value fails" 2
flagged guard_test.py $'import time\nif True:\n    START = time.time()' "Python: a read under a module-level if fails" 3
clean fn_test.py $'import time, datetime\ndef f():\n    return time.time(), datetime.date.today()\nlater = lambda: time.time()' \
  "Python: the same reads inside a def and a lambda pass"

mkdir -p "$SANDBOX/src"
printf 'const t = Date.now();\n' >"$SANDBOX/src/not-a-test.mjs"
lint "$SANDBOX/src/not-a-test.mjs"
[[ $STATUS -ne 0 ]] && ok "a file named on the command line is always checked" || fail "not-a-test.mjs passed"

# The baseline, over the files git tracks.
cd "$SANDBOX" || exit 1
git init -q -b main
mkdir -p tools/web_e2e
printf 'const t = new Date();\n' >tools/web_e2e/a.mjs
printf 'const t = 1;\n' >tools/web_e2e/b.mjs
git add -A tools/web_e2e
printf '{}\n' >tools/lint/clock-baseline.json
lint
expect_result "a read the baseline does not hold fails, naming the file and the line" failure "tools/web_e2e/a.mjs:1" "baseline 0"
printf '{"tools/web_e2e/a.mjs": {"reads": 1, "reason": "run once, before anything else"}}\n' >tools/lint/clock-baseline.json
lint
expect_result "a read the baseline holds, with its reason, passes" 0
printf '{"tools/web_e2e/a.mjs": {"reads": 1, "reason": ""}}\n' >tools/lint/clock-baseline.json
lint
expect_result "a baseline entry without a reason fails" failure "has no reason"
printf 'const t = new Date();\nconst u = Date.now();\n' >tools/web_e2e/a.mjs
printf '{"tools/web_e2e/a.mjs": {"reads": 1, "reason": "x"}}\n' >tools/lint/clock-baseline.json
lint
expect_result "a second read in a baselined file fails" failure "2 clock reads"
printf 'const t = 1;\n' >tools/web_e2e/a.mjs
lint
expect_result "a baselined file that no longer reads the clock must leave the baseline" failure "tools/web_e2e/a.mjs: 0 clock reads" "baseline 1"
printf '{"tools/web_e2e/gone.mjs": {"reads": 1, "reason": "x"}}\n' >tools/lint/clock-baseline.json
lint
expect_result "a baseline entry for a file that is gone fails" failure "gone.mjs: in the baseline but not"

# The tree itself.
capture python3 -I "$REPO_ROOT/tools/lint/clock.py"
expect_result "the tracked test files of this repository are clean against the baseline" 0

finish
