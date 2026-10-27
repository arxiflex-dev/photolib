#!/usr/bin/env bash
# The web journey's midnight run (tools/web_e2e/clock.mjs, midnight.mjs; PHO-238): the clock it sets for the process,
# and the gate step that runs the journey under it.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_tool node

capture timeout 120 node --test "$REPO_ROOT/tools/web_e2e/test/clock.test.mjs"
expect_result "the clock set before midnight runs on from there, in the process and from the preload" 0 "# fail 0"

# The step is in the web part, after the journey proper, in Chrome alone, loading the preload before the journey.
STEP=$(grep -n 'WEB_E2E_CLOCK=midnight' "$REPO_ROOT/tools/check.sh")
[[ $STEP == *"WEB_E2E_ONLY=chromium"* && $STEP == *"node --import ./tools/web_e2e/midnight.mjs tools/web_e2e/run.mjs"* ]] &&
  ok "the gate runs the journey in Chrome under the midnight clock, the preload loaded first" ||
  fail "no gate step runs the journey under WEB_E2E_CLOCK=midnight with the preload: $STEP"
JOURNEY=$(grep -n 'step . node tools/web_e2e/run.mjs' "$REPO_ROOT/tools/check.sh" | cut -d: -f1)
[[ -n $JOURNEY && ${STEP%%:*} -gt $JOURNEY ]] && ok "it runs after the journey under the real clock" ||
  fail "the midnight step is not after the journey's own step"
grep -q 'CHECK_ADVISORY_CI-midnight' "$REPO_ROOT/tools/check.sh" &&
  ok "on a hosted runner the step is advisory until the journey is proven under it" ||
  fail "the midnight step is not advisory on CI"

finish
