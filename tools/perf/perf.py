#!/usr/bin/env python3
"""The performance budgets of docs/19 §3 (budgets.json): checks benchmark results against them and against this
machine's history, records the results per commit and renders that history as a static dashboard. Compares the
instruction counts of the hot paths on a branch with its base (instructions.sh). Runs a benchmark app under a watch.

  perf.py check RESULTS [--expect TARGET]... [--history FILE --commit SHA] [--only FILE] [--failed FILE]
  perf.py dashboard HISTORY HTML
  perf.py instructions BASE BRANCH [--accept PULL_REQUEST]
  perf.py watch RESULTS BUDGET [--each REGEX] -- COMMAND...
  perf.py series [--units UNITS] [--except UNITS]

RESULTS and HISTORY hold one JSON object per line: budget, metric, target, fixture (may be empty), value, for a
calibrated value its raw figure and load average (raw, load), for a janky share what an idle isolate missed meanwhile
and the attempts it took (idle, attempts; ADR-0140) and, in a history, the commit, time and machine, and for a sample
that passed only on a retry or the idle credit, which (passed_on); or the budget of an app that hung and how (hung),
or that failed and why (error). check exits 1 when any fails or is missing, 124 when an app hung, as timeout(1) does,
which the gate reports as no timing. --failed writes the series that failed or are missing, one a line with each
attempt's value (values, null where it measured none), and --only checks just the series such a file lists (and any
hang or error), naming the values before: the gate's rerun of a failed run, up to three attempts. BASE and BRANCH
hold one per benchmark: bench and instructions; PULL_REQUEST is the text that may accept a regression in a
`perf-accept: <reason>` line. series prints every series budgets.json measures, one a line as --failed writes them,
of the UNITS given (comma-separated; all when none) and none of the --except ones: a share of the budgets, which CI
splits over machines (tools/perf/run.sh's PERF_UNITS). A unit is a test of app/benchmark/perf_test.dart (a fixture's,
folder-10k, videos, sphere-video, device-folders-5k or server-tiles), the server's benchmarks (server), or the app's
cold start or idle CPU (cold-start, idle-cpu).
"""
import argparse
import contextlib
import glob
import html
import json
import os
import pathlib
import platform
import re
import select
import signal
import statistics
import subprocess
import sys
import time

BUDGETS = json.loads(pathlib.Path(__file__).resolve().with_name("budgets.json").read_text(encoding="utf-8"))
SERIES = ("budget", "metric", "target", "fixture", "machine")
RESULT = re.compile(r"result: (\{.*\})$")  # as a benchmark app prints one


def load(path):
    if not os.path.exists(path):
        return []
    with open(path, encoding="utf-8") as handle:
        return [json.loads(line) for line in handle if line.strip()]


def this_machine():
    model = platform.processor()
    if os.path.exists("/proc/cpuinfo"):
        model = next((line.split(":", 1)[1].strip() for line in
                      pathlib.Path("/proc/cpuinfo").read_text(encoding="utf-8").splitlines()
                      if line.startswith("model name")), model)
    return f"{platform.system()} {platform.machine()}, {model}, {os.cpu_count()} CPUs"


def metric_of(result):
    return BUDGETS["budgets"].get(result["budget"], {}).get("metrics", {}).get(result["metric"]) or {}


def budget_of(result):
    """(bound, limit, unit) of the budget a result is checked against, or None."""
    metric = metric_of(result)
    bound = "min" if "min" in metric else "max"
    limit = metric.get(bound)
    if isinstance(limit, dict):
        limit = limit.get(result["target"])
    return None if limit is None else (bound, limit, metric["unit"])


def show(value):
    return f"{value:g}"


def short(commit):
    """The first 12 digits of a commit, keeping a "-dirty" suffix."""
    return html.escape(commit[:12] + commit[40:])


def label(result):
    return " ".join(part for part in (result[k] for k in SERIES[:4]) if part)


