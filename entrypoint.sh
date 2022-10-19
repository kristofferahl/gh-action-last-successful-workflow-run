#!/usr/bin/env bash

set -eo pipefail

main() {
  [ "${GITHUB_REF:?'GITHUB_REF environment variable not set'}" ]
  [ "${GITHUB_REPOSITORY:?'GITHUB_REPOSITORY environment variable not set'}" ]

  declare -r github_token="${1:?'A github-token is required'}"
  declare workflow_runs
  declare last_successful_run

  export GITHUB_BRANCH_NAME="${GITHUB_REF#refs/heads/}"

  echo "Fetching workflow runs for branch \"${GITHUB_BRANCH_NAME:?}\""
  #shellcheck disable=SC2016
  #shellcheck disable=SC2154
  workflow_runs="$(curl --request GET \
    --url "https://api.github.com/repos/${GITHUB_REPOSITORY:?}/actions/runs" \
    --header "authorization: Bearer ${github_token:?}" \
    --header 'content-type: application/json')"

  echo "Finding last successful worflow run for branch \"${GITHUB_BRANCH_NAME:?}\""
  last_successful_run="$(echo "${workflow_runs:-}" | jq -r -c '[ .workflow_runs[] | select(.name == env.GITHUB_WORKFLOW and .head_branch == env.GITHUB_BRANCH_NAME and .status == "completed" and .conclusion == "success")] | first | { run_number, head_branch, status, conclusion, head_commit }')"
  echo "${last_successful_run:-}" | jq '.'

  if [[ ! -n "${last_successful_run:-}" ]]; then
    echo "Failed to locate a successful workflow run for branch \"${GITHUB_BRANCH_NAME:?}\""
    return 1
  fi

  declare run_number
  declare head_branch
  declare head_commit_id
  declare head_commit_tree_id
  declare head_commit_message
  declare head_commit_timestamp
  declare head_commit_author_name
  declare head_commit_author_email
  declare head_commit_committer_name
  declare head_commit_committer_email

  run_number="$(echo "${last_successful_run:-}" | jq -r '.run_number // empty')"
  head_branch="$(echo "${last_successful_run:-}" | jq -r '.head_branch // empty')"
  head_commit_id="$(echo "${last_successful_run:-}" | jq -r '.head_commit.id // empty')"
  head_commit_tree_id="$(echo "${last_successful_run:-}" | jq -r '.head_commit.tree_id // empty')"
  head_commit_message="$(echo "${last_successful_run:-}" | jq -r '.head_commit.message // empty')"
  head_commit_timestamp="$(echo "${last_successful_run:-}" | jq -r '.head_commit.timestamp // empty')"
  head_commit_author_name="$(echo "${last_successful_run:-}" | jq -r '.head_commit.author.name // empty')"
  head_commit_author_email="$(echo "${last_successful_run:-}" | jq -r '.head_commit.author.email // empty')"
  head_commit_committer_name="$(echo "${last_successful_run:-}" | jq -r '.head_commit.committer.name // empty')"
  head_commit_committer_email="$(echo "${last_successful_run:-}" | jq -r '.head_commit.committer.email // empty')"

  {
    echo "run-number=${run_number:-}"
    echo "head-branch=${head_branch:-}"
    echo "head-commit-id=${head_commit_id:-}"
    echo "head-commit-tree-id=${head_commit_tree_id:-}"
    echo "head-commit-message=${head_commit_message:-}"
    echo "head-commit-timestamp=${head_commit_timestamp:-}"
    echo "head-commit-author-name=${head_commit_author_name:-}"
    echo "head-commit-author-email=${head_commit_author_email:-}"
    echo "head-commit-committer-name=${head_commit_committer_name:-}"
    echo "head-commit-committer-email=${head_commit_committer_email:-}"
  } >>"${GITHUB_OUTPUT:?}"
}

main "$@"
