#!/usr/bin/env bash
# Requires a Developer Certificate of Origin sign-off (see DCO and AGENTS.md) on every commit in a range.
#
#   tools/dco.sh <git-range>     e.g. <remote>/dev..HEAD
#
# A sign-off is a `Signed-off-by: Name <email>` trailer whose email is the commit's author or committer. Merge commits
# and commits authored by a GitHub bot account (Renovate and the like, which cannot certify anything) are exempt.
# Exit status: 0 every commit is signed off, 1 a commit is not, 2 usage or git error.
set -uo pipefail

SIGNOFF_RE='^Signed-off-by: [^<>]+ <([^<> @]+@[^<> @]+)>$'
BOT_RE='^([0-9]+\+)?[^@+ ]+\[bot\]@users\.noreply\.github\.com$'

# signed_off <sha>: true when the author is a bot, or a sign-off trailer carries the author's or the committer's email
signed_off() {
  local line emails
  emails=$(git log -1 --format='%ae%n%ce' "$1")
  [[ $(head -1 <<<"$emails") =~ $BOT_RE ]] && return 0
  while IFS= read -r line; do
    [[ $line =~ $SIGNOFF_RE ]] || continue
    grep -qixF -- "${BASH_REMATCH[1]}" <<<"$emails" && return 0
  done < <(git log -1 --format=%B "$1" | git interpret-trailers --parse)
  return 1
}

[[ $# -eq 1 && $1 != -* ]] || { echo "usage: tools/dco.sh <git-range>" >&2; exit 2; }
if ! shas=$(git rev-list --no-merges --end-of-options "$1" 2>&1); then
  echo "dco: cannot read range '$1': $shas" >&2
  exit 2
fi

status=0
for sha in $shas; do
  signed_off "$sha" && continue
  echo "$(git rev-parse --short "$sha"): no 'Signed-off-by: Name <email>' trailer with the author's or committer's email" >&2
  status=1
done
if [[ $status -ne 0 ]]; then
  echo "Every commit certifies the DCO (see DCO and AGENTS.md): sign off with 'git commit -s --amend'," >&2
  echo "or for several commits 'git rebase --signoff <base>', then push again." >&2
fi
exit $status