def series(result):
    return {k: result.get(k, "") for k in SERIES[:4]}


# The budgets that are no test of perf_test.dart: the server's benchmarks, and what run.sh measures of the app alone
SERVER = ("server-idle-rss", "ingest-throughput", "initial-sync-100k")
ALONE = ("cold-start", "idle-cpu")
# The budgets that measure.sh measures in a step of the gate of their own: the kernel through its bindings, hls.js's start
MEASURED = ("kernel-binding", "hls-start")
# The test of perf_test.dart that measures a budget over no fixture, as run.sh picks it for a rerun
TESTS = {"video-swipe": "videos", "sphere-video": "sphere-video", "device-folders-scroll": "device-folders-5k",
         "server-tiles": "server-tiles"}


def unit(want):
    """What measures a series: a test of perf_test.dart, the server's benchmarks, or the app's cold start or idle
    CPU."""
    if want["budget"] in SERVER:
        return "server"
    if want["budget"] in ALONE + MEASURED:
        return want["budget"]
    return want["fixture"] or TESTS.get(want["budget"], "folder-10k")


def expected(targets):
    """Every series budgets.json measures on these targets."""
    for target in targets:
        for name, budget in BUDGETS["budgets"].items():
            for metric, spec in budget["metrics"].items():
                for fixture in budget.get("fixtures", [""]) if target in spec.get("measured", []) else []:
                    yield {"budget": name, "metric": metric, "target": target, "fixture": fixture}


def shard(args):
    units, skipped = (set(filter(None, (value or "").split(","))) for value in (args.units, args.skip))
    targets = sorted({t for budget in BUDGETS["budgets"].values() for spec in budget["metrics"].values()
                      for t in spec.get("measured", [])})
    for want in expected(targets):
        if (not units or unit(want) in units) and unit(want) not in skipped:
            print(json.dumps(want))
    return 0


def after(before, unit):
    """On the gate's rerun, which of its attempts this is and the values of the ones before it."""
    values = ", ".join("missing" if v is None else show(v) for v in before)
    return f", gate attempt {len(before) + 1} after {values} {unit}" if before else ""


