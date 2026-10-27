#!/usr/bin/env bash
# Measures the budgets of budgets.json this machine can measure and checks them (perf.py): the server, and the desktop
# app over every fixture. On Linux without a display the app runs under Xvfb as the `headless` target. With
# PERF_HISTORY=<file>.jsonl, a reference machine records the run there per commit, fails a regression over 10% and
# writes the dashboard to <file>.html. With PERF_FAILED=<file>, the series that fail are written there, and a run that
# finds some there (the gate's rerun of a failed run) measures and checks those alone, so that another budget cannot
# fail it. Each benchmark app runs under `perf.py watch`, which records each result the app prints as it comes, fails
# its budget as hung once it falls silent or misses a fixture's deadline, or with its status once it fails, and goes on.
# The server's benchmarks run beside the app's idle CPU, the app's frame-timed benchmarks and its cold start alone
# after them; the time each step took ends the output (ADR-0212). Needs python3, cargo, flutter, the PostgreSQL
# programs, FFmpeg (tools/video/ffmpeg.sh) for the videos the viewer swipes through, and on Linux xvfb-run and libmpv,
# and without a session bus dbus-run-session and gnome-keyring-daemon (keyring.sh).
# shellcheck disable=SC2329 # the steps run through timed
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../.."
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
results=$tmp/results.jsonl
failed=${PERF_FAILED:-$tmp/failed.jsonl}
check=(check "$results" --failed "$failed")
server=(server-idle-rss ingest-throughput initial-sync-100k ocr-read cold-start idle-cpu)
# The tests of app/benchmark/perf_test.dart to run, comma-separated (all when empty): a fixture's, folder-10k's,
# videos', sphere-video's, device-folders-5k's or server-tiles'.
tests=
# PERF_UNITS and PERF_UNITS_EXCEPT (comma-separated, perf.py series names them): only a share of the budgets, which CI
# splits over machines. The first run measures that share's series as a rerun measures those that failed; a rerun, the
# share's that failed.
if [[ ! -s $failed && -n ${PERF_UNITS:-}${PERF_UNITS_EXCEPT:-} ]]; then
  python3 tools/perf/perf.py series --units "${PERF_UNITS:-}" --except "${PERF_UNITS_EXCEPT:-}" >"$failed"
  [[ -s $failed ]] || {
    echo "run.sh: PERF_UNITS='${PERF_UNITS:-}' and PERF_UNITS_EXCEPT='${PERF_UNITS_EXCEPT:-}' name no budget" >&2
    exit 1
  }
fi
if [[ -s $failed ]]; then
  # Kept there: a rerun that ends before its check leaves them to the gate's next attempt.
  cp "$failed" "$tmp/only.jsonl"
  check+=(--only "$tmp/only.jsonl")
  tests=$(python3 -c 'import json, sys; print(",".join(sorted({r["fixture"] or
    {"video-swipe": "videos", "sphere-video": "sphere-video",
     "device-folders-scroll": "device-folders-5k", "server-tiles": "server-tiles"}.get(r["budget"], "folder-10k")
    for r in map(json.loads, open(sys.argv[1])) if r["budget"] not in sys.argv[2:]})))' "$tmp/only.jsonl" "${server[@]}")
  [[ -n $tests ]] || tests=none
fi
# Whether this run measures budget $1 (on fixture $2): every one but on a rerun.
measures() { [[ ! -f $tmp/only.jsonl ]] || grep -q "\"budget\": \"$1\".*\"fixture\": \"${2:-.*}\"" "$tmp/only.jsonl"; }

# timed <step> <command...>: runs it, noting how long it took for the table at the end.
timed() {
  local start=$SECONDS
  "${@:2}"
  echo "$((SECONDS - start)) $1" >>"$tmp/times"
}
fixtures() {
  python3 -c 'import json; [print(k, *v) for k, v in json.load(open("tools/perf/budgets.json"))["fixtures"].items()]' |
    while read -ra fixture; do
      name=${fixture[0]}
      [[ -z $tests || ,$tests, == *,$name,* ]] || measures idle-cpu "$name" || continue
      cargo run --locked --release -q --manifest-path tools/synthlib/Cargo.toml -- "${fixture[@]:1}" \
        --out "$PERF_FIXTURES/$name"
    done
}
# An environment variable, not a define: a define that changed each run would compile the app anew each run.
export PERF_FIXTURES=$tmp/fixtures
mkdir -p "$PERF_FIXTURES"
timed fixtures fixtures

case $(uname) in
  Linux) device=linux ;;
  Darwin) device=macos ;;
  *) device=windows ;;
esac
display=()
target=desktop
if [[ $device == linux && -z ${DISPLAY:-}${WAYLAND_DISPLAY:-} ]]; then
  display=(xvfb-run -a)
  target=headless
fi
target=${PERF_TARGET:-$target}
# Without a session bus the app's store would wait for a passphrase (ADR-0154): it runs with a throwaway keyring.
[[ $device != linux || -n ${DBUS_SESSION_BUS_ADDRESS:-} ]] ||
  display=(bash "$PWD/tools/perf/keyring.sh" ${display[@]+"${display[@]}"})
if [[ $tests != none ]] || measures cold-start || measures idle-cpu; then
  # Until a kernel release is pinned, the app bundles the kernel built here (ADR-0057); before the server's builds,
  # which would hold cargo's lock on the target directory.
  timed kernel python3 tools/kernel/build.py --out app/build/kernel \
    "$device-$(uname -m | sed 's/x86_64/x64/; s/aarch64/arm64/')"
fi
[[ $tests == none ]] || ffmpeg=$(bash tools/video/ffmpeg.sh)

