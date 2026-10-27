#!/usr/bin/env bash
# The lint ratchet (tools/lint/ratchet.sh, docs/dev/lint.md) against stubbed linters in a throwaway repository: a new
# finding fails, a cleaned one must be burned off the baseline, which never grows; then the rules it relies on.
# shellcheck disable=SC2016 # stubs are literal scripts
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_tool git
require_tool python3

SANDBOX=$(mktemp -d)
trap 'rm -rf "$SANDBOX"' EXIT
mkdir -p "$SANDBOX/tools/lint" "$SANDBOX/stubs"
cp "$REPO_ROOT/tools/lint/ratchet.sh" "$REPO_ROOT/tools/lint/ratchet.py" "$SANDBOX/tools/lint/"
echo '{}' >"$SANDBOX/tools/lint/baseline.json"
# The stub reports SC2086 on every line that says VIOLATION.
cat >"$SANDBOX/tools/lint/tool.sh" <<'STUB'
#!/bin/bash
[[ $1 == shellcheck ]] || exit 3
exec python3 -c '
import json, sys
found = [{"file": f, "line": n, "code": 2086, "level": "info", "message": "Double quote"}
         for f in sys.argv[1:] if f.endswith(".sh") for n, l in enumerate(open(f), 1) if "VIOLATION" in l]
print(json.dumps({"comments": found}))
sys.exit(1 if found else 0)' "${@:2}"
STUB
git -C "$SANDBOX" init -q -b main
git -C "$SANDBOX" config user.email lint@example.org
git -C "$SANDBOX" config user.name lint

lint() { capture bash -c 'cd "$0" && PATH="$0/stubs:$PATH" bash tools/lint/ratchet.sh "$@"' "$SANDBOX" "$@"; }
entry() { python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("shellcheck .", {}).get("a.sh", {}))' \
  "$SANDBOX/tools/lint/baseline.json"; }
commit() { git -C "$SANDBOX" add -A && git -C "$SANDBOX" commit -qm "$1"; }

printf 'echo $1 # VIOLATION\n' >"$SANDBOX/a.sh"
commit "add a.sh"
lint shellcheck .
expect_result "a finding the baseline does not hold fails, naming the file, the line and the rule" failure \
  "a.sh:1: SC2086" "a.sh: SC2086: 1, baseline 0"
lint --update shellcheck .
expect_result "--update refuses to grow the baseline" failure "would grow"
[[ $(entry) == '{}' ]] && ok "a refused update leaves the baseline as it was" || fail "the baseline changed: $(entry)"
lint --update --grow shellcheck .
expect_result "--update --grow records today's findings" 0
[[ $(entry) == "{'SC2086': 1}" ]] && ok "the baseline counts per rule and file" || fail "baseline entry: $(entry)"
lint shellcheck .
expect_result "findings the baseline holds pass" 0
commit "record the baseline"
base=$(git -C "$SANDBOX" rev-parse HEAD)

printf 'echo $1 # VIOLATION\necho $2 # VIOLATION\n' >"$SANDBOX/a.sh"
lint shellcheck .
expect_result "a violation added to a file in the baseline fails the gate" failure "a.sh: SC2086: 2, baseline 1"
lint --update shellcheck .
expect_result "and the baseline update refuses to grow" failure "a.sh: SC2086: 2, baseline 1" "would grow"
[[ $(entry) == "{'SC2086': 1}" ]] && ok "the refused update keeps the old count" || fail "baseline entry: $(entry)"

printf 'echo "$1"\n' >"$SANDBOX/a.sh"
lint shellcheck .
expect_result "a cleaned file fails until the baseline is burned down" failure "a.sh: SC2086: 0, baseline 1" \
  "tools/lint/ratchet.sh --update shellcheck ."
lint --update
expect_result "--update re-measures every run of the baseline and shrinks it" 0
[[ $(entry) == '{}' ]] && ok "the cleaned file left the baseline" || fail "baseline entry: $(entry)"
lint shellcheck .
expect_result "the shrunk baseline passes" 0
commit "burn down a.sh"

