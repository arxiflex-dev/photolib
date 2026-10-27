#!/usr/bin/env python3
"""The lint ratchet (docs/dev/lint.md): tools/lint/baseline.json holds, per run (a linter over a directory), how many
findings of each rule each file had when the rules landed. The gate fails on any count above it, and on any below it
until the baseline is burned down; it never grows unless a `lint-accept: <reason>` line says why.

  ratchet.sh <linter> <dir>                       fail on counts that differ from the baseline's
  ratchet.sh --update [--grow] [<linter> <dir>]   write the counts of that run, or of every run in the baseline;
                                                  refuses to grow a count without --grow
  ratchet.sh --against <rev>                      fail on a baseline larger than at the merge base with <rev>, unless
                                                  $PR_BODY or a commit since says `lint-accept: <reason>`
  ratchet.sh --top [n]                            the n files with the most findings in the baseline
"""

import collections
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BASELINE = ROOT / "tools/lint/baseline.json"
# The crash classes are denied outside tests only: a test that unwraps fails as loudly as an assertion.
CRASH = {
    "clippy::unwrap_used", "clippy::expect_used", "clippy::panic", "clippy::unimplemented", "clippy::todo",
    "clippy::unreachable", "clippy::indexing_slicing", "clippy::arithmetic_side_effects",
    "clippy::cast_possible_truncation", "clippy::let_underscore_must_use",
    "avoid-non-null-assertion", "cast_nullable_to_non_nullable", "avoid_dynamic_calls", "unawaited_futures",
    "discarded_futures", "avoid_catches_without_on_clauses", "empty_catches", "only_throw_errors",
    "force_unwrapping", "force_cast", "force_try", "implicitly_unwrapped_optional", "not-null-assertion",
}
TESTS = {"test", "tests", "integration_test", "test_driver", "benchmark", "benches", "RunnerTests"}
GENERATED = re.compile(r"(^|/)gen/|\.g\.dart$|\.pb\w*\.dart$|/l10n/app_localizations|(^|/)drift_schemas/|"
                       r"/test/drift/|[Gg]enerated_?[Pp]lugin_?[Rr]egistrant|/ephemeral/")
DART_LIMITS = {"cyclomatic-complexity", "source-lines-of-code"}
DART_DIRS = ("lib", "bin", "tool", "test", "integration_test", "test_driver", "benchmark")
DART_FILE_LINES = 800

Finding = collections.namedtuple("Finding", "file rule line text")


class Failed(Exception):
    pass


def run(cmd, cwd=ROOT, ok=(0,), env=None):
    proc = subprocess.run(cmd, check=False, cwd=cwd, capture_output=True, text=True, env=env)
    if proc.returncode not in ok:
        command = " ".join(map(str, cmd))
        raise Failed(f"{proc.stdout[-6000:]}{proc.stderr[-6000:]}\n{command} exited with {proc.returncode}")
    return proc.stdout


def tool(name, *args, ok=(0, 1)):
    return run(["bash", ROOT / "tools/lint/tool.sh", name, *args], ok=ok)


def rel(path, base=ROOT):
    return os.path.relpath(os.path.normpath(os.path.join(base, path)), ROOT)


def is_test(path):
    return not TESTS.isdisjoint(Path(path).parts)


def files(directory, *patterns):
    """Tracked files under a directory, outside the Dart packages nested in it and generated code."""
    def tracked(*globs):
        return [f for f in run(["git", "ls-files", "-z", "--", *(f"{directory}/{g}" for g in globs)]).split("\0") if f]

    nested = [Path(f).parent for f in tracked("*/pubspec.yaml")] if patterns == ("*.dart",) else []
    return [f for f in tracked(*patterns) if not GENERATED.search(f) and not any(n in Path(f).parents for n in nested)]


