#!/usr/bin/env bash
# Fails when the protobuf module (default: proto) changes incompatibly (buf breaking) against the last release tag
# reachable from HEAD or, until the first tag exists, against <remote>/dev (tools/remote.sh). Run it from anywhere inside the checkout;
# CI needs the tags and <remote>/dev fetched (a full-history checkout).
set -euo pipefail

TOOLS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
MODULE=${1:-proto}

cd "$(git rev-parse --show-toplevel)"

if baseline=$(git describe --tags --abbrev=0 --match 'v[0-9]*' 2>/dev/null); then
  :
elif REMOTE=$(bash "$TOOLS/remote.sh") && git rev-parse --verify --quiet "refs/remotes/$REMOTE/dev" >/dev/null; then
  baseline=$REMOTE/dev
else
  echo "proto_breaking.sh: no release tag and no ${REMOTE:-origin}/dev to compare against; fetch them" \
    "(git fetch --tags ${REMOTE:-origin} dev)" >&2
  exit 1
fi

if ! git cat-file -e "$baseline:$MODULE/buf.yaml" 2>/dev/null; then
  echo "$baseline has no $MODULE/buf.yaml: nothing to compare"
  exit 0
fi

echo "comparing $MODULE with $baseline"
against=$(mktemp -d)
trap 'rm -rf "$against"' EXIT
# An exported copy, so that buf needs no git history of its own (worktrees, shallow clones).
git archive "$baseline" "$MODULE" | tar -x -C "$against"
bash "$TOOLS/buf.sh" breaking "$MODULE" --against "$against/$MODULE"