lint --against "$base"
expect_result "a baseline no larger than the base's passes" 0
python3 - "$SANDBOX/tools/lint/baseline.json" <<'PY'
import json, sys
json.dump({"shellcheck .": {"a.sh": {"SC2086": 2}}}, open(sys.argv[1], "w"))
PY
commit "grow the baseline by hand"
lint --against "$base"
expect_result "a baseline that grew against the base fails" failure "a.sh: SC2086: 2, base 1"
PR_BODY=$'Clippy 1.100 adds lints.\nlint-accept: a toolchain upgrade' lint --against "$base"
expect_result "unless the pull request says why in a lint-accept line" 0
git -C "$SANDBOX" commit -q --allow-empty -m $'chore: bump the toolchain\n\nlint-accept: new pedantic lints'
lint --against "$base"
expect_result "or a commit since the base does" 0

lint --top 5
expect_result "--top lists the files with the most baseline entries" 0 "2 a.sh"

mkdir -p "$SANDBOX/gen"
printf 'echo $1 # VIOLATION\n' >"$SANDBOX/gen/made.sh"
printf 'echo $1 # VIOLATION\n' >"$SANDBOX/b.sh"
commit "add generated and new files"
lint shellcheck .
expect_result "generated code is not linted, everything else is" failure "b.sh: SC2086: 1, baseline 0"
[[ $OUT != *made.sh* ]] && ok "gen/ is skipped" || fail "generated code was linted: $OUT"
lint nonsense .
expect_result "an unknown linter fails and names the linters" failure "unknown linter 'nonsense'" "shellcheck"
rm "$SANDBOX/b.sh" "$SANDBOX/gen/made.sh"
commit "drop them"

# --- Rust: crash classes count only outside tests (a second clippy over --lib --bins); everything else everywhere.
mkdir -p "$SANDBOX/rs"
finding() {
  printf '{"reason":"compiler-message","message":{"level":"warning","code":{"code":"%s"},"rendered":"%s",' "$1" "$1"
  printf '"spans":[{"is_primary":true,"file_name":"%s","line_start":%s,"column_start":1}]}}\n' "$2" "$3"
}
{
  finding clippy::unwrap_used src/lib.rs 3
  finding clippy::unwrap_used src/lib.rs 9
  finding clippy::unwrap_used tests/it.rs 2
  finding clippy::doc_markdown tests/it.rs 1
  finding clippy::doc_markdown tests/it.rs 1
  echo '{"reason":"compiler-message","message":{"level":"warning","code":null,"rendered":"2 warnings","spans":[]}}'
} >"$SANDBOX/rs/all.jsonl"
finding clippy::unwrap_used src/lib.rs 3 >"$SANDBOX/rs/shipped.jsonl"
cat >"$SANDBOX/stubs/cargo" <<'STUB'
#!/bin/bash
echo "cargo $*" >>../calls.log
if [[ " $* " == *" --all-targets "* ]]; then cat all.jsonl; else cat shipped.jsonl; fi
STUB
chmod +x "$SANDBOX/stubs/cargo"
lint clippy rs
expect_result "clippy findings are counted per rule and file" failure \
  "rs/src/lib.rs: clippy::unwrap_used: 1, baseline 0" "rs/tests/it.rs: clippy::doc_markdown: 1, baseline 0"
[[ $OUT != *"rs/tests/it.rs: clippy::unwrap_used"* ]] && ok "an unwrap in a test or an integration test is allowed" ||
  fail "a test's unwrap was counted: $OUT"
