#!/usr/bin/env python3
"""Pin the workflows, Renovate settings and secret-scan allowlists."""
import glob
import json
import os
import re
import subprocess
import sys
import tomllib
from pathlib import Path

import checklib
import miniyaml
from checklib import ROOT, check, read


def action_steps(job, action):
    return [step for step in job.get("steps", []) if step.get("uses", "").startswith(action + "@")]


def runs_of(job):
    return "\n".join(step.get("run", "") for step in job.get("steps", []))


# What makes a job expensive: macOS, Windows or iOS runners, an Android emulator or APK, the smoke test, Flutter beta
EXPENSIVE = ("macos", "windows", "android-emulator-runner", "flutter build apk", "tools/smoke.sh", "'channel': 'beta'")
# The one pipeline and the five blocks it calls, each a part of the gate's jobs (ci.yml's header)
WORKFLOWS = ["block-dart.yml", "block-perf.yml", "block-rust.yml", "block-static.yml", "block-web.yml",
             "cancel-queue-runs.yml", "ci.yml", "post-merge-builds.yml"]
# The one workflow that runs on a pull request: it cancels the runs of a closed Mergify queue pull request's branch
CANCEL = "cancel-queue-runs.yml"
# The other one that is not part of the gate: it builds the apps and the server after a push to dev, checking nothing
POST = "post-merge-builds.yml"
LANE = "./.github/actions/lane"


def triggers(workflow):
    on = workflow.get("on") or {}
    return {on: None} if isinstance(on, str) else dict.fromkeys(on) if isinstance(on, list) else on


def lane_step(job):
    return next((step for step in job.get("steps", []) if step.get("uses") == LANE), None)


def check_workflows():
    """CI runs only on the merge queue's branches, cheaply: ci.yml calls the five blocks, which run the gate's parts."""
    workflows = {os.path.basename(path): miniyaml.load(read(path))
                 for path in sorted(glob.glob(os.path.join(ROOT, ".github/workflows/*.y*ml")))}
    check(sorted(workflows) == WORKFLOWS,
          f"no new workflow file, which would start enabled beside ci.yml and its blocks ({list(workflows)})")
    for name, workflow in workflows.items():
        on = triggers(workflow)
        if name == CANCEL:
            check_cancel(workflow, on)
            continue
        if name == POST:
            check_post_merge(workflow, on)
            continue
        check(not {"pull_request", "pull_request_target"} & set(on), f"{name} does not run on pull requests")
        wanted = {"push": {"branches": ["mergify/merge-queue/**"]}} if name == "ci.yml" else {"workflow_call": None}
        when = "only on the merge queue's branches" if name == "ci.yml" else "only when ci.yml calls it"
        check(on == wanted, f"{name} runs {when}")
        check(workflow.get("permissions") == {"contents": "read"}, f"{name} has read-only permissions")
        for job_name, job in workflow.get("jobs", {}).items():
            if "uses" in job:
                continue  # a called block's jobs have their own timeouts
            check(0 < job.get("timeout-minutes", 99) <= (60 if lane_step(job) else 30),
                  f"{name}: {job_name} has a timeout (an hour for a share of the gate, else 30 minutes)")
            check(not any(word in str(job) for word in EXPENSIVE),
                  f"{name}: {job_name} runs on Linux and builds no APK, smoke test or Flutter beta")
            check("ubuntu-latest" == job.get("runs-on"), f"{name}: {job_name} runs on ubuntu-latest")
    check_gate(workflows)
    check_flutter()
    check_android_sdk()

    paths = glob.glob(os.path.join(ROOT, ".github/workflows/*.y*ml")) + glob.glob(
        os.path.join(ROOT, ".github/actions/*/action.yml"))
    refs = [ref for path in paths
            for ref in re.findall(r"uses:\s*([\w./-]+@\S+)", Path(path).read_text(encoding="utf-8"))]
    unpinned = [ref for ref in refs if not re.search(r"@(v\d+(\.\d+)*|[0-9a-f]{40})$", ref)]
    check(refs and not unpinned, f"every action is pinned to a version or commit ({unpinned or len(refs)} checked)")


