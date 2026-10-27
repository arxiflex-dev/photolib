#!/usr/bin/env bash
# The checks that failed the merge queue, run before asking for it (each queue failure costs everyone ~25 minutes).
# It does NOT replace the gate (`bash tools/check.sh --since <remote>/dev`); it catches the cheap, repeated failures first.
#
#   bash tools/prequeue.sh [--quick|--full] [--perf] [--list]
#     (default)  the quick steps plus the Dart analyzer, the app guard tests and cargo check (about a minute)
#     --quick    only the steps that take seconds (no Dart or Rust build, test or analysis step; 15 s)
#     --full     the default steps, the CI lanes' own checks, the touched packages' tests under CI's conditions, a
#                fresh clone and the PRs queued ahead of this one: what workers run before asking for the merge
#                queue; its budget is PREQUEUE_BUDGET (default 420 s)
#     --perf     adds tools/perf/instructions.sh when kernel/ or server code changed: opt-in, outside the budget
#     --list     prints the steps of the tier with their command and the failure class they catch, runs nothing
#
#   PHOTOLIB_REMOTE=<name>        the remote that holds dev (tools/remote.sh: else the only remote, else origin)
#   PREQUEUE_BASE=<remote>/dev    the ref the branch is compared with
#   PREQUEUE_OTHERS='<remote>/wi/*' the refs whose kernel/ADR/schema numbers and files are compared with ours
#   PREQUEUE_NO_FETCH=1           do not `git fetch` first (offline)
#   PREQUEUE_NO_GH=1              do not call `gh` (the PR title and the queued PRs are then skipped)
#   PREQUEUE_ONLY=<name or regex> run only the steps whose name contains it or matches it (to run or time one)
#   PREQUEUE_BUDGET=<seconds>     a step still running when the budget is used up is stopped and reported as `slow`,
#                                 the steps not yet started as `skip`
#
# Every step prints one line: ok, FAIL (with its output), skip <name> (reason) for a step this machine cannot run
# (a missing tool, rs-vips on aarch64, no docker), n/a when nothing it checks changed, slow, and warn lines. The last
# line is `prequeue: PASS|FAIL (tier, Ns, W warnings, S skipped)`. Exit status 1 on any FAIL; warnings never fail. A run
# that cut a step at the budget ends `prequeue: INCOMPLETE (n steps not run)` with status 3: it proves less than its tier.
set -uo pipefail

SELF=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")
TIER=default LIST=0 PERF=0
for arg in "$@"; do
  case $arg in
    --quick) TIER=quick ;;
    --full) TIER=full ;;
    --list) LIST=1 ;;
    --perf) PERF=1 ;;
    -h | --help) sed -n '2,/^set -uo/p' "$SELF" | sed '$d; s/^# \{0,1\}//'; exit 0 ;;
    *) echo "usage: tools/prequeue.sh [--quick|--full] [--perf] [--list]" >&2; exit 2 ;;
  esac
done
case $TIER in quick) RANK_MAX=1 ;; default) RANK_MAX=2 ;; full) RANK_MAX=3 ;; esac
REMOTE=$(bash "$(dirname "${BASH_SOURCE[0]}")/remote.sh") || exit 2
export PREQUEUE_REMOTE=$REMOTE
BASE=${PREQUEUE_BASE:-$REMOTE/dev}
OTHERS=${PREQUEUE_OTHERS-$REMOTE/wi/* $REMOTE/mergify/merge-queue/*}
BUDGET=${PREQUEUE_BUDGET:-$([[ $TIER == full ]] && echo 420 || echo 300)}
[[ $BUDGET =~ ^[1-9][0-9]*$ ]] || { echo "prequeue: PREQUEUE_BUDGET must be a whole number of seconds" >&2; exit 2; }
# PREQUEUE_TREE_ONLY: a nested run in a clone or a merge of branches: only the steps that read the tree.
TREE_ONLY=${PREQUEUE_TREE_ONLY:-}
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "prequeue: not in a git checkout" >&2; exit 2; }
cd "$ROOT" || exit 2
TMP=$(mktemp -d) || exit 2
export TMP

# Tools live in the per-user cache on these machines; keep an already set PATH first.
CACHE=${XDG_CACHE_HOME:-$HOME/.cache}
for d in "$CACHE/toolchains/cargo/bin" "$CACHE/toolchains/flutter/bin" "$CACHE/toolchains/node/bin"; do
  [[ ! -d $d || :$PATH: == *":$d:"* ]] || PATH="$PATH:$d"
done
[[ -n ${CARGO_HOME:-} || ! -d $CACHE/toolchains/cargo ]] || export CARGO_HOME=$CACHE/toolchains/cargo
[[ -n ${RUSTUP_HOME:-} || ! -d $CACHE/toolchains/rustup ]] || export RUSTUP_HOME=$CACHE/toolchains/rustup
# The cache of pinned tools (tools/lint/tool.sh) where these machines keep it. Spelled in two parts: this script only
# points at a cache that exists and downloads nothing, so it is not one of the pins the CI cache key hashes.
TOOLS_VAR=PHOTOLIB
TOOLS_VAR+=_TOOLS_CACHE
[[ -n ${!TOOLS_VAR:-} || ! -d $CACHE/toolchains/photolib-tools ]] || export "$TOOLS_VAR=$CACHE/toolchains/photolib-tools"
# A target directory of this checkout's own (warm after the first run), and sccache where it is set up.
if [[ -z ${CARGO_TARGET_DIR:-} && -d $CACHE/rust-targets ]]; then
  CARGO_TARGET_DIR=$CACHE/rust-targets/prequeue-$(printf %s "$ROOT" | cksum | cut -d' ' -f1)
  export CARGO_TARGET_DIR
fi
if [[ -z ${RUSTC_WRAPPER:-} && -d $CACHE/sccache ]] && command -v sccache >/dev/null 2>&1; then
  export RUSTC_WRAPPER=sccache SCCACHE_DIR=${SCCACHE_DIR:-$CACHE/sccache} CARGO_INCREMENTAL=0
fi
export PATH

# ---------------------------------------------------------------------------------------------------------------------
# Helpers for the steps (`na` and `skipped` end the step: it runs in a subshell). A step is a shell function whose output is kept; its exit status says: 0 ok, 77 skipped on
# this machine (its first output line is the reason), 78 not applicable (nothing it checks changed), else FAIL. A line
# `WARN <text>` in its output is a warning, whatever the status.
changed() { git diff --name-only --diff-filter=ACMR "$BASE"...HEAD -- "$@"; }
# base_is_root: BASE is a root commit, so BASE...HEAD is the whole repository and old content would be judged
base_is_root() { [[ -z $(git rev-list --parents -n 1 "$BASE" | cut -d' ' -f2-) ]]; }
need() { command -v "$1" >/dev/null 2>&1 || { echo "$1 is not installed"; return 77; }; }
na() { echo "$*"; exit 78; }
skipped() { echo "$*"; exit 77; }
# crate_of <file> <root>: the package name of the crate a file belongs to
crate_of() {
  local d
  d=$(dirname "$1")
  while [[ $d != . && $d != "$2" && -z $(git ls-files "$d/Cargo.toml") ]]; do d=$(dirname "$d"); done
  [[ -n $(git ls-files "$d/Cargo.toml") ]] &&
    awk '/^\[package\]/ {p=1; next} /^\[/ {p=0} p && /^name *=/ {gsub(/[" ]/, "", $3); print $3; exit}' "$d/Cargo.toml"
}
# crates_of <root>: the package names of the crates with a changed .rs or Cargo.toml under <root>
crates_of() {
  local f
  while IFS= read -r f; do crate_of "$f" "$1"; done < <(changed "$1/*.rs" "$1/*Cargo.toml") | sort -u
}
rust_roots() {
  local r
  for r in kernel server tools/synthlib; do
    [[ -f $r/Cargo.toml ]] && [[ -n $(changed "$r/*") ]] && echo "$r"
  done
}
# pkg_dirs: the Dart packages (a pubspec.yaml above a changed .dart file), one per line
pkg_dirs() {
  local f d
  while IFS= read -r f; do
    d=$(dirname "$f")
    while [[ $d != . && ! -f $d/pubspec.yaml ]]; do d=$(dirname "$d"); done
    [[ $d == . ]] || echo "$d"
  done < <(changed '*.dart' '*.arb' '*/pubspec.yaml' '*/build.yaml') | sort -u
}
# waits for the quick steps (a step that rewrites the checkout, or reads what the quick steps do) for 2 minutes at most
after_quick() {
  local n=0
  while [[ ! -f $TMP/quick.done ]] && ((n++ < 600)); do sleep 0.2; done
}
# A patched rs-vips for a root that links it on a host where it does not compile (aarch64: c_char is u8): a clone of
# HEAD of its own beside the cache (so the checkout is never touched, and cargo's target dir stays warm) with
# ~/.cache/patches/rs-vips as a [patch.crates-io] (~/.cache/patches/README.md).
vips_patched() {
  [[ $(uname -m) == aarch64 && -f $1/Cargo.lock ]] && grep -q '^name = "rs-vips"' "$1/Cargo.lock"
}
vips_clone() {
  local dir patch=$CACHE/patches/rs-vips
  # one clone per kind of step (lint, test): two builds in one source tree, their build scripts writing generated
  # code, broke each other
  dir=$CACHE/prequeue/clone-$(printf %s "$ROOT" | cksum | cut -d' ' -f1)-${CLONE_TAG:-test}
  [[ -f $patch/Cargo.toml ]] || { echo "rs-vips does not compile on aarch64 and $patch (the local fix) is missing"; return 77; }
  mkdir -p "$CACHE/prequeue"
  find "$CACHE/prequeue" -maxdepth 1 -name "clone-*" -mtime +14 -exec rm -rf {} + 2>/dev/null # clones of old worktrees
  [[ -d $dir/.git ]] || git clone -q --no-local "$ROOT" "$dir" || return 1
  git -C "$dir" fetch -q "$ROOT" HEAD && git -C "$dir" checkout -q -f --detach FETCH_HEAD && git -C "$dir" clean -fdq || return 1
  grep -q '^\[patch.crates-io\]' "$dir/server/Cargo.toml" && { echo "server/Cargo.toml has a [patch.crates-io] already"; return 77; }
  printf '\n[patch.crates-io]\nrs-vips = { path = "%s" }\n' "$patch" >>"$dir/server/Cargo.toml"
  (cd "$dir/server" && cargo metadata --offline --format-version 1 >/dev/null) || return 1
  echo "$dir"
}
# root_base <root>: the checkout holding <root> for cargo: this one, or the patched clone where rs-vips needs it
# vips_once: vips_clone once per run, whichever lane asks first (the lanes run side by side)
vips_once() {
  (
    flock 9
    if [[ -s $TMP/vips.dir.${CLONE_TAG:-test} ]]; then cat "$TMP/vips.dir.${CLONE_TAG:-test}"; exit 0; fi
    if [[ -s $TMP/vips.fail ]]; then cat "$TMP/vips.fail"; exit 77; fi
    out=$(vips_clone 2>&1) && rc=0 || rc=$?
    if ((rc)); then echo "$out" >"$TMP/vips.fail"; echo "$out"; exit 77; fi
    out=$(tail -n 1 <<<"$out")
    echo "$out" >"$TMP/vips.dir.${CLONE_TAG:-test}"
    echo "$out"
  ) 9>"$TMP/vips.lock"
}
root_base() {
  local dir
  if vips_patched "$1"; then
    dir=$(vips_once) || { echo "$dir"; exit 77; }
    echo "$dir"
  else
    echo "$ROOT"
  fi
}
# in_root <root> <cmd...>: the command in the root, in the base root_base names
in_root() {
  local root=$1 base
  shift
  base=$(root_base "$root") || exit 77
  (cd "$base/$root" && "$@")
}
offline() { bash "$ROOT/tools/offline.sh" "$@"; }

