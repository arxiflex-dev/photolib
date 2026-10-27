#!/usr/bin/env bash
# The performance harness (tools/perf): the budgets of docs/19 §3, their enforcement, the 10% regression rule and the
# dashboard of the history per commit.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_tool python3
cd "$REPO_ROOT" || exit 1

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
PERF=tools/perf/perf.py

# The budgets, as docs/19 §3 states them, and one change synced within 200 ms (M2-14): budget, metric, target, limit.
capture python3 - <<'PY'
import json
budgets = json.load(open("tools/perf/budgets.json"))
want = {
    ("timeline-scroll", "fps", "*"): ("min", 60), ("timeline-scroll", "janky", "*"): ("max", 1),
    ("cold-start", "first_frame", "android"): ("max", 1000), ("cold-start", "first_frame", "desktop"): ("max", 600),
    ("cold-start", "first_frame", "headless"): ("max", 600), ("cold-start", "first_frame", "web"): ("max", 2500),
    ("scrub-to-month", "placeholders", "*"): ("max", 100), ("scrub-to-month", "thumbnails_local", "*"): ("max", 300),
    ("scrub-to-month", "thumbnails_lan", "*"): ("max", 600),
    ("thumbnail-endpoint", "throughput", "server"): ("min", 2000), ("thumbnail-endpoint", "p95", "server"): ("max", 20),
    ("initial-sync-100k", "standard", "*"): ("max", 15), ("initial-sync-100k", "private", "*"): ("max", 60),
    ("initial-sync-100k", "incremental", "*"): ("max", 200),
    ("semantic-search-100k", "query", "server"): ("max", 200), ("semantic-search-100k", "query", "desktop"): ("max", 200),
    ("semantic-search-100k", "query", "android"): ("max", 500), ("semantic-search-100k", "query", "ios"): ("max", 500),
    ("server-idle-rss", "rss", "server"): ("max", 150),
    ("ingest-throughput", "photos", "server"): ("min", 19),
    # docs/10 §3.7, M1-10's acceptance: at frame budget, as NFR-PERF-1 counts it.
    ("drag-select-5k", "janky", "*"): ("max", 1),
    # M1-37's acceptance: Settings' list of 5,000 device folders at frame budget.
    ("device-folders-scroll", "janky", "*"): ("max", 1),
    # docs/10 §4.1, M1-11's acceptance: the viewer's open, sharp image and tiles.
    ("viewer", "open", "*"): ("max", 150), ("viewer", "sharp_local", "*"): ("max", 250),
    ("viewer", "sharp_lan", "*"): ("max", 600), ("viewer", "tiles", "*"): ("max", 300),
    # M1-28's acceptance: the open from a cold grid, and at frame budget over a warm and a cold folder.
    ("viewer", "open_cold", "*"): ("max", 150),
    ("viewer-folder", "warm", "*"): ("max", 16), ("viewer-folder", "cold", "*"): ("max", 16),
    # M1-52's acceptance: the open's first frame has the viewer's bar; the open alone at frame budget too.
    ("viewer", "chrome", "*"): ("max", 150), ("viewer", "chrome_cold", "*"): ("max", 150),
    ("viewer-folder", "warm_open", "*"): ("max", 16), ("viewer-folder", "cold_open", "*"): ("max", 16),
    # M1-60's acceptance: the slowest frame of a swipe-down dismiss; headless, loaded, two frames until measured.
    **{("viewer-folder", f"{run}_dismiss", target): ("max", limit) for run in ["warm", "cold"]
       for target, limit in [("desktop", 16), ("headless", 33)]},
    # M1-26's acceptance: a cold and a warm folder at frame budget; docs/10 §3.4's T4 (80 ms) and T2 (10 ms).
    ("folder-scroll", "cold_janky", "*"): ("max", 1), ("folder-scroll", "warm_janky", "*"): ("max", 1),
    ("thumbnail-tile", "cold", "*"): ("max", 80), ("thumbnail-tile", "warm", "*"): ("max", 10),
    # M1-27's acceptance: no cell without an image for more than a frame after the warm-up at 1 and 3 screens a second;
    # a cold open's ThumbHashes in its first frame and its tiles within 300 ms; each tile from the disk cache within
    # 10 ms, its embedded preview within 30 ms and its exact tier within 80 ms, at either speed and in a fling.
    ("folder-scroll", "blank_1x", "*"): ("max", 1), ("folder-scroll", "blank_3x", "*"): ("max", 1),
    ("folder-open", "hashes_missing", "*"): ("max", 0), ("folder-open", "tiles_p95", "*"): ("max", 300),
    **{("tile-latency", f"{stage}_{run}", "*"): ("max", limit) for stage, limit in
       [("read", 10), ("embedded", 30), ("exact", 80)] for run in ["1x", "3x", "fling"]},
    # M1-12's acceptance: swipes between videos at frame budget, cold and warm; docs/10 §4.2's local start (500 ms).
    ("video-swipe", "cold_janky", "*"): ("max", 1), ("video-swipe", "warm_janky", "*"): ("max", 1),
    ("video-swipe", "cold_first_frame", "*"): ("max", 500), ("video-swipe", "warm_first_frame", "*"): ("max", 500),
    # docs/10 §8.2, M1-20's acceptance: idle CPU below 1 % with a 100k library open; headless 2.6 % until M2-51 (M0-60).
    ("idle-cpu", "cpu", "desktop"): ("max", 1), ("idle-cpu", "cpu", "headless"): ("max", 2.6),
    # M1-41's acceptance: the Linux app shows the corpus' 4K 360° sample under Xvfb with software GL at 30 fps,
    # projected and flat.
    ("sphere-video", "fps", "headless"): ("min", 30), ("sphere-video", "flat", "headless"): ("min", 30),
    # M2-42's acceptance: a cold screen of a local photolibd's tiles within T5's 600 ms at p95, a warm one from disk
    # within a frame; headless, loaded, 10 frames as a regression guard.
    ("server-tiles", "cold_p95", "*"): ("max", 600), ("server-tiles", "warm_blank", "desktop"): ("max", 1),
    ("server-tiles", "warm_blank", "headless"): ("max", 10),
    # M1-43's acceptance: a folder of 500 HEIC files fills within the page's frame budget in the web part.
    ("heic-web-fill", "janky", "web"): ("max", 1),
    # M2-25's acceptance: the web timeline's frames over the 1M library, in Chrome, miss 60 Hz less than 1%.
    ("timeline-scroll-web", "janky", "web"): ("max", 1),
    # M1-45's acceptance: 1M geotagged assets cluster and pan smoothly: the map's frames within 60 Hz, a query of the
    # kernel's index within a frame (headless, loaded, 25 ms), the first clusters within 5 s (headless 10 s).
    ("map-pan", "janky", "*"): ("max", 1), ("map-pan", "query_p95", "desktop"): ("max", 16),
    ("map-pan", "query_p95", "headless"): ("max", 25), ("map-pan", "open", "desktop"): ("max", 5),
    ("map-pan", "open", "headless"): ("max", 10),
}
got = {}
for name, budget in budgets["budgets"].items():
    for metric, spec in budget["metrics"].items():
        bound = "min" if "min" in spec else "max"
        limits = spec[bound] if isinstance(spec[bound], dict) else {"*": spec[bound]}
        for target, limit in limits.items():
            got[(name, metric, target)] = (bound, limit)
print("missing or different:", sorted(set(want.items()) ^ set(got.items())))
assert got == want
assert budgets["regression"] == 0.1
fixtures = set(budgets["fixtures"])
assert all(b.get("requirement") and b.get("how") and set(b.get("fixtures", [])) <= fixtures and
           (b.get("pending") or all(m.get("measured") for m in b["metrics"].values()))
           for b in budgets["budgets"].values())
measured = {(name, metric): spec["measured"] for name, budget in budgets["budgets"].items()
            for metric, spec in budget["metrics"].items() if "measured" in spec}