def clippy(directory):
    def warnings(*targets):
        found = {}
        out = run(["cargo", "clippy", "--locked", *targets, "--message-format=json"], cwd=ROOT / directory)
        for line in out.splitlines():
            msg = json.loads(line).get("message") if line.startswith("{") else None
            spans = [s for s in (msg or {}).get("spans", []) if s["is_primary"]]
            path = rel(spans[0]["file_name"], ROOT / directory) if spans else ".."
            # Code that build scripts generate lies outside the repository.
            if msg and msg["level"] == "warning" and not path.startswith(".."):
                rule = (msg.get("code") or {}).get("code") or "warning"
                found[(rule, path, spans[0]["line_start"], spans[0]["column_start"])] = msg["rendered"]
        return found

    def own(path):
        """Not a path dependency's file: the workspace that holds it lints it."""
        lock = next((d for d in (ROOT / path).parents if (d / "Cargo.lock").is_file()), ROOT / directory)
        return lock == ROOT / directory

    every, shipped = warnings("--all-targets"), warnings("--lib", "--bins")
    return [Finding(f, rule, line, text) for (rule, f, line, col), text in every.items()
            if own(f) and (rule not in CRASH or (rule, f, line, col) in shipped)]


def dart(directory):
    cwd = ROOT / directory
    # An error fails analysis; strict-casts' are counted like any finding, as the code still compiles and runs.
    analysis = run(["flutter", "analyze", "--no-fatal-infos", "--no-fatal-warnings"], cwd=cwd, ok=(0, 1))
    found = []
    for line in analysis.splitlines():
        parts = line.strip().split(" • ")
        if len(parts) >= 4 and parts[0] in ("info", "warning", "error"):
            path, number = parts[-2].rsplit(":", 2)[:2]
            found.append(Finding(rel(path, cwd), parts[-1], int(number), parts[1]))
    if not found and "No issues found" not in analysis:
        raise Failed(f"{analysis}\nflutter analyze failed in {directory}")
    dirs = [d for d in DART_DIRS if (cwd / d).is_dir()]
    found += dart_code_linter(cwd, dirs) if dirs else []
    for path in files(directory, "*.dart"):
        lines = (ROOT / path).read_bytes().count(b"\n")
        if lines > DART_FILE_LINES:
            found.append(Finding(path, "file-length", DART_FILE_LINES + 1, f"{lines} lines"))
    return found


JSON_START = re.compile(r'\{\s*["}]')


def first_json(out, what):
    """The first complete JSON object of a tool's stdout, which also holds a spinner and, once pub.dev has a newer
    release, an update notice. dart_code_linter prints no JSON when it finds nothing, only its completion line."""
    starts = [m.start() for m in JSON_START.finditer(out)]
    for start in starts:
        try:
            return json.JSONDecoder().raw_decode(out, start)[0]
        except ValueError:
            continue
    if not starts and "Analysis is completed" in out:
        return {}
    raise Failed(f"{what} printed no JSON document; the head of its output: {out.strip()[:600] or '(no output)'!r}")


# dart_code_linter asks pub.dev for its latest release after every command and prints an update notice if there is one;
# it has no flag to stop that. Its HTTP client takes the proxy from the environment, so a proxy that refuses ends the
# check at once and silently (it ignores the failure): no notice, no wait, no dependence on pub.dev (PHO-239).
NO_UPDATE_CHECK = dict.fromkeys(
    ("http_proxy", "https_proxy", "all_proxy", "HTTP_PROXY", "HTTPS_PROXY", "ALL_PROXY"), "http://127.0.0.1:9")


def dart_code_linter(cwd, dirs):
    """Its rules, the functions over DART_LIMITS, and unused code and files."""
    dcl, found = ["dart", "run", "dart_code_linter:metrics"], []
    env = {**os.environ, **NO_UPDATE_CHECK}
    with tempfile.TemporaryDirectory() as tmp:
        report = Path(tmp) / "metrics.json"
        run([*dcl, "analyze", *dirs, "--reporter=json", f"--json-path={report}", "--no-fatal-warnings"],
            cwd=cwd, env=env)
        records = json.loads(report.read_text())["records"]
    for record in records:
        path = rel(record["path"], cwd)
        found += [Finding(path, i["ruleId"], i["codeSpan"]["start"]["line"], i["message"]) for i in record["issues"]]
        found += [Finding(path, m["metricsId"], entity["codeSpan"]["start"]["line"], f"{name}: {m['comment']}")
                  for kind in ("classes", "functions") for name, entity in record[kind].items()
                  for m in entity["metrics"] if m["metricsId"] in DART_LIMITS and m["level"] in ("warning", "alarm")]
    for command, key in (("check-unused-code", "unusedCode"), ("check-unused-files", "unusedFiles")):
        out = run([*dcl, command, *dirs, "--reporter=json", "--no-fatal-unused"], cwd=cwd, env=env)
        for entry in first_json(out, f"{command} in {rel(cwd)}").get(key, []):
            for issue in entry.get("issues", [{"line": 1, "declarationName": "no file imports it"}]):
                found.append(Finding(rel(entry["path"], cwd), command[6:], issue["line"], issue["declarationName"]))
    return found