# ---------------------------------------------------------------------------------------------------------------------
# The registry: add <rank> <lane> <name> <command> <catches> <hint> <function>. Rank 1 is --quick, 2 the default, 3
# --full, 4 --perf. The lanes run side by side, their steps one after another.
NAMES=() RANKS=() LANES=() CMDS=() CATCH=() HINTS=() FUNCS=()
add() {
  RANKS+=("$1") LANES+=("$2") NAMES+=("$3") CMDS+=("$4") CATCH+=("$5") HINTS+=("$6") FUNCS+=("$7")
}

s_diffcheck() {
  ! base_is_root || na "$BASE is a root commit: the diff would be the whole repository"
  # trailing space and conflict markers; a blank line at the end of a file is the hygiene test's (final newline)
  git -c core.whitespace=trailing-space,space-before-tab,-blank-at-eof diff --check "$BASE"...HEAD -- . ':!*/gen/*' ':!*.g.dart' ':!*.pb*.dart' ':!*/drift_schemas/*' ':!*/l10n/app_localizations*'
}
add 1 q "git diff --check" "git diff --check BASE...HEAD (generated code excluded)" \
  "trailing whitespace, conflict markers" "whitespace or conflict markers in the diff" s_diffcheck

s_commitlint() { bash tools/commitlint.sh "$BASE"..HEAD; }
add 1 q "commitlint" "bash tools/commitlint.sh BASE..HEAD" \
  "subject > 72 chars, wip(...), unknown type (commits lane)" \
  "subjects <= 72 chars, type(scope): summary, no wip(...); reword with git rebase" s_commitlint

s_flutter_gate() {
  [[ -f tools/flutter_upgrade_gate.py ]] || na "no tools/flutter_upgrade_gate.py"
  python3 tools/flutter_upgrade_gate.py "$BASE" HEAD
}
add 1 q "flutter upgrade gate" "python3 tools/flutter_upgrade_gate.py BASE HEAD" \
  "a moved Flutter pin without the ticked checklist (commits lane)" \
  "a moved Flutter pin needs the ticked checklist in the PR body" s_flutter_gate