frames = ["desktop", "headless"]
assert measured == {("timeline-scroll", "fps"): frames, ("timeline-scroll", "janky"): frames,
                    ("cold-start", "first_frame"): [*frames, "web"], ("scrub-to-month", "placeholders"): frames,
                    ("scrub-to-month", "thumbnails_local"): ["desktop"], ("drag-select-5k", "janky"): frames,
                    ("device-folders-scroll", "janky"): frames,
                    ("folder-scroll", "cold_janky"): frames, ("folder-scroll", "warm_janky"): frames,
                    ("thumbnail-tile", "cold"): ["desktop"], ("thumbnail-tile", "warm"): ["desktop"],
                    ("folder-scroll", "blank_1x"): frames, ("folder-scroll", "blank_3x"): frames,
                    ("folder-open", "hashes_missing"): frames, ("folder-open", "tiles_p95"): ["desktop"],
                    **{("tile-latency", f"{stage}_{run}"): ["desktop"] for stage in ["read", "embedded", "exact"]
                       for run in ["1x", "3x", "fling"]},
                    ("server-idle-rss", "rss"): ["server"], ("ingest-throughput", "photos"): ["server"],
                    ("initial-sync-100k", "standard"): ["server"], ("initial-sync-100k", "incremental"): ["server"],
                    ("viewer", "open"): frames, ("viewer", "open_cold"): frames,
                    ("viewer-folder", "warm"): frames, ("viewer-folder", "cold"): frames,
                    ("viewer", "chrome"): frames, ("viewer", "chrome_cold"): frames,
                    ("viewer-folder", "warm_open"): frames, ("viewer-folder", "cold_open"): frames,
                    ("viewer-folder", "warm_dismiss"): frames, ("viewer-folder", "cold_dismiss"): frames,
                    ("video-swipe", "cold_janky"): frames, ("video-swipe", "warm_janky"): frames,
                    ("video-swipe", "cold_first_frame"): frames, ("video-swipe", "warm_first_frame"): frames,
                    ("idle-cpu", "cpu"): frames, ("sphere-video", "fps"): ["headless"],
                    ("sphere-video", "flat"): ["headless"],
                    ("server-tiles", "cold_p95"): frames, ("server-tiles", "warm_blank"): frames,
                    ("heic-web-fill", "janky"): ["web"], ("timeline-scroll-web", "janky"): ["web"],
                    ("map-pan", "janky"): frames, ("map-pan", "query_p95"): frames, ("map-pan", "open"): frames}, measured
# Every janky share is measured again over its budget and less what an idle isolate missed (ADR-0140).
janky = {(name, metric): spec.get("requires") for name, budget in budgets["budgets"].items()
         for metric, spec in budget["metrics"].items() if metric.endswith("janky")}
assert len(janky) == 10 and all(r == ["attempts"] for r in janky.values()), janky
# Ingest throughput is checked against a reference measured beside it (ADR-0121).
calibration = budgets["budgets"]["ingest-throughput"]["calibration"]
assert calibration["how"] and 0 < calibration["quiet"] < 1, calibration
assert budgets["budgets"]["drag-select-5k"]["fixtures"] == budgets["budgets"]["scrub-to-month"]["fixtures"]
assert budgets["budgets"]["viewer"]["fixtures"] == budgets["budgets"]["scrub-to-month"]["fixtures"]
assert set(budgets["budgets"]["timeline-scroll"]["fixtures"]) == fixtures
assert "M2-51" in budgets["budgets"]["idle-cpu"]["how"]
PY
expect_result "budgets.json encodes the eight budgets of docs/19 §3, the drag-select of docs/10 §3.7, the viewer of §4.1, M1-28, M1-52 and M1-60, the folder and tile budgets of M1-26 and M1-27, the video swipes of M1-12, the idle CPU of M1-20, the 4K 360° video of M1-41 and the server's tiles of M2-42, the HEIC folder of the web part of M1-43, each measured or pending a roadmap item" 0
assert_matches tools/perf/run.sh 'flutter run --profile .*-t benchmark/idle_cpu\.dart' \
  "the idle CPU is measured under the binding the app ships with"

result() { # result <budget> <metric> <target> <value> [fixture]: a janky share with its attempts, as the app records it
  local attempts=
  [[ $2 != *janky ]] || attempts=', "attempts": 1'
  printf '{"budget": "%s", "metric": "%s", "target": "%s", "value": %s, "fixture": "%s", "machine": "m1"%s}\n' \
    "$1" "$2" "$3" "$4" "${5:-}" "$attempts"
}

{
  result server-idle-rss rss server 48.5
  result ingest-throughput photos server 24.5
  result initial-sync-100k standard server 4.2
  result initial-sync-100k incremental server 9
  result cold-start first_frame desktop 420
} >"$TMP/good.jsonl"
capture python3 $PERF check "$TMP/good.jsonl"
expect_result "results within their budgets pass" 0 "server-idle-rss rss server: 48.5 MB (budget ≤ 150 MB)"

result server-idle-rss rss server 151 >"$TMP/rss.jsonl"
capture python3 $PERF check "$TMP/rss.jsonl"
expect_result "a result over a maximum fails and says by how much" 1 "FAIL server-idle-rss rss server: 151 MB (budget ≤ 150 MB)"

result timeline-scroll fps desktop 59.9 one-day-50k >"$TMP/fps.jsonl"
capture python3 $PERF check "$TMP/fps.jsonl"
expect_result "a result under a minimum fails, naming its fixture" 1 "FAIL timeline-scroll fps desktop one-day-50k: 59.9 fps (budget ≥ 60 fps)"

result cold-start first_frame desktop 601 >"$TMP/start.jsonl"
result cold-start first_frame android 601 >>"$TMP/start.jsonl"
capture python3 $PERF check "$TMP/start.jsonl"
expect_result "each target has its own limit" 1 "FAIL cold-start first_frame desktop: 601 ms (budget ≤ 600 ms)"
[[ $OUT != *"FAIL cold-start first_frame android"* ]] && ok "601 ms passes on Android" || fail "601 ms failed on Android"

# Idle CPU counts with the folder watchers running over a 100k folder, and the hourly reconcile scan's share.
result idle-cpu cpu headless 0.05 near-duplicates-100k >"$TMP/idle.jsonl"
capture python3 $PERF check "$TMP/idle.jsonl"
expect_result "an idle CPU measured without folder watches fails" 1 \
  "FAIL idle-cpu cpu headless near-duplicates-100k: 0.05 % (budget ≤ 2.6 %), measured without watches"
for target in headless desktop; do
  printf '{"budget": "idle-cpu", "metric": "cpu", "target": "%s", "value": 2.34, "fixture": "1m", "watches": 1001}\n' \
    "$target"
done >"$TMP/idle.jsonl"
capture python3 $PERF check "$TMP/idle.jsonl"
expect_result "one measured with them passes headless at the train's 2.34 % until M2-51; a desktop keeps 1 %" 1 \
  "ok   idle-cpu cpu headless 1m: 2.34 % (budget ≤ 2.6 %)" "FAIL idle-cpu cpu desktop 1m: 2.34 % (budget ≤ 1 %)"
assert_patterns assert_matches app/benchmark/idle_cpu.dart \
  'addFolder\(' "the idle CPU benchmark adds a folder to the library, which the data isolate watches" \
  'FolderIndexer\(db\)\.scan' "and times a reconcile scan of it" \
  "'watches'" "and reports the watches"

# A calibrated result: its value is checked, its raw figure and the machine's load printed beside it.
calibrated() { # calibrated <value> <raw> <load>
  printf '{"budget": "ingest-throughput", "metric": "photos", "target": "server", "value": %s, "raw": %s, "load": %s}\n' \
    "$@"
}
calibrated 19.4 18.6 51.2 >"$TMP/calibrated.jsonl"
capture python3 $PERF check "$TMP/calibrated.jsonl"
expect_result "a calibrated result passes on its calibrated figure and shows the raw one and the load average" 0 \
  "ok   ingest-throughput photos server: 19.4 photos/s/core calibrated, 18.6 raw, load average 51.2 (budget ≥ 19 photos/s/core)"
calibrated 18.9 18.9 0.4 >"$TMP/calibrated.jsonl"
capture python3 $PERF check "$TMP/calibrated.jsonl"
expect_result "a calibrated result under its budget fails" 1 \
  "FAIL ingest-throughput photos server: 18.9 photos/s/core calibrated, 18.9 raw, load average 0.4 (budget ≥ 19 photos/s/core)"
# The owner lowered the ingest budget from 20 (design commit 8e7532e): nothing may state the old figure. 2[0] keeps this
# line from matching itself.
stale=$(git grep -nIE '(^|[^0-9.–])2[0] photos/s/core|(budget of|budget ≥|meets|against|in its) 2[0](\.?[^0-9.–]|\.?$)' \
  -- docs tools server app)
[[ -z $stale ]] && ok "no file states the ingest budget the owner lowered" ||
  fail "these state the ingest budget the owner lowered: $stale"

# A janky share beside what an idle isolate of the app missed meanwhile (ADR-0140, accepted in photolib-design#533):
# that share is the machine's, so it is taken off, but the budget never rises to it.
assert_matches docs/adr/0140-jank-budgets-against-an-idle-isolate.md '^\* \*\*Status\*\*: Accepted' \
  "ADR-0140 is accepted"
