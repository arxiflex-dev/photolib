#!/usr/bin/env bash
# The kernel's go/no-go report (M0-14): numbers for every native target of tools/kernel/build.py and every browser
# and compiler, against each threshold of ADR-0004, and the decision recorded as ADR-0029, as the owner confirmed it
# (photolib-design#317); and crypto suite v1's budgets (M0-40): PLB decrypt and Argon2id calibration, PLB decrypt
# on a desktop's performance cores, as the owner confirmed (photolib-design#333).
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT" || exit 1

REPORT=docs/dev/kernel-go-no-go.md
ADR=docs/adr/0029-kernel-go-no-go.md
for target in $(sed -nE 's/^    "([a-z0-9-]+)": "[^"]+",$/\1/p' tools/kernel/build.py); do
  assert_matches "$REPORT" "^\| $target \|" "has a row for $target"
done
for browser in "Chrome 154" "Chrome 155" "Firefox 157" "Firefox 158" Safari; do
  for compiler in dart2js dart2wasm; do
    [[ $browser == Safari && $compiler == dart2wasm ]] && continue
    assert_matches "$REPORT" "^\| $browser \| $compiler \|" "has a row for $browser with $compiler"
  done
done
for threshold in '3 MB' '1 MB' '50 µs' '200 µs' '200 MB/s' '50 MB/s' '1,000 files/s' 'COOP/COEP' '1 GiB/s' '300 MiB/s'; do
  assert_prose "$REPORT" "$threshold" "measures against $threshold"
done
assert_prose "$REPORT" 'Argon2id at the device floor.*reference phone' "measures Argon2id calibration, phone included"
check "the series kernel-binding fails PLB decrypt below 300 MiB/s on the web and 1 GiB/s natively" python3 -c "
import json
m = json.load(open('tools/perf/budgets.json'))['budgets']['kernel-binding']['metrics']['decrypt_MiB_s']
assert m['min'] == {'native': 1024, 'dart2js': 300, 'dart2wasm': 300}, m"
assert_prose "$REPORT" 'on a performance core \(the owner confirmed, photolib-design#333\)' \
  "holds PLB decrypt's budget on a performance core, as the owner confirmed"
for pinned in benchmark/kernel_bench_test test/wasm_server; do
  assert_prose "app/packages/photolib_kernel/$pinned.dart" 'pinToFastestCores\(pid\)' \
    "$pinned benchmarks on the fastest cores"
done
assert_prose docs/dev/README.md 'kernel-go-no-go\.md' "the developer guide links the report"
assert_prose "$ADR" 'We will go on all targets with the Rust kernel' "records the outcome the owner answered (Rust)"
assert_prose "$ADR" '\*\*Status\*\*: Accepted .*photolib-design#305' "is Accepted with the owner's answer (#305)"
assert_prose "$ADR" 'owner confirmed [^*]*photolib-design#317' "records the owner's confirmation of that reading (#317)"
check "no longer asks the owner to confirm" bash -c "! grep -qi 'asked to confirm' $ADR"
assert_matches docs/adr/README.md '0029-kernel-go-no-go\.md\) \| [^|]* \| Accepted \(owner confirmed' \
  "the ADR index lists it as Accepted"
assert_prose "$ADR" '\(\.\./dev/kernel-go-no-go\.md\)' "links the report"

finish
