# Performance budgets

`tools/perf/budgets.json` encodes every budget of quality and testing §3, the drag-select of
client app §3.7, the viewer's of §4.1, the thumbnail tiers of §3.4 and the swipes
between videos of §4.2: its limit per
target, what measures it, and for a budget whose code does not exist yet, the roadmap item that will measure it.
`tools/tests/test_perf.sh` pins it to the design. The gate's `perf` part runs `tools/perf/instructions.sh`, which
compares the hot paths' [instruction counts](#instruction-counts) with the base, and `tools/perf/run.sh`, which
measures what the machine can measure and checks it with `tools/perf/perf.py`; the decisions are in
[ADR-0048](../adr/0048-performance-harness.md).

```sh
bash tools/perf/instructions.sh                           # the hot paths' instructions, base against this checkout
bash tools/perf/run.sh                                    # the budgets, on this machine
PERF_HISTORY=~/perf/history.jsonl bash tools/perf/run.sh  # a reference machine: also regressions and the dashboard
```

`run.sh` generates the [synthlib](https://github.com/arxiflex-dev/photolib/blob/main/tools/synthlib/README.md)
fixtures (1M assets, a 300k timeline, 100k near-duplicates, 100k with one timestamp, 50k on one day, 5k folders,
10k albums), measures photolibd's idle RSS without ML, its ingest throughput (the kernel's metadata, `thumb_s`,
`thumb_m` and ThumbHash of 12 MP JPEGs, in CPU time on the fastest cores, [calibrated](#calibration)) and the sync of a
100k-asset library and of one change through the Connect stack, drives `app/benchmark/perf_test.dart` in profile mode
over every fixture and traces the app's cold start. A timeline fixture becomes the device index, whose timeline is
scrolled for 5 s, jumped to eight months (until the first frame and until every visible cell shows its thumbnail),
opens the viewer from a cell (until its first frame, with the grid's thumbnails in memory and without) and is
drag-selected until 5,000 items are; folders and
albums scroll a stand-in grid (M1-15). A folder of 10,000 12 MP JPEGs with EXIF thumbnails is scrolled through the
desktop thumbnail pipeline with an empty disk cache, at 1 and 3 screens a second and in a fling, opens the viewer and
turns a page there, warm and, cold, at its far end (the slowest frame), then is warmed (ADR-0114), opened anew and
scrolled the same ways: each tile's stages are printed at p50 and p95 (`tile-latency:`), with the cold open
(`cold-open:`) and the frames any visible cell went without an image (`blank-cells:`); a tile is timed from the original
and from the disk cache (`thumbnail-tile:`). Stage latencies and the open's tiles are checked on `desktop` and printed
on `headless`, whose shared cores time decodes as they will. Sets of eight 1080p videos, made with the pinned
FFmpeg, open in the viewer from the timeline and are swiped through, cold (a set shown the first time) and warm (a set
again), retried as other janky samples are: janky frames from the open or a swipe until the viewer rests, counting on
`desktop` the wait before a frame's build, where a player made on the UI thread would show, and the median time from a
swipe's start to the first frame with the next video's player in it (printed as `video-swipe:`). On `headless`, a 4K
360° video plays projected full window, then flat, its frame number burnt in where the view looks, and x11grab reads
that number to count the frames the screen shows a second over 4 s windows, while the test binding draws only the
frames the engine asks for, as the app does (`sphere-video:`). `app/benchmark/server_tiles.dart` starts photolibd
(which `run.sh` builds first) with an external library of 96 photos and opens a screen of their server thumbnails (T5)
cold, then warm from the disk cache, the best of three (`server-tiles:`, with each tile's stages). `heic-web-fill` is
the one budget of the `web` part: `app/test/features/library/timeline/web_test.dart` fills a folder of 500 HEIC files
(the AVC twins of `tools/corpus/avc_twins.py`) through the thumbnail worker in Chrome under `withinFrameBudget`, which
`run.sh` does not run. A timing over its
budget is measured again, the best counting: a scrub and an open up to three times, a 360° window up to five
([ADR-0212](../adr/0212-perf-part-in-half-the-time.md)). Beside the server's
benchmarks, `app/benchmark/idle_cpu.dart` runs the whole app over the 1M and a 100k fixture
with `flutter run`, as a test binding draws frames all the time, and takes the CPU time it uses at rest (M1-20) with a
folder of 100k files in the library, scanned before the fixture loads, whose 1,001 directories the data isolate
watches, adding a reconcile scan's CPU time spread over its hour; a result without `watches` fails. An error, or a
fixture not done in 8 minutes, ends it with an `error` result naming it; in `perf_test.dart` it ends its test, and
nothing of the test runs on into the next (`app/benchmark/bounded.dart`). The app's frame-timed benchmarks and its cold
start then run alone. The run ends with the time each step took (`run.sh:`); [run time](#run-time) has the figures.
With `PERF_FAILED=<file>` (the gate's), a failed run writes the series that failed there with their values, and a run
that finds them measures and checks those alone, naming the values before (`gate attempt 2 after 25 ms`): the gate
measures a failed budget up to three times, and a series passes when any attempt meets its budget
(photolib-design#749).

Each benchmark app runs under `perf.py watch`, which records each result the app prints as `result: <json>` as it
comes: one that writes nothing for 5 min (`PERF_SILENCE` seconds) or reaches no fixture within 10 min (`PERF_DEADLINE`:
three times the slowest fixture here, folder-10k's 2.6 min, at least 10 min) is killed with its session, keeping what
it measured, its budget fails as `FAIL <budget>: hung after N min (<last line>)`, the run goes on and exits 124, which
the gate reports as no timing. An app's error is a result that names it (`error`) and fails its budget, as does an
app that exits non-zero (`exited N (<last line>)`), the run going on. The watch prints how long the app and each of its
tests took (`perf.py: perf_test.dart took …`).

## Run time

The merge train runs `run.sh` on every round. [ADR-0212](../adr/0212-perf-part-in-half-the-time.md) halves it.
Seconds: the train's quiet round of 2026-10-21 03:12 before (15 min 24 s; 21 min was the median of 2026-10-20; `~`
splits the 368 s outside the tests by estimate), and this machine beside other runs on 2026-10-21, before and after. A
test's time runs from its line to the next one's (`perf.py watch`).

| Step | Train before | Here before | Here after | What changed |
|---|--:|--:|--:|---|
| fixtures (synthlib, release) | 3 | 3 | 3 | — |
| server-idle-rss, ingest-throughput, initial-sync-100k | ~75 | — | — | beside the idle CPU, as is a changed server's release build (150 s here) |
| idle-cpu, 1M and 100k | ~120 | 218 | 123 | the folder scanned before the fixture loads (1M: 71 s → 9 s) |
| 1m | 72 | 168 | 47 | scrubs reuse the day counts (89 s → 10 s); 0.5 s rests; timings again only over budget |
| albums-10k | 14 | 13 | 15 | 0.5 s rests |
| folders-5k | 12 | 12 | 12 | 0.5 s rests |
| near-duplicates-100k | 39 | 43 | 42 | as 1m |
| one-day-50k | 32 | 48 | 23 | as 1m |
| one-timestamp-100k | 33 | 90 | 26 | as 1m |
| timeline-300k | 45 | 88 | 28 | as 1m |
| folder-10k | 152 | 285 | 156 | 0.5 s rests; its warm-up of 10,000 tiles follows the load (57 s on the train, 177 s and 70 s here) |
| sphere-video | 35 | 43 | 7 | its clip made beside the server (43 s here); a window again only under budget |
| videos | 122 | 130 | 38 | a pass again only over budget (ADR-0140): two passes, not six |
| the app's three builds (idle CPU, perf_test, cold start) | ~150 | 46–88 each | 3–6 each | when unchanged, as no define holds the run's directory; 40–70 when it changed |
| total | 924 | | | measured by the train on three quiet rounds |

The 1M fixture costs about a minute of the app's benchmarks and the idle CPU, the folder's warm-up a minute; the train
runs the full set on every round all the same, as the owner confirmed (ADR-0212).

## Targets

| Target | Where | A frame takes |
|---|---|---|
| `desktop` | a desktop with a display | the slower of build and raster |
| `headless` | Linux without a display, under Xvfb: the gate's machines, CI | its build alone: the raster thread runs a software GPU on the CPU, which says nothing about a real one; nor do thumbnails, which are not timed but for the server's, against a loaded machine's guard |
| `server` | photolibd | — |
| `web` | Chrome, headless, against photolibd serving the app (`tools/web_e2e/cold_start.mjs`, the `web` part): the cold start, and `timeline-scroll-web`: `tools/timeline_bench.py chrome --wasm --check` drags and flings the 1M library in software GL (SwiftShader), which dart2wasm holds under 1 % janky ([ADR-0385](../adr/0385-web-client-v1.md)) | cold start, janky |
| `android`, `ios` | the device lab (M10-02) | pending |

`PERF_TARGET` overrides the choice, for example `headless` on a desktop without a GPU.
On `headless` llvmpipe composites on the CPU what a GPU would: a frame of the Linux app's video is libmpv's software
render on GTK's main thread, Flutter's texture upload, Impeller's draw and a read-back GTK draws again (libmpv's GL
scalers are not on that path): with decoding and projecting, about 50 ms of CPU a frame of the 4K sphere, whose 30 fps
(`sphere-video`) holds with the cores idle.
On Linux without a session bus the app runs under `tools/perf/keyring.sh`, a D-Bus session with a throwaway unlocked
GNOME Keyring, as without a Secret Service its store waits for a passphrase (ADR-0154).

## Calibration

A CPU-time throughput budget is checked calibrated ([ADR-0121](../adr/0121-calibrated-throughput-budgets.md)): before
each sample the benchmark runs a fixed reference on the same cores, and its rate counts × the fastest reference /
`calibration.quiet` in `budgets.json`, the reference's CPU time on the reference machine at its quietest, never less than
the raw rate. `perf.py` prints the calibrated figure, the raw one and the load average; the benchmark prints the
reference's time, which on a new reference machine becomes `quiet`. Ingest's reference is a seventh 12 MP JPEG,
hashed and decoded at 1/4. A janky share is checked less the share of 60 Hz frames an idle isolate of the app missed
meanwhile, never below 0, against its unchanged budget; a sample over it is drawn again after 5 s of rest, up to five
times in all (folder-scroll's cold one over an emptied disk cache, video-swipe's cold one over a set of videos not yet
shown), the least janky counting, and one that passes only on a retry or that credit is marked on the dashboard
([ADR-0140](../adr/0140-jank-budgets-against-an-idle-isolate.md)); the app's other wall-clock budgets are not
calibrated. With every core saturated, a 10% slower ingest path still fails:

```sh
cargo test --release -p photolib-server --test renditions -- --ignored --nocapture saturated_machine  # in server/; needs stress-ng
```

## Instruction counts

Timings on a shared machine vary far more than 10%, so the gate applies the 10% rule to CPU instructions, which
Callgrind counts the same however loaded the machine is. `kernel/benches/instructions.rs` counts calls through the
ABI (crypto, metadata per corpus folder, capture time, queries, develop) and
`server/crates/photolib-server/benches/instructions.rs` what ingest does with each file (sniff and extraction per
corpus folder, grouping, hashing). `instructions.sh` builds them on this checkout and on its merge base with
`origin/main` (or the commit it is given), the base in a target directory of its own in the private cache, counts each
benchmark's second run of `measured`, prints the table and writes it to `$PERF_REPORT` for the pull request's
description. More than 10% more instructions fails unless a `perf-accept: <reason>` line, in `$PR_BODY` or in a
commit message since the base, says why. It needs valgrind.

A new hot path is a case in one of these benchmarks (`tools/perf/harness.rs` runs them): its setup outside
`measured`, the work inside.

## History, regressions and the dashboard

With `PERF_HISTORY`, each run is appended to that file under its commit (`<sha>-dirty` for uncommitted changes) and
machine. A result more than 10% worse than the median of the machine's last five of the same series fails, and
`<file>.html` charts every series per commit against its budget, as one static page that loads nothing. A failed run
is recorded too, so an accepted regression becomes the baseline after three more runs.

Only a quiet reference machine keeps a history, from the test phase on: on a shared machine two runs of one commit
differ by far more than 10%, so the gate there checks the budgets alone.

## Adding a benchmark

A benchmark appends one JSON object per line to `$PERF_RESULTS`, or an app prints each as `result: <json>`: `budget`,
`metric`, `target`, `value`, and `fixture` when it runs per fixture. List the target under the metric's `measured` in
`budgets.json` and call the benchmark from `run.sh`. The thumbnail endpoint (a load generator, M10-02) and search
(M5-05) arrive this way.

## The map

The map is the `map-pan` budget of `budgets.json` ([ADR-0403](../adr/0403-map-pan-budget.md)): `run.sh` drives
`app/benchmark/map_perf.dart` over the 1m fixture's located assets and records `janky`, `query_p95` and `open`. Run it
alone with `MAP_FIXTURE=<dir> flutter drive --profile -d linux --driver test_driver/integration_test.dart --target
benchmark/map_perf.dart --dart-define=PERF_TARGET=headless` under `xvfb-run` (`taskset -c 0,1` for two cores); each
sweep prints its frames and queries. `kernel/tests/cluster.rs` builds and pans a million points and asserts counts
only. `app/benchmark/map_web.dart` is the page alone in a browser over `?n=` synthetic photos, for Chrome's phone
emulation. The first numbers are in [ADR-0384](../adr/0384-map-view.md)'s and ADR-0403's pull requests.