def check_cancel(workflow, on):
    """The cancel workflow acts on a closed pull request of one of our own queue branches, with a token that can only
    manage runs, and passes the branch name through the environment, never into the script."""
    check(on == {"pull_request": {"types": ["closed"]}}, f"{CANCEL} runs only when a pull request closes")
    check(workflow.get("permissions") == {"actions": "write"}, f"{CANCEL} has only the actions: write permission")
    jobs = list(workflow.get("jobs", {}).values())
    check(len(jobs) == 1, f"{CANCEL} has one job")
    for job in jobs:
        guard = str(job.get("if", ""))
        check("startsWith(github.head_ref, 'mergify/merge-queue/')" in guard
              and "github.event.pull_request.head.repo.full_name == github.repository" in guard,
              f"{CANCEL} acts only on this repository's merge-queue branches")
        check("ubuntu-latest" == job.get("runs-on") and 0 < job.get("timeout-minutes", 99) <= 5,
              f"{CANCEL} runs on ubuntu-latest with a short timeout")
        check(not any("uses" in step for step in job.get("steps", [])), f"{CANCEL} checks out and runs no PR code")
        check("${{" not in runs_of(job), f"{CANCEL} keeps expressions out of its script")


# Everything a check, a test or a gate part is run with; the post-merge builds run none of them
CHECKS = ("check.sh", "nextest", "flutter test", "dart test", "cargo test", "cargo clippy", "cargo deny", "fmt --check",
          "lint", "analyze", "smoke.sh", "tools/perf", "pytest", "npm test", "/lane")
# A build job: its runner, and the target its artifact is named after (photolib-<kind>-<target>-<short sha>)
BUILDS = {"client-linux": ("ubuntu-latest", "photolib-client-linux-x64-"),
          "client-android": ("ubuntu-latest", "photolib-client-android-arm64-"),
          "client-macos": ("macos-latest", "photolib-client-macos-universal-"),
          "server-linux": ("ubuntu-latest", "photolib-server-linux-x64-")}


def check_post_merge(workflow, on):
    """After a push to dev, one job per target builds an unsigned artifact and uploads it when its own build worked;
    a summary job lists them. No pull request, queue branch, test, lint or gate, no secret and no write permission."""
    push = on.get("push") or {}
    check(set(on) == {"push"} and push.get("branches") == ["dev"] and set(push) <= {"branches", "paths-ignore"},
          f"{POST} runs only on a push to dev (not a pull request, merge-queue branch or main)")
    check(workflow.get("permissions") == {"contents": "read"}, f"{POST} has read-only permissions")
    concurrency = workflow.get("concurrency") or {}
    check(concurrency.get("cancel-in-progress") is True and "github.ref" in concurrency.get("group", ""),
          f"{POST}: a newer push to dev cancels a superseded run")
    text = Path(os.path.join(ROOT, ".github/workflows", POST)).read_text(encoding="utf-8")
    check("secrets." not in text and "contents: write" not in text and "id-token" not in text,
          f"{POST} uses no secret and publishes nothing outside the run's artifacts")
    jobs = workflow.get("jobs", {})
    check(sorted(jobs) == sorted([*BUILDS, "summary"]), f"{POST} has a job per target and a summary ({sorted(jobs)})")
    for job_name, (runner, prefix) in BUILDS.items():
        job = jobs.get(job_name, {})
        steps = job.get("steps", [])
        check(job.get("runs-on") == runner and 0 < job.get("timeout-minutes", 99) <= 45,
              f"{POST}: {job_name} runs on {runner} with a timeout")
        check(not job.get("needs") and not job.get("strategy"), f"{POST}: {job_name} waits for no other job")
        words = [word for word in CHECKS if word in runs_of(job) or word in str(job.get("with", ""))]
        check(not words and not any(s.get("uses") == LANE for s in steps),
              f"{POST}: {job_name} runs no check ({words})")
        uploads = action_steps(job, "actions/upload-artifact")
        given = uploads[0].get("with", {}) if uploads else {}
        check(len(uploads) == 1 and steps[-1] is uploads[0]
              and not any(word in str(s.get("if", "")) for s in steps
                          for word in ("always()", "failure()", "cancelled()")),
              f"{POST}: {job_name} uploads last, only when its own build worked (no always())")
        check(given.get("name", "").startswith(prefix) and "steps." in given.get("name", "")
              and given.get("if-no-files-found") == "error" and isinstance(given.get("retention-days"), int)
              and 0 < given["retention-days"] <= 14 and "compression-level" in given,
              f"{POST}: {job_name} uploads {prefix}<short sha>, errors on no file, keeps it at most 14 days")
    mac = runs_of(jobs.get("client-macos", {}))
    check("macos-arm64 macos-x64" in mac and "x86_64-apple-darwin" in mac and "lipo -archs" in mac
          and "GITHUB_STEP_SUMMARY" in mac and "exit 1" in mac,
          f"{POST}: the macOS app is universal, built with both kernels, and the job fails without both slices")
    names = [step.get("name", "") for step in jobs.get("client-macos", {}).get("steps", [])]
    vips = next((step.get("run", "") for step in jobs.get("client-macos", {}).get("steps", [])
                 if "brew install vips" in step.get("run", "")), "")
    check("-iname '*kernel_ffi*'" in mac and "find \"$app\"" in mac and "otool -L" in mac,
          f"{POST}: the macOS slice check finds the kernel library by name and prints what it found")
    check("tools/macos/bundle_vips.py" in vips and "Build" in names and names.index("Vips") < names.index("Build"),
          f"{POST}: macOS installs Homebrew's vips before the build, only where the checkout bundles it")
    summary = jobs.get("summary", {})
    check(sorted(summary.get("needs", [])) == sorted(BUILDS) and "cancelled()" in str(summary.get("if", ""))
          and summary.get("permissions") == {"contents": "read", "actions": "read"}
          and "GITHUB_STEP_SUMMARY" in runs_of(summary) and "gh run download" in runs_of(summary),
          f"{POST}: the summary job waits for every build and writes the table, with how to download the latest")
    check(not any("uses" in step for step in summary.get("steps", [])), f"{POST}: the summary checks out no code")
    refs = re.findall(r"uses:\s*([\w./-]+)@", text)
    check(all(ref.startswith(("actions/", "Swatinem/", "subosito/", "./")) for ref in refs),
          f"{POST} uses only first-party-ish actions ({sorted(set(refs))})")