# The server's benchmarks and the 360° video the app plays, beside the app's build and idle CPU (ADR-0212): ingest
# counts CPU time calibrated against the load (ADR-0121), the sync is far within its budget, memory is no time, and
# the idle CPU is its process's CPU time.
server_benchmarks() {
  if measures server-idle-rss; then
    PERF_RESULTS=$tmp/server.jsonl timed server-idle-rss cargo test --locked -q --manifest-path server/Cargo.toml \
      -p photolib-server --test photolibd photolibd_without_ml
  fi
  local benches=()
  measures ingest-throughput && benches+=(ingest_throughput)
  measures initial-sync-100k && benches+=(initial_sync)
  if ((${#benches[@]})); then
    PERF_RESULTS=$tmp/server.jsonl timed "${benches[*]}" cargo test --locked -q --release \
      --manifest-path server/Cargo.toml -p photolib-server --test renditions --test sync -- --ignored "${benches[@]}"
  fi
  if measures ocr-read; then
    PERF_RESULTS=$tmp/server.jsonl timed ocr-read cargo test --locked -q --release --manifest-path server/Cargo.toml \
      -p photolib-ml --test ocr -- --ignored ocr_read
  fi
  if [[ $target == headless && ( -z $tests || ,$tests, == *,sphere-video,* ) ]]; then
    # A twin of the corpus' 4K 360° sample: 3,840 × 1,920 H.264 at 30 fps, its frame number modulo 8 burnt in as
    # the grey of a block 56° below the equator, where the benchmark's view looks.
    timed sphere.mp4 "$ffmpeg/ffmpeg" -nostdin -v error -f lavfi -i testsrc=s=960x480:r=30:d=26 \
      -f lavfi -i 'color=s=240x120:r=30:d=26,format=gray,geq=lum=36*mod(N\,8)' \
      -filter_complex '[0]scale=3840:1920[s];[s][1]overlay=1800:1497,scale=out_color_matrix=bt709' \
      -colorspace bt709 -pix_fmt yuv420p -c:v libopenh264 -b:v 20M -movflags +faststart "$PERF_FIXTURES/sphere.mp4"
  fi
  if [[ -z $tests || ,$tests, == *,server-tiles,* ]]; then
    # server-tiles starts photolibd, which the app builds with cargo first: here, where cargo's silence is no hang.
    timed photolibd cargo build --locked -q --manifest-path server/Cargo.toml -p photolib-server --bin photolibd
  fi
}
server_benchmarks >"$tmp/server.log" 2>&1 &
lane=$!
trap 'wait; rm -rf "$tmp"' EXIT

watch() { python3 ../tools/perf/perf.py watch "$results" "$1" --each "$2" -- ${display[@]+"${display[@]}"} "${@:3}"; }
idle() {
  # The idle CPU under the binding the app ships with, which draws no frame unless asked (a test binding draws all).
  watch idle-cpu 'result: ' flutter run --profile -d "$device" -t benchmark/idle_cpu.dart \
    --dart-define=PERF_TARGET="$target"
}
drive() {
  # A fixture's deadline starts again at each test of perf_test.dart, which the test runner prints as `mm:ss +n: name`,
  # a lap of the watch.
  local test='^\d+:\d+ \+\d+(?: ~\d+)?(?: -\d+)?: (?P<lap>.+)'
  watch perf_test.dart "$test" flutter drive --profile -d "$device" \
    --driver test_driver/integration_test.dart --target benchmark/perf_test.dart --dart-define=PERF_TARGET="$target" \
    --dart-define=PERF_FFMPEG="$ffmpeg" --dart-define=PERF_BUDGETS="$(cd .. && pwd)/tools/perf/budgets.json" \
    ${tests:+--dart-define=PERF_TESTS=$tests}
}
cold() {
  FLUTTER_TEST_OUTPUTS_DIR=$tmp/startup watch cold-start '' flutter run --profile --trace-startup -d "$device"
  [[ ! -f $tmp/startup/start_up_info.json ]] || python3 -c 'import json, sys; print(json.dumps({"budget": "cold-start",
    "metric": "first_frame", "target": sys.argv[2],
    "value": round(json.load(open(sys.argv[1]))["timeToFirstFrameRasterizedMicros"] / 1000, 2)}))' \
    "$tmp/startup/start_up_info.json" "$target" >>"$results"
}
cd app
if measures idle-cpu; then timed idle-cpu idle; fi
# The app's frame-timed benchmarks and its cold start measure time alone.
status=0
wait "$lane" || status=$?
cat "$tmp/server.log"
[[ ! -f $tmp/server.jsonl ]] || cat "$tmp/server.jsonl" >>"$results"
((status == 0)) || exit "$status"
if [[ $tests != none ]]; then timed perf_test.dart drive; fi
if measures cold-start; then timed cold-start cold; fi
cd ..

check+=(--expect server --expect "$target")
if [[ -n ${PERF_HISTORY:-} ]]; then
  commit=$(git rev-parse HEAD)
  [[ -z $(git status --porcelain) ]] || commit+=-dirty
  check+=(--history "$PERF_HISTORY" --commit "$commit")
fi
python3 tools/perf/perf.py "${check[@]}" || status=$?
[[ -z ${PERF_HISTORY:-} ]] || python3 tools/perf/perf.py dashboard "$PERF_HISTORY" "${PERF_HISTORY%.jsonl}.html"
echo "run.sh: the time of each step, the server's beside the app's idle CPU:"
while read -r secs step; do printf '%5d s  %s\n' "$secs" "$step"; done <"$tmp/times"
exit $status
