#!/usr/bin/env bash
# Offline places packs (PHO-71, ADR-0405): the builder's tests, then the committed packs against their manifest.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_tool python3

if timeout 300 python3 "$REPO_ROOT/tools/tests/geodata_tests.py"; then ok "geodata_tests pass"; else fail "geodata_tests fail"; fi
if timeout 120 python3 "$REPO_ROOT/tools/geodata/build.py" --check; then ok "packs match manifest.json"; else
  fail "packs drifted from manifest.json; rebuild with python3 tools/geodata/build.py --sources DIR"
fi
finish
