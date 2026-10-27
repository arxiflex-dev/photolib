#!/usr/bin/env python3
"""Fails a test file that reads the clock when it is loaded (docs/dev/lint.md): at module top level, or in the body of
`main` or a `group`/`describe` that runs while the tests are registered. A value taken then is minutes old when a test
uses it, and a run that crosses midnight (CI starts a few minutes before 00:00 UTC and builds for six) sees another
day: PHO-235. Read the clock inside the test, or inject it.

  clock.py                  check the test files git tracks against tools/lint/clock-baseline.json
  clock.py <file>...        check these files, with no baseline

The baseline lists, per file, how many such reads it has and why they are harmless; a count that differs fails, so it
only shrinks. Python is parsed (ast); JavaScript, TypeScript and Dart are scanned for braces, which is exact enough
for code that is formatted.
"""

import ast
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BASELINE = ROOT / "tools/lint/clock-baseline.json"
TEST_DIRS = {"test", "tests", "integration_test", "test_driver", "web_e2e", "web_probe"}
TEST_NAME = re.compile(r"(^|[._-])tests?([._-]|$)")
SUFFIXES = {".py", ".mjs", ".js", ".ts", ".dart"}

# What reads the clock, with the text of a line stripped of strings and comments.
READS = {
    ".dart": re.compile(r"\bDateTime\s*\.\s*now\s*\("),
    "js": re.compile(r"\bDate\s*\.\s*now\s*\(|\bnew\s+Date\s*\(\s*\)|(?<![\w.])Date\s*\(\s*\)|\bperformance\s*\.\s*now\s*\("),
}
GROUPS = {".dart": r"\bgroup\s*\(", "js": r"\b(?:describe|suite)\s*\("}
MAIN = {".dart": r"\bmain\s*\([^)]*\)\s*(?:async\s*)?$", "js": r"$^"}
PY_CLOCK = {("datetime", "now"), ("datetime", "utcnow"), ("datetime", "today"), ("date", "today"), ("time", "time"),
            ("time", "time_ns")}


def is_test(path):
    p = Path(path)
    return p.suffix in SUFFIXES and (TEST_DIRS & set(p.parts[:-1]) or TEST_NAME.search(p.stem) is not None)


def python_reads(source):
    """Lines of clock reads that run when the module is imported: not inside a def or lambda, but yes in a decorator,
    a default value or a class body."""
    hits = []

    class Visit(ast.NodeVisitor):
        def visit_Call(self, node):
            func = node.func
            if isinstance(func, ast.Attribute) and (name := _tail(func.value)):
                if (name, func.attr) in PY_CLOCK:
                    hits.append(node.lineno)
            self.generic_visit(node)

        def visit_Lambda(self, node):
            pass

        def visit_FunctionDef(self, node):
            for part in (*node.decorator_list, *node.args.defaults, *filter(None, node.args.kw_defaults)):
                self.visit(part)

        visit_AsyncFunctionDef = visit_FunctionDef

    Visit().visit(ast.parse(source))
    return hits


def _tail(node):
    return node.attr if isinstance(node, ast.Attribute) else node.id if isinstance(node, ast.Name) else None


def blank(text, dart):
    """`text` with comments, strings and template literals turned into spaces, newlines kept."""
    out, i, n = [], 0, len(text)
    triple = ("'''", '"""') if dart else ()
    while i < n:
        two = text[i:i + 2]
        if two == "//":
            j = text.find("\n", i)
            j = n if j < 0 else j
        elif two == "/*":
            j = text.find("*/", i + 2)
            j = n if j < 0 else j + 2
        elif text[i:i + 3] in triple:
            j = text.find(text[i:i + 3], i + 3)
            j = n if j < 0 else j + 3
        elif text[i] in "'\"`":
            j = i + 1
            while j < n and text[j] != text[i] and (text[j] != "\n" or text[i] == "`"):
                j += 2 if text[j] == "\\" else 1
            j = min(j + 1, n)
        else:
            out.append(text[i])
            i += 1
            continue
        out.append(re.sub(r"[^\n]", " ", text[i:j]))
        i = j
    return "".join(out)


def braced_reads(source, kind):
    """Lines of clock reads in code that runs at load: top level, and the blocks of main and group/describe."""
    read, group, main = READS[kind], re.compile(GROUPS[kind]), re.compile(MAIN[kind])
    text = blank(source, kind == ".dart")
    hits, stack, header, line = [], [], "", 1  # stack: True for a block that runs at load
    for lineno, row in enumerate(text.split("\n"), 1):
        line = lineno
        pos = 0
        for m in re.finditer(r"[{}]|;", row):
            piece = row[pos:m.start()]
            header += piece
            _look(read, header, piece, line, stack, hits)
            if m.group() == "{":
                loads = (not stack or stack[-1]) and (bool(group.search(header) and re.search(r"(\)|=>)\s*$", header))
                                                      or not stack and bool(main.search(header.strip())))
                stack.append(loads)
                header = ""
            elif m.group() == "}":
                if stack:
                    stack.pop()
                header = ""
            else:
                header = ""
            pos = m.end()
        piece = row[pos:]
        header += piece + "\n"
        _look(read, header, piece, line, stack, hits)
    return sorted(set(hits))


def _look(read, header, piece, line, stack, hits):
    # A lambda earlier in the statement (`=>`, `function`) defers the read to when it is called.
    if (stack and not stack[-1]) or not (found := read.search(piece)):
        return
    if re.search(r"=>|\bfunction\b", header[:header.rfind(piece) + found.start()]):
        return
    hits.append(line)


def reads(path, source):
    suffix = Path(path).suffix
    if suffix == ".py":
        return python_reads(source)
    return braced_reads(source, ".dart" if suffix == ".dart" else "js")


def tracked():
    out = subprocess.run(["git", "ls-files", "-z"], cwd=ROOT, capture_output=True, text=True, check=True).stdout
    return [p for p in out.split("\0") if p and is_test(p)]


def main(args):
    if args:
        found = {f: reads(f, Path(f).read_text(errors="replace")) for f in args}
        baseline = {}
    else:
        found = {f: reads(f, (ROOT / f).read_text(errors="replace")) for f in tracked()}
        baseline = json.loads(BASELINE.read_text())
    problems = []
    for path, lines in sorted(found.items()):
        allowed = baseline.get(path, {}).get("reads", 0)
        if len(lines) != allowed:
            at = ", ".join(f"{path}:{n}" for n in lines)
            problems.append(f"{path}: {len(lines)} clock reads at load ({at or 'none'}), baseline {allowed}")
    for path, entry in sorted(baseline.items()):
        if path not in found:
            problems.append(f"{path}: in the baseline but not a tracked test file")
        if not str(entry.get("reason", "")).strip():
            problems.append(f"{path}: the baseline entry has no reason")
    if problems:
        print("clock.py: a test must read the clock inside the test, not when its file is loaded:", *problems,
              sep="\n  ")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
