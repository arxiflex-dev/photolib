#!/usr/bin/env bash
# The all-in-one compose bundle (deploy/compose): check_compose.py checks compose.yaml with .env.example and with what
# setup.sh, the one-command quickstart, writes; docker is a stub here, so setup.sh starts nothing.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_tool python3
require_tool docker
docker compose version >/dev/null 2>&1 || { echo "FAIL: the docker compose plugin is required" >&2; exit 1; }

python3 "$REPO_ROOT/tools/tests/check_compose.py" || fail "check_compose.py reported failures"

SANDBOX=$(mktemp -d)
trap 'rm -rf "$SANDBOX"' EXIT
mkdir "$SANDBOX/bin"
printf '#!/bin/sh\necho "$*" >>"%s/docker.log"\n' "$SANDBOX" >"$SANDBOX/bin/docker"
chmod +x "$SANDBOX/bin/docker"
setup() {
  rm -rf "$SANDBOX/$1" && cp -r "$REPO_ROOT/deploy/compose" "$SANDBOX/$1"
  OUT=$(cd "$SANDBOX" && PATH=$SANDBOX/bin:$PATH sh "$1/setup.sh" "${@:2}" 2>&1)
  STATUS=$?
}

setup a photos.test /photos
env=$SANDBOX/a/.env
[[ $STATUS -eq 0 && $(stat -c %a "$env") == 600 ]] && ok "setup.sh writes .env, readable by its owner only" ||
  fail "setup.sh: exit $STATUS: $OUT"
grep -qx "PHOTOLIB_DOMAIN=photos.test" "$env" && grep -qx "PHOTOLIB_BASE_PATH=/photos" "$env" &&
  grep -qx "PUID=$(id -u)" "$env" && grep -qx "PGID=$(id -g)" "$env" &&
  ok "setup.sh sets the domain, the base path and the user and group running it" || fail "setup.sh: $(cat "$env")"
password=$(sed -n 's/^POSTGRES_PASSWORD=//p' "$env")
[[ $password =~ ^[0-9a-f]{48}$ ]] && ok "setup.sh makes a 192-bit database password" || fail "password: $password"
for dir in data keys postgres caddy/data caddy/config; do
  [[ -d $SANDBOX/a/$dir ]] || fail "setup.sh does not make $dir"
done
[[ $(cat "$SANDBOX/docker.log" 2>/dev/null) == "compose up -d" ]] &&
  ok "setup.sh starts photolib" || fail "docker was called with: $(cat "$SANDBOX/docker.log" 2>/dev/null)"
python3 "$REPO_ROOT/tools/tests/check_compose.py" "$env" >/dev/null && ok "compose.yaml runs with what setup.sh wrote" ||
  fail "check_compose.py fails with setup.sh's .env"

cp "$env" "$SANDBOX/before"
OUT=$(cd "$SANDBOX" && PATH=$SANDBOX/bin:$PATH sh a/setup.sh other.test 2>&1)
[[ $? -ne 0 && $OUT == *".env exists"* ]] && cmp -s "$env" "$SANDBOX/before" &&
  ok "setup.sh never overwrites an .env" || fail "second run: $OUT"
setup b photos.test
[[ $STATUS -eq 0 && $(sed -n 's/^POSTGRES_PASSWORD=//p' "$SANDBOX/b/.env") != "$password" ]] &&
  grep -qx "PHOTOLIB_BASE_PATH=" "$SANDBOX/b/.env" && ok "each install gets its own password; no base path is the root" ||
  fail "second install: $OUT"
setup c
[[ $STATUS -ne 0 && $OUT == *usage* && ! -e $SANDBOX/c/.env ]] && ok "setup.sh without a domain says how to call it" ||
  fail "no domain: exit $STATUS: $OUT"

assert_patterns assert_prose docs/admin/install.md \
  'DNS record .* ports 80 and 443' "names what a fresh install needs before it starts" \
  'sh photolib/setup\.sh photos\.example\.com' "installs with one command" \
  'docker compose logs photolibd' "says where the setup token is" \
  'keys/` holds the OPAQUE key: back it up apart' "says to back the key up apart from the database dumps" \
  'docker compose pull' "upgrades with the new release's compose files and no edits" \
  'ghcr\.io/arxiflex-dev/photolib' "names the image for other setups" \
  'Docker Desktop on Windows or macOS, WSL2 or a NAS.s container manager' "runs the image on any OS (#374)" \
  'no native Windows or macOS[[:space:]]+photolibd, as its media sandbox \(\[ADR-0024\]\([^)]*\)\) needs Linux' \
  "says photolibd runs natively on Linux only, as its media sandbox needs Linux" \
  'trusted-node mode \(M6-11\)[^.]*natively on Windows and macOS' "names the desktop app's trusted-node mode instead"
assert_prose docs/admin/README.md '\(install\.md\)' "links the installation guide"

finish
