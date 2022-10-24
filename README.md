# gh-action-last-successful-workflow-run

NOTE: **Experimental**

Github Action to find the last successful workflow run for the current branch

## Inputs

### `github-token`

The GITHUB_TOKEN secret used to access the Github API on your behalf

## Outputs

### `run-number`

The workflow run number

### `head-branch`

The head branch

### `head-commit-id`

The head commit id

### `head-commit-tree-id`

The head commit tree id

### `head-commit-message`

The head commit message

### `head-commit-timestamp`

The head commit timestamp

### `head-commit-author-name`

The head commit author name

### `head-commit-author-email`

The head commit author email

### `head-commit-committer-name`

The head commit committer name

### `head-commit-committer-email`

The head commit committer email

## Example usage

```yaml
uses: kristofferahl/gh-action-last-successful-workflow-run@v1
with:
  github-token: ${{ secrets.GITHUB_TOKEN }}
```
