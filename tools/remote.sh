#!/usr/bin/env bash
# The git remote the gate and the pre-queue tools compare a branch with (`<remote>/dev`): bash tools/remote.sh prints
# its name. $PHOTOLIB_REMOTE if set, else the only remote the checkout has (this repository's is `arxiflex-dev`, a
# clone of a fork may have `origin`), else `origin` when it has none or several that include it. Several remotes
# without an origin are not guessed at: the script says to set PHOTOLIB_REMOTE and fails.
set -uo pipefail

if [[ -n ${PHOTOLIB_REMOTE:-} ]]; then
  echo "$PHOTOLIB_REMOTE"
  exit 0
fi
remotes=()
while IFS= read -r name; do remotes+=("$name"); done < <(git remote 2>/dev/null)
case ${#remotes[@]} in
  0) echo origin ;;
  1) echo "${remotes[0]}" ;;
  *)
    for name in "${remotes[@]}"; do
      [[ $name != origin ]] || { echo origin; exit 0; }
    done
    echo "remote.sh: ${remotes[*]} are remotes and none is origin: set PHOTOLIB_REMOTE to the one holding dev" >&2
    exit 1
    ;;
esac