[[ $(cat "$SANDBOX/calls.log") == "cargo clippy --locked --all-targets --message-format=json
cargo clippy --locked --lib --bins --message-format=json" ]] &&
  ok "clippy runs over all targets, then over shipped code" || fail "clippy calls: $(cat "$SANDBOX/calls.log")"
printf '#!/bin/bash\necho "error: could not compile" >&2\nexit 101\n' >"$SANDBOX/stubs/cargo"
lint clippy rs
expect_result "code that does not compile fails the ratchet" failure "could not compile"

# --- Dart: the analyzer, dart_code_linter's rules, metrics and unused code, and file length; crash rules outside tests.
mkdir -p "$SANDBOX/dart/lib" "$SANDBOX/dart/test" "$SANDBOX/dart/packages/inner/lib"
python3 -c 'print("\n".join(["// line"] * 801))' >"$SANDBOX/dart/lib/long.dart"
python3 -c 'print("\n".join(["// line"] * 801))' >"$SANDBOX/dart/packages/inner/lib/long.dart"
: >"$SANDBOX/dart/packages/inner/pubspec.yaml"
cp "$SANDBOX/dart/lib/long.dart" "$SANDBOX/dart/lib/a.g.dart"
cat >"$SANDBOX/stubs/flutter" <<'STUB'
#!/bin/bash
cat <<'OUT'
Analyzing dart...
   info • Missing documentation • lib/a.dart:3:1 • public_member_api_docs
warning • Dynamic call • lib/a.dart:7:5 • avoid_dynamic_calls
warning • Dynamic call • test/a_test.dart:7:5 • avoid_dynamic_calls
3 issues found.
OUT
STUB
cat >"$SANDBOX/stubs/dart" <<'STUB'
#!/bin/bash
case "$*" in
  *" analyze "*)
    for arg; do [[ $arg == --json-path=* ]] && json=${arg#--json-path=}; done
    cat >"$json" <<'JSON'
{"records": [{"path": "lib/a.dart", "issues": [{"ruleId": "avoid-non-null-assertion", "message": "Avoid !",
  "codeSpan": {"start": {"line": 4}}}], "classes": {}, "functions": {"f": {"codeSpan": {"start": {"line": 2}},
  "metrics": [{"metricsId": "cyclomatic-complexity", "level": "warning", "comment": "complexity 25"},
              {"metricsId": "halstead-volume", "level": "warning", "comment": "not a limit of ours"},
              {"metricsId": "source-lines-of-code", "level": "noted", "comment": "70 lines"}]}}},
 {"path": "test/a_test.dart", "issues": [{"ruleId": "avoid-non-null-assertion", "message": "Avoid !",
  "codeSpan": {"start": {"line": 4}}}], "classes": {}, "functions": {}}]}
JSON
    ;;
  *check-unused-code*) echo '{"unusedCode": [{"path": "lib/a.dart", "issues": [{"declarationName": "g", "line": 9}]}]}' ;;
  *check-unused-files*) echo '{"unusedFiles": [{"path": "lib/orphan.dart"}]}' ;;
esac
STUB
chmod +x "$SANDBOX/stubs/flutter" "$SANDBOX/stubs/dart"
commit "add a Dart package"
lint dart dart
expect_result "the Dart linters' findings are counted per rule and file" failure \
  "dart/lib/a.dart: public_member_api_docs: 1, baseline 0" "dart/lib/a.dart: avoid_dynamic_calls: 1, baseline 0" \
  "dart/lib/a.dart: avoid-non-null-assertion: 1, baseline 0" "dart/lib/a.dart: cyclomatic-complexity: 1, baseline 0" \
  "dart/lib/a.dart: unused-code: 1, baseline 0" "dart/lib/orphan.dart: unused-files: 1, baseline 0" \
  "dart/lib/long.dart: file-length: 1, baseline 0"
for absent in "test/a_test.dart" "halstead" "source-lines-of-code" "inner" "a.g.dart"; do
  [[ $OUT != *"$absent"* ]] && ok "not counted: $absent" || fail "counted $absent: $OUT"
done

# dart_code_linter prints its JSON on stdout beside a spinner, an "Update available" notice once pub.dev has a newer
# release (CI run 40422019567: "Extra data"), and no JSON at all when it finds nothing. The stub prints $UNUSED_CODE
# for check-unused-code and $UNUSED_FILES for check-unused-files, verbatim, and nothing else to count.
cat >"$SANDBOX/stubs/dart" <<'STUB'
#!/bin/bash
case "$*" in
  *" analyze "*)
    for arg; do [[ $arg == --json-path=* ]] && json=${arg#--json-path=}; done
    echo '{"records": []}' >"$json" ;;
  *check-unused-code*) printf '%s' "$UNUSED_CODE" ;;
  *check-unused-files*) printf '%s' "$UNUSED_FILES" ;;