jank() { # jank <value> <idle>
  printf '{"budget": "folder-scroll", "metric": "cold_janky", "target": "headless", "value": %s, "idle": %s, "attempts": 1}\n' \
    "$@" >"$TMP/jank.jsonl"
  capture python3 $PERF check "$TMP/jank.jsonl"
}
jank 1.18 0.5
expect_result "a janky share passes less what an idle isolate missed meanwhile" 0 \
  "ok   folder-scroll cold_janky headless: 0.68 % calibrated, 1.18 raw, 0.5 % missed idle (budget ≤ 1 %)"
jank 1.5 0.2
expect_result "and fails when what is left is over the budget" 1 \
  "FAIL folder-scroll cold_janky headless: 1.3 % calibrated, 1.5 raw, 0.2 % missed idle (budget ≤ 1 %)"
jank 0.3 0.8
expect_result "an idle isolate missing more leaves nothing" 0 "headless: 0 % calibrated, 0.3 raw, 0.8 % missed idle"
jank 6 3.5
expect_result "on a busy machine the budget does not rise to what an idle isolate missed" 1 \
  "FAIL folder-scroll cold_janky headless: 2.5 % calibrated, 6 raw, 3.5 % missed idle (budget ≤ 1 %)"
[[ $OUT != *raised* ]] && ok "nor says it did" || fail "it raised the budget: $OUT"

# The web timeline's frames (timeline-scroll-web, 1 %) are measured as ADR-0140 measures the app's: up to three runs of
# tools/timeline_bench.py, the least charged counting, each less what an idle app of the same page missed meanwhile.
web() { # web <value> <idle> <attempts>
  printf '{"budget": "timeline-scroll-web", "metric": "janky", "target": "web", "fixture": "1m", "value": %s, "idle": %s, "attempts": %s}\n' \
    "$@" >"$TMP/web.jsonl"
  capture python3 $PERF check "$TMP/web.jsonl"
}
web 4.4 3.9 3
expect_result "a hosted runner's 4.4 % passes on what its idle page missed too, and says it took three runs" 0 \
  "ok   timeline-scroll-web janky web 1m: 0.5 % calibrated, 4.4 raw, 3.9 % missed idle, the least janky of 3 attempts (budget ≤ 1 %), passed on a retry and the idle credit"
web 29.3 0.2 3
expect_result "a timeline that really drops frames still fails, whatever the machine" 1 \
  "FAIL timeline-scroll-web janky web 1m: 29.1 % calibrated, 29.3 raw, 0.2 % missed idle, the least janky of 3 attempts (budget ≤ 1 %)"
if python3 - <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("timeline_bench", "tools/timeline_bench.py")
bench = importlib.util.module_from_spec(spec)
spec.loader.exec_module(bench)

def runs(*samples):
    queue = list(samples)
    return lambda: queue.pop(0)

# A run within the budget stops there.
assert bench.least_janky(runs((0.4, 0.0), (9, 0)), 1) == (0.4, 0.0, 1)
# The idle page's share is taken off before the budget; the least charged of three counts, the first of equals.
assert bench.least_janky(runs((4.4, 0.1), (9.3, 0.2), (0.6, 0.1)), 1) == (0.6, 0.1, 3)
assert bench.least_janky(runs((4.4, 3.9), (9.3, 0.2)), 1) == (4.4, 3.9, 1)
# Never within the budget: three runs, the least charged.
assert bench.least_janky(runs((29.3, 0.2), (9.3, 0.2), (4.4, 0.3)), 1) == (4.4, 0.3, 3)
assert bench.charged(0.3, 0.8) == 0 and bench.charged(1.5, 0.2) == 1.3
# The janky share of a run is the worse of the drag and the fling; the idle page's is its own.
run = {"codec/drag": {"janky_pct": 0.4}, "codec/fling": {"janky_pct": 2.1}, "idle": {"janky_pct": 1.7}}
assert bench.sample(run) == (2.1, 1.7)
# An idle page that missed most of its frames says the machine cannot measure anything: no credit, so the run fails.
run["idle"]["janky_pct"] = 100
assert bench.sample({**run, "codec/drag": {"janky_pct": 100}}) == (100, 0)
assert bench.sample({**run, "idle": {"janky_pct": 10}}) == (2.1, 10)
assert bench.sample({**run, "idle": {"janky_pct": 10.1}}) == (2.1, 0)
# The result carries the machine's load, so a loaded runner shows in the log.
line = bench.result_line(2.1, 1.7, 2, 3.25)
assert line == {"budget": "timeline-scroll-web", "metric": "janky", "target": "web", "fixture": "1m", "value": 2.1,
                "idle": 1.7, "attempts": 2, "loadavg": 3.25}, line
PY
then
  ok "tools/timeline_bench.py keeps the least janky of three runs less an idle page's share, and records the load"
else
  fail "tools/timeline_bench.py measures the web timeline as ADR-0140 asks"
fi
assert_matches app/lib/features/library/timeline/benchmark.dart "results\['idle'\]" \
  "the timeline benchmark measures an idle page of the same view"

# The app measures a janky sample over its budget again, up to five times, and records how many it took: a sample that
# passes only on a retry or on the idle credit is marked so in the history and on the dashboard.
printf '{"budget": "folder-scroll", "metric": "%s", "target": "headless", "value": %s, "idle": %s, "attempts": %s}\n' \
  cold_janky 0.4 0 1 warm_janky 0.9 0.1 3 >"$TMP/marked.jsonl"
printf '{"budget": "%s", "metric": "janky", "target": "headless", "fixture": "1m", "value": %s, "idle": %s, "attempts": %s}\n' \
  timeline-scroll 1.18 0.5 1 drag-select-5k 1.5 0.6 2 >>"$TMP/marked.jsonl"
echo '{"budget": "timeline-scroll", "metric": "janky", "target": "headless", "fixture": "one-day-50k", "value": 1.6, "idle": 0.1, "attempts": 5}' \
  >>"$TMP/marked.jsonl"
capture python3 $PERF check "$TMP/marked.jsonl" --history "$TMP/marked-history.jsonl" --commit c1
expect_result "a retried or idle-credited janky sample says so" 1 \
  "ok   folder-scroll cold_janky headless: 0.4 % calibrated, 0.4 raw, 0 % missed idle (budget ≤ 1 %)"$'\n' \
  "ok   folder-scroll warm_janky headless: 0.8 % calibrated, 0.9 raw, 0.1 % missed idle, the least janky of 3 attempts (budget ≤ 1 %), passed on a retry"$'\n' \
  "ok   timeline-scroll janky headless 1m: 0.68 % calibrated, 1.18 raw, 0.5 % missed idle (budget ≤ 1 %), passed on the idle credit"$'\n' \
  "ok   drag-select-5k janky headless 1m: 0.9 % calibrated, 1.5 raw, 0.6 % missed idle, the least janky of 2 attempts (budget ≤ 1 %), passed on a retry and the idle credit"$'\n' \
  "FAIL timeline-scroll janky headless one-day-50k: 1.5 % calibrated, 1.6 raw, 0.1 % missed idle, the least janky of 5 attempts (budget ≤ 1 %)"
marks=$(python3 -c 'import json, sys; print([json.loads(l).get("passed_on") for l in open(sys.argv[1])])' \
  "$TMP/marked-history.jsonl")
[[ $marks == "[None, 'a retry', 'the idle credit', 'a retry and the idle credit', None]" ]] &&
  ok "the history marks what passed only on a retry or the idle credit" || fail "the history marks: $marks"
capture python3 $PERF dashboard "$TMP/marked-history.jsonl" "$TMP/marked.html"
page=$(cat "$TMP/marked.html" 2>/dev/null)
[[ $(grep -o '<circle[^>]*fill="#e80"' <<<"$page" | wc -l) -eq 3 && $page == *"<td>a retry and the idle credit</td>"* ]] &&
  ok "and so does the dashboard, in its chart and its table" || fail "the dashboard does not mark them: $page"
# Every janky share is measured so, video-swipe's too: one recorded without its attempts fails.
printf '{"budget": "video-swipe", "metric": "%s", "target": "headless", "value": 0}\n' cold_janky warm_janky \
  >"$TMP/bare.jsonl"
