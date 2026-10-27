#!/usr/bin/env bash
# Counts the CPU instructions of the kernel's and the server's hot paths (benches/instructions.rs) with Callgrind,
# which counts the same however loaded the machine is, on this checkout and on its base, and fails a benchmark that
# takes more than 10% more unless the pull request says why in a `perf-accept: <reason>` line: in $PR_BODY or in a
# commit message since the base (ADR-0048). The base-against-branch table goes to stdout and, for the pull request's
# description, to $PERF_REPORT when set. Needs git, cargo, python3 and valgrind.
#   bash tools/perf/instructions.sh [base]    # default: the merge base with <remote>/dev, tools/remote.sh
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
cd "$ROOT"
remote=$(bash "$ROOT/tools/remote.sh")
base=$(git rev-parse --verify "${1:-$(git merge-base "$remote/dev" HEAD)}^{commit}")
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# The base's checkout and target directory keep their paths, so cargo rebuilds it only when the base moves (tar -m:
# files dated now). Its target directory is its own: cargo names a workspace's crates by their path within it, so in
# the branch's it would take the base's build, dated later, for the branch's. Its code runs, so only from a private
# directory, as check.sh keeps build/.
cache=${PHOTOLIB_CACHE:-${TMPDIR:-/var/tmp}/photolib-$UID}
mkdir -p -m 700 "$cache"
if [[ -L $cache || ! -O $cache ]]; then
  echo "instructions.sh: $cache is not a private directory of this user; set PHOTOLIB_CACHE" >&2
  exit 1
fi
checkout=$cache/perf-base$ROOT
if [[ $(cat "$checkout/.base" 2>/dev/null) != "$base" ]]; then
  rm -rf "$checkout" && mkdir -p "$checkout"
  git archive "$base" | tar -x -m -C "$checkout"
  echo "$base" >"$checkout/.base"
fi

# count <checkout> [target directory]: one JSON line per benchmark.
count() {
  local bench dir rel exe names name
  for bench in "$1"/kernel/benches/instructions.rs "$1"/server/crates/*/benches/instructions.rs; do
    [[ -f $bench ]] || continue
    dir=${bench%/benches/*} rel=${bench#"$1"/}
    # The bench's executable: a package's binaries are built with it.
    exe=$(cd "$dir" && CARGO_TARGET_DIR=${2:-${CARGO_TARGET_DIR:-$ROOT/${rel%%/*}/target}} \
      cargo bench --locked -q --bench instructions --no-run --message-format=json |
      sed -n '/\/benches\/instructions\.rs"/s/.*"executable":"\([^"]*\)".*/\1/p')
    names=$("$exe" --list)
    for name in $names; do
      valgrind --tool=callgrind --collect-atstart=no --toggle-collect='instructions::harness::counted*' \
        --callgrind-out-file="$tmp/callgrind" "$exe" "$name" >/dev/null 2>"$tmp/valgrind" || {
        cat "$tmp/valgrind" >&2
        return 1
      }
      printf '{"bench": "%s %s", "instructions": %s}\n' "${dir##*/}" "$name" \
        "$(sed -n 's/^totals: //p' "$tmp/callgrind")"
    done
  done
}

count "$checkout" "$cache/perf-target$ROOT" >"$tmp/base.jsonl"
count "$ROOT" >"$tmp/branch.jsonl"
{
  printf '%s\n' "${PR_BODY:-}"
  git log --format=%B "$base..HEAD"
} >"$tmp/pull-request"
{
  printf 'Instructions of the hot paths (Callgrind), base %s against this branch:\n\n' "${base:0:12}"
  python3 tools/perf/perf.py instructions "$tmp/base.jsonl" "$tmp/branch.jsonl" --accept "$tmp/pull-request"
} | tee "${PERF_REPORT:-/dev/null}"