def check(args):
    only = load(args.only) if args.only else None
    before = {tuple(series(s).values()): s.get("values", []) for s in only or []}
    only = None if only is None else [series(s) for s in only]
    results = [r for r in load(args.results) if only is None or series(r) in only or "hung" in r or "error" in r]
    history = load(args.history) if args.history else []
    for result in results:
        result.setdefault("fixture", "")
        result.setdefault("machine", this_machine())
    problems, failures = ([] if results else ["no results: nothing was measured"]), []
    for result in results:
        if why := result.get("hung") or result.get("error"):
            print(f"FAIL {result['budget']}: {why}")
            problems.append(f"{result['budget']}: {why}")
            continue
        budget = budget_of(result)
        if budget is None:
            problems.append(f"no budget for {label(result)}")
            continue
        bound, limit, unit = budget
        how = ""
        if "load" in result:  # calibrated (ADR-0121): the raw figure, and the load it was measured under
            how = f" calibrated, {show(result['raw'])} raw, load average {show(result['load'])}"
        if "idle" in result:  # less what an idle isolate missed meanwhile, against the same budget (ADR-0140)
            idle = result["idle"]
            result["raw"], result["value"] = result["value"], round(max(0, result["value"] - idle), 2)
            how = f" calibrated, {show(result['raw'])} raw, {show(idle)} {unit} missed idle"
        attempts = result.get("attempts", 1)
        if attempts > 1:
            how += f", the least janky of {attempts} attempts"
        value, sign = result["value"], "≥" if bound == "min" else "≤"
        earlier = before.get(tuple(series(result).values()), [])
        line = f"{label(result)}: {show(value)} {unit}{how} (budget {sign} {show(limit)} {unit}){after(earlier, unit)}"
        failed = value < limit if bound == "min" else value > limit
        # What the measurement must have run with, as fields of the result.
        if missing := [k for k in metric_of(result).get("requires", []) if not result.get(k)]:
            failed, line = True, f"{line}, measured without {', '.join(missing)}"
        past = [h["value"] for h in history if all(h.get(k, "") == result[k] for k in SERIES)][-5:]
        baseline = statistics.median(past) if past else 0
        if baseline:
            worse = (baseline - value if bound == "min" else value - baseline) / baseline
            if worse > BUDGETS["regression"] + 1e-9:
                failed, line = True, f"{line}, regressed {worse:.1%} from {show(baseline)}"
        credits = [c for c, used in (("a retry", attempts > 1),
                                     ("the idle credit", "idle" in result and result["raw"] > limit)) if used]
        if credits and not failed:  # marked in the history, which the dashboard shows
            result["passed_on"] = " and ".join(credits)
            line += f", passed on {result['passed_on']}"
        print(f"{'FAIL' if failed else 'ok  '} {line}")
        if failed:
            problems.append(line)
            failures.append({**series(result), "values": [*earlier, value]})
    for want in expected(args.expect):
        if (only is None or want in only) and not any(series(r) == want for r in results):
            earlier = before.get(tuple(want.values()), [])
            unit_of = BUDGETS["budgets"][want["budget"]]["metrics"][want["metric"]]["unit"]
            problems.append(f"missing: {label(want)}{after(earlier, unit_of)}")
            failures.append({**want, "values": [*earlier, None]})
    if args.failed:
        with open(args.failed, "w", encoding="utf-8") as handle:
            handle.writelines(json.dumps(f) + "\n" for f in failures)
    if args.history:
        stamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
        with open(args.history, "a", encoding="utf-8") as handle:
            for result in results:
                handle.write(json.dumps({"commit": args.commit, "time": stamp, **result}) + "\n")
    for problem in problems:
        print(f"perf.py: {problem}", file=sys.stderr)
    return 124 if any("hung" in r for r in results) else 1 if problems else 0


def watch(args):
    """Runs a benchmark app (stdin closed), passing its output through and appending each result it prints as
    `result: <json>` to RESULTS at once, so that a hang keeps those. Once it writes nothing for PERF_SILENCE seconds
    (300) or no line matching --each, a fixture's, for PERF_DEADLINE (600: the slowest fixture here, folder-10k at
    2.6 min, three times, at least 10 min), kills it with its session and records BUDGET as hung in RESULTS, which
    check fails; the run goes on, as it does when the app fails (a drive with a failed test): BUDGET's error is its
    status and last line. Says how long it ran and each lap took: a lap starts at the first line whose match of --each
    has a new group `lap`, a test's name."""
    silence, deadline = (float(os.environ.get(k, v)) for k, v in (("PERF_SILENCE", 300), ("PERF_DEADLINE", 600)))
    app = subprocess.Popen(args.app, stdin=subprocess.DEVNULL, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                           start_new_session=True)
    start = heard = fixture = time.monotonic()
    last, rest, failure, laps = "", b"", None, {}
    while (now := time.monotonic()) < heard + silence and now < fixture + deadline:
        if not select.select([app.stdout], [], [], 1)[0]:
            if app.poll() is not None:  # it ended, leaving a process that holds its output open
                break
            continue
        data = os.read(app.stdout.fileno(), 65536)
        if not data:
            break
        sys.stdout.buffer.write(data)
        sys.stdout.flush()
        heard = now = time.monotonic()
        *lines, rest = (rest + data).split(b"\n")
        for line in filter(None, (line.decode(errors="replace").strip() for line in lines)):
            last = line
            if args.each and (match := re.search(args.each, line)):
                fixture = now
                if (lap := match.groupdict().get("lap")) is not None:
                    laps.setdefault(lap, now)
            if found := RESULT.search(line):
                with contextlib.suppress(ValueError), open(args.results, "a", encoding="utf-8") as handle:
                    handle.write(json.dumps(json.loads(found[1])) + "\n")
    else:
        why = f"no output for {silence:g} s" if now >= heard + silence else f"no fixture within {deadline:g} s"
        print(f"perf.py: {args.budget}: {why}; killing it with its session", file=sys.stderr)
        with contextlib.suppress(ProcessLookupError):
            os.killpg(app.pid, signal.SIGKILL)
        for stat in glob.glob("/proc/[0-9]*/stat"):  # those of its session in other process groups too
            with contextlib.suppress(OSError, ValueError), open(stat, encoding="utf-8") as handle:
                if int(handle.read().rsplit(")", 1)[1].split()[3]) == app.pid:
                    os.kill(int(stat.split("/")[2]), signal.SIGKILL)
        app.wait()
        failure = {"hung": f"hung after {round((now - start) / 60, 1):g} min ({last})"}
    if failure is None and (code := app.wait()):
        failure = {"error": f"exited {128 - code if code < 0 else code} ({last})"}
    if failure:
        with open(args.results, "a", encoding="utf-8") as handle:
            handle.write(json.dumps({"budget": args.budget, **failure}) + "\n")
    took(args.budget, start, laps)
    return 0