esac
STUB
DONE=$'\n\xe2\x9c\x94 Analysis is completed. Preparing the results: 4.3s\n\n'
CODE='{"formatVersion":3,"unusedCode":[{"path":"lib/a.dart","issues":[{"declarationName":"g","line":9}]}]}'
NOTICE=$'\n\xf0\x9f\x86\x95 Update available! 4.4.2 -> 4.4.3\n\xf0\x9f\x86\x95 Changelog: https://example.org/{v4.4.3}\n'
dart_lint() { UNUSED_CODE=$1 UNUSED_FILES=$2 lint dart dart; }
dart_lint "$DONE$CODE$NOTICE" "$DONE"
expect_result "text after the JSON of check-unused-code does not hide its finding" failure \
  "dart/lib/a.dart: unused-code: 1, baseline 0"
[[ $OUT != *Traceback* ]] && ok "no traceback after trailing text" || fail "traceback: $OUT"
dart_lint "$DONE$CODE"$'\n{"formatVersion":3,"unusedCode":[]}\n' "$DONE"
expect_result "only the first of two JSON documents is read" failure "dart/lib/a.dart: unused-code: 1, baseline 0"
dart_lint $'progress {1/2}\n'"$CODE$NOTICE" "$DONE"
expect_result "a brace in text before the JSON is skipped" failure "dart/lib/a.dart: unused-code: 1, baseline 0"
dart_lint "$DONE" "$DONE$NOTICE"
expect_result "a clean run (no JSON, completion line) has only the analyzer's findings" failure \
  "dart/lib/a.dart: avoid_dynamic_calls: 1, baseline 0"
[[ $OUT != *unused* && $OUT != *"no JSON"* ]] && ok "a clean run reports no unused code and no error" || fail "$OUT"
dart_lint "" "$DONE"
expect_result "empty output is an error naming the command and the package, not a traceback" failure \
  "check-unused-code" "in dart" "no output"
[[ $OUT != *Traceback* ]] && ok "no traceback for empty output" || fail "traceback: $OUT"
dart_lint "$DONE" $'Could not resolve the package config {x}\nbye'
expect_result "output with neither JSON nor completion line is an error showing its head" failure \
  "check-unused-files" "in dart" "Could not resolve the package config"
dart_lint "$DONE"$'{"unusedCode": [\n' "$DONE"
expect_result "a truncated JSON document is an error showing its head" failure "check-unused-code" "in dart" "unusedCode"

# --- the pinned linters: a missing prerequisite fails loudly
mkdir -p "$SANDBOX/bin"
for tool in bash uname id dirname; do ln -s "$(command -v "$tool")" "$SANDBOX/bin/$tool"; done
capture env PATH="$SANDBOX/bin" bash "$REPO_ROOT/tools/lint/tool.sh" ktlint --version
expect_result "ktlint without java fails loudly" failure "'java' (a JDK 11 or later) is required for ktlint"
capture env PATH="$SANDBOX/bin" bash "$REPO_ROOT/tools/lint/tool.sh" eslint --version
expect_result "eslint without npm fails loudly" failure "'npm' is required to fetch eslint"
capture bash "$REPO_ROOT/tools/lint/tool.sh" nonsense
expect_result "an unknown tool fails" failure "unknown tool 'nonsense'"
# A stub fetch beside a copy of tool.sh: clang-tidy is fetched once, and again when the cache lacks its headers, as
# fetch_release.sh before photolib-design#575 left it.
mkdir -p "$SANDBOX/pinned/tools/lint"
cp "$REPO_ROOT/tools/lint/tool.sh" "$SANDBOX/pinned/tools/lint/"
cat >"$SANDBOX/pinned/tools/fetch_release.sh" <<'STUB'
echo "$@" >>"$(dirname "$0")/fetches"
mkdir -p "$(dirname "$3/$4")" "$3/clang_tidy/data/lib/clang"
printf '#!/bin/sh\necho clang-tidy "$@"\n' >"$3/$4"
STUB
fetches() { wc -l <"$SANDBOX/pinned/tools/fetches"; }
tidy() {
  capture env PHOTOLIB_TOOLS_CACHE="$SANDBOX/pinned/cache" bash "$SANDBOX/pinned/tools/lint/tool.sh" clang-tidy -v
}
tidy
expect_result "clang-tidy is fetched with its headers, then run" 0 "clang-tidy -v"
tidy
[[ $STATUS -eq 0 && $(fetches) -eq 1 ]] && ok "then it is not fetched again" || fail "fetched $(fetches) times: $OUT"
rm -r "$SANDBOX"/pinned/cache/clang-tidy-*/clang_tidy/data/lib
tidy
[[ $STATUS -eq 0 && $(fetches) -eq 2 ]] && ok "a cache without its headers is fetched again" ||
  fail "without headers: fetched $(fetches) times: $OUT"