def check_gate(workflows):
    """The gate's parts over the blocks' jobs, side by side: every part of tools/check.sh runs, each step on one job
    only, through the lane action, which sets up what the parts need with every cache keyed by what pins it."""
    ci = workflows.get("ci.yml", {})
    jobs = ci.get("jobs", {})
    concurrency = ci.get("concurrency") or {}
    check(concurrency.get("cancel-in-progress") is True and "github.ref" in concurrency.get("group", ""),
          "a newer push cancels a superseded run")
    calls = {job: spec["uses"] for job, spec in jobs.items() if "uses" in spec}
    blocks = sorted(name for name in workflows if name.startswith("block-"))
    check(sorted(os.path.basename(use) for use in calls.values()) == blocks, f"ci.yml calls every block ({calls})")
    gate = jobs.get("gate", {})
    check(sorted(gate.get("needs", [])) == sorted(calls) and gate.get("if") == "always()"
          and "needs.*.result" in str(gate), "the gate job waits for every block and passes only when each did")
    entries = []
    for name in blocks:
        block = list(workflows[name].get("jobs", {}).values())
        job = block[0] if len(block) == 1 else {}
        step = lane_step(job) or {}
        given = step.get("with", {})
        strategy = job.get("strategy") or {}
        check(len(block) == 1 and step and strategy.get("fail-fast") is False,
              f"{name} is one matrix job through the lane action, and a failure does not cancel the others")
        checkout = [s for s in job.get("steps", []) if s.get("uses", "").startswith("actions/checkout@")]
        check(checkout and checkout[0].get("with", {}).get("fetch-depth") == 0,
              f"{name} fetches the full history: origin/dev for the commits, tags for buf breaking, history for "
              "gitleaks")
        for entry in strategy.get("matrix", {}).get("include", []):
            parts = given.get("parts", "")
            entries.append({**entry, "parts": entry["parts"] if "matrix.parts" in parts else parts})
    split = [part for entry in entries for part in entry["parts"].split()]
    parts = re.search(r"^PARTS=\(([^)]*)\)", read("tools/check.sh"), re.MULTILINE).group(1).split()
    check(sorted(set(split)) == sorted(parts), f"the blocks run every part of tools/check.sh ({sorted(set(split))})")
    # A part several jobs share: all but one pick their steps (steps), the last runs all the others' (except).
    for part in sorted({part for part in split if split.count(part) > 1}):
        shared = [entry for entry in entries if part in entry["parts"].split()]
        rest = [entry for entry in shared if entry.get("except")]
        picked = [entry["steps"] for entry in shared if entry.get("steps")]
        check(len(rest) == 1 and len(picked) == len(shared) - 1
              and rest[0]["except"] == "|".join(dict.fromkeys(picked)),
              f"{part} is split over {len(shared)} jobs, one of which runs every step the others do not")
    # The timed budgets over machines likewise (PERF_UNITS, tools/perf/run.sh): all but one name their units, the last
    # measures every other one.
    budgets = [entry for entry in entries if entry.get("units") or entry.get("units-except")]
    rest = [entry for entry in budgets if entry.get("units-except")]
    named = [unit for entry in budgets for unit in entry.get("units", "").split(",") if unit]
    check(not budgets or len(rest) == 1 and rest[0]["units-except"].split(",") == named
          and len(named) == len(set(named)), "the budgets are split over jobs, one of which measures every other one")

    lane = miniyaml.load(read(".github/actions/lane/action.yml"))["runs"]
    gated = [step for step in lane.get("steps", []) if "tools/check.sh" in step.get("run", "")]
    check(len(gated) == 1 and "bash tools/check.sh ${{ inputs.parts }}" in gated[0]["run"],
          "each job runs its parts of the gate once")
    advisory = (gated[0].get("env", {}) if gated else {}).get("CHECK_ADVISORY", "")
    check(all(name in advisory for name in (r"perf/run\.sh", r"perf/measure\.sh")),
          "what only measures time (the budgets, the kernel's speed, hls.js's start) is advisory on a hosted runner")
    check("timing" not in advisory, "no test is tagged for being flaky: nothing is advisory by a tag")
    check(r"advisories\.py" in advisory, "the RustSec check is advisory on a hosted runner: it never fails a build")
    check(r"timeline_bench\.py" in advisory,
          "the web timeline's frame budget (timeline_bench.py --check) only measures time: advisory on a hosted runner")
    commands = runs_of(lane)
    check("libgtk-3-dev" in commands and "xvfb" in commands and "libmpv-dev" in commands,
          "the lane installs the Linux build tools, libmpv and Xvfb, for the dart and perf parts' headless app")
    check(re.search(r"\bvalgrind\b", commands), "the lane installs valgrind, for the perf part's instruction counts")
    check(all(package in commands for package in ("libvips-dev", "libheif-plugin-libde265")),
          "the lane installs libvips and its HEVC decoder, which photolibd's renderer links and loads")
    check(all(package in commands for package in ("nginx", "apache2-bin")),
          "the lane installs nginx and Apache httpd, which the proxy template suite runs (tools/proxies.sh)")
    lockfiles = subprocess.run(["git", "-C", ROOT, "ls-files", "*Cargo.lock"], check=True, capture_output=True,
                               text=True).stdout
    # The kernel's fuzz crate and its script (ADR-0036) and the Windows libmpv build (ADR-0229) run outside the gate.
    outside = {"kernel/fuzz", "tools/kernel/fuzz.sh", "tools/video/libmpv.sh"}
    roots = sorted({os.path.dirname(path) for path in lockfiles.split()} - outside)
    caches = action_steps(lane, "Swatinem/rust-cache")
    check(roots and caches and sorted(caches[0].get("with", {}).get("workspaces", "").split()) == roots,
          f"one Rust cache covers every workspace, keyed by its Cargo.lock ({roots})")
    installs = action_steps(lane, "taiki-e/install-action")
    tools = {tool for step in installs for tool in step.get("with", {}).get("tool", "").split(",")}
    check({"cargo-deny", "cargo-machete", "cargo-nextest"} <= tools,
          "the lane installs cargo-deny, cargo-machete and cargo-nextest")
    python = action_steps(lane, "actions/setup-python")
    check(python and python[0].get("with", {}).get("cache") == "pip"
          and python[0]["with"].get("cache-dependency-path", "").split()
          == ["tools/docs-requirements.txt", "tools/corpus/decode-requirements.txt"],
          "pip downloads are cached, keyed by the pinned MkDocs and corpus decoder requirements")
    tools = [step for step in action_steps(lane, "actions/cache") if "photolib-tools" in step["with"].get("path", "")]
    # The scripts that download into the tools cache, the lockfiles that pin wasm-bindgen and sqlite3mc.wasm for them
    pins = {os.path.relpath(path, ROOT) for path in glob.glob(os.path.join(ROOT, "tools/**/*.sh"), recursive=True)
            if "/tests/" not in path and re.search(r"PHOTOLIB_TOOLS_CACHE|npm_tool\.sh", read(path))} - outside
    pins |= {"kernel/Cargo.lock", "app/packages/photolib_data/pubspec.lock"}
    key = tools[0].get("with", {}).get("key", "") if tools else ""
    hashed = set(re.findall(r"'([^']+)'", "".join(re.findall(r"hashFiles\(([^)]*)\)", key))))
    check(tools and hashed == pins and "PHOTOLIB_TOOLS_CACHE" in commands,
          f"the tools the gate downloads are cached, keyed by every file that pins them (differences: "
          f"{sorted(pins ^ hashed)})")
    node = action_steps(lane, "actions/setup-node")
    check(node and node[0].get("with", {}).get("node-version-file") == "viewer/.nvmrc" and node[0]["with"].get("cache")
          == "npm" and node[0]["with"].get("cache-dependency-path") == "viewer/package-lock.json",
          "the node part gets the Node version viewer/.nvmrc pins, with npm's cache keyed by its lock file")