capture python3 $PERF check "$TMP/bare.jsonl"
expect_result "a janky share measured without ADR-0140's retries fails" 1 \
  "FAIL video-swipe cold_janky headless: 0 % (budget ≤ 1 %), measured without attempts"$'\n' \
  "FAIL video-swipe warm_janky headless: 0 % (budget ≤ 1 %), measured without attempts"

# A rerun: --failed writes the series that failed or are missing with each attempt's value (null where it measured
# none), and --only checks those alone, so that a rerun forced by one budget cannot fail on another; up to three
# attempts, each naming the values before it (photolib-design#749).
result folder-scroll cold_janky headless 1.5 >"$TMP/run.jsonl"
result folder-scroll warm_janky headless 0.2 >>"$TMP/run.jsonl"
capture python3 $PERF check "$TMP/run.jsonl" --failed "$TMP/failed.jsonl" --expect headless
expect_result "a failed run" 1 "FAIL folder-scroll cold_janky headless"
[[ $(sed -n 1p "$TMP/failed.jsonl") == '{"budget": "folder-scroll", "metric": "cold_janky", "target": "headless", "fixture": "", "values": [1.5]}' &&
  $(sed -n 2p "$TMP/failed.jsonl") == *'"values": [null]}' &&
  $(grep -c . "$TMP/failed.jsonl") -gt 1 && $(grep -c 'folder-scroll", "metric": "warm_janky' "$TMP/failed.jsonl") -eq 0 ]] &&
  ok "--failed lists the series that failed, then the missing ones, with their values" ||
  fail "--failed wrote: $(cat "$TMP/failed.jsonl")"
head -1 "$TMP/failed.jsonl" >"$TMP/only.jsonl"
result folder-scroll cold_janky headless 2 >"$TMP/rerun.jsonl"
result folder-scroll warm_janky headless 3 >>"$TMP/rerun.jsonl"
capture python3 $PERF check "$TMP/rerun.jsonl" --only "$TMP/only.jsonl" --failed "$TMP/failed.jsonl" --expect headless
expect_result "a second attempt that fails names the first's value" 1 \
  "FAIL folder-scroll cold_janky headless: 2 % (budget ≤ 1 %), gate attempt 2 after 1.5 %"
[[ $OUT != *warm_janky* && $(cat "$TMP/failed.jsonl") == *'"values": [1.5, 2]}' ]] &&
  ok "and checks nothing else, leaving both values to the next" ||
  fail "the rerun checked more: $OUT; failed: $(cat "$TMP/failed.jsonl")"
mv "$TMP/failed.jsonl" "$TMP/only.jsonl"
result folder-scroll cold_janky headless 0.9 >"$TMP/rerun.jsonl"
capture python3 $PERF check "$TMP/rerun.jsonl" --only "$TMP/only.jsonl" --failed "$TMP/failed.jsonl" --expect headless
expect_result "a third attempt that passes says so, with the values before it" 0 \
  "ok   folder-scroll cold_janky headless: 0.9 % (budget ≤ 1 %), gate attempt 3 after 1.5, 2 %"
[[ ! -s $TMP/failed.jsonl ]] && ok "leaving nothing to rerun" || fail "failed: $(cat "$TMP/failed.jsonl")"
result folder-scroll warm_janky headless 0.2 >"$TMP/rerun.jsonl"
capture python3 $PERF check "$TMP/rerun.jsonl" --only "$TMP/only.jsonl" --expect headless
expect_result "a rerun that did not measure what failed fails" 1 \
  "missing: folder-scroll cold_janky headless, gate attempt 3 after 1.5, 2 %"

for bad in "server-idle-rss heap server" "no-such-budget rss server" "cold-start first_frame server"; do
  read -r b m t <<<"$bad"
  result "$b" "$m" "$t" 1 >"$TMP/bad.jsonl"
  capture python3 $PERF check "$TMP/bad.jsonl"
  expect_result "a result without a budget fails: $bad" 1 "no budget for $b $m $t"
done
: >"$TMP/empty.jsonl"
capture python3 $PERF check "$TMP/empty.jsonl"
expect_result "no results prove nothing and fail" 1 "no results"

# --expect: every measurement budgets.json declares for a target must be there.
capture python3 $PERF check "$TMP/good.jsonl" --expect server
expect_result "the measurements expected on the server are there" 0
capture python3 $PERF check "$TMP/good.jsonl" --expect desktop
expect_result "a missing measurement fails" 1 "missing: timeline-scroll fps desktop 1m"

# The regression rule: worse by more than 10% than the median of the last five results of the same machine fails.
history() { # history <file> <value...>: one commit per value on machine m1
  local i=0 v
  for v in "${@:2}"; do
    i=$((i + 1))
    printf '{"commit": "c%07d", "time": "2026-10-0%dT00:00:00Z", "budget": "server-idle-rss", "metric": "rss", ' "$i" "$i"
    printf '"target": "server", "fixture": "", "machine": "m1", "value": %s}\n' "$v"
  done >"$1"
}
history "$TMP/h.jsonl" 90 40 41 42 43 44
result server-idle-rss rss server 46.3 >"$TMP/new.jsonl"
capture python3 $PERF check "$TMP/new.jsonl" --history "$TMP/h.jsonl" --commit abc1234
expect_result "10.2% over the median of the last five fails" 1 "regressed 10.2% from 42"
[[ $(wc -l <"$TMP/h.jsonl") -eq 7 ]] && grep -q '"commit": "abc1234"' "$TMP/h.jsonl" &&
  ok "the run is recorded under its commit, failed or not" || fail "the run was not recorded: $(cat "$TMP/h.jsonl")"

history "$TMP/h.jsonl" 40 41 42 43 44
result server-idle-rss rss server 46.2 >"$TMP/new.jsonl"
capture python3 $PERF check "$TMP/new.jsonl" --history "$TMP/h.jsonl" --commit abc1234
expect_result "10% over the median passes" 0

history "$TMP/h.jsonl" 40 41 42 43 44
result timeline-scroll fps desktop 70 1m >"$TMP/new.jsonl"
sed 's/"m1"/"m2"/' "$TMP/new.jsonl" >"$TMP/other.jsonl"
result timeline-scroll fps desktop 100 1m | sed 's/^{/{"commit": "c1", "time": "t", /' >>"$TMP/h.jsonl"
capture python3 $PERF check "$TMP/other.jsonl" --history "$TMP/h.jsonl" --commit abc1234
expect_result "another machine has no baseline" 0
capture python3 $PERF check "$TMP/new.jsonl" --history "$TMP/h.jsonl" --commit abc1234
expect_result "for a minimum, lower is worse" 1 "regressed 30.0% from 100"

capture python3 $PERF check "$TMP/new.jsonl" --history "$TMP/h.jsonl"
expect_result "a history needs the commit the results belong to" 2 "--commit"

# run.sh with its tools stubbed: each benchmark reports every series it measures at its limit, with the fields its
# budget requires, or over it where $BAD names it. A failed run leaves the series to rerun in $PERF_FAILED; the rerun
# measures and checks those alone.
sandbox=$TMP/run
mkdir -p "$sandbox/tools/perf" "$sandbox/tools/kernel" "$sandbox/tools/video" "$sandbox/app" "$TMP/stubs"
cp tools/perf/run.sh tools/perf/perf.py tools/perf/budgets.json "$sandbox/tools/perf/"
: >"$sandbox/tools/kernel/build.py"
echo "echo '$TMP/ffmpeg'" >"$sandbox/tools/video/ffmpeg.sh"
echo 'exec "$@"' >"$sandbox/tools/perf/keyring.sh"
cat >"$TMP/stubs/report.py" <<'PY'
import json, os, sys
budgets = json.load(open("tools/perf/budgets.json"))["budgets"]
measured, wanted = sys.argv[1], sys.argv[2:]
# A budget a `flutter run` measures alone; the drive measures the others. The apps print each result as
# `result: <json>`, the server's tests append it to $PERF_RESULTS.
alone = os.environ.get("ALONE")
server = {"server-idle-rss": "photolibd_without_ml", "ingest-throughput": "ingest_throughput",
          "initial-sync-100k": "initial_sync"}