# --- the rules: the same in every Rust workspace and every Dart package, with the limits the project set
cd "$REPO_ROOT" || exit 1
rules() { sed -n '/^# The project/,/^$/p; /^\[\(workspace\.\)\{0,1\}lints\.clippy\]$/,/^$/p' "$1" | sed 's/workspace.//'; }
for manifest in server/Cargo.toml tools/synthlib/Cargo.toml; do
  [[ $(rules "$manifest") == "$(rules kernel/Cargo.toml)" ]] && ok "$manifest has the kernel's lint table" ||
    fail "$manifest's lint table differs from the kernel's: $(diff <(rules "$manifest") <(rules kernel/Cargo.toml))"
done
for root in kernel server tools/synthlib; do
  assert_patterns assert_matches "$root/Cargo.toml" '^pedantic = \{ level = "warn"' "enables clippy's pedantic group" \
    '^nursery = \{ level = "warn"' "and its nursery group" '^missing_docs = "warn"' "requires docs on public items" \
    '^unwrap_used = "warn"' "flags unwraps" '^arithmetic_side_effects = "warn"' "and arithmetic that can overflow"
  assert_prose "$root/Cargo.toml" \
    '\[profile\.release\] overflow-checks = true \[profile\.test\] overflow-checks = true' "checks overflow everywhere"
  assert_patterns assert_matches "$root/clippy.toml" '^too-many-lines-threshold = 80$' "limits functions to 80 lines" \
    '^cognitive-complexity-threshold = 20$' "and their complexity to 20"
  assert_matches "$root/rustfmt.toml" '^max_width = 120$' "formats at 120 columns"
  [[ ! -e $root/rust-toolchain.toml && ! -e $root/rust-toolchain ]] && ok "$root builds with the repository's Rust" ||
    fail "$root overrides rust-toolchain.toml"
done
# A new stable's clippy brings lints the baseline does not hold: the Rust release moves only on purpose.
assert_patterns assert_matches rust-toolchain.toml '^channel = "[0-9]+\.[0-9]+\.[0-9]+"$' "pins an exact Rust release" \
  '^components = \["clippy", "rustfmt"\]$' "with clippy and rustfmt"
assert_prose AGENTS.md '`rust-toolchain\.toml` pins' "says how the Rust release moves"
assert_patterns assert_matches app/analysis_options.yaml '^include: package:very_good_analysis/' "uses very_good_analysis" \
  'strict-casts: true' "casts strictly" 'strict-inference: true' "infers strictly" 'strict-raw-types: true' \
  "allows no raw types" 'cyclomatic-complexity: 20' "limits complexity to 20" 'source-lines-of-code: 80' \
  "limits functions to 80 lines" 'avoid-non-null-assertion' "denies the null assertion"
for pubspec in app/pubspec.yaml app/packages/*/pubspec.yaml; do
  package=${pubspec%/pubspec.yaml}
  [[ $package == app ]] ||
    assert_matches "$package/analysis_options.yaml" '^include: \.\./\.\./analysis_options\.yaml$' "uses the app's analysis"
  assert_patterns assert_matches "$pubspec" '^  very_good_analysis:' "depends on very_good_analysis" \
    '^  dart_code_linter:' "and on dart_code_linter"
done
assert_patterns assert_matches .swiftlint.yml '^  - force_unwrapping$' "SwiftLint denies force unwraps" \
  '^  - implicitly_unwrapped_optional$' "and implicitly unwrapped optionals"
assert_matches .clang-tidy "Checks: '-\*,clang-diagnostic-\*,bugprone-\*,cert-\*'" "clang-tidy: bug-prone and CERT checks"
assert_matches app/linux/CMakeLists.txt 'PRIVATE -Wall -Werror\)' "the Linux build fails on a warning"
assert_matches app/linux/runner/CMakeLists.txt 'PRIVATE -Wextra\)' "and the runner's code builds with -Wextra"
assert_patterns assert_matches ruff.toml '^line-length = 120$' "Python lines are 120 columns" \
  '^extend-select = \["E501"\]$' "and ruff checks it"
assert_matches eslint.config.mjs "no-unused-vars': 'error'" "eslint finds unused variables"
assert_patterns assert_prose AGENTS.md 'ratchet\.sh --update <linter> <dir>' "says how to burn the baseline down" \
  'Refactor runs burn it down' "and who does" 'lint-accept: <reason>' "and when it may grow"
for language in Rust Dart Swift Kotlin C++ Python Shell TypeScript; do
  assert_matches docs/dev/lint.md "^\| [^|]*${language//+/\\+}" "docs/dev/lint.md states the rules for $language"
done
for pubspec in app/pubspec.yaml app/packages/*/pubspec.yaml; do
  assert_matches "${pubspec%pubspec.yaml}test/flutter_test_config.dart" 'strictTests\(' "installs the test harness"