def shellcheck(directory):
    paths = files(directory, "*.sh")
    out = json.loads(tool("shellcheck", "-f", "json1", *paths)) if paths else {"comments": []}
    return [Finding(rel(c["file"]), f"SC{c['code']}", c["line"], c["message"]) for c in out["comments"]]


def ruff(directory):
    paths = files(directory, "*.py")
    out = json.loads(tool("ruff", "check", "--no-cache", "--output-format=json", *paths)) if paths else []
    return [Finding(rel(f["filename"]), f["code"] or "syntax-error", f["location"]["row"], f["message"]) for f in out]


def eslint(directory):
    paths = files(directory, "*.js", "*.mjs", "*.ts")
    out = json.loads(tool("eslint", "--format=json", *paths)) if paths else []
    return [Finding(rel(f["filePath"]), m["ruleId"] or "parse-error", m["line"], m["message"])
            for f in out for m in f["messages"]]


def swiftlint(directory):
    paths = files(directory, "*.swift")
    out = json.loads(tool("swiftlint", "lint", "--quiet", "--reporter", "json", *paths, ok=(0, 2))) if paths else []
    return [Finding(rel(v["file"]), v["rule_id"], v["line"], v["reason"]) for v in out]


def ktlint(directory):
    paths = files(directory, "*.kt", "*.kts")
    out = tool("ktlint", "--reporter=json", "--log-level=none", *paths) if paths else "[]"
    found = [Finding(rel(f["file"]), e["rule"], e["line"], e["message"])
             for f in json.loads(out[out.index("["):]) for e in f["errors"]]
    # ktlint has no rule for `!!`, the not-null assertion that throws.
    for path in paths:
        for number, line in enumerate((ROOT / path).read_text().splitlines(), 1):
            code = re.sub(r'"(\\.|[^"\\])*"', '""', line).split("//")[0]
            found += [Finding(path, "not-null-assertion", number, line.strip())] * code.count("!!")
    return found


def clang_tidy(directory):
    """The runner of this machine's OS, compiled as its CMake build does, with GTK and Flutter's headers."""
    paths = files(directory, "*.cc", "*.cpp")
    if not paths:
        return []
    flutter = Path(run(["bash", "-c", "command -v flutter"]).strip()).resolve().parent
    engine = flutter / f"cache/artifacts/engine/linux-{'arm64' if os.uname().machine == 'aarch64' else 'x64'}"
    if not (engine / "flutter_linux").is_dir():
        raise Failed(f"{engine}/flutter_linux is missing: run flutter precache --linux")
    gtk = run(["pkg-config", "--cflags", "gtk+-3.0"]).split()
    app_id = re.search(r'set\(APPLICATION_ID "(.*)"\)', (ROOT / directory / "CMakeLists.txt").read_text())[1]
    flags = ["-std=c++14", "-Wall", "-Wextra", f"-I{ROOT / directory}", "-isystem", str(engine),
             f'-DAPPLICATION_ID="{app_id}"',
             *(f"-isystem{f[2:]}" if f.startswith("-I") else f for f in gtk)]
    out = tool("clang-tidy", "--quiet", *paths, "--", *flags, ok=(0, 1))
    found = []
    for match in re.finditer(r"^(\S+?):(\d+):\d+: (warning|error): (.*) \[([\w.,-]+)\]$", out, re.MULTILINE):
        if match[3] == "error":
            raise Failed(f"{out}\nclang-tidy could not compile {match[1]}")
        found.append(Finding(rel(match[1]), match[5].split(",")[0], int(match[2]), match[4]))
    return found


LINTERS = {"clippy": clippy, "dart": dart, "shellcheck": shellcheck, "ruff": ruff, "eslint": eslint,
           "swiftlint": swiftlint, "ktlint": ktlint, "clang-tidy": clang_tidy}


