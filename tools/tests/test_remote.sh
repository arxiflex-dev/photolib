#!/usr/bin/env bash
# tools/remote.sh, the one place that names the git remote the gate and the pre-queue tools compare with
# (`<remote>/dev`): $PHOTOLIB_REMOTE, else the only remote, else `origin`; and the pre-queue script in a repository
# whose only remote is not called `origin`. Offline, in throwaway repositories.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_tool git

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# remote_in <dir> [env...]: what remote.sh prints (and says) in that repository
remote_in() {
  local dir=$1
  shift
  capture env -u PHOTOLIB_REMOTE "$@" bash -c 'cd "$0" && bash "$1"' "$dir" "$REPO_ROOT/tools/remote.sh"
}
repo() {
  git init -q "$WORK/$1"
  local name
  for name in "${@:2}"; do git -C "$WORK/$1" remote add "$name" "https://example.invalid/$name.git"; done
}

repo none
remote_in "$WORK/none"
expect_result "a repository with no remote compares with origin, as a fresh clone does" 0 "origin"
[[ $OUT == origin ]] && ok "and prints nothing else" || fail "printed: $OUT"

repo solo arxiflex-dev
remote_in "$WORK/solo"
[[ $STATUS -eq 0 && $OUT == arxiflex-dev ]] && ok "the only remote is the one, whatever it is called" || fail "solo: $STATUS $OUT"

repo pair upstream origin
remote_in "$WORK/pair"
[[ $STATUS -eq 0 && $OUT == origin ]] && ok "of several remotes, origin keeps being the one" || fail "pair: $STATUS $OUT"

repo many upstream fork
remote_in "$WORK/many"
expect_result "several remotes and no origin: it does not guess, it names PHOTOLIB_REMOTE" failure "PHOTOLIB_REMOTE" "upstream" "fork"

remote_in "$WORK/many" PHOTOLIB_REMOTE=fork
[[ $STATUS -eq 0 && $OUT == fork ]] && ok "PHOTOLIB_REMOTE decides" || fail "override: $STATUS $OUT"
remote_in "$WORK/solo" PHOTOLIB_REMOTE=upstream
[[ $STATUS -eq 0 && $OUT == upstream ]] && ok "PHOTOLIB_REMOTE wins over the only remote" || fail "override: $STATUS $OUT"

# --- prequeue.sh in a clone whose only remote is arxiflex-dev: base arxiflex-dev/dev, the fetch works, no word of origin
git -C "$REPO_ROOT" rev-parse -q --verify HEAD >/dev/null || { fail "no commit to clone"; finish; }
git init -q --bare "$WORK/up.git"
git -C "$REPO_ROOT" push -q "$WORK/up.git" HEAD:refs/heads/dev 2>/dev/null || fail "cannot push HEAD to the scratch remote"
git clone -q -o arxiflex-dev "$WORK/up.git" "$WORK/clone" 2>/dev/null || fail "cannot clone the scratch remote"
# the clone is this checkout's HEAD, so it holds the tools under test; its branch equals dev, which a quick run passes
git -C "$WORK/clone" checkout -q -b wi/sandbox
[[ $(git -C "$WORK/clone" remote) == arxiflex-dev ]] && ok "the clone has no origin" || fail "remotes: $(git -C "$WORK/clone" remote)"
capture env -u PHOTOLIB_REMOTE -u PREQUEUE_BASE -u PREQUEUE_OTHERS PREQUEUE_NO_GH=1 PREQUEUE_FAST_TESTS="layout" \
  bash -c 'cd "$0" && bash tools/prequeue.sh --quick' "$WORK/clone"
expect_result "prequeue.sh compares with arxiflex-dev/dev and fetches from the only remote" 0 \
  "against arxiflex-dev/dev" "prequeue: PASS (quick,"
[[ $OUT != *origin* && $OUT != *"fetch failed"* ]] && ok "and says nothing of origin or a failed fetch" || fail "mentions origin or a failed fetch: $OUT"

finish