def check_flutter():
    """The pinned Flutter install, which every job that needs Flutter gets through the lane action."""
    setup = miniyaml.load(read(".github/actions/flutter/action.yml"))["runs"]
    installs = action_steps(setup, "subosito/flutter-action")
    install = installs[0].get("with", {}) if installs else {}
    check("app/.fvmrc" in runs_of(setup), "the Flutter setup reads the pinned version from app/.fvmrc")
    check(install.get("cache") is True and "steps.pin.outputs.version" in install.get("flutter-version", ""),
          "the Flutter setup installs that exact version, with the SDK and pub cache (keyed by pubspec.lock) cached")
    lane = miniyaml.load(read(".github/actions/lane/action.yml"))["runs"]
    check(not action_steps(lane, "subosito/flutter-action")
          and any(step.get("uses") == "./.github/actions/flutter" for step in lane.get("steps", [])),
          "the lane installs the pinned Flutter, never a floating one")
    check("runner.arch == 'ARM64' && 'master'" in install.get("channel", ""),
          "the pinned Flutter is checked out from git on Linux arm64, which has no SDK archive")


ANDROID_SDK = "./.github/actions/android-sdk"


def check_android_sdk():
    """The Android SDK packages that builds download come from caches keyed by version; broken downloads are fetched
    again."""
    runs = miniyaml.load(read(".github/actions/android-sdk/action.yml"))["runs"]
    commands = runs_of(runs)
    check("FlutterExtension.kt" in commands and "val ndkVersion" in commands and "val compileSdkVersion" in commands,
          "the Android setup reads the NDK and SDK platform versions from the pinned Flutter")
    caches = {step["with"].get("path"): step["with"].get("key", "") for step in action_steps(runs, "actions/cache")}
    home, ndk, image = (f"${{{{ steps.sdk.outputs.{name} }}}}" for name in ("home", "ndk", "image"))
    check(caches.get(f"{home}/ndk/{ndk}", "").endswith(ndk) and caches.get(f"{home}/{image}", "").endswith(image),
          "the NDK and the emulator's system image are cached, each keyed by its version")
    install = [step for step in runs.get("steps", []) if step.get("run") == "bash tools/android_sdk.sh $PACKAGES"]
    check(install and install[0].get("env", {}).get("PACKAGES") == "${{ steps.sdk.outputs.packages }}"
          and 'packages=ndk;$ndk platforms;android-${platform:?no compileSdkVersion in $kotlin} $IMAGE' in commands,
          "tools/android_sdk.sh installs the NDK, the platform and the system image, and fetches a broken download "
          "again")


