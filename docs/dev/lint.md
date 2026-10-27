# Lint rules and the ratchet

Rules catch what a review would: dead code, long files and functions, long lines, complexity, and the constructs
behind the crashes a user meets first. The gate (`bash tools/check.sh`) runs every linter below at the release
`tools/lint/tool.sh` pins and holds its findings to `tools/lint/baseline.json` ([ADR-0129](../adr/0129-lint-ratchet.md)).

## The ratchet

The baseline counts, per run (a linter over a directory), file and rule, the findings on `main` when the rules landed.

* `bash tools/lint/ratchet.sh <linter> <dir>`, the gate's step, prints every finding of a count above the baseline and
  fails; it also fails on a count below it, until the baseline is burned down.
* `--update [<linter> <dir>]` writes the counts of that run, or of every run, and refuses any that grew. `--grow`
  records a new rule's or a tool upgrade's findings; a `lint-accept: <reason>` line in a commit or `$PR_BODY` must
  say why, or `--against origin/main` (the `commits` part) fails on the grown baseline.
* `--top [n]` lists the files with the most findings: refactor runs clean them and run `--update`.
* Rust's clippy and rustfmt are those of the release `rust-toolchain.toml` pins; bump it in a change of its own.
* Generated code is not linted. A moved or new file starts at zero: clean what you move.
* A construct allowed on purpose gets its suppression (`#[allow]`, `// ignore:`, `# shellcheck disable=`) with a short
  comment that says why.

## Rules

| Language | Linter, configuration | Rules | Crash classes, denied outside tests |
|---|---|---|---|
| Rust | clippy, `[workspace.lints]` of each workspace, `clippy.toml`; `cargo machete` | `pedantic` and `nursery` but the commented allow-list, `too_many_lines` 80, `cognitive_complexity` 20, `missing_docs`, `unreachable_pub`, `unused_qualifications`; `rustfmt` at 120; `overflow-checks` in test and release builds; no unused dependency | `unwrap_used`, `expect_used`, `panic`, `unimplemented`, `todo`, `unreachable`, `indexing_slicing`, `arithmetic_side_effects`, `cast_possible_truncation`, `let_underscore_must_use` |
| Dart | `flutter analyze`, dart_code_linter; `app/analysis_options.yaml`, which every package includes | very_good_analysis, `strict-casts`, `strict-inference`, `strict-raw-types`, lines of 80 as `dart format` keeps them, files of 800 lines; outside tests functions of 80 lines and complexity 20; unused code and files | `avoid-non-null-assertion` (`!`), `cast_nullable_to_non_nullable`, `avoid_dynamic_calls`, `unawaited_futures`, `discarded_futures`, `avoid_catches_without_on_clauses`, `empty_catches`, `only_throw_errors` |
| Swift | SwiftLint, `.swiftlint.yml` | its defaults, lines of 120, files of 800, functions of 80, complexity 20 | `force_unwrapping`, `force_cast`, `force_try`, `implicitly_unwrapped_optional` |
| Kotlin | ktlint, `.editorconfig` | its standard rules, lines of 120 | `!!` (the ratchet's `not-null-assertion`) |
| C++ | clang-tidy, `.clang-tidy`, over `app/linux` on Linux | `bugprone-*`, `cert-*`, `-Wall -Wextra` (the build adds `-Werror`) | |
| Python | ruff, `ruff.toml` | its defaults, `E501` at 120 | |
| Shell | ShellCheck, `.shellcheckrc` | all but SC1091 and SC2015 | |
| JavaScript, TypeScript | eslint, `eslint.config.mjs` | `no-unused-vars` | |

Tests are Rust's test and bench targets and `#[cfg(test)]` code, and elsewhere files under `test/`, `tests/`,
`integration_test/`, `test_driver/`, `benchmark/`, `benches/` or `RunnerTests/`.

## Clock reads when a test file is loaded

`tools/lint/clock.py` fails a Python, JavaScript, TypeScript or Dart test file (under `test/`, `tests/`, `integration_test/`,
`test_driver/`, `web_e2e/`, `web_probe/`, or named `*_test.*` / `test_*`) that reads the clock where it runs once, while
the file loads: at module top level, in a class body or default value (Python), in the body of `main`, `group` or
`describe`. CI starts a few minutes before 00:00 UTC and builds for six, so a day taken at load is the wrong day when the
test uses it (PHO-235). Read the clock inside the test or `setUp`, or take the value from what the test made.
`tools/lint/clock-baseline.json` lists the reads that remain per file with the reason; a count that differs fails, so it
only shrinks. `tools/tests/test_clock_lint.sh` holds the fixtures.

## Failures tests used to swallow

* Rust: the gate runs `cargo nextest run --success-output immediate` and `cargo test --doc -- --show-output` through
  `tools/lint/panics.py` with `RUST_BACKTRACE=1`, which fails a passing test whose output shows a panic on a thread
  other than its own. A test that checks a panic on a thread it
  spawns names that thread after itself.
* Dart: every package's `test/flutter_test_config.dart` installs `app/packages/photolib_harness`, which fails a test on
  a `FlutterError`, an error-level log record (of its isolate's `Log`, ADR-0115, or a JSON log line it prints) or, in a
  browser, an uncaught error, an unhandled rejection or a `console.error` in the page; package:test already fails one on
  an unhandled async error. A problem of a `setUpAll` or between tests fails the next test, one after the last test
  the suite's `tearDownAll`. The `dart test` browser suites call `strict()` first in `main`. A test that provokes such a
  failure on purpose checks `takeProblems()`. `test/harness_test.dart` there and `app/test/harness/` prove it on
  fixtures that fail on purpose, in the VM and in Chrome and Firefox, so those suites need both browsers.
* The browser drivers fail on their own pages' errors too: `tools/web_requests.py` (the media probe and the app),
  `tools/playback/bench.mjs` and `tools/video/play.mjs` through `tools/web_probe/errors.js`, which their pages load
  first (`errors_test.mjs` there runs it on a page that fails on purpose), and the passkey test's driver over the
  DevTools protocol.
