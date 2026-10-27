#!/usr/bin/env bash
# Enforces the Conventional Commits policy (see "Commits" in AGENTS.md).
#
#   tools/commitlint.sh <git-range>      lint every non-merge commit in the range, e.g. <remote>/dev..HEAD
#   tools/commitlint.sh --file <path>    lint a message file (commit-msg hook); '#' comment lines are ignored
#   tools/commitlint.sh --stdin          lint a message read from standard input
#
# Exit status: 0 all messages comply, 1 a message breaks the policy, 2 usage or git error.
set -uo pipefail

TYPES='feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert'
MAX_SUBJECT=72
SUBJECT_RE="^(${TYPES})(\\([a-z0-9][a-z0-9._/-]*\\))?!?: [^ ]"

usage() {
  echo "usage: tools/commitlint.sh <git-range> | --file <path> | --stdin" >&2
  exit 2
}

# lint_message <label> <message>: report every broken rule; non-zero when any rule is broken.
lint_message() {
  local label=$1 message=$2 subject second="" problems=()
  subject=${message%%$'\n'*}
  [[ $message == *$'\n'* ]] && { second=${message#*$'\n'}; second=${second%%$'\n'*}; }

  [[ $subject == "Merge "* ]] && return 0

  if [[ -z $subject ]]; then
    problems+=("the subject line is empty")
  else
    [[ $subject =~ $SUBJECT_RE ]] ||
      problems+=("subject must look like 'type(scope): summary' with type one of ${TYPES//|/, }")
    [[ ${#subject} -le $MAX_SUBJECT ]] ||
      problems+=("subject is ${#subject} characters; the limit is $MAX_SUBJECT")
    [[ $subject != *. ]] || problems+=("subject must not end with a period")
    [[ -z $second ]] || problems+=("the subject must be followed by a blank line")
  fi

  [[ ${#problems[@]} -eq 0 ]] && return 0
  printf '%s: %s\n' "$label" "${problems[0]}" >&2
  printf '  %s\n' "${problems[@]:1}" >&2
  return 1
}

lint_range() {
  local range=$1 shas sha status=0
  if ! shas=$(git rev-list --no-merges --end-of-options "$range" 2>&1); then
    echo "commitlint: cannot read range '$range': $shas" >&2
    exit 2
  fi
  for sha in $shas; do
    lint_message "$(git rev-parse --short "$sha")" "$(git log -1 --format=%B "$sha")" || status=1
  done
  return $status
}

finish() {
  if [[ $1 -ne 0 ]]; then
    echo "Commit messages follow Conventional Commits: 'type(scope): summary', at most $MAX_SUBJECT characters." >&2
    echo "See \"Commits\" in AGENTS.md." >&2
  fi
  exit "$1"
}

[[ $# -ge 1 ]] || usage
case "$1" in
  --stdin)
    [[ $# -eq 1 ]] || usage
    lint_message "message" "$(cat)"
    finish $?
    ;;
  --file)
    [[ $# -eq 2 ]] || usage
    [[ -r $2 ]] || { echo "commitlint: cannot read '$2'" >&2; exit 2; }
    lint_message "$2" "$(grep -v '^#' "$2")"
    finish $?
    ;;
  -*) usage ;;
  *)
    [[ $# -eq 1 ]] || usage
    lint_range "$1"
    finish $?
    ;;
esac