# The squash policy: the PR title becomes the commit message on dev, plus " (#N)" (up to 5 characters more).
s_title() {
  local title number
  [[ -z $TREE_ONLY ]] || na "not repeated in a nested run"
  [[ -z ${PREQUEUE_NO_GH:-} ]] || skipped "PREQUEUE_NO_GH is set: the PR title is not checked"
  command -v gh >/dev/null 2>&1 || skipped "gh is not installed: the PR title is not checked"
  if title=$(timeout 30 gh pr view --json title,number --jq '.title + "\t" + (.number | tostring)' 2>/dev/null); then
    number=${title##*$'\t'} title=${title%$'\t'*}
    printf '%s (#%s)\n' "$title" "$number" | bash tools/commitlint.sh --stdin
  else
    # No PR yet: GitHub takes the subject of a one-commit branch as the title; a longer one is titled by hand. The
    # number is the next one of the repository (pull requests and issues share them), else 9999.
    number=$(timeout 30 gh api 'repos/{owner}/{repo}/issues?state=all&per_page=1' --jq '.[0].number + 1' 2>/dev/null) ||
      number=9999
    if (($(git rev-list --count "$BASE"..HEAD) == 1)); then
      echo "WARN no PR for this branch yet: the title will be the commit subject, checked as 'subject (#$number)'"
      printf '%s (#%s)\n' "$(git log -1 --format=%s)" "$number" | bash tools/commitlint.sh --stdin
    else
      echo "WARN no PR for this branch yet: give it a title 'type(scope): summary' of at most 72 chars with ' (#N)'"
    fi
  fi
}
add 1 q "PR title" "gh pr view --json title | commitlint.sh --stdin ('title (#N)')" \
  "squash message > 72 with ' (#N)', not type(scope): summary" \
  "retitle: gh pr edit --title 'type(scope): summary', at most 72 chars with ' (#N)'" s_title

s_lintgrowth() { bash tools/lint/ratchet.sh --against "$BASE"; }
add 1 q "lint baseline growth" "bash tools/lint/ratchet.sh --against BASE" \
  "baseline grew without lint-accept: (commits lane)" "a baseline that grew needs a lint-accept: line" s_lintgrowth

s_lockguard() {
  python3 - "$BASE" <<'PY'
# Every package of a committed Cargo.lock without a `source` must be a crate of this repository: a path patch (the
# local rs-vips one) is not, and `--locked` then fails on every CI machine.
import subprocess, sys, tomllib

def git(*args):
    return subprocess.run(["git", *args], capture_output=True, text=True).stdout

files = git("ls-files", "*Cargo.lock").split()
names = set()
for m in git("ls-files", "*Cargo.toml").split():
    try:
        names.add(tomllib.loads(git("show", f"HEAD:{m}")).get("package", {}).get("name"))
    except tomllib.TOMLDecodeError:
        pass
bad = []
for f in files:
    for p in tomllib.loads(git("show", f"HEAD:{f}")).get("package", []):
        if "source" not in p and p["name"] not in names:
            bad.append(f"{f}: {p['name']} {p['version']} has no registry source and no crate in this repository")
added = git("diff", "-U0", sys.argv[1] + "...HEAD", "--", "*Cargo.toml")
if any(x.startswith("+[patch") or (x.startswith("+") and 'path = "/' in x) for x in added.splitlines()):
    bad.append("the diff adds a [patch] section or an absolute path dependency to a Cargo.toml")
print("\n".join(bad))
sys.exit(1 if bad else 0)
PY
}
add 1 q "Cargo.lock path patch" "python3 (committed Cargo.lock: sourceless packages are crates of the repo)" \
  "server/Cargo.lock committed with the local rs-vips patch (7 jobs red)" \
  "git checkout BASE -- server/Cargo.lock; keep rs-vips patches out of commits" s_lockguard

s_nodedir() {
  ! git grep -nE 'node --test +[^ -][^ ]*/( |$|"|'"'"')' -- ':!tools/prequeue.sh' ':!tools/tests/test_prequeue.sh' ':!docs' ||
    { echo "node --test <dir> fails on the CI node: pass a glob or run 'node --test' with no argument"; return 1; }
}
add 1 q "node --test <dir>" "git grep 'node --test <dir>/'" "the directory form of node --test (web-node)" \
  "use 'node --test' alone or a file glob" s_nodedir

s_smells() {
  local added newurls
  [[ -z $TREE_ONLY ]] || { : >"$TMP/timing.done"; na "not repeated in a nested run"; }
  ! base_is_root || { : >"$TMP/timing.done"; na "$BASE is a root commit"; }
  # test code that reads the clock or the core count: CI has 4 cores and runs tests beside others. A warning, not a
  # FAIL (clean trees assert on time too): the files are rerun under load (rust tests under load)
  added=$(git diff -U0 "$BASE"...HEAD -- '*test*' '*_test.*')
  printf '%s\n' "$added" | awk -v re='(Stopwatch\\(\\)|elapsed\\(\\)|Instant::now\\(\\)|< *[0-9]+ *ms|numberOfProcessors|available_parallelism|cores|median|fastest|slowest|worst)' '
    /^\+\+\+ b\// { file = substr($0, 7) }
    /^\+[^+]/ && $0 ~ re { print file }' | sort -u >"$TMP/timing.warn"
  if [[ -s $TMP/timing.warn ]]; then
    echo "WARN wall-clock or core-count use in new test code (CI has 4 cores and runs tests beside others; the Rust ones are rerun under load): $(tr '\n' ' ' <"$TMP/timing.warn")"
  fi
  : >"$TMP/timing.done"
  newurls=$(git diff -U0 "$BASE"...HEAD -- server kernel app/lib tools | grep -E '^\+[^+].*https?://[a-z0-9.-]+' |
    grep -vE 'localhost|127\.0\.0\.1|example\.|^\+\s*(//|#)' | head -n 3)
  [[ -z $newurls ]] || echo "WARN new URLs in source need a row in docs/admin/privacy.md (test_outbound): ${newurls//$'\n'/ | }"
  return 0
}
add 1 q "test and URL smells" "awk over the added test lines: clock, core count, median/worst; new URLs" \
  "wall-clock/core-count test (faces 5.5 s #78, thumbnails 4 slots), privacy rows: warnings; the Rust files are rerun under load" "" s_smells

s_prefetch() {
  python3 - <<'PY'
# A model or picture that a test loads must be in the gate's prefetch of its lane (tools/check.sh): the gate runs the
# tests with egress blocked, and one that is only in the local cache passes here and fails there. The Rust lane's
# fetches come first in the prefetch function, the Dart lane's after its `dart` test.
import json, re, subprocess, sys
# SigLIP 2 (3 GB) is opt-in (PHOTOLIB_ML_MODELS=all), not prefetched
names = [n for n in json.load(open("tools/ml/artefacts.json"))
         if not n.startswith(("ort-", "siglip2")) and n != "onnxruntime-web"]
check = open("tools/check.sh").read()
start = max(check.find("prefetch() {"), 0)
split = check.find('== *" dart "*', start)
if split < 0:
    split = len(check)

def fetched(text):
    ids = set()
    for line in re.findall(r"fetch\.py([^\"]*)\"", text):
        ids |= set(line.split())
    return ids

lanes = {"rust": (fetched(check[start:split]), ["server/*.rs", "kernel/*.rs"]),
         "dart": (fetched(check[split:]), ["app/*_test.dart"])}
missing = {}
for lane, (have, globs) in lanes.items():
    for f in subprocess.run(["git", "ls-files", *globs], capture_output=True, text=True).stdout.split():
        if f.endswith(".g.dart"):
            continue
        text = open(f, errors="ignore").read()
        if lane == "dart" and "PHOTOLIB_ML_MODELS" in text:
            continue  # skipped unless the models are asked for
        used = {n for n in names if f'"{n}"' in text or f"'{n}'" in text}
        for prefix in re.findall(r'starts_with\("([a-z0-9-]+)"\)', text):
            used |= {n for n in names if n.startswith(prefix)}
        for n in used - have:
            missing.setdefault((lane, n), f)
for (lane, n), f in sorted(missing.items()):
    print(f"{n} is used by {f} but the {lane} prefetch of tools/check.sh does not fetch it")
sys.exit(1 if missing else 0)
PY
}
add 1 q "models in the prefetch" "python3: artefacts of tools/ml/artefacts.json used by tests vs check.sh's prefetch" \
  "offline test run missing a model the prefetch lacks (ppocr-v5-det, face portraits)" \
  "add the artefact to the fetch.py line of the prefetch in tools/check.sh" s_prefetch

s_lint_touched() {
  python3 - "$BASE" <<'PY'
import subprocess, sys, importlib.util, pathlib
sys.path.insert(0, "tools/lint")
spec = importlib.util.spec_from_file_location("ratchet", "tools/lint/ratchet.py")
r = importlib.util.module_from_spec(spec)
spec.loader.exec_module(r)
changed = subprocess.run(["git", "diff", "--name-only", "--diff-filter=ACMR", sys.argv[1] + "...HEAD"],
                         capture_output=True, text=True).stdout.split()
bad = False
for linter, pats in (("shellcheck", (".sh",)), ("ruff", (".py",)), ("eslint", (".js", ".mjs", ".ts"))):
    mine = [f for f in changed if f.endswith(pats) and not r.GENERATED.search(f) and pathlib.Path(f).exists()]
    if not mine:
        continue
    r.files = lambda directory, *patterns, mine=mine: mine
    found, counts = r.measure(linter, ".")
    expected = {f: v for f, v in r.load().get(f"{linter} .", {}).items() if f in mine}
    for f, rule, n, b in r.differences(counts, expected):
        bad = True
        print(f"{linter}: {f}: {rule}: {n}, baseline {b}" + ("  (fewer: lower it with tools/lint/ratchet.sh --update)" if n < b else ""))
        for x in found:
            if (x.file, x.rule) == (f, rule):
                print(f"    {f}:{x.line}: {x.text}")
sys.exit(1 if bad else 0)
PY
}
add 1 q "lint of touched files" "tools/lint/ratchet.py: shellcheck, ruff, eslint on the changed files vs the baseline" \
  "SC2174/SC2016, E501/EXE001, counts above or below the baseline (static/light lane)" \
  "fix the finding, or lower the baseline if the count fell (tools/lint/ratchet.sh --update <linter> .)" s_lint_touched

s_fmt_rust() {
  local rc=0 root
  need cargo || return 77
  for root in kernel server tools/synthlib; do
    [[ -f $root/Cargo.toml && -n $(changed "$root/*.rs") ]] || continue
    (cd "$root" && cargo fmt --check) || rc=1
  done
  return $rc
}
add 1 q "cargo fmt --check" "cargo fmt --check in each root with a changed .rs" "unformatted Rust (rust-lint)" \
  "cargo fmt in the root, after your LAST edit" s_fmt_rust

s_fmt_dart() {
  local f d dir ver rc=0 skip='(\.g\.dart|/gen/|/l10n/app_localizations)'
  declare -A files=()
  need dart || return 77
  while read -r f; do
    [[ $f =~ $skip ]] && continue
    d=$(dirname "$f")
    while [[ $d != . && ! -f $d/pubspec.yaml ]]; do d=$(dirname "$d"); done
    files[$d]+="${f#"$d"/} "
  done < <(changed '*.dart')
  for dir in "${!files[@]}"; do
    ver=$(sed -n 's/^  sdk: *[\^>=]*\([0-9]*\.[0-9]*\).*/--language-version=\1/p' "$dir/pubspec.yaml")
    # shellcheck disable=SC2086 # one path a word
    (cd "$dir" && dart format $ver --output=none --set-exit-if-changed ${files[$dir]}) || rc=1
  done
  return $rc
}
add 1 q "dart format" "dart format --set-exit-if-changed in the pubspec's language version, changed files" \
  "unformatted Dart (dart part)" "dart format --language-version=<the pubspec's> the files" s_fmt_dart

# Numbers other branches may take too: kernel Method, ADR, migration, drift schema, threat id.
s_collisions() {
  [[ -z $TREE_ONLY ]] || na "not repeated in a nested run"
  ! base_is_root || na "$BASE is a root commit: every number would be new"
  python3 - "$BASE" "$OTHERS" <<'PY'
import os, re, subprocess, sys
base, others = sys.argv[1], sys.argv[2].split()

def git(*a):
    return subprocess.run(["git", *a], capture_output=True, text=True).stdout

def refs(globs):
    out = []
    for g in globs:
        out += git("for-each-ref", "--format=%(refname:short)", "refs/remotes/" + g).split()
    return out

def blob(ref, path):
    return git("rev-parse", f"{ref}:{path}").strip()

def taken(ref):
    """What a ref adds to base: kind -> {number: where}."""
    t = {k: {} for k in ("method", "adr", "migration", "drift schema", "threat")}
    for n in git("diff", "--name-only", "--diff-filter=A", f"{base}...{ref}").split():
        for kind, rx in (("adr", r"^docs/adr/(\d{4})-"), ("migration", r"^server/migrations/(\d{4})_"),
                         ("drift schema", r"drift_schemas/.*/drift_schema_v(\d+)\.json$")):
            m = re.search(rx, n)
            if m:
                t[kind][int(m[1])] = n
    for line in git("diff", "-U0", f"{base}...{ref}", "--", "proto/photolib/kernel/v1").splitlines():
        m = re.match(r"^\+\s*(METHOD_\w+)\s*=\s*(\d+)", line)
        if m:
            t["method"][int(m[2])] = m[1]
    for line in git("diff", "-U0", f"{base}...{ref}", "--", "docs/dev/threat-model.md").splitlines():
        m = re.match(r"^\+\|\s*(T\d+)\s*\|", line)
        if m:
            t["threat"][int(m[1][1:])] = line[1:].strip()
    return t

mine = taken("HEAD")
here = git("rev-parse", "--abbrev-ref", "HEAD").strip()
head = git("rev-parse", "HEAD").strip()
bad = []
for ref in refs(others):
    if ref.removeprefix(os.environ["PREQUEUE_REMOTE"] + "/") == here or git("rev-parse", ref).strip() == head:
        continue
    theirs = taken(ref)
    for kind in mine:
        for n in sorted(set(mine[kind]) & set(theirs[kind])):
            if mine[kind][n] != theirs[kind][n] or (kind == "drift schema" and blob(ref, mine[kind][n]) != blob("HEAD", mine[kind][n])):
                bad.append(f"{kind} {n}: {mine[kind][n]} here, {theirs[kind][n]} in {ref}")
# the same number already in base, added by the branch since its merge base
for kind, rx, tree in (("adr", r"^(\d{4})-.*\.md$", "docs/adr"), ("migration", r"^(\d{4})_.*\.sql$", "server/migrations")):
    in_base = {int(m[1]): f for f in git("ls-tree", "--name-only", base, tree + "/").split()
               for m in [re.match(rx, f.rsplit("/", 1)[-1])] if m}
    for n, where in mine[kind].items():
        if n in in_base and in_base[n].rsplit("/", 1)[-1] != where.rsplit("/", 1)[-1]:
            bad.append(f"{kind} {n}: {where} here, {in_base[n]} already in {base}")
for line in git("show", f"{base}:proto/photolib/kernel/v1/call.proto").splitlines():
    m = re.match(r"^\s*(METHOD_\w+)\s*=\s*(\d+)", line)
    if m and int(m[2]) in mine["method"] and mine["method"][int(m[2])] != m[1]:
        bad.append(f"method {m[2]}: {mine['method'][int(m[2])]} here, {m[1]} in {base}")
warns = []
for kind, rx, tree in (("adr", r"^(\d{4})-.*\.md$", "docs/adr"), ("migration", r"^(\d{4})_.*\.sql$", "server/migrations")):
    seen = {}
    for f in git("ls-tree", "--name-only", "HEAD", tree + "/").split():
        m = re.match(rx, f.rsplit("/", 1)[-1])
        if m:
            seen.setdefault(int(m[1]), []).append(f)
    added = set(mine[kind].values())
    for n, fs in sorted(seen.items()):
        if len(fs) > 1:
            line = f"{kind} {n} is on {len(fs)} files in HEAD: {', '.join(fs)}"
            if any(f in added for f in fs):
                bad.append(line)
            else:
                warns.append("WARN " + line + " (already so in " + base + ": renumber one in a change of its own)")
print("\n".join(bad + warns) if bad or warns else "no number is taken twice")
sys.exit(1 if bad else 0)
PY
}
add 1 q "numbers taken twice" "python3 over PREQUEUE_OTHERS: Method, ADR, migration, drift schema, T-id" \
  "two branches using one number (renumbering after #55 hit #69)" \
  "renumber after the branch that queues first; regenerate with tools/codegen.sh" s_collisions

s_dryrun() {
  local out
  [[ -z $TREE_ONLY ]] || na "not repeated in a nested run"
  out=$(git merge-tree --write-tree --name-only "$BASE" HEAD 2>&1) || { printf '%s\n' "$out" | tail -n +2; return 1; }
}
add 1 q "merge dry run" "git merge-tree --write-tree BASE HEAD" "conflicts with dev (generated code, ADR index)" \
  "rebase on BASE; regenerate generated code, ADR index, AGENTS.md with the union rules" s_dryrun

s_conflicts() {
  local ref head out glob
  [[ -z $TREE_ONLY ]] || na "not repeated in a nested run"
  head=$(git rev-parse HEAD)
  for glob in $OTHERS; do
    for ref in $(git for-each-ref --format='%(refname:short)' "refs/remotes/$glob"); do
      [[ $(git rev-parse "$ref") != "$head" ]] || continue
      git merge-base --is-ancestor "$ref" HEAD 2>/dev/null && continue
      out=$(git merge-tree --write-tree --name-only HEAD "$ref" 2>&1) ||
        echo "WARN conflicts with $ref in: $(printf '%s\n' "$out" | awk 'NR>1 && /^$/ {exit} NR>1' | head -n 6 | tr '\n' ' ')(the one that queues second must rebase; batch these two apart)"
    done
  done
  return 0
}
add 1 q "conflicts with other branches" "git merge-tree --write-tree HEAD <each $REMOTE/wi/* and queue branch>" \
  "two PRs editing one generated file or numbered registry (warning)" "" s_conflicts

# A tool that reads a child's output without a limit fails in the CI's node (the default buffer is 1 MiB).
s_maxbuffer() {
  local f bad=0
  ! base_is_root || na "$BASE is a root commit"
  while IFS= read -r f; do
    grep -qE '(spawnSync|execSync|execFileSync)\(' "$f" || continue
    grep -q maxBuffer "$f" && continue
    # the scripts that read cargo's JSON messages, which outgrow the 1 MiB default
    grep -q 'message-format' "$f" || continue
    echo "$f reads cargo's --message-format output from spawnSync/execSync/execFileSync and sets no maxBuffer"
    bad=1
  done < <(changed 'tools/*.mjs' 'tools/*.js' 'tools/*.cjs')
  return $bad
}
add 1 q "child output buffers" "grep of changed tools/*.mjs|js that read cargo --message-format: spawnSync/execSync without maxBuffer" \
  "node's 1 MiB default output buffer (web-node, #63)" "pass { maxBuffer: 1 << 30 } to the call" s_maxbuffer


# The repo tests that need nothing but git, python and bash (about 6 s side by side on 18 cores); the default and --full
# tiers run every tools/tests/test_*.sh the machine can run (about 15 s), as the gate's repo part does.
FAST_TESTS=(hygiene layout markdown adr threat_model merge_union ci outbound photolib_env commitlint lint
  links docs devdocs scenario_adrs tile_marks_adr)
[[ -z ${PREQUEUE_FAST_TESTS:-} ]] || read -ra FAST_TESTS <<<"$PREQUEUE_FAST_TESTS" # a hook for tests/test_prequeue.sh
# name:tools it needs:why it is left out. The first is left out always, the others when a tool is missing.
LEFT_OUT=(
  "check_sh::runs the whole gate (150 s and more; CI runs it)"
  "perf:gnome-keyring-daemon:needs gnome-keyring"
  "compose:docker:needs docker"
  "devstack:docker:needs docker"
  "nas:docker:needs docker"
  "observability:docker:needs docker"
  "secrets::the local gitleaks reports 101 findings that the image CI pins does not"
  "web_requests:google-chrome firefox:needs Chrome and Firefox"
)
# The tests that build a virtualenv (docs, corpus) and the docs lane run one at a time: two builds of one venv, or of
# the corpus one that every tree shares, break each other (ensurepip errors, rm: Directory not empty).
VENV_LOCK=$CACHE/prequeue/venv.lock
export VENV_LOCK
run_one() {
  local out
  case $1 in
    *test_docs.sh | *test_corpus.sh)
      mkdir -p "$(dirname "$VENV_LOCK")"
      out=$(flock "$VENV_LOCK" bash "$1" 2>&1) ||
        { printf '== %s\n%s\n' "$1" "$(printf '%s\n' "$out" | grep -v '^ok')"; return 1; }
      return 0
      ;;
  esac
  out=$(bash "$1" 2>&1) || { printf '== %s\n%s\n' "$1" "$(printf '%s\n' "$out" | grep -v '^ok')"; return 1; }
}
export -f run_one
s_repotests() {
  local t entry name tools why tool list=()
  if [[ $TIER != quick || -n ${PREQUEUE_ALL_TESTS:-} ]]; then
    for t in tools/tests/test_*.sh; do
      name=${t##*/test_} name=${name%.sh}
      [[ $name != prequeue || -z ${PREQUEUE_RUNNING:-} ]] || continue
      for entry in "${LEFT_OUT[@]}"; do
        [[ ${entry%%:*} == "$name" ]] || continue
        tools=${entry#*:} why=${tools#*:} tools=${tools%%:*}
        if [[ -z $tools ]]; then echo "SKIP test_$name ($why)"; continue 2; fi
        for tool in $tools; do
          command -v "$tool" >/dev/null 2>&1 || { echo "SKIP test_$name ($why)"; continue 3; }
        done
      done
      list+=("$t")
    done
  else
    for t in "${FAST_TESTS[@]}"; do [[ -f tools/tests/test_$t.sh ]] && list+=("tools/tests/test_$t.sh"); done
  fi
  # shellcheck disable=SC2016 # "$@" is for the inner shell
  printf '%s\n' "${list[@]}" | xargs -P 12 -n 1 bash -c 'run_one "$@"' _
}
add 1 q "repo tests" "tools/tests/test_*.sh, 12 at a time (--quick: ${#FAST_TESTS[@]} fast ones, else all the machine can run)" \
  "markdown > 120 cols / unlabeled fence, README limits, ADR/threat/AGENTS rows, tools-cache keys, URLs, layout (repo lane)" \
  "markdown <= 120 cols and fenced code needs a language, README line limits, ADR/threat rows, cache key list" s_repotests

# --- rank 2: Dart and Rust steps, side by side with the quick ones --------------------------------------------------
dart_ready() { # <pkg>: dependencies resolved, else a skip
  [[ -f $1/.dart_tool/package_config.json ]] && return 0
  need flutter || return 77
  (cd "$1" && flutter pub get --enforce-lockfile >/dev/null) || { echo "flutter pub get --enforce-lockfile failed in $1 (stale pubspec.lock?)"; return 1; }
}
s_dart_analyzer() {
  need flutter || return 77
  [[ -n $(changed '*.dart' | head -n 1) ]] || na "no .dart file changed"
  local pkg
  for pkg in $(pkg_dirs); do dart_ready "$pkg" || return $?; done
  python3 - "$BASE" <<'PY'
import importlib.util, os, pathlib, subprocess, sys
spec = importlib.util.spec_from_file_location("ratchet", "tools/lint/ratchet.py")
r = importlib.util.module_from_spec(spec)
spec.loader.exec_module(r)
r.dart_code_linter = lambda cwd, dirs: []  # the analyzer's rules only (seconds); the metrics stay with --full and CI
changed = subprocess.run(["git", "diff", "--name-only", "--diff-filter=ACMR", sys.argv[1] + "...HEAD", "--", "*.dart"],
                         capture_output=True, text=True).stdout.split()
pkgs = set()
for f in changed:
    d = pathlib.Path(f).parent
    while str(d) != "." and not (d / "pubspec.yaml").exists():
        d = d.parent
    pkgs.add(str(d))
bad = False
for pkg in sorted(pkgs):
    found, counts = r.measure("dart", pkg)
    base = r.load().get(f"dart {pkg}", {})
    for f, rule, n, b in r.differences(counts, base):
        if n > b and not rule.startswith(("cyclomatic", "source-lines", "unused", "file-length")) or rule == "file-length" and n > b:
            bad = True
            print(f"dart {pkg}: {f}: {rule}: {n}, baseline {b}")
            for x in found:
                if (x.file, x.rule) == (f, rule):
                    print(f"    {x.file}:{x.line}: {x.text}")
sys.exit(1 if bad else 0)
PY
}
add 2 dart "dart analyzer vs baseline" "ratchet.py dart <touched packages>, analyzer rules only (3-6 s each)" \
  "lines_longer_than_80_chars, avoid_escaping_inner_quotes above the baseline (dart-lint)" \
  "an analyzer lint above the baseline: fix it, do not raise the baseline" s_dart_analyzer

kernel_prebuilt() {
  local host
  host=linux-$(uname -m | sed 's/x86_64/x64/; s/aarch64/arm64/')
  # flutter test builds the native assets the kernel package bundles: build/kernel/prebuilt.json (seconds, cached)
  [[ -f app/build/kernel/prebuilt.json ]] || python3 tools/kernel/build.py --out app/build/kernel "$host"
}
# app_guard_tests: the guards among the app's tests, found by glob so that a new one joins by itself: every lint and
# tool test under test/tool/ (root isolate, single writer, paint, deletion, i18n), the device queries, the
# localizations and the web imports. They fail the gate's dart-app job whatever else a branch changes.
app_guard_tests() {
  local f
  for f in app/test/tool/*_test.dart app/test/device_queries_test.dart app/test/l10n_test.dart app/test/web_imports_test.dart; do
    [[ ! -f $f ]] || echo "${f#app/}"
  done
}
s_app_guards() {
  local guards
  need flutter || return 77
  [[ -n $(changed 'app/*' | head -n 1) ]] || na "nothing under app/ changed"
  dart_ready app || return $?
  kernel_prebuilt || return 1
  mapfile -t guards < <(cd "$ROOT" && app_guard_tests)
  (cd app && flutter test --no-pub --reporter failures-only "${guards[@]}")
}
add 2 dart "app guard tests" "flutter test app/test/tool/*_test.dart, device_queries, l10n and web_imports tests (by glob)" \
  "sync I/O on the root isolate (#130), hard-coded string / left-right (i18n_lint), a table read missing from the device_queries pins" \
  "i18n: no hard-coded strings or left/right (use app_en.arb, start/end); device_queries: filter hidden folders or list the file with a reason" s_app_guards

s_cargo_check() {
  local root crate out rc=0
  [[ $TIER != full ]] || na "covered by clippy and the tests"
  need cargo || return 77
  for root in $(rust_roots); do
    if vips_patched "$root"; then
      echo "skipped $root: rs-vips does not compile on aarch64 without the local patch (--full checks it in a patched clone)"
      continue
    fi
    for crate in $(crates_of "$root"); do
      if out=$(cd "$root" && cargo check --locked --offline --all-targets -p "$crate" 2>&1); then
        echo "checked $crate"
      elif grep -q 'did not match any packages' <<<"$out"; then
        echo "skipped $crate: not a member of the workspace"
      else
        printf '%s\n' "$out" | grep -E '^error' -A8 | head -n 30
        rc=1
      fi
    done
  done
  return $rc
}
add 2 rust "cargo check (touched crates)" "cargo check --locked --offline --all-targets -p <crate> (3-23 s warm)" \
  "compile errors in a touched crate (rs-vips crates are not built here)" "compile error in a touched crate" s_cargo_check

# --- more of what the gate's parts run, cheap and offline here -------------------------------------------------------------
cargo_roots_changed() { # roots whose Cargo.toml, Cargo.lock or deny.toml changed
  local r
  for r in kernel server tools/synthlib; do
    [[ -f $r/Cargo.toml && -n $(changed "$r/Cargo.toml" "$r/Cargo.lock" "$r/*/Cargo.toml" "$r/crates/*/Cargo.toml" deny.toml "$r/deny.toml" | head -n 1) ]] && echo "$r"
  done
}
s_machete() {
  local root rc=0
  need cargo || return 77
  need cargo-machete || return 77
  [[ -n $(cargo_roots_changed | head -n 1) ]] || na "no Cargo.toml changed"
  for root in $(cargo_roots_changed); do (cd "$root" && cargo machete) || rc=1; done
  return $rc
}
add 2 rustl "cargo machete" "cargo machete in each root with a changed Cargo.toml" \
  "an unused dependency (the rust part)" "remove the dependency from Cargo.toml" s_machete
s_deny() {
  local root rc=0 cfg
  need cargo || return 77
  need cargo-deny || return 77
  [[ -n $(cargo_roots_changed | head -n 1) ]] || na "no Cargo.toml, Cargo.lock or deny.toml changed"
  for root in $(cargo_roots_changed); do
    cfg=deny.toml
    [[ ! -f $root/deny.toml ]] || cfg=$root/deny.toml
    (cd "$root" && cargo deny --locked --config "$ROOT/$cfg" check bans licenses sources) || rc=1
  done
  return $rc
}
add 2 rustl "cargo deny" "cargo deny --locked check bans licenses sources in each root with a changed Cargo.toml or lock" \
  "a dependency with a licence, ban or source the policy refuses (the rust part)" \
  "drop or replace the dependency; a licence needs an ADR (ADR-0013)" s_deny
s_migrations() {
  local dir=$TMP/mig rc
  [[ -n $(changed 'server/migrations/*' tools/migrations.sh tools/squawk.sh | head -n 1) ]] || na "no migration changed"
  [[ $(git rev-parse "$BASE") == "$(git rev-parse -q --verify "refs/remotes/$REMOTE/dev")" ]] ||
    skipped "tools/migrations.sh compares with $REMOTE/dev, which is not $BASE"
  if [[ -z $TREE_ONLY ]] && (($(git rev-list --count HEAD.."$BASE") > 0)); then
    # migrations.sh compares with $REMOTE/dev: a branch behind it would call dev's newer migrations deleted, so it runs on
    # the branch merged with the base, as the queue builds its tree
    git worktree add -q --detach "$dir" HEAD || return 1
    if git -C "$dir" -c user.name=prequeue -c user.email=prequeue@invalid -c core.hooksPath=/dev/null merge -q --no-edit "$BASE" >/dev/null 2>&1; then
      (cd "$dir" && bash tools/migrations.sh server/migrations)
      rc=$?
    else
      rc=0
      echo "WARN merging $BASE conflicts: the migrations were not checked (see the merge dry run)"
    fi
    git worktree remove --force "$dir" >/dev/null 2>&1
    return $rc
  fi
  bash tools/migrations.sh server/migrations
}
add 2 rustl "migrations" "bash tools/migrations.sh server/migrations (squawk, released migrations unchanged)" \
  "a migration squawk refuses, or a released one edited (the rust part)" "add a new migration instead of editing a released one" s_migrations
s_dart_licences() {
  local pkg rc=0
  need python3 || return 77
  [[ -n $(pkg_dirs | head -n 1) ]] || na "no Dart package changed"
  [[ -n $(changed '*/pubspec.yaml' '*/pubspec.lock' | head -n 1) ]] || na "no pubspec changed"
  for pkg in $(pkg_dirs); do
    [[ -f $pkg/pubspec.lock || -f $pkg/pubspec.yaml ]] || continue
    dart_ready "$pkg" || return $?
    python3 tools/dart_licenses.py "$pkg" || rc=1
  done
  return $rc
}
add 2 dart "dart licences" "python3 tools/dart_licenses.py <package> when a pubspec changed" \
  "a Dart dependency with a licence the policy refuses (the dart part)" "drop the dependency, or amend the allow-list with an ADR" s_dart_licences
s_node_licences() {
  local dir
  need python3 || return 77
  [[ -n $(changed '*/package.json' '*/package-lock.json' | head -n 1) ]] || na "no package.json changed"
  for dir in $(git ls-files '*package.json' | xargs -n 1 dirname); do
    [[ -n $(changed "$dir/package.json" "$dir/package-lock.json" | head -n 1) ]] || continue
    python3 tools/node_licenses.py "$dir" || return 1
  done
}
add 2 rustl "node licences" "python3 tools/node_licenses.py <dir> when a package.json or lock changed (the node part's licence check)" \
  "an npm dependency with a licence the policy refuses (the node part)" "drop the dependency, or amend the allow-list with an ADR" s_node_licences

# --- rank 3: --full -------------------------------------------------------------------------------------------------
# local_failures: the quick steps this run failed (the nested runs only add what differs)
local_failures() {
  local i rc
  for i in "${!NAMES[@]}"; do
    [[ ${RANKS[i]} == 1 && -f $TMP/r.$i.rc ]] || continue
    read -r rc _ <"$TMP/r.$i.rc"
    case $rc in 0 | 77 | 78) ;; *) echo "${NAMES[i]}" ;; esac
  done
}
# new_failures <nested output>: the steps that failed there and not here
new_failures() {
  comm -23 <(grep -oE '^FAIL .* \([0-9.]+s\)$' <<<"$1" | sed -E 's/^FAIL //; s/ \([0-9.]+s\)$//' | sort -u) <(local_failures | sort -u)
}
# A nested run of the quick steps in another tree: <dir> <label>
nested_quick() {
  local dir=$1
  local all=1
  [[ -z ${PREQUEUE_FAST_TESTS:-} ]] || all='' # a test's own short list
  (cd "$dir" && PREQUEUE_ONLY='' PREQUEUE_RUNNING=1 PREQUEUE_ALL_TESTS=$all PREQUEUE_TREE_ONLY=1 PREQUEUE_NO_FETCH=1 PREQUEUE_BASE=${2:-$BASE} PREQUEUE_BUDGET=120 bash "$SELF" --quick 2>&1)
}
s_fresh() {
  local dir=$TMP/fresh branch out new dirty
  branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ $branch == HEAD ]]; then
    git worktree add -q --detach "$dir" HEAD || return 1
  else
    git clone -q --no-local --branch "$branch" "$ROOT" "$dir" || return 1
  fi
  if [[ $branch == HEAD ]]; then
    # a worktree shares the refs of this repository: a private ref, removed again
    git update-ref refs/prequeue/base "$(git rev-parse "$BASE")" || return 1
  else
    git -C "$dir" fetch -q "$ROOT" "$(git rev-parse "$BASE")" && git -C "$dir" update-ref refs/prequeue/base FETCH_HEAD || return 1
  fi
  out=$(nested_quick "$dir" refs/prequeue/base)
  local rc=$?
  if ((rc != 0)); then
    after_quick
    new=$(new_failures "$out")
    if [[ -z $new ]]; then
      echo "NOTE the fresh clone fails the same quick steps as this checkout: nothing the clone lacks"
      rc=0
    else
      printf '%s\n' "$out" | tail -n 60
      echo "fails in the fresh clone and not here: $(tr '\n' ',' <<<"$new")"
      echo "DO NOT QUEUE: the clone is what you pushed (the queue tests that), this checkout is not. Not a quirk of the nested run."
      dirty=$(git -C "$ROOT" status --porcelain --untracked-files=no | head -n 5 | tr '\n' ';')
      [[ -z $dirty ]] || echo "uncommitted changes here that the clone lacks: $dirty commit them (or run the failed test on a clean checkout)"
    fi
  fi
  if [[ $branch == HEAD ]]; then
    git worktree remove --force "$dir" >/dev/null 2>&1
    git update-ref -d refs/prequeue/base
  fi
  return $rc
}
add 3 fresh "fresh clone" "git clone --no-local <branch> && prequeue --quick in it" \
  "untracked, git-ignored or locally generated files the tests rely on (missing test file, stale lock, generated code)" \
  "commit what the clone lacks (git status --ignored shows it), then run again" s_fresh

