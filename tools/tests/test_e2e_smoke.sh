#!/usr/bin/env bash
# The server-and-client smoke (PHO-240, tools/e2e/server_client_smoke.sh): its harness waits only in bounded polls, stops
# what it started and cleans up after a failure, and names what it was waiting for. The real run needs photolibd,
# PostgreSQL and FFmpeg and is a step of the gate's `web` part; here every program is a stub.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

SMOKE=tools/e2e/server_client_smoke.sh
assert_file "$SMOKE"
check "the script is valid bash" bash -n "$REPO_ROOT/$SMOKE"

# No fixed sleeps, no unbounded loops: the only sleep is the 0.3 s step of wait_for and of cleanup's bounded loop, and
# every loop in the script is one of those or a for.
check "the only sleeps are polling steps" bash -c "! grep -E 'sleep [0-9]+($|[^.0-9])' '$REPO_ROOT/$SMOKE'"
check "there is no while loop and the one until loop is wait_for's" \
  bash -c "! grep -E '^\s*while ' '$REPO_ROOT/$SMOKE' && [[ \$(grep -cE '^\s*until ' '$REPO_ROOT/$SMOKE') == 1 ]]"
check "every curl has a time limit" bash -c "! grep -E 'curl -' '$REPO_ROOT/$SMOKE' | grep -vE -- '--max-time|^\s*#|curl -sS --max-time'"
check "no clock is read at the top of a file for a name" bash -c "! grep -E 'date \+' '$REPO_ROOT/$SMOKE'"

WORK=$(mktemp -d)
stop_stubs() {
  local pidfile
  for pidfile in "$WORK"/*/pid; do [[ -e $pidfile ]] && kill "$(cat "$pidfile")" 2>/dev/null; done
  rm -rf "$WORK"
}
trap stop_stubs EXIT
mkdir -p "$WORK/pgbin" "$WORK/ffmpeg" "$WORK/tmp" "$WORK/server"

# Stubs: a PostgreSQL that starts and stops, an FFmpeg, and a photolibd that runs and never listens.
cat >"$WORK/pgbin/initdb" <<EOF
#!/bin/bash
mkdir -p "\${@: -1}"
EOF
cat >"$WORK/pgbin/pg_ctl" <<EOF
#!/bin/bash
echo "\$*" >>"$WORK/pg_ctl.calls"
EOF
cat >"$WORK/pgbin/psql" <<EOF
#!/bin/bash
echo 0
EOF
printf '#!/bin/bash\nexit 0\n' >"$WORK/ffmpeg/ffmpeg"
cat >"$WORK/server/photolibd" <<EOF
#!/bin/bash
echo \$\$ >"$WORK/server/pid"
exec sleep 600
EOF
printf '#!/bin/bash\nexit 0\n' >"$WORK/server/photolib"
chmod +x "$WORK"/pgbin/* "$WORK"/ffmpeg/* "$WORK"/server/*

smoke() {
  env TMPDIR="$WORK/tmp" PG_BIN="$WORK/pgbin" FFMPEG_DIR="$WORK/ffmpeg" PHOTOLIBD="$WORK/server/photolibd" \
    PHOTOLIB="$WORK/server/photolib" SMOKE_WAIT=2 timeout 60 bash "$REPO_ROOT/$SMOKE" "$@"
}

capture smoke
expect_result "a photolibd that never listens fails the run" failure "timed out after 2s waiting for photolibd to listen"
check "the failure came before the 60 s hang guard" test "$STATUS" -ne 124
check "the PostgreSQL it started was stopped" grep -q 'immediate stop' "$WORK/pg_ctl.calls"
check "the photolibd it started was stopped" bash -c "! kill -0 \$(cat '$WORK/server/pid') 2>/dev/null"
check "its temporary directory is gone" bash -c "[[ -z \$(ls '$WORK/tmp') ]]"

capture env PG_BIN="$WORK/nowhere" TMPDIR="$WORK/tmp" FFMPEG_DIR="$WORK/ffmpeg" PHOTOLIBD="$WORK/server/photolibd" \
  PHOTOLIB="$WORK/server/photolib" timeout 60 bash "$REPO_ROOT/$SMOKE"
expect_result "without PostgreSQL's programs it says so" failure "no PostgreSQL programs"
check "and leaves no temporary directory" bash -c "[[ -z \$(ls '$WORK/tmp') ]]"

capture env PHOTOLIBD="$WORK/server/nope" PHOTOLIB="$WORK/server/photolib" PG_BIN="$WORK/pgbin" TMPDIR="$WORK/tmp" \
  FFMPEG_DIR="$WORK/ffmpeg" timeout 60 bash "$REPO_ROOT/$SMOKE"
expect_result "without a photolibd binary it says so" failure "photolibd and photolib are needed"

finish