def check_renovate():
    try:
        config = json.loads(read("renovate.json"))
    except (OSError, ValueError) as error:
        check(False, f"renovate.json is valid JSON ({error})")
        return
    rules = config.get("packageRules", [])
    grouped = {m for rule in rules if rule.get("groupName") for m in rule.get("matchManagers", [])}

    check("config:recommended" in config.get("extends", []), "Renovate extends config:recommended")
    check("helpers:pinGitHubActionDigests" in config.get("extends", []),
          "Renovate pins GitHub Actions to commit digests")
    check(any(re.fullmatch(r"(before|after) .*on (mon|tues|wednes|thurs|fri|satur|sun)day", s, re.IGNORECASE)
              for s in config.get("schedule", [])), "Renovate runs once a week")
    check(grouped >= {"cargo", "pub", "npm", "github-actions"},
          f"Renovate groups updates per ecosystem ({sorted(grouped)})")
    check(config.get("minimumReleaseAge"), "Renovate waits for a release cooldown")
    check(config.get("osvVulnerabilityAlerts") is True,
          "Renovate raises alerts for known vulnerabilities from OSV in every ecosystem, pub and npm included")
    # platform auto-merge lets GitHub wait for the required `check` status; ignoreTests would merge without it
    check(config.get("automerge") is True and config.get("platformAutomerge", True) and not config.get("ignoreTests")
          and all(r.get("automerge", True) for r in [config.get("lockFileMaintenance", {})] + rules),
          "Renovate merges its pull requests once check passes (owner, photolib-design#275)")
    check(any(rule.get("matchManagers") == ["fvm"] and rule.get("enabled") is False for rule in rules),
          "Renovate leaves the Flutter pin to the upgrade gates")
    managers = config.get("customManagers") or [{"matchStrings": ["(?!)"]}]
    tool_image = re.compile(managers[0]["matchStrings"][0].replace("(?<", "(?P<"))
    files = [p.strip("/") for p in managers[0].get("managerFilePatterns", [])]
    scan = "tools/tests/test_secrets.sh"
    check(any(re.search(p, scan) for p in files) and tool_image.search(read(scan)),
          "Renovate keeps the gitleaks image of the gate's secret scan current")