def took(budget, start, laps):
    """Prints how long a watched app ran since its start, and each of its laps until the next one's start."""
    end = time.monotonic()
    ends = [*laps.values()][1:] + [end]
    each = ", ".join(f"{lap} {round(stop - at)} s" for (lap, at), stop in zip(laps.items(), ends))
    print(f"perf.py: {budget} took {round(end - start)} s" + (f": {each}" if each else ""), flush=True)


def chart(entries, budget):
    """An inline SVG line of the values in commit order, with the budget as a dashed line."""
    values = [e["value"] for e in entries]
    low, high = min(values + [budget[1]]), max(values + [budget[1]])
    span = (high - low) or 1
    width, height, pad = 640, 160, 12

    def xy(i, value):
        x = pad + (width - 2 * pad) * (i / (len(values) - 1) if len(values) > 1 else 0.5)
        return round(x, 1), round(height - pad - (height - 2 * pad) * (value - low) / span, 1)

    points = [xy(i, v) for i, v in enumerate(values)]
    limit_y = xy(0, budget[1])[1]
    label_y = limit_y - 4 if limit_y > 24 else limit_y + 16
    sign = "≥" if budget[0] == "min" else "≤"
    dots = ""
    for (x, y), e in zip(points, entries):  # what passed on a retry or the idle credit in orange
        mark = f", passed on {html.escape(e['passed_on'])}" if "passed_on" in e else ""
        fill = ' fill="#e80"' if mark else ""
        dots += (f'<circle cx="{x}" cy="{y}" r="3"{fill}><title>{short(e["commit"])}: {show(e["value"])}{mark}'
                 "</title></circle>")
    return (f'<svg width="{width}" height="{height}" role="img">'
            f'<line x1="{pad}" x2="{width - pad}" y1="{limit_y}" y2="{limit_y}" stroke="#c00" stroke-dasharray="4"/>'
            f'<text x="{pad}" y="{label_y}" fill="#c00">budget {sign} {show(budget[1])} {budget[2]}</text>'
            f'<polyline fill="none" stroke="#36c" points="{" ".join(f"{x},{y}" for x, y in points)}"/>{dots}</svg>')


