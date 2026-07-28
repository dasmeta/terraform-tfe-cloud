# GitHub token variable-set synchronization

## Why

The token supplied to MetaCloud created the Terraform Cloud VCS OAuth client,
but the GitHub provider variable set was independently managed. That allowed a
valid VCS token and a stale provider token to coexist.

## Requirements

- When MetaCloud is configured for GitHub with a raw personal access token, it
  MUST manage `GITHUB_TOKEN` in the existing `github` Terraform Cloud variable
  set.
- The variable MUST be an `env` variable and remain sensitive.
- OAuth token IDs and non-GitHub providers MUST remain unchanged.
- Tokens MUST NOT be rendered into generated repository files.

## Acceptance criteria

- Re-running MetaCloud updates the GitHub provider token without a manual
  Terraform Cloud edit.
- A workspace attached to the `github` variable set receives the current
  `GITHUB_TOKEN`.