def check_gitleaks():
    try:
        config = tomllib.loads(read(".gitleaks.toml"))
    except (OSError, ValueError) as error:
        check(False, f".gitleaks.toml is valid TOML ({error})")
        return
    lists = config.get("allowlists", [])
    fields = {"description", "condition", "targetRules", "paths", "regexes"}
    check(config.get("extend") == {"useDefault": True} and set(config) <= {"title", "extend", "allowlists"},
          "gitleaks keeps its default rules and adds only allowlists")
    check(lists and all(a.get("condition") == "AND" and a.get("targetRules") == ["generic-api-key"] and a.get("paths")
                        and a.get("regexes") and set(a) <= fields for a in lists),
          "every gitleaks allowlist needs one rule, a path and a secret pattern at once")

    def allowed(path, secret):
        return any(any(re.search(p, path) for p in a.get("paths", [])) and
                   any(re.search(r, secret) for r in a.get("regexes", [])) for a in lists)

    keys = []
    for path in glob.glob(os.path.join(ROOT, "testdata/corpus/golden/**/*.json"), recursive=True):
        group = json.loads(read(path)).get("group") or {}
        if group.get("kind") == "live_photo" and group.get("key"):
            keys.append((os.path.relpath(path, ROOT), group["key"]))
    check(keys and all(allowed(path, key) for path, key in keys),
          f"the secret scan passes the corpus' {len(keys)} Live Photo identifiers")
    check(keys and not allowed("server/config.json", keys[0][1]) and not allowed(keys[0][0], "Zx9" * 12),
          "the secret scan still flags those identifiers elsewhere and other secrets in the corpus")
    vector, hex_key = "kernel/testvectors/crypto/plb.json", "0f" * 32
    check(allowed(vector, hex_key) and allowed("tools/cryptoref/standards.json", hex_key * 2),
          "the secret scan passes the hex test keys of the crypto known-answer vectors")
    check(not allowed("server/config.json", hex_key) and not allowed(vector, "Zx9" * 12)
          and not allowed(vector, hex_key[:40]), "the secret scan still flags other secrets in and around the vectors")


check(miniyaml.selftest() == 0, "the YAML reader passes its own self-test")
check_workflows()
check_renovate()
check_gitleaks()
sys.exit(1 if checklib.failures else 0)