def measure(linter, directory):
    if linter not in LINTERS:
        raise Failed(f"unknown linter '{linter}'; the linters are: {', '.join(LINTERS)}")
    found = [f for f in LINTERS[linter](directory.rstrip("/") or ".")
             if not GENERATED.search(f.file) and not (f.rule in CRASH and is_test(f.file))]
    counts = collections.defaultdict(collections.Counter)
    for finding in found:
        counts[finding.file][finding.rule] += 1
    return found, {f: dict(sorted(c.items())) for f, c in sorted(counts.items())}


def differences(counts, base):
    """(file, rule, count, baseline count) wherever they differ."""
    keys = {(f, r) for side in (counts, base) for f, rules in side.items() for r in rules}
    return [(f, r, counts.get(f, {}).get(r, 0), base.get(f, {}).get(r, 0)) for f, r in sorted(keys)
            if counts.get(f, {}).get(r, 0) != base.get(f, {}).get(r, 0)]


def load(text=None):
    return json.loads(BASELINE.read_text() if text is None else text)


def save(baseline):
    BASELINE.write_text(json.dumps(dict(sorted(baseline.items())), indent=1) + "\n")


def check(linter, directory):
    found, counts = measure(linter, directory)
    name = f"{linter} {directory}"
    diff = differences(counts, load().get(name, {}))
    above = [d for d in diff if d[2] > d[3]]
    for f, rule, _, _ in above:
        for finding in found:
            if (finding.file, finding.rule) == (f, rule):
                print(f"{f}:{finding.line}: {rule}: {finding.text}")
    for f, rule, n, base in diff:
        print(f"{f}: {rule}: {n}, baseline {base}")
    if above:
        raise Failed(f"{name}: {len(above)} rule(s) found more often than the baseline holds: fix the code above")
    if diff:
        raise Failed(f"{name}: fewer findings than the baseline holds: burn it down with "
                     f"tools/lint/ratchet.sh --update {name}")
    print(f"{name}: {sum(sum(c.values()) for c in counts.values())} findings, as the baseline holds")


def update(runs, grow):
    baseline = load()
    runs = runs or [tuple(name.split(" ", 1)) for name in baseline]
    grown = False
    for linter, directory in runs:
        name = f"{linter} {directory}"
        _, counts = measure(linter, directory)
        for f, rule, n, base in differences(counts, baseline.get(name, {})):
            print(f"{f}: {rule}: {n}, baseline {base}")
            grown |= n > base
        baseline[name] = counts
    if grown and not grow:
        raise Failed("the baseline would grow: fix the new findings (or, for a new rule or tool, --grow with a "
                     "lint-accept: <reason> line in a commit)")
    save(baseline)


def against(rev):
    base = run(["git", "merge-base", rev, "HEAD"]).strip()
    shown = subprocess.run(["git", "show", f"{base}:tools/lint/baseline.json"], check=False, cwd=ROOT,
                           capture_output=True, text=True)
    old = load(shown.stdout) if shown.returncode == 0 else {}
    grown = [(name, *d) for name, counts in load().items() for d in differences(counts, old.get(name, {}))
             if d[2] > d[3]]
    if not grown:
        return
    for name, f, rule, n, was in grown:
        print(f"{name}: {f}: {rule}: {n}, base {was}")
    said = os.environ.get("PR_BODY", "") + run(["git", "log", "--format=%B", f"{base}..HEAD"])
    if re.search(r"^lint-accept: *\S", said, re.MULTILINE):
        print("the baseline grew, as a lint-accept line says why")
        return
    raise Failed(f"the lint baseline grew against {rev}: fix the findings, or say why in a lint-accept: <reason> line")


def top(n):
    totals = collections.Counter()
    for counts in load().values():
        for f, rules in counts.items():
            totals[f] += sum(rules.values())
    for f, total in totals.most_common(n):
        print(f"{total} {f}")


def main(args):
    if args[:1] == ["--update"]:
        grow = "--grow" in args
        rest = [a for a in args[1:] if a != "--grow"]
        update([tuple(rest)] if rest else [], grow)
    elif args[:1] == ["--against"] and len(args) == 2:
        against(args[1])
    elif args[:1] == ["--top"]:
        top(int(args[1]) if len(args) > 1 else 20)
    elif len(args) == 2:
        check(*args)
    else:
        raise Failed(__doc__)


if __name__ == "__main__":
    try:
        main(sys.argv[1:])
    except Failed as failure:
        sys.exit(f"ratchet: {failure}")