out = open(os.environ["PERF_RESULTS"], "a") if measured == "server" else None
for name, budget in budgets.items():
    for metric, spec in budget["metrics"].items():
        for target in [measured] if measured in spec.get("measured", []) else []:
            for fixture in budget.get("fixtures", [""]):
                test = server.get(name) if target == "server" else fixture or \
                    {"video-swipe": "videos", "sphere-video": "sphere-video",
                     "server-tiles": "server-tiles"}.get(name, "folder-10k")
                skip = name != alone if alone else name in ("cold-start", "idle-cpu")
                skip = skip or (name == "map-pan") != bool(os.environ.get("MAP"))
                if skip or test not in wanted:
                    continue
                limit = spec.get("max", spec.get("min"))
                limit = limit.get(target) if isinstance(limit, dict) else limit
                bad = f"{name} {metric}" in os.environ.get("BAD", "")
                value = limit * 2 + 1 if bad and "max" in spec else 0 if bad else limit
                line = json.dumps({"budget": name, "metric": metric, "target": target, "fixture": fixture,
                                   "value": value} | dict.fromkeys(spec.get("requires", []), 1))
                out.write(line + "\n") if out else print(f"result: {line}")
PY
cat >"$TMP/stubs/cargo" <<'SH'
#!/usr/bin/env bash
echo "cargo $*" >>"$CALLS"
for arg; do [[ $prev == --out ]] && mkdir -p "$arg"; prev=$arg; done
[[ $1 != test ]] || { python3 "${0%/*}/report.py" server "$@" && sleep 1 && echo "cargo test done" >>"$CALLS"; }
SH
mkdir -p "$TMP/ffmpeg"
cat >"$TMP/ffmpeg/ffmpeg" <<'SH'
#!/usr/bin/env bash
echo "ffmpeg $*" >>"${CALLS:-/dev/null}"
: >"${*: -1}"
SH
chmod +x "$TMP/ffmpeg/ffmpeg"
cat >"$TMP/stubs/flutter" <<'SH'
#!/usr/bin/env bash
echo "flutter $*" >>"$CALLS"
if [[ $1 == drive ]]; then
  for arg; do
    case $arg in --dart-define=*) declare "${arg#--dart-define=}" ;; esac
  done
  [[ -n ${PERF_TESTS:-} ]] || PERF_TESTS="$(ls "$PERF_FIXTURES" | tr '\n' ,)folder-10k,videos,sphere-video,server-tiles"
  [[ ,$PERF_TESTS, != *,sphere-video,* || -f $PERF_FIXTURES/sphere.mp4 ]] || { echo "no sphere.mp4" && exit 1; }
  [[ $* != *benchmark/map_perf.dart* ]] || { cd .. && MAP=1 python3 "$STUBS/report.py" "$PERF_TARGET" 1m; exit; }
  cd .. && python3 "$STUBS/report.py" "$PERF_TARGET" ${PERF_TESTS//,/ }
elif [[ $* == *" -t benchmark/idle_cpu.dart "* ]]; then
  for arg; do
    case $arg in --dart-define=*) declare "${arg#--dart-define=}" ;; esac
  done
  cd .. && ALONE=idle-cpu python3 "$STUBS/report.py" "$PERF_TARGET" $(ls "$PERF_FIXTURES")
else
  mkdir -p "$FLUTTER_TEST_OUTPUTS_DIR"
  echo '{"timeToFirstFrameRasterizedMicros": 500000}' >"$FLUTTER_TEST_OUTPUTS_DIR/start_up_info.json"
fi
SH
printf '#!/usr/bin/env bash
shift
exec "$@"
' >"$TMP/stubs/xvfb-run"
chmod +x "$TMP/stubs/"*
perf_run() {
  : >"$TMP/calls.log"
  capture env -u DISPLAY -u WAYLAND_DISPLAY PATH="$TMP/stubs:$PATH" STUBS="$TMP/stubs" CALLS="$TMP/calls.log" \
    PERF_FAILED="$TMP/rerun.jsonl" "$@" bash "$sandbox/tools/perf/run.sh"
}
rm -f "$TMP/rerun.jsonl"
perf_run BAD="folder-scroll cold_janky"
expect_result "a run measures every budget, and fails on one" 1 \
  "FAIL folder-scroll cold_janky headless" "ok   ingest-throughput photos server" "ok   cold-start first_frame headless" \
  "ok   idle-cpu cpu headless 1m"
[[ $(cat "$TMP/rerun.jsonl") == '{"budget": "folder-scroll", "metric": "cold_janky", "target": "headless", "fixture": "", "values": [3]}' ]] &&
  ok "and leaves what failed to rerun" || fail "it left to rerun: $(cat "$TMP/rerun.jsonl")"
# The server's benchmarks and the 360° clip run beside the app's idle CPU, which counts CPU time, and end before the
# app's frame-timed benchmarks and its cold start.
python3 - "$TMP/calls.log" <<'PY' && ok "the server's benchmarks run beside the idle CPU, before the timed apps" ||
import sys
calls = open(sys.argv[1]).read().splitlines()
at = lambda *parts: [i for i, c in enumerate(calls) if c.startswith(parts[0]) and all(p in c for p in parts)]
server = at("cargo test done") + at("ffmpeg ")
timed = at("flutter drive") + at("flutter run", "--trace-startup")
assert at("flutter run", "idle_cpu")[0] < max(server) < min(timed), calls
PY
  fail "the run ran: $(cat "$TMP/calls.log")"
expect_result "and says how long each step took" 1 " s  fixtures" " s  server-idle-rss" " s  idle-cpu" \
  " s  perf_test.dart" " s  cold-start"