lint_wanted() { # <globs>: any changed file of the glob list or a config of the lint ratchet
  [[ -n $(changed "$@" .shellcheckrc ruff.toml eslint.config.mjs .swiftlint.yml tools/lint | head -n 1) ]]
}
s_ci_lint() {
  local rc=0 linter globs
  for linter in shellcheck:'*.sh' ruff:'*.py' eslint:'*.js *.mjs *.ts' swiftlint:'*.swift' ktlint:'*.kt *.kts'; do
    # shellcheck disable=SC2086 # a list of globs
    globs=${linter#*:} linter=${linter%%:*}
    # shellcheck disable=SC2086
    [[ -n $(changed $globs | head -n 1) || -n $(changed .shellcheckrc ruff.toml eslint.config.mjs .swiftlint.yml tools/lint | head -n 1) ]] || { echo "n/a $linter: no file changed"; continue; }
    if [[ $linter == ktlint ]] && ! command -v java >/dev/null 2>&1; then echo "skipped ktlint: java is not installed"; continue; fi
    echo "== $linter ."
    bash tools/lint/ratchet.sh "$linter" . || rc=1
  done
  return $rc
}
add 3 ci "CI lint lane" "bash tools/lint/ratchet.sh <shellcheck|ruff|eslint|swiftlint|ktlint> . (the lint part)" \
  "a lint count that moved anywhere in the repo, not only in touched files (static/light)" \
  "fix the finding, or lower the baseline (tools/lint/ratchet.sh --update <linter> .)" s_ci_lint

s_ci_proto() {
  local rc=0 dir tool
  [[ -n $(changed 'proto/*' '*/gen/*' 'docs/dev/api/*' tools/buf.sh tools/codegen.sh | head -n 1) ]] || na "no proto or generated file changed"
  for dir in $(git ls-files '*buf.yaml' | xargs -n 1 dirname); do
    (cd "$dir" && bash "$ROOT/tools/buf.sh" lint) || rc=1
    (cd "$dir" && bash "$ROOT/tools/buf.sh" format --diff --exit-code) || rc=1
  done
  for dir in $(git ls-files '*buf.yaml' | xargs -n 1 dirname); do
    bash tools/proto_breaking.sh "$dir" || rc=1
  done
  if [[ -f proto/buf.gen.yaml ]]; then
    for tool in cargo dart npm curl; do
      command -v "$tool" >/dev/null 2>&1 || { ((rc == 0)) && skipped "codegen.sh --check needs $tool, which is not installed"; return 1; }
    done
    bash tools/codegen.sh install >/dev/null && bash tools/codegen.sh --check || rc=1
  fi
  return $rc
}
add 3 ci "CI proto lane" "buf lint, buf format --diff, tools/codegen.sh --check (the proto part)" \
  "stale generated code, unformatted .proto (static/repo, kernel lanes)" \
  "bash tools/codegen.sh and commit the result" s_ci_proto

s_ci_docs() {
  [[ -n $(changed 'docs/*' '*.md' mkdocs.yml tools/docs.sh | head -n 1) ]] || na "no documentation changed"
  if ! command -v mkdocs >/dev/null 2>&1 && [[ ! -x $ROOT/.cache/docs-venv/bin/python ]]; then
    skipped "mkdocs is not installed and tools/docs.sh would pip install it (network)"
  fi
  mkdir -p "$(dirname "$VENV_LOCK")"
  flock "$VENV_LOCK" bash tools/docs.sh "$TMP/site"
}
add 3 ci "CI docs lane" "bash tools/docs.sh (strict MkDocs: broken links and anchors)" \
  "a broken link or anchor in docs/ (the docs part)" "fix the link mkdocs names" s_ci_docs

s_dart_tests() {
  local pkg f t c i k=0 r tests skip_tags rc=0 PKGK=()
  need flutter || return 77
  [[ -n $(pkg_dirs | head -n 1) ]] || na "no Dart package changed"
  for pkg in $(pkg_dirs); do
    dart_ready "$pkg" || return $?
    [[ -d $pkg/test ]] || continue
    tests=()
    if [[ $pkg == app ]]; then
      mapfile -t -O "${#tests[@]}" tests < <(app_guard_tests)
      kernel_prebuilt || return 1
    fi
    while IFS= read -r f; do
      f=${f#"$pkg"/}
      case $f in
        test/*_test.dart) t=$f ;;
        lib/*.dart)
          # its own test, the test of its directory (lib/a/b/c.dart: test/a/b/c_test.dart, test/a/b_test.dart,
          # test/a/b/b_test.dart)
          t=test/${f#lib/} t=${t%.dart}
          for c in "${t}_test.dart" "$(dirname "$t")_test.dart" "$(dirname "$t")/$(basename "$(dirname "$t")")_test.dart"; do
            [[ ! -f $pkg/$c ]] || tests+=("$c")
          done
          continue
          ;;
        *) continue ;;
      esac
      [[ -f $pkg/$t ]] && tests+=("$t")
    done < <(changed "$pkg/*.dart")
    # the store's own pins
    if [[ $pkg == app/packages/photolib_data ]]; then
      for c in test/native_test.dart test/migration_test.dart; do [[ ! -f $pkg/$c ]] || tests+=("$c"); done
    fi
    # a schema change: every test that pins the schema version (native_test's user_version, migrations, the vault)
    if [[ -n $(changed "$pkg/drift_schemas/*" "$pkg/*.drift" "$pkg/lib/src/replica*.dart" | head -n 1) ]]; then
      while IFS= read -r f; do tests+=("${f#"$pkg"/}"); done < <(grep -lE 'user_version|schemaVersion|drift_schema|SchemaVerifier' "$pkg"/test/*_test.dart 2>/dev/null)
    fi
    ((${#tests[@]})) || continue
    # test/live/ builds photolibd and starts PostgreSQL (and rs-vips does not build on aarch64): left to the gate
    mapfile -t tests < <(printf '%s\n' "${tests[@]}" | sort -u | grep -v '^test/live/')
    ((${#tests[@]})) || continue
    # The tests tagged alone, flaky or timing measure time on the whole machine: the gate runs them in steps of their own.
    skip_tags=()
    for t in alone flaky timing; do
      ! grep -qs "^  $t:" "$pkg/dart_test.yaml" || skip_tags+=(--exclude-tags "$t")
    done
    k=$((k + 1))
    PKGK[k]=$pkg
    # 79: every selected test was excluded by a tag
    (
      cd "$pkg" && offline flutter test --no-pub --reporter failures-only "${skip_tags[@]}" "${tests[@]}"
      r=$?
      ((r == 79)) && r=0
      echo $r >"$TMP/dt.$k.rc"
    ) >"$TMP/dt.$k" 2>&1 &
  done
  wait
  for ((i = 1; i <= k; i++)); do
    [[ $(<"$TMP/dt.$i.rc") == 0 ]] && continue
    tail -n 40 "$TMP/dt.$i"
    echo "failed tests of ${PKGK[i]}:"
    grep -E '\[E\]' "$TMP/dt.$i" | sed -E 's/^[0-9:]+ \+[0-9]+( [-~][0-9]+)*: //' | sort -u | head -n 20
    rc=1
  done
  return $rc
}
add 3 dart "dart tests (touched)" "flutter test of the touched test files, their lib files' tests and the guards (offline)" \
  "i18n lint, device_queries pins, l10n_test, a broken touched test (dart-app, dart-data)" \
  "fix the test; the guards list the file to add or change" s_dart_tests

# Dart, for the touched packages, one after another: they share .dart_tool and build/.
s_dart_gen() {
  local pkg rc=0 before
  need flutter || return 77
  [[ -n $(pkg_dirs | head -n 1) ]] || na "no Dart package changed"
  after_quick
  for pkg in $(pkg_dirs); do
    dart_ready "$pkg" || return $?
    before=$(git status --porcelain -- "$pkg"; git diff -- "$pkg" | cksum)
    if [[ -f $pkg/l10n.yaml && -n $(changed "$pkg/*.arb" "$pkg/l10n.yaml" "$pkg/pubspec.yaml" | head -n 1) ]]; then
      (cd "$pkg" && flutter gen-l10n) || rc=1
    fi
    if [[ -f $pkg/build.yaml && -n $(changed "$pkg/*.dart" "$pkg/*.drift" "$pkg/build.yaml" "$pkg/pubspec.*" | head -n 1) ]]; then
      (cd "$pkg" && dart run build_runner build --force-jit --delete-conflicting-outputs) || rc=1
    fi
    if [[ $before != $(git status --porcelain -- "$pkg"; git diff -- "$pkg" | cksum) ]]; then
      echo "$pkg: generated code (l10n, build_runner, drift schema dump) was stale; commit what the generators wrote:"
      git status --porcelain -- "$pkg" | head -n 10
      rc=1
    fi
  done
  return $rc
}
add 3 dart "dart generated code" "flutter gen-l10n / dart run build_runner build, then the tree must not change" \
  "stale generated localizations, drift code, schema dump without a final newline (dart-data)" \
  "commit what gen-l10n / build_runner wrote" s_dart_gen

s_dart_ratchet() {
  local pkg
  need flutter || return 77
  [[ -n $(pkg_dirs | head -n 1) ]] || na "no Dart package changed"
  for pkg in $(pkg_dirs); do dart_ready "$pkg" || return $?; done
  # one package after another: analyses side by side counted findings twice on a fresh checkout (the app alone passes)
  for pkg in $(pkg_dirs); do
    bash tools/lint/ratchet.sh dart "$pkg" || return 1
  done
}
add 3 dart "dart ratchet (full)" "bash tools/lint/ratchet.sh dart <touched package>, one after another (app: 42 s warm, 170 s cold)" \
  "dart_code_linter metrics and unused code above the baseline (dart-lint); the analyzer lints are the step before" \
  "fix the finding, or lower the baseline (tools/lint/ratchet.sh --update dart <dir>)" s_dart_ratchet

s_rust_clippy() {
  local root base
  export CLONE_TAG=lint
  need cargo || return 77
  [[ -z ${CARGO_TARGET_DIR:-} ]] || export CARGO_TARGET_DIR=$CARGO_TARGET_DIR/lint
  [[ -n $(rust_roots | head -n 1) ]] || na "no Rust root changed"
  for root in $(rust_roots); do
    base=$(root_base "$root") || exit 77
    (cd "$base" && bash tools/lint/ratchet.sh clippy "$root") || return 1
  done
}
add 3 rustl "clippy ratchet" "bash tools/lint/ratchet.sh clippy <root> (rs-vips roots in a patched clone)" \
  "clippy counts above the baseline in a touched root (rust-lint)" \
  "fix the finding, or lower the baseline (tools/lint/ratchet.sh --update clippy <root>)" s_rust_clippy

s_rust_msrv() {
  local root v rc=0
  export CLONE_TAG=lint
  need cargo || return 77
  [[ -z ${CARGO_TARGET_DIR:-} ]] || export CARGO_TARGET_DIR=$CARGO_TARGET_DIR/lint
  need rustup || return 77
  [[ -n $(rust_roots | head -n 1) ]] || na "no Rust root changed"
  for root in $(rust_roots); do
    v=$(sed -nE '/^rust-version[[:space:]]*=/{s/.*"([0-9.]+)".*/\1/p;q}' "$root/Cargo.toml")
    [[ -n $v ]] || { echo "$root/Cargo.toml declares no rust-version"; rc=1; continue; }
    if ! rustup toolchain list | grep -q "^$v"; then
      timeout 120 rustup toolchain install "$v" --profile minimal >/dev/null 2>&1 ||
        { echo "skipped $root: Rust $v (its rust-version) is not installed and could not be fetched"; return 77; }
    fi
    in_root "$root" cargo "+$v" check --locked --workspace || rc=1
  done
  return $rc
}
add 3 rustl "msrv check" "cargo +<rust-version> check --locked --workspace in each touched root" \
  "code or a dependency newer than the declared rust-version (msrv job)" \
  "use only what the rust-version has, or raise it deliberately" s_rust_msrv

# The test binaries that run FFmpeg need the pinned x86-64 build (tools/video/ffmpeg.sh); on another host TEST_FFMPEG
# names a build, else they are left out and said so.
ffmpeg_filter() { # <root>: a nextest filterset leaving out the binaries that need FFmpeg, or nothing
  local f names=() crate
  [[ -z ${TEST_FFMPEG:-} && $(uname -m) != x86_64 ]] || return 0
  while IFS= read -r f; do
    crate=$(crate_of "$f" "$1")
    [[ -n $crate ]] && names+=("(package($crate) & binary($(basename "$f" .rs)))")
  done < <(git grep -lE 'tools/video/ffmpeg\.sh|TEST_FFMPEG' -- "$1/*/tests/*.rs" "$1/crates/*/tests/*.rs" | grep -v '/common/')
  ((${#names[@]})) || return 0
  echo "WARN no FFmpeg for $(uname -m) (set TEST_FFMPEG): left out ${names[*]}" >&2
  local IFS='|'
  echo "not (${names[*]})"
}
# select_for <crate> <dir>: adds to EXPRS (a nextest filterset) and TARGETS (the cargo targets to build) the tests a diff
# can reach in a crate: its unit tests, and the integration test binaries whose file changed or that name a changed
# module (all of them, WHOLE, when Cargo.toml or tests/common changed). Only those are built: the cold build is most of
# the time.
select_for() {
  local crate=$1 dir=$2 f stem t b stems=() names=() expr
  if [[ -n $(changed "$dir/Cargo.toml" "$dir/tests/common/*" | head -n 1) ]]; then
    EXPRS+=("package($crate)")
    WHOLE=1
    return
  fi
  while IFS= read -r f; do
    [[ $f == */src/* ]] || continue
    stem=$(basename "$f" .rs)
    [[ $stem != lib && $stem != main && $stem != mod ]] || stem=$(basename "$(dirname "$f")")
    stems+=("$stem")
  done < <(changed "$dir/*.rs")
  for t in "$dir"/tests/*.rs; do
    [[ -f $t ]] || continue
    b=$(basename "$t" .rs)
    if [[ -n $(changed "$t" | head -n 1) ]]; then names+=("$b"); continue; fi
    for stem in "${stems[@]}"; do
      if grep -qw -- "$stem" "$t"; then names+=("$b"); break; fi
    done
  done
  expr="(package($crate) & (kind(lib) | kind(bin)))"
  for b in "${names[@]}"; do
    expr+=" | (package($crate) & binary($b))"
    TARGETS+=(--test "$b")
  done
  EXPRS+=("($expr)")
}
# the tests of the touched crates in CI's conditions: <cores> <jobs...>; ONLY_FILES narrows them to files
rust_tests() {
  local cores=$1 root crate rc=0 pkgs filter f only expr d sel ff t0 t1
  declare -A cdir
  shift
  need cargo-nextest || return 77
  need taskset || return 77
  [[ -n $(rust_roots | head -n 1) ]] || na "no Rust root changed"
  [[ -z ${CARGO_TARGET_DIR:-} ]] || export CARGO_TARGET_DIR=$CARGO_TARGET_DIR/test
  if [[ -z ${TEST_FFMPEG:-} && $(uname -m) != x86_64 && -x $CACHE/toolchains/ffmpeg-lgpl/bin/ffmpeg ]]; then
    export TEST_FFMPEG=$CACHE/toolchains/ffmpeg-lgpl/bin
  fi
  for root in $(rust_roots); do
    pkgs=() filter=()
    if [[ -n ${ONLY_FILES:-} ]]; then
      only=()
      while IFS= read -r f; do
        [[ $f == "$root"/* && $f == *.rs ]] || continue
        crate=$(crate_of "$f" "$root")
        [[ -n $crate ]] || continue
        pkgs+=(-p "$crate")
        if [[ $f == */tests/*.rs && $f != */tests/common/* ]]; then only+=("(package($crate) & binary($(basename "$f" .rs)))"); else only+=("package($crate)"); fi
      done <"$ONLY_FILES"
      ((${#only[@]})) || continue
      expr=$(IFS='|'; echo "${only[*]}")
      filter=(-E "$expr")
    else
      cdir=()
      while IFS= read -r f; do
        crate=$(crate_of "$f" "$root")
        [[ -n $crate ]] || continue
        d=$(dirname "$f")
        while [[ $d != . && -z $(git ls-files "$d/Cargo.toml") ]]; do d=$(dirname "$d"); done
        # a workspace of its own inside the root (kernel/fuzz) is no member: cargo-fuzz builds it, not nextest
        if [[ $d != "$root" ]] && grep -q '^\[workspace\]' "$d/Cargo.toml"; then continue; fi
        cdir[$crate]=$d
      done < <(changed "$root/*.rs" "$root/*Cargo.toml")
      EXPRS=() TARGETS=() WHOLE=0
      for crate in "${!cdir[@]}"; do
        pkgs+=(-p "$crate")
        select_for "$crate" "${cdir[$crate]}"
      done
      ((${#pkgs[@]})) || continue
      sel=$(IFS='|'; echo "${EXPRS[*]}")
      ff=$(ffmpeg_filter "$root")
      filter=(-E "($sel)${ff:+ & $ff}")
      ((WHOLE)) || filter+=(--lib --bins "${TARGETS[@]}")
    fi
    ((${#pkgs[@]})) || continue
    # build on every core, run on CI's four (a build under taskset is several times slower)
    t0=$SECONDS
    in_root "$root" cargo nextest run --locked --no-run "${pkgs[@]}" "${filter[@]}" || { rc=1; continue; }
    t1=$SECONDS
    in_root "$root" env RUST_BACKTRACE=1 bash "$ROOT/tools/offline.sh" taskset -c "$cores" \
      cargo nextest run --locked --no-fail-fast --retries 0 --no-tests=pass "$@" "${pkgs[@]}" "${filter[@]}" >"$TMP/nextest.out" 2>&1 || rc=1
    echo "NOTE $root: built in $((t1 - t0))s, ran in $((SECONDS - t1))s: $(grep -E '^ *Summary' "$TMP/nextest.out" | sed 's/^ *//; s/\x1b\[[0-9;]*m//g')"
    grep -q 'test run failed\|error:' "$TMP/nextest.out" && cat "$TMP/nextest.out"
  done
  return $rc
}
s_rust_tests() { rust_tests 0-3 --failure-output final; }
add 3 rust "rust tests (4 cores)" "taskset -c 0-3 offline.sh cargo nextest run --locked --retries 0 -E <tests the diff reaches>" \
  "a test that passes only on retry or only with many cores; a model or fixture missing from the prefetch (rust-server-1)" \
  "run the failing test alone with the same taskset; add the fixture to the check.sh prefetch" s_rust_tests

s_rust_load() {
  local n=0
  while [[ ! -f $TMP/timing.done ]] && ((n++ < 300)); do sleep 0.2; done
  [[ -s $TMP/timing.warn ]] || na "no new Rust test reads the clock or the core count"
  ONLY_FILES=$TMP/timing.warn rust_tests 0-1 --failure-output final -j 8
}
add 3 rustu "rust tests under load" "taskset -c 0-1 cargo nextest run -j 8, when a test asserts time" \
  "a wall-clock budget in a correctness test (faces 5.5 s)" "do not assert wall-clock time; count work instead" s_rust_load

# The queue tests the branch merged with the base (dev as it is then): AGENTS.md and tools/README.md merge as a union
# of lines, so two edits of one line, or two additions that nearly repeat each other, fail only after the merge.
s_merged_base() {
  local dir=$TMP/mb behind out new
  [[ -z $TREE_ONLY ]] || na "not repeated in a nested run"
  behind=$(git rev-list --count HEAD.."$BASE")
  ((behind > 0)) || na "this branch has everything of $BASE"
  git worktree add -q --detach "$dir" HEAD || return 1
  if ! git -C "$dir" -c user.name=prequeue -c user.email=prequeue@invalid -c core.hooksPath=/dev/null merge -q --no-edit "$BASE" >/dev/null 2>&1; then
    git worktree remove --force "$dir" >/dev/null 2>&1
    na "merging $BASE conflicts: see the merge dry run"
  fi
  out=$(nested_quick "$dir")
  local rc=$?
  git worktree remove --force "$dir" >/dev/null 2>&1
  if ((rc != 0)); then
    after_quick
    new=$(new_failures "$out")
    if [[ -z $new ]]; then
      echo "NOTE the merge with $BASE fails the same quick steps as this branch alone"
      return 0
    fi
    printf '%s\n' "$out" | tail -n 50
    echo "fails once merged with $BASE ($behind commits ahead of this branch), not before: $(tr '\n' ',' <<<"$new")"
    echo "rebase on $BASE and fix it there: the queue tests that merge"
    return 1
  fi
}
add 3 comb "merged with base" "merge BASE into a scratch tree with this branch; the quick steps and the repo tests there" \
  "AGENTS.md / README union-merge duplicates, rows two branches edited (#129: the web row five times)" \
  "rebase on BASE and fix the duplicated or conflicting lines it leaves" s_merged_base

# The PRs queued ahead of this one, merged into a scratch tree with this branch; the quick steps in it.
s_combined() {
  local current heads=() names=() ref n name dir=$TMP/comb json bad merged=() rc=0 i t tests git_merge ok new
  [[ -z ${PREQUEUE_NO_GH:-} ]] || skipped "PREQUEUE_NO_GH is set: the queue is not listed"
  command -v gh >/dev/null 2>&1 || skipped "gh is not installed: the queue cannot be listed"
  current=$(timeout 30 gh pr view --json number --jq .number 2>/dev/null) || current=0
  json=$(timeout 60 gh pr list --state open --limit 100 --json number,headRefName,labels,baseRefName 2>/dev/null) ||
    skipped "gh pr list failed (not logged in, or no network)"
  # the PRs labelled queued, and the merge queue's own branches (each holds the PRs stacked on it)
  while IFS=$'\t' read -r n name; do
    [[ $n != "$current" ]] || continue
    ref=$REMOTE/$name
    git rev-parse -q --verify "$ref" >/dev/null || { echo "WARN #$n ($name) is not fetched: not merged in"; continue; }
    [[ $(git rev-parse "$ref") != "$(git rev-parse HEAD)" ]] || continue
    git merge-base --is-ancestor "$ref" HEAD 2>/dev/null && continue
    heads+=("$ref") names+=("#$n")
  done < <(printf '%s' "$json" | jq -r '.[] | select(.baseRefName == "dev") |
      select((.headRefName | startswith("mergify/merge-queue/")) or any(.labels[]; .name == "queued")) |
      "\(.number)\t\(.headRefName)"')
  ((${#heads[@]})) || na "no other PR is queued"
  git worktree add -q --detach "$dir" HEAD || return 1
  git_merge=(git -C "$dir" -c user.name=prequeue -c user.email=prequeue@invalid -c core.hooksPath=/dev/null merge -q --no-edit)
  for i in "${!heads[@]}"; do
    if git merge-tree --write-tree HEAD "${heads[i]}" >/dev/null 2>&1; then
      merged+=("$i")
    else
      echo "WARN ${names[i]} (${heads[i]}) conflicts with this branch: the one that queues second must rebase"
    fi
  done
  if ((${#merged[@]} == 0)); then
    git worktree remove --force "$dir" >/dev/null 2>&1
    echo "no other PR merges cleanly with this branch"
    return 0
  fi
  for i in "${merged[@]}"; do
    "${git_merge[@]}" "${heads[i]}" >/dev/null 2>&1 ||
      { git -C "$dir" merge --abort >/dev/null 2>&1; echo "WARN ${names[i]} does not merge after the PRs before it"; }
  done
  bad=$(nested_quick "$dir") && ok=0 || ok=1
  if ((ok)); then
    after_quick
    new=$(new_failures "$bad")
    [[ -n $new ]] || { echo "NOTE the merge with ${names[*]} fails the same quick steps as this branch alone"; ok=0; }
  fi
  if ((ok)); then
    rc=1
    echo "this branch passes alone but not merged with ${names[*]}"
    # which one: the repo tests that failed (else the quick steps) with this branch and each of them alone
    tests=$(grep -o 'tools/tests/test_[a-z_0-9]*\.sh' <<<"$bad" | sort -u)
    for i in "${merged[@]}"; do
      git -C "$dir" checkout -q -f --detach "$(git rev-parse HEAD)" || continue
      "${git_merge[@]}" "${heads[i]}" >/dev/null 2>&1 || continue
      if [[ -n $tests ]]; then
        for t in $tests; do
          (cd "$dir" && bash "$t" >/dev/null 2>&1) || echo "  $t fails together with ${names[i]} (${heads[i]})"
        done
      else
        nested_quick "$dir" >/dev/null 2>&1 || echo "  the quick steps fail together with ${names[i]} (${heads[i]})"
      fi
    done
    printf '%s\n' "$bad" | tail -n 40
  fi
  git worktree remove --force "$dir" >/dev/null 2>&1
  return $rc
}
add 3 comb "combined with queued PRs" "merge each queued PR into a scratch tree with this branch; the quick steps there" \
  "lint counts, README/ADR rows or generated files that fit alone but not together (the other PR is named)" \
  "land after the PR it names, or rebase onto it once it is in dev" s_combined

# --- rank 4: --perf ---------------------------------------------------------------------------------------------------
s_perf() {
  need valgrind || return 77
  [[ -n $(changed 'kernel/*' 'server/*' tools/perf | head -n 1) ]] || na "no kernel or server code changed"
  if vips_patched server; then
    skipped "tools/perf/instructions.sh builds the server benches, and rs-vips does not compile on aarch64 unpatched"
  fi
  bash tools/perf/instructions.sh "$(git merge-base "$BASE" HEAD)"
}
add 4 perf "perf instructions" "bash tools/perf/instructions.sh (Callgrind; about 11 min in CI)" \
  "an instruction count +10% (perf-instructions, ingest-hdr +12.4%)" \
  "fix the regression, or say why in a perf-accept: line of the PR body" s_perf

# ---------------------------------------------------------------------------------------------------------------------
selected() { # <rank>
  (($1 <= RANK_MAX || (PERF == 1 && $1 == 4)))
}
TIER_OF=("" quick default full perf)
if ((LIST)); then
  echo "prequeue steps of --$TIER$([[ $PERF == 1 ]] && echo ' --perf')  (budget ${BUDGET}s)"
  for r in 1 2 3 4; do
    for i in "${!NAMES[@]}"; do
      [[ ${RANKS[i]} == "$r" ]] && selected "$r" || continue
      printf '%-7s %s\n          $ %s\n          catches: %s\n' "${TIER_OF[r]}" "${NAMES[i]}" "${CMDS[i]}" "${CATCH[i]}"
    done
  done
  rm -rf "$TMP"
  exit 0
fi

# ---------------------------------------------------------------------------------------------------------------------
# The caches of this tool stay small: the three newest clones and cargo target directories of the user, not this run's.
prune_caches() {
  local d here
  here=$(printf %s "$ROOT" | cksum | cut -d' ' -f1)
  # shellcheck disable=SC2012 # newest first by mtime; the names are ours
  for d in $(ls -1dt "$CACHE"/prequeue/clone-* 2>/dev/null | tail -n +7) $(ls -1dt "$CACHE"/rust-targets/prequeue-* 2>/dev/null | tail -n +4); do
    [[ $d == *-$here* ]] && continue
    chmod -R u+w "$d" 2>/dev/null
    rm -rf "$d"
  done
}
[[ -n $TREE_ONLY ]] || prune_caches >/dev/null 2>&1 &
set -m # each lane its own process group, so that a lane over the budget can be stopped whole
PIDS=()
cleanup() {
  local p
  for p in "${PIDS[@]+"${PIDS[@]}"}"; do kill -TERM -- "-$p" 2>/dev/null; done
  rm -rf "$TMP"
}
trap cleanup EXIT
trap 'echo; echo "prequeue: interrupted" >&2; exit 130' INT TERM

WARNS=0 SKIPS=0 FAILED=() NOTRUN=() CUT=()
warn() { echo "warn $*"; WARNS=$((WARNS + 1)); }
echo "== prequeue --$TIER: $(git rev-parse --abbrev-ref HEAD) against $BASE (budget ${BUDGET}s)"
if [[ -z ${PREQUEUE_NO_FETCH:-} ]]; then
  timeout 60 git fetch -q "$REMOTE" 2>/dev/null || warn "git fetch failed: comparing with the refs you have"
fi
git rev-parse -q --verify "$BASE" >/dev/null || { echo "FAIL $BASE is missing: git fetch $REMOTE" >&2; exit 1; }
behind=$(git rev-list --count HEAD.."$BASE")
((behind == 0)) || warn "$behind commits of $BASE are not in this branch: rebase or merge before queueing (generated code, ADR index and AGENTS.md conflict first)"
[[ -z $(git status --porcelain --untracked-files=no) ]] || warn "uncommitted changes: this checks HEAD, the queue sees only what you push"

run_step() { # <index>
  local i=$1 rc
  echo "${EPOCHREALTIME/./}" >"$TMP/r.$i.start"
  ("${FUNCS[i]}") >"$TMP/r.$i.out" 2>&1
  rc=$?
  echo "$rc ${EPOCHREALTIME/./}" >"$TMP/r.$i.rc.tmp" && mv "$TMP/r.$i.rc.tmp" "$TMP/r.$i.rc"
}
# the steps of this run, in order of rank then registration, and their lanes
ORDER=() LANE_NAMES=()
for r in 1 2 3 4; do
  for i in "${!NAMES[@]}"; do
    [[ ${RANKS[i]} == "$r" ]] && selected "$r" && [[ -z ${PREQUEUE_ONLY:-} || ${NAMES[i]} == *"$PREQUEUE_ONLY"* || ${NAMES[i]} =~ $PREQUEUE_ONLY ]] || continue
    ORDER+=("$i")
    [[ " ${LANE_NAMES[*]:-} " == *" ${LANES[i]} "* ]] || LANE_NAMES+=("${LANES[i]}")
  done
done
START=$SECONDS
# the steps that wait for the quick lane (after_quick) must not wait for one this run does not have (PREQUEUE_ONLY)
[[ " ${LANE_NAMES[*]:-} " == *" q "* ]] || : >"$TMP/quick.done"
# --perf runs after the budgeted steps: its own lane, started when the others have ended
for lane in "${LANE_NAMES[@]}"; do
  steps=()
  for i in "${ORDER[@]}"; do [[ ${LANES[i]} == "$lane" && ${RANKS[i]} != 4 ]] && steps+=("$i"); done
  ((${#steps[@]})) || continue
  (
    set +m
    for j in "${steps[@]}"; do run_step "$j"; done
    [[ $lane != q ]] || : >"$TMP/quick.done"
  ) &
  PIDS+=("$!")
done

report() { # <index>: prints the step's line(s); sets nothing global but the counters
  local i=$1 rc t0 t1 secs name reason
  name=${NAMES[i]}
  read -r rc t1 <"$TMP/r.$i.rc"
  t0=$(cat "$TMP/r.$i.start" 2>/dev/null || echo "$t1")
  secs=$(awk -v a="$t0" -v b="$t1" 'BEGIN { printf "%.1f", (b - a) / 1000000 }')
  while IFS= read -r line; do warn "$name: ${line#WARN }"; done < <(grep '^WARN ' "$TMP/r.$i.out")
  while IFS= read -r line; do echo "skip $name: ${line#SKIP }"; SKIPS=$((SKIPS + 1)); done < <(grep '^SKIP ' "$TMP/r.$i.out")
  while IFS= read -r line; do echo "note $name: ${line#NOTE }"; done < <(grep '^NOTE ' "$TMP/r.$i.out")
  reason=$(grep -v '^WARN \|^SKIP \|^NOTE ' "$TMP/r.$i.out" | head -n 1)
  case $rc in
    0) echo "ok $name (${secs}s)" ;;
    77) echo "skip $name (${reason:-skipped on this machine})"; SKIPS=$((SKIPS + 1)); NOTRUN+=("$name") ;;
    78) echo "n/a $name (${reason:-nothing to check})" ;;
    200) echo "slow $name (still running at $((SECONDS - START))s, stopped: over the budget of ${BUDGET}s)"; WARNS=$((WARNS + 1)); NOTRUN+=("$name (slow)"); CUT+=("$name") ;;
    201) echo "skip $name (the budget of ${BUDGET}s was used up)"; SKIPS=$((SKIPS + 1)); NOTRUN+=("$name (budget)"); CUT+=("$name") ;;
    *)
      echo "FAIL $name (${secs}s)"
      grep -v '^WARN \|^SKIP \|^NOTE ' "$TMP/r.$i.out" | tail -n 40 | sed 's/^/      /'
      FAILED+=("$name: ${HINTS[i]:-see above}")
      ;;
  esac
}
stop_lanes() {
  local p i
  for p in "${PIDS[@]}"; do kill -TERM -- "-$p" 2>/dev/null; done
  sleep 0.5
  for p in "${PIDS[@]}"; do kill -KILL -- "-$p" 2>/dev/null; done
  for i in "${ORDER[@]}"; do
    [[ -f $TMP/r.$i.rc ]] && continue
    [[ -f $TMP/r.$i.out ]] || : >"$TMP/r.$i.out"
    if [[ -f $TMP/r.$i.start ]]; then echo "200 ${EPOCHREALTIME/./}" >"$TMP/r.$i.rc"; else echo "201 ${EPOCHREALTIME/./}" >"$TMP/r.$i.rc"; fi
  done
}
STOPPED=0
for i in "${ORDER[@]}"; do
  [[ ${RANKS[i]} != 4 ]] || continue
  while [[ ! -f $TMP/r.$i.rc ]]; do
    if ((STOPPED == 0 && SECONDS - START >= BUDGET)); then
      STOPPED=1
      stop_lanes 2>/dev/null
      break
    fi
    sleep 0.2
  done
  report "$i"
done
wait 2>/dev/null
PIDS=()
for i in "${ORDER[@]}"; do
  [[ ${RANKS[i]} == 4 ]] || continue
  run_step "$i"
  report "$i"
done

((${#NOTRUN[@]} == 0)) || { local_list=$(IFS=,; echo "${NOTRUN[*]}"); echo "== not run: ${local_list//,/, }"; }
echo "== not covered here: timing budgets on a loaded box, apt/CI infrastructure, browsers, gitleaks, docker, the full"
echo "   gate (run 'bash tools/check.sh --since $BASE' for the rest)"
cut_note=''
((${#CUT[@]} == 0)) || cut_note=" and ${#CUT[@]} cut by the budget"
if ((${#FAILED[@]})); then
  printf 'FAIL %s\n' "${FAILED[@]}" >&2
  echo "prequeue: FAIL ($TIER, $((SECONDS - START))s, $WARNS warnings, $SKIPS skipped$cut_note)"
  echo "do not queue: the queue runs these checks on the commits you pushed, so a check that passes alone in your checkout"
  echo "still fails there when your working tree differs from HEAD, or when your branch merged with ${BASE} fails it"
  exit 1
fi
if ((${#CUT[@]})); then
  # a step stopped at the budget, or never started: the run proves less than its tier says
  plural=steps
  ((${#CUT[@]} != 1)) || plural=step
  echo "prequeue: INCOMPLETE (${#CUT[@]} $plural not run) ($TIER, $((SECONDS - START))s, $WARNS warnings, $SKIPS skipped): run each alone: PREQUEUE_BUDGET=1800 PREQUEUE_ONLY='<name>' bash tools/prequeue.sh --full"
  exit 3
fi
echo "prequeue: PASS ($TIER, $((SECONDS - START))s, $WARNS warnings, $SKIPS skipped)"
