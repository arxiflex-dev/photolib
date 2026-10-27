#!/usr/bin/env bash
# Measures one budget of budgets.json with a command of its own and checks it (perf.py): the kernel through each of its
# bindings, hls.js's start. The command runs in the current directory and prints one `result: {json}` line per
# series (budget, metric, target, value); no test asserts a time. It fails when a series on those targets misses its
# budget or is missing, when the command fails, and (exit 124) when it hangs, as run.sh does.
#
#   bash tools/perf/measure.sh <budget> <target>... -- <command...>
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
perf=$root/tools/perf/perf.py
budget=${1:?usage: measure.sh <budget> <target>... -- <command...>}
shift
targets=()
while (($#)) && [[ $1 != -- ]]; do targets+=("$1") && shift; done
((${#targets[@]} && $#)) && shift && (($#)) || { echo "usage: measure.sh <budget> <target>... -- <command...>" >&2; exit 2; }
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
: >"$tmp/results.jsonl"
# A build before the first result is silent for minutes on a cold cache (cargo, the web module).
export PERF_SILENCE=${PERF_SILENCE:-1500} PERF_DEADLINE=${PERF_DEADLINE:-1700}
python3 "$perf" watch "$tmp/results.jsonl" "$budget" -- "$@"
pattern=$(IFS='|' && echo "${targets[*]}")
python3 "$perf" series --units "$budget" | grep -E "\"target\": \"($pattern)\"" >"$tmp/only.jsonl" || {
  echo "measure.sh: budgets.json measures no series of $budget on ${targets[*]}" >&2
  exit 1
}
expect=()
for target in "${targets[@]}"; do expect+=(--expect "$target"); done
exec python3 "$perf" check "$tmp/results.jsonl" --only "$tmp/only.jsonl" "${expect[@]}"