apps=$(grep -E '^flutter (drive|run) ' "$TMP/calls.log")
budgets=$(grep -o '^flutter drive .*--dart-define=PERF_BUDGETS=[^ ]*' "$TMP/calls.log" | sed 's/.*PERF_BUDGETS=//')
[[ $budgets == /*/tools/perf/budgets.json && -f $budgets ]] &&
  ok "the app gets the budgets its janky samples are measured again against" || fail "it ran: $(cat "$TMP/calls.log")"
mv "$TMP/rerun.jsonl" "$TMP/failed.jsonl"
perf_run
[[ $STATUS == 0 && $(grep -E '^flutter (drive|run) ' "$TMP/calls.log") == "$apps" ]] &&
  ok "the apps build alike from run to run, so an unchanged app is not compiled again" ||
  fail "another run built: $(grep -E '^flutter (drive|run) ' "$TMP/calls.log") after $apps"
mv "$TMP/failed.jsonl" "$TMP/rerun.jsonl"
perf_run BAD="folder-scroll warm_janky"
expect_result "the rerun measures and checks only what failed, so another budget cannot fail it" 0 \
  "ok   folder-scroll cold_janky headless: 1 % (budget ≤ 1 %), gate attempt 2 after 3 %"
[[ $(cat "$TMP/calls.log") == "flutter drive "*"--dart-define=PERF_TESTS=folder-10k" &&
  $OUT != *"folder-scroll warm_janky"* && ! -s $TMP/rerun.jsonl ]] && ok "only the app's folder benchmark ran" ||
  fail "the rerun ran: $(cat "$TMP/calls.log")"
printf '%s\n' '{"budget": "ingest-throughput", "metric": "photos", "target": "server", "fixture": ""}' \
  '{"budget": "timeline-scroll", "metric": "janky", "target": "headless", "fixture": "one-day-50k"}' \
  '{"budget": "video-swipe", "metric": "warm_janky", "target": "headless", "fixture": ""}' >"$TMP/rerun.jsonl"
perf_run
expect_result "a rerun of a server, a timeline and a video budget" 0 "ok   ingest-throughput photos server" \
  "ok   timeline-scroll janky headless one-day-50k" "ok   video-swipe warm_janky headless"
calls=$(cat "$TMP/calls.log")
[[ $calls == *"/fixtures/one-day-50k"*"cargo test "*"-- --ignored ingest_throughput"* &&
  $calls == *"PERF_FFMPEG=$TMP/ffmpeg "*"PERF_TESTS=one-day-50k,videos"* &&
  $calls != *"photolibd"* && $calls != *"--out "*"/1m"* && $calls != *"flutter run"* ]] &&
  ok "builds that fixture alone and runs those benchmarks alone" || fail "the rerun ran: $calls"
echo '{"budget": "sphere-video", "metric": "fps", "target": "headless", "fixture": ""}' >"$TMP/rerun.jsonl"
perf_run
expect_result "a rerun of the 360° video" 0 "ok   sphere-video fps headless"
[[ $(cat "$TMP/calls.log") == "ffmpeg "*"/sphere.mp4"$'\n'"flutter drive "*"--dart-define=PERF_TESTS=sphere-video" ]] &&
  ok "makes its clip and runs its benchmark alone" || fail "the rerun ran: $(cat "$TMP/calls.log")"
echo '{"budget": "server-tiles", "metric": "warm_blank", "target": "headless", "fixture": ""}' >"$TMP/rerun.jsonl"
perf_run
expect_result "a rerun of the server's tiles" 0 "ok   server-tiles warm_blank headless"
calls=$(cat "$TMP/calls.log")
[[ $calls == *"cargo build "*"--bin photolibd"*"flutter drive "*"--dart-define=PERF_TESTS=server-tiles" ]] &&
  ok "builds photolibd before the app, whose own build of it goes unheard, and runs its benchmark alone" ||
  fail "the rerun ran: $calls"
echo '{"budget": "idle-cpu", "metric": "cpu", "target": "headless", "fixture": "1m"}' >"$TMP/rerun.jsonl"
perf_run
expect_result "a rerun of the idle CPU" 0 "ok   idle-cpu cpu headless 1m"
calls=$(cat "$TMP/calls.log")
[[ $calls == *"--out "*"/fixtures/1m"*"flutter run "*"-t benchmark/idle_cpu.dart"* && $calls != *"cargo test"* &&
  $calls != *"near-duplicates-100k"* && $calls != *"flutter drive"* && $calls != *"--trace-startup"* &&
  $OUT != *near-duplicates-100k* ]] && ok "builds that fixture alone and runs the idle CPU alone" ||
  fail "the rerun ran: $calls"
# A rerun that dies before its check (here the kernel's build) leaves what it was to measure to the gate's next attempt,
# which would otherwise measure every series again and could fail one that had passed.
echo '{"budget": "folder-scroll", "metric": "cold_janky", "target": "headless", "fixture": "", "values": [3]}' \
  >"$TMP/rerun.jsonl"
cp "$TMP/rerun.jsonl" "$TMP/only.jsonl"
echo 'raise SystemExit(1)' >"$sandbox/tools/kernel/build.py"
perf_run
: >"$sandbox/tools/kernel/build.py"
[[ $STATUS != 0 ]] && cmp -s "$TMP/rerun.jsonl" "$TMP/only.jsonl" && ok "a rerun that dies early keeps what failed" ||
  fail "a rerun that died left: $(cat "$TMP/rerun.jsonl" 2>/dev/null)"
# The dashboard: one chart and table per series, every commit in order, nothing loaded from anywhere.
history "$TMP/h.jsonl" 40 41 39
sed -i '3s/"c0000003"/"0123456789abcdef0123456789abcdef01234567-dirty"/' "$TMP/h.jsonl"
capture python3 $PERF dashboard "$TMP/h.jsonl" "$TMP/perf.html"
expect_result "the dashboard renders" 0
page=$(cat "$TMP/perf.html" 2>/dev/null)
[[ $page == *"server-idle-rss"*"rss"*"server"*"m1"* ]] && ok "the dashboard names each series and its machine" ||
  fail "series missing from the dashboard"
[[ $page == *"c0000001"*"40"*"c0000002"*"41"*"0123456789ab-dirty"*"39"* ]] && ok "it lists the history per commit, in order" ||
  fail "commits missing from the dashboard"
[[ $(grep -o '<circle' <<<"$page" | wc -l) -eq 3 && $page == *"budget ≤ 150 MB"* ]] &&
  ok "it charts one point per commit against the budget" || fail "chart missing its points or budget"
[[ $page != *"<script"* && $page != *"src="* && $page != *"@import"* ]] && ok "the dashboard loads nothing" ||
  fail "the dashboard loads resources"

# Instruction counts (Callgrind, tools/perf/instructions.sh): a benchmark that takes more than 10% more instructions
# than on the base fails, unless the pull request accepts it with a `perf-accept: <reason>` line.
counts() { # counts <file> <bench=count>...
  local pair
  for pair in "${@:2}"; do printf '{"bench": "%s", "instructions": %s}\n' "${pair%=*}" "${pair#*=}"; done >"$1"
}
counts "$TMP/base.jsonl" "kernel call=1000" "kernel decrypt=2000000" "server gone=5" "server zero=0"
counts "$TMP/branch.jsonl" "kernel call=1100" "kernel decrypt=1500000" "server new=7" "server zero=9"
capture python3 $PERF instructions "$TMP/base.jsonl" "$TMP/branch.jsonl"
expect_result "10% more instructions pass, and the table lists the base and the branch" 0 \
  "| Benchmark | Base | Branch | Change |" "| kernel call | 1,000 | 1,100 | +10.0% |" \
  "| kernel decrypt | 2,000,000 | 1,500,000 | -25.0% |" "| server new | — | 7 | new |" "| server gone | 5 | — | removed |" \
  "| server zero | — | 9 | new |"

counts "$TMP/branch.jsonl" "kernel call=1101" "kernel decrypt=2000000"
capture python3 $PERF instructions "$TMP/base.jsonl" "$TMP/branch.jsonl"
expect_result "more than 10% more instructions fail" 1 "| kernel call | 1,000 | 1,101 | +10.1% |" \
  "kernel call: 10.1% more instructions than the base"

printf 'perf-accept:  \nperf-accepted: no\n' >"$TMP/pull-request.txt"
capture python3 $PERF instructions "$TMP/base.jsonl" "$TMP/branch.jsonl" --accept "$TMP/pull-request.txt"
expect_result "a perf-accept line without a reason accepts nothing" 1 "10.1% more instructions"

counts "$TMP/branch.jsonl" "kernel call=0"
capture python3 $PERF instructions "$TMP/base.jsonl" "$TMP/branch.jsonl"
expect_result "a benchmark that counted nothing fails" 1 "kernel call counted no instructions"
: >"$TMP/branch.jsonl"
capture python3 $PERF instructions "$TMP/base.jsonl" "$TMP/branch.jsonl"
expect_result "no benchmarks on the branch fail" 1 "no instruction counts"

# instructions.sh end to end, with cargo and valgrind stubbed: each checkout's benchmark counts what its kernel/count
# says, the base is the merge base with origin/dev, and a commit or $PR_BODY may accept a regression.
repo=$TMP/repo
mkdir -p "$repo/tools/perf" "$repo/kernel/benches" "$TMP/bin"
cp tools/perf/instructions.sh tools/perf/perf.py tools/perf/budgets.json "$repo/tools/perf/"
: >"$repo/kernel/benches/instructions.rs"
# Like cargo, which names a workspace's crates by their path within it, the stub takes the build in its target
# directory as fresh unless the checkout's source is newer; it reports the package's binaries too, after the bench.
cat >"$TMP/bin/cargo" <<'SH'
#!/usr/bin/env bash
exe=$CARGO_TARGET_DIR/release/bench
if [[ ! -f $exe || count -nt $exe ]]; then
  mkdir -p "${exe%/*}" && cp count "${exe%/*}/count"
  printf '#!/bin/sh\n[ "$1" = --list ] && echo call\n' >"$exe" && chmod +x "$exe"
fi
echo "{\"target\":{\"src_path\":\"$PWD/benches/instructions.rs\"},\"executable\":\"$exe\"}"
echo "{\"target\":{\"src_path\":\"$PWD/src/main.rs\"},\"executable\":\"$PWD/photolibd\"}"
SH
cat >"$TMP/bin/valgrind" <<'SH'
#!/usr/bin/env bash
for arg; do [[ $arg == --callgrind-out-file=* ]] && out=${arg#*=}; done
exe=${*: -2:1}
echo "totals: $(cat "${exe%/*}/count")" >"$out"
SH
chmod +x "$TMP/bin/cargo" "$TMP/bin/valgrind"
commit() { # commit <count> <message>
  echo "$1" >"$repo/kernel/count"
  git -C "$repo" add -A && git -C "$repo" -c user.name=t -c user.email=t@t commit -q --allow-empty -m "$2"
}
git -C "$repo" init -q && commit 1000 "feat: base" && git -C "$repo" update-ref refs/remotes/origin/dev HEAD
commit 1200 "perf: slower"
instructions() {
  capture env PATH="$TMP/bin:$PATH" PHOTOLIB_CACHE="$TMP/cache" CARGO_TARGET_DIR="$TMP/target" \
    PERF_REPORT="$TMP/report.md" "$@" bash "$repo/tools/perf/instructions.sh"
}
instructions
expect_result "instructions.sh fails 20% more instructions than the merge base, built apart from the branch" 1 \
  "| kernel call | 1,000 | 1,200 | +20.0% |" "kernel call: 20.0% more instructions than the base"
instructions PR_BODY=$'Summary\nperf-accept: the pull request says why'
expect_result "a perf-accept line in \$PR_BODY passes" 0 "Accepted (perf-accept): the pull request says why"
commit 1200 $'perf: still slower\n\nperf-accept: a commit says why'
instructions
expect_result "a perf-accept line in a commit since the base passes" 0 "Accepted (perf-accept): a commit says why"
[[ $(cat "$TMP/report.md") == *"| kernel call | 1,000 | 1,200 | +20.0% |"*"a commit says why"* ]] &&
  ok "\$PERF_REPORT gets the table and why" || fail "\$PERF_REPORT lacks the table or the reason"
# The base's checkout is built and run: only from a private directory of this user.
ln -s "$TMP/cache" "$TMP/link"
instructions PHOTOLIB_CACHE="$TMP/link"
expect_result "a cache that is a symlink is refused" 1 "not a private directory"

# perf.py watch (photolib-design#529): a benchmark app that writes nothing for PERF_SILENCE seconds, or reaches no
# fixture (a line matching --each) within PERF_DEADLINE seconds, is killed with its session; its budget fails as hung.
# Its limits count wall time, which quiet.sh's stops run out: each case runs through thawed (photolib-design#648).
watch() { thawed watched "$@"; }
# A stop before thawed's ticker first ticks and past its last is seen too: on a loaded machine the ticker missed one,
# and the train judged the stopped deadline case (photolib-design#424).
stops_once() { echo run >>"$TMP/runs"; (($(wc -l <"$TMP/runs") > 1)) || kill -STOP 0; }
: >"$TMP/runs"
set -m
(thawed stops_once) &
stopped=$!
set +m
(sleep 6 && kill -CONT -- -"$stopped") &
wait "$stopped"
(($(wc -l <"$TMP/runs") == 2)) && ok "a case stopped as it starts runs again" ||
  fail "it ran $(wc -l <"$TMP/runs") time(s)"
watched() { # watched <silence> <deadline> <script> [--each <regex>]: the app is bash -c <script>
  : >"$TMP/watched.jsonl"
  local started=$SECONDS
  capture env PERF_SILENCE="$1" PERF_DEADLINE="$2" python3 $PERF watch "$TMP/watched.jsonl" idle-cpu "${@:4}" -- \
    bash -c "$3"
  TOOK=$((SECONDS - started))
}
alive() { kill -0 "$(cat "$TMP/$1.pid")" 2>/dev/null; }
RESULT='{"budget": "idle-cpu", "metric": "cpu", "target": "headless", "fixture": "1m", "value": 0.5, "watches": 1}'
deadline() {
  watch 60 2 "echo 'flutter: result: $RESULT'; while :; do echo tick; sleep 0.2; done" --each '^fixture'
  expect_result "an app that reaches no fixture within its deadline is killed, however much it writes" 0 \
    "no fixture within 2 s"
  ((TOOK < 10)) && ok "within seconds of its deadline" || fail "after $TOOK s"
}
deadline
# Stopped by quiet.sh (lib.sh's frozen) while the app runs on in its session, perf.py finds the deadline run out when
# it resumes: the case runs again, and that run is judged (photolib-design#648).
frozen deadline
# 124, as timeout(1) exits, which the gate reports as no timing (photolib-design#536). A loaded machine that stalls
# the watch past its deadline makes 0 min 0.1.
capture python3 $PERF check "$TMP/watched.jsonl"
expect_result "its budget fails as hung, and a result it printed before is kept" 124 \
  "FAIL idle-cpu: hung after 0" " min (tick)" "ok   idle-cpu cpu headless 1m: 0.5 %"
capture python3 $PERF check "$TMP/watched.jsonl" --only "$TMP/only.jsonl"
expect_result "a rerun reports a hang, whatever it reruns" 124 "FAIL idle-cpu: hung after 0" " min (tick)"
echo '{"budget": "idle-cpu", "error": "idle_cpu.dart failed: Bad state: no replica"}' >"$TMP/error.jsonl"
capture python3 $PERF check "$TMP/error.jsonl" --only "$TMP/only.jsonl"
expect_result "an app's error fails its budget, whatever a rerun reruns" 1 \
  "FAIL idle-cpu: idle_cpu.dart failed: Bad state: no replica"

# An app that fails, as a drive with a failed test does, fails its budget with its status and last line; the run goes
# on and checks what it measured.
watch 60 3 "for i in 1 2 3 4 5; do echo fixture \$i; sleep 1; done; exit 3" --each '^fixture'
expect_result "each fixture has its deadline" 0 "fixture 5"
capture python3 $PERF check "$TMP/watched.jsonl"
expect_result "an app that failed fails its budget, naming its status and last line" 1 \
  "FAIL idle-cpu: exited 3 (fixture 5)"
watch 60 60 'echo "00:00 +0: (setUpAll)"; echo "00:00 +1: 1m"; sleep 2; echo "00:02 +1: 1m"
  echo "00:02 +2: 10k"; sleep 1' --each '^\d+:\d+ \+\d+: (?P<lap>.+)'
expect_result "it says how long the app and each of its laps took, from a lap's first line to the next lap's" 0 \
  "perf.py: idle-cpu took 3 s: (setUpAll) 0 s, 1m 2 s, 10k 1 s"

# Its child outlives the silence: perf.py ends at the app's end, before the child's or the silence, however loaded
# the machine; never judged by wall time (photolib-design#666).
watch 60 60 "echo done; (sleep 600 & echo \$! >>$TMP/child.pid)"
expect_result "an app that ends is done, though a process it left holds its output open" 0 "done"
kill -0 "$(tail -n1 "$TMP/child.pid")" 2>/dev/null && [[ $OUT != *"no output"* ]] &&
  ok "at once, its child still running" || fail "only once its child ended or the silence ran out: $OUT"
[[ ! -s $TMP/watched.jsonl ]] && ok "an app that keeps its deadlines and succeeds records nothing" ||
  fail "$(cat "$TMP/watched.jsonl")"
xargs kill <"$TMP/child.pid" 2>/dev/null

# run.sh end to end, with stand-ins for the benchmark apps, the server's tests and the tools. With $HANG the drive and
# the idle CPU app print a result each and then sleep, silent: the run keeps those results, goes on to the cold start
# and fails the budgets that hung only. Without, the drive fails a test after its first and exits 1, as the
# integration_test driver does, and the idle CPU app hits an error it cannot recover from, prints it as its result and
# exits 1, which flutter run takes for an end like any other (photolib-design#536).
IDLE='result: {"budget": "idle-cpu", "metric": "cpu", "target": "headless", "fixture": "1m", "value": 0.2,'
IDLE+=' "watches": 1}'
DRIVE='result: {"budget": "timeline-scroll", "metric": "fps", "target": "headless", "fixture": "1m", "value": 120}'
repo=$TMP/run
mkdir -p "$repo/tools/perf" "$repo/tools/kernel" "$repo/tools/video" "$repo/app" "$TMP/runbin"
cp tools/perf/run.sh tools/perf/perf.py tools/perf/budgets.json "$repo/tools/perf/"
: >"$repo/tools/kernel/build.py"
echo "echo '$TMP/ffmpeg'" >"$repo/tools/video/ffmpeg.sh"
cat >"$TMP/runbin/cargo" <<'SH'
#!/usr/bin/env bash
[[ -z ${PERF_RESULTS:-} ]] ||
  echo '{"budget": "server-idle-rss", "metric": "rss", "target": "server", "value": 50}' >>"$PERF_RESULTS"
SH
cat >"$TMP/runbin/flutter" <<SH
#!/usr/bin/env bash
case "\$*" in
  drive*) echo '$DRIVE'
    [[ -n \$HANG ]] || { echo 'All tests passed but one.'; exit 1; }
    sleep 300 ;;
  *idle_cpu.dart*) [[ -n \$HANG ]] ||
    { echo 'result: {"budget": "idle-cpu", "error": "idle_cpu.dart failed: no replica"}'; exit 0; }
    echo '$IDLE'; echo \$\$ >$TMP/app.pid; sleep 300 & echo \$! >$TMP/child.pid; wait ;;
  *--trace-startup*) mkdir -p "\$FLUTTER_TEST_OUTPUTS_DIR"
    echo '{"timeToFirstFrameRasterizedMicros": 129000}' >"\$FLUTTER_TEST_OUTPUTS_DIR/start_up_info.json" ;;
esac
SH
printf '#!/usr/bin/env bash\nshift\nexec "$@"\n' >"$TMP/runbin/xvfb-run"
chmod +x "$TMP/runbin"/*
stand_ins() {
  local started=$SECONDS
  capture env -u DISPLAY -u WAYLAND_DISPLAY PATH="$TMP/runbin:$PATH" PERF_SILENCE=3 PERF_TARGET=headless "$@" \
    bash "$repo/tools/perf/run.sh"
  TOOK=$((SECONDS - started))
}
thawed stand_ins HANG=1
expect_result "run.sh fails the budgets of apps that hung, naming their last lines, and keeps what they measured" 124 \
  "perf.py: perf_test.dart: no output for 3 s" "FAIL perf_test.dart: hung after 0" \
  "perf.py: idle-cpu: no output for 3 s" "FAIL idle-cpu: hung after 0" " min ($IDLE)" \
  "ok   idle-cpu cpu headless 1m: 0.2 %" "ok   timeline-scroll fps headless 1m: 120 fps" \
  "ok   cold-start first_frame headless: 129 ms" "perf.py: missing: idle-cpu cpu headless near-duplicates-100k"
[[ $OUT != *Traceback* ]] && ok "run.sh's check takes a hung app in its stride" || fail "the check crashed: $OUT"
((TOOK < 30)) && ! alive app && ! alive child && ok "within seconds, killing its session's processes" ||
  fail "after $TOOK s, app $(alive app && echo alive) child $(alive child && echo alive)"
# Nothing hangs here: a silence of 60 s outlasts a loaded machine's stall of an app that is ending.
thawed stand_ins HANG= PERF_SILENCE=60
expect_result "run.sh fails the idle CPU on its app's error, naming it, and the drive on its failed test" 1 \
  "FAIL idle-cpu: idle_cpu.dart failed: no replica" "perf.py: missing: idle-cpu cpu headless 1m" \
  "FAIL perf_test.dart: exited 1 (All tests passed but one.)" "ok   timeline-scroll fps headless 1m: 120 fps" \
  "ok   cold-start first_frame headless: 129 ms"
for app in perf_test idle_cpu; do
  assert_matches "app/benchmark/$app.dart" "'result: " "the app prints each result once it has it"
done
assert_matches app/benchmark/idle_cpu.dart "'error': " "the idle CPU app reports an error it cannot recover from"
apps=$(grep -E 'flutter (run|drive)' tools/perf/run.sh)
[[ -n $apps ]] && ! grep -qvE '(^| )watch ' <<<"$apps" && ok "run.sh runs every benchmark app under the watch" ||
  fail "an app runs unwatched in run.sh: $apps"

# ADR-0048 as the owner answered it: the budgets (#344), then the perf-accept line and the table as made (#449).
assert_prose docs/adr/0048-performance-harness.md \
  '\* \*\*Status\*\*: Accepted — 2026-10-17\. [^*]*photolib-design#344[^*]*.perf-accept:.[^*]*photolib-design#449' \
  "is Accepted, recording the owner's answers (#344, #449)"
assert_matches docs/adr/README.md '\(0048-performance-harness\.md\) \| [^|]* \| Accepted \([^|]*2026-10-20\)' \
  "the index lists ADR-0048 as Accepted with the answer of 2026-10-20"

# Without a session bus the Linux app's store would wait for a passphrase (ADR-0154), so its runs get a Secret Service
# of their own: a throwaway, unlocked GNOME Keyring, gone after.
assert_prose tools/perf/run.sh 'DBUS_SESSION_BUS_ADDRESS[^;]*keyring\.sh' "the app runs in a keyring of its own without a session bus"
if [[ $(uname) == Linux ]] && command -v dbus-run-session gnome-keyring-daemon dbus-send >/dev/null; then
  # Into a file under a timeout: a process left holding the output would make a pipe wait for it forever. Thawed, as
  # a stop runs the timeout out.
  keyring() {
    # shellcheck disable=SC2016 # expanded inside keyring.sh's session
    timeout 60 bash tools/perf/keyring.sh sh -c 'echo "data $XDG_DATA_HOME"; dbus-send --session --print-reply \
      --dest=org.freedesktop.secrets /org/freedesktop/secrets/aliases/default org.freedesktop.DBus.Properties.Get \
      string:org.freedesktop.Secret.Collection string:Locked' >"$TMP/keyring.out" 2>&1
    # shellcheck disable=SC2034 # read by expect_result
    STATUS=$? OUT=$(<"$TMP/keyring.out")
  }
  thawed keyring
  expect_result "keyring.sh runs a command with an unlocked default keyring on the session bus" 0 "boolean false"
  data=$(sed -n 's/^data //p' <<<"$OUT")
  [[ -n $data && ! -e $data ]] && ok "and deletes its keyring and data after" || fail "keyring.sh left '$data'"
  left=()
  [[ -z $data ]] || mapfile -t left < <(grep -lzx "XDG_DATA_HOME=$data" /proc/[0-9]*/environ 2>/dev/null | cut -d/ -f3)
  if [[ ${#left[@]} -eq 0 ]]; then
    ok "and leaves no process running"
  else
    fail "keyring.sh left running: $(ps -o pid=,args= -p "${left[*]}")"
    kill "${left[@]}"
  fi
else
  echo "skip: not Linux, or no dbus-run-session, gnome-keyring-daemon or dbus-send to run tools/perf/keyring.sh with"
fi

# ADR-0121 as the owner kept it (#477): the reference beside each sample, the app's wall-clock budgets not by it.
ADR=docs/adr/0121-calibrated-throughput-budgets.md
assert_prose "$ADR" '\* \*\*Status\*\*: Accepted — 2026-10-20\. The owner kept both decisions [^*]*photolib-design#477' \
  "is Accepted, recording the owner's answer (#477)"
assert_matches docs/adr/README.md \
  '\(0121-calibrated-throughput-budgets\.md\) \| [^|]* \| Accepted \(owner confirmed, 2026-10-20; #520.s choice kept, 2026-10-23\)' \
  "the index lists ADR-0121 as Accepted, #520's choice kept"
# #520's choice as the owner kept it (#672): ADR-0098, an alternative #477 cited, stays Proposed for its own question.
assert_prose "$ADR" '\* \*\*Status\*\*: [^*]*photolib-design#672[^*]*ADR-0098[^*]*stays Proposed[^*]*photolib-design#383' \
  "records that ADR-0098 stays Proposed for its own question (#672)"
assert_prose docs/adr/0098-frame-budgets-against-an-idle-isolate.md \
  '\* \*\*Status\*\*: \*\*Proposed — owner to confirm\*\* \(photolib-design#383\)' "ADR-0098 stays Proposed (#383)"
assert_prose "$ADR" '\(0140-[a-z-]*\.md\), accepted on its own answer[^.]*idle isolate' \
  "leaves ADR-0140's idle-isolate jank check to its own answer"
assert_matches tools/perf/budgets.json '"quiet": 0\.0292' "quiet is 29.2 ms, the reference machine's"

# ADR-0122 as the owner answered it (#479): no option that changes a rendition, adds a dependency or changes the fixture.
ADR=docs/adr/0122-faster-image-ingest.md
assert_prose "$ADR" '\* \*\*Status\*\*: Accepted — 2026-10-20\. The owner took none of the four [^*]*photolib-design#479' \
  "is Accepted, recording the owner's answer (#479)"
assert_matches docs/adr/README.md '\(0122-faster-image-ingest\.md\) \| [^|]* \| Accepted \(owner confirmed, 2026-10-20\)' \
  "the index lists ADR-0122 as Accepted"
assert_prose "$ADR" '4:2:0 fixture[^.]*baseline[^.]*M10-02' "revisits the 4:2:0 fixture and its baseline with M10-02"
RENDER=server/crates/photolib-media/src/render.rs
assert_prose "$RENDER" 'ThumbHash of .image., from at most 100 × 100' "the ThumbHash comes from a resize to 100 × 100"
check "no resize picks a kernel of its own, such as Linear" bash -c "! grep -q '\"kernel\"' $RENDER"
check "no SIMD resampler" bash -c "! grep -q fast_image_resize server/Cargo.lock"
check "the benchmark's photos stay at libvips' Q92 4:4:4" bash -c \
  "grep -q '\"Q\", 92' server/crates/photolib-server/tests/renditions.rs && ! grep -q subsample server/crates/photolib-server/tests/renditions.rs"

# ADR-0212 as the owner answered it (photolib-design#608): the full fixture set every round, a timing again only over
# budget.
ADR=docs/adr/0212-perf-part-in-half-the-time.md
assert_prose "$ADR" '\* \*\*Status\*\*: Accepted — 2026-10-21\. The owner confirmed [^*]*photolib-design#608' \
  "is Accepted, recording the owner's confirmation (#608)"
assert_matches docs/adr/README.md '\(0212-perf-part-in-half-the-time\.md\) \| [^|]* \| Accepted \(owner confirmed' \
  "the index lists ADR-0212 as Accepted"

finish