def dashboard(args):
    series = {}
    for entry in load(args.history):
        series.setdefault(tuple(entry.get(k, "") for k in SERIES), []).append(entry)
    sections = []
    for key, entries in sorted(series.items()):
        budget = budget_of(dict(zip(SERIES, key)))
        if budget is None:
            continue
        rows = "".join(f"<tr><td><code>{short(e['commit'])}</code></td><td>{html.escape(e['time'])}</td>"
                       f"<td>{show(e['value'])}</td><td>{html.escape(e.get('passed_on', ''))}</td></tr>"
                       for e in entries)
        title = " · ".join(html.escape(part) for part in key[:4] if part)
        sections.append(f"<h2>{title}</h2><p>{html.escape(key[4])}</p>{chart(entries, budget)}<table><tr>"
                        f"<th>Commit</th><th>Time</th><th>{html.escape(budget[2])}</th><th>Passed on</th></tr>{rows}"
                        "</table>")
    with open(args.html, "w", encoding="utf-8") as handle:
        handle.write('<!doctype html><meta charset="utf-8"><title>Photolib performance</title>'
                     "<style>body{font-family:sans-serif;margin:2em}td,th{padding:0 1em;text-align:left}</style>"
                     f"<h1>Photolib performance budgets</h1>{''.join(sections) or '<p>No results yet.</p>'}")
    return 0


def instructions(args):
    """Prints the table of instructions per benchmark, base against branch; over 10% more fails, unless accepted."""
    base, branch = ({r["bench"]: r["instructions"] for r in load(path)} for path in (args.base, args.branch))
    problems = [] if branch else ["no instruction counts: no benchmark ran on the branch"]
    print("| Benchmark | Base | Branch | Change |\n|---|--:|--:|--:|")
    for bench in [*branch, *(b for b in base if b not in branch)]:
        old, new = base.get(bench) or None, branch.get(bench)  # a base that counted nothing has no count
        change = "new" if old is None else "removed" if new is None else f"{(new - old) / old:+.1%}"
        print(f"| {bench} | {'—' if old is None else f'{old:,}'} | {'—' if new is None else f'{new:,}'} | {change} |")
        if new == 0:
            problems.append(f"{bench} counted no instructions: its measured() never ran")
        elif old and new and (new - old) / old > BUDGETS["regression"] + 1e-9:
            problems.append(f"{bench}: {(new - old) / old:.1%} more instructions than the base")
    accept = pathlib.Path(args.accept).read_text(encoding="utf-8") if args.accept else ""
    reason = re.search(r"^perf-accept:[ \t]*(\S.*)$", accept, re.MULTILINE)
    if reason and any("more instructions" in p for p in problems):
        print(f"\nAccepted (perf-accept): {reason[1].strip()}")
        problems = [p for p in problems if "more instructions" not in p]
    for problem in problems:
        print(f"perf.py: {problem}", file=sys.stderr)
    return 1 if problems else 0


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    commands = parser.add_subparsers(dest="command", required=True)
    checking = commands.add_parser("check")
    checking.add_argument("results")
    checking.add_argument("--expect", action="append", default=[], metavar="TARGET")
    checking.add_argument("--history")
    checking.add_argument("--commit")
    checking.add_argument("--only")
    checking.add_argument("--failed")
    rendering = commands.add_parser("dashboard")
    rendering.add_argument("history")
    rendering.add_argument("html")
    comparing = commands.add_parser("instructions")
    comparing.add_argument("base")
    comparing.add_argument("branch")
    comparing.add_argument("--accept", metavar="PULL_REQUEST")
    watching = commands.add_parser("watch")
    watching.add_argument("results")
    watching.add_argument("budget")
    watching.add_argument("--each", metavar="REGEX")
    watching.add_argument("app", nargs="+", metavar="COMMAND")
    sharing = commands.add_parser("series")
    sharing.add_argument("--units")
    sharing.add_argument("--except", dest="skip")
    argv, command = sys.argv[1:], None
    if argv[:1] == ["watch"] and "--" in argv:  # argparse would drop a `--` of the command's own too
        argv, command = argv[: argv.index("--")] + ["command"], argv[argv.index("--") + 1:]
    args = parser.parse_args(argv)
    if command:
        args.app = command
    if args.command == "check" and args.history and not args.commit:
        parser.error("--history needs the --commit the results belong to")
    commands = {"check": check, "dashboard": dashboard, "instructions": instructions, "watch": watch,
                "series": shard}
    return commands[args.command](args)


if __name__ == "__main__":
    sys.exit(main())