done
python3 -c 'import json, sys; json.load(open(sys.argv[1]))' tools/lint/baseline.json && ok "the baseline is JSON" ||
  fail "tools/lint/baseline.json does not parse"

# --- ADR-0129 as the owner kept it (photolib-design#487): ten rejected lints, 120 columns, the tight ratchet, two
# ShellCheck exclusions
ADR=docs/adr/0129-lint-ratchet.md
assert_prose "$ADR" '\* \*\*Status\*\*: Accepted — 2026-10-20\. The owner kept [^*]*photolib-design#487' \
  "is Accepted, recording the owner's answers (#487)"
assert_matches docs/adr/README.md '\(0129-lint-ratchet\.md\) \| [^|]* \| Accepted \(owner confirmed, 2026-10-20\)' \
  "the index lists ADR-0129 as Accepted"
assert_prose "$ADR" '`rust-toolchain\.toml` pins the Rust release' "says the Rust release is pinned"
rejected=$(rules kernel/Cargo.toml | grep -c '= "allow"$')
[[ $rejected == 10 ]] && ok "Rust rejects ten lints" || fail "Rust rejects $rejected lints, the owner kept ten"
assert_matches .shellcheckrc '^disable=SC1091,SC2015$' "ShellCheck skips only SC1091 and SC2015"

# --- Rust tests: a passing test fails when a thread it did not join panicked (tools/lint/panics.py); real cargo.
if command -v cargo >/dev/null; then
  mkdir -p "$SANDBOX/crate/src"
  cp "$REPO_ROOT/tools/lint/panics.py" "$SANDBOX/tools/lint/"
  printf '[package]\nname = "panics"\nversion = "0.0.0"\nedition = "2024"\n' >"$SANDBOX/crate/Cargo.toml"
  cat >"$SANDBOX/crate/src/lib.rs" <<'RUST'
#[test]
fn catches_its_own_panic() {
    assert!(std::panic::catch_unwind(|| panic!("on purpose")).is_err());
}

#[test]
fn adds() {
    assert_eq!(1 + 1, 2);
}
RUST
  tests() {
    capture bash -c 'cd "$1" && CARGO_TARGET_DIR=$2 python3 ../tools/lint/panics.py cargo test -q -- --show-output' \
      _ "$SANDBOX/crate" "$SANDBOX/target"
  }
  tests
  expect_result "a test that catches a panic on its own thread passes" 0 "panicked at"
  cat >>"$SANDBOX/crate/src/lib.rs" <<'RUST'

#[test]
fn loses_a_panic_in_a_thread() {
    std::thread::spawn(|| panic!("nobody joins me"));
    std::thread::sleep(std::time::Duration::from_millis(200));
}
RUST
  tests
  expect_result "a test that passes while a thread it did not join panicked fails" failure \
    "loses_a_panic_in_a_thread: thread '<unnamed>' panicked at src/lib.rs:" "stack backtrace:"
  if command -v cargo-machete >/dev/null; then
    printf '[dependencies]\nitoa = "1"\n' >>"$SANDBOX/crate/Cargo.toml"
    capture bash -c 'cd "$1" && cargo machete' _ "$SANDBOX/crate"
    expect_result "cargo machete fails on an unused dependency" failure "itoa"
  fi
else
  echo "skip: cargo is not installed; the panic check is not run through a real test here"
fi

finish
