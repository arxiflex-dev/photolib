#!/usr/bin/env bash
# Checks a migrations directory (default: server/migrations) for what CI rejects and PostgreSQL cannot see: squawk's
# findings, and the release rules against <remote>/dev (tools/remote.sh), where a merged migration counts as released. A released
# migration and its upgrade fixtures (fixtures/<migration>.*) are never edited, renamed or deleted; a new migration is
# numbered above the newest released one; and a release branch (the pull request's target or the current branch is
# release/*) only carries migrations identical to main's.
#
# --renumber moves the new migrations and their fixtures above the newest released one first, keeping their order:
# run it after rebasing onto main, which is how migration numbers are assigned at merge time.
set -euo pipefail

TOOLS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
RENUMBER=0
if [[ ${1:-} == --renumber ]]; then
  RENUMBER=1
  shift
fi
DIR=${1:-server/migrations}

cd "$(git rev-parse --show-toplevel)"

REMOTE=$(bash "$(dirname "${BASH_SOURCE[0]}")/remote.sh") || exit 1
if ! git rev-parse --verify --quiet "refs/remotes/$REMOTE/dev" >/dev/null; then
  echo "migrations.sh: there is no $REMOTE/dev to compare $DIR with; fetch it (git fetch $REMOTE dev)" >&2
  exit 1
fi

FAILURES=0
reject() {
  echo "migrations.sh: $*" >&2
  FAILURES=$((FAILURES + 1))
}

released() { git ls-tree --name-only "$REMOTE/dev:$DIR" 2>/dev/null | grep -E '^[0-9]{4}_.+\.sql$' || true; }
released_fixtures() { git ls-tree --name-only "$REMOTE/dev:$DIR/fixtures" 2>/dev/null | sed 's|^|fixtures/|'; }
current() { (cd "$DIR" && ls -- *.sql 2>/dev/null) || true; }
is_released() { git cat-file -e "$REMOTE/dev:$DIR/$1" 2>/dev/null; }
same_as_main() { is_released "$1" && git show "$REMOTE/dev:$DIR/$1" | cmp -s - "$DIR/$1"; }

NEWEST=$(released | tail -n 1 | cut -c1-4)
NEWEST=${NEWEST:-0000}

if [[ $RENUMBER -eq 1 ]]; then
  next=$((10#$NEWEST))
  for file in $(current); do
    is_released "$file" && continue
    next=$((next + 1))
    renamed=$(printf '%04d_%s' "$next" "${file#*_}")
    if [[ $renamed != "$file" ]]; then
      mv "$DIR/$file" "$DIR/$renamed"
      for fixture in "$DIR/fixtures/${file%.sql}".*; do
        [[ -e $fixture ]] && mv "$fixture" "$DIR/fixtures/${renamed%.sql}.${fixture##*.}"
      done
      echo "renumbered $file to $renamed"
    fi
  done
fi

BRANCH=${GITHUB_BASE_REF:-${GITHUB_REF_NAME:-$(git rev-parse --abbrev-ref HEAD)}}
for file in $(current); do
  if [[ ! $file =~ ^[0-9]{4}_.+\.sql$ ]]; then
    reject "$file: a migration is named NNNN_description.sql"
  elif [[ $BRANCH == release/* ]]; then
    same_as_main "$file" || reject "$file: release branches only receive migrations identical to main's"
  elif ! is_released "$file" && [[ ! ${file:0:4} > $NEWEST ]]; then
    reject "$file: a new migration is numbered above the newest released one ($NEWEST); run tools/migrations.sh --renumber"
  fi
done
if [[ $BRANCH != release/* ]]; then
  for file in $(released) $(released_fixtures); do
    kind=migration
    [[ $file == fixtures/* ]] && kind=fixture
    if [[ ! -f $DIR/$file ]]; then
      reject "$file: a released $kind was renamed or deleted; released ${kind}s are immutable"
    elif ! same_as_main "$file"; then
      reject "$file: a released $kind was edited; released ${kind}s are immutable, so add a new migration"
    fi
  done
fi
duplicates=$(current | cut -c1-4 | uniq -d)
[[ -z $duplicates ]] || reject "two migrations share the number $duplicates"

mapfile -t files < <(current)
if [[ ${#files[@]} -gt 0 ]]; then
  bash "$TOOLS/squawk.sh" --config "$DIR/.squawk.toml" "${files[@]/#/$DIR/}" || reject "squawk found unsafe migrations"
fi

[[ $FAILURES -eq 0 ]] || exit 1
echo "migrations.sh: $DIR passes ($(current | wc -l) migrations, newest released $NEWEST)"
