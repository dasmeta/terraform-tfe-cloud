# GitHub token variable-set synchronization

## Why

The token supplied to MetaCloud creates the Terraform Cloud VCS OAuth client,
but the YAML-managed GitHub provider variable set did not receive it. That
allowed a valid VCS token and a stale provider token to coexist.

## Requirements

- When MetaCloud is configured for GitHub with a raw personal access token, it
  MUST pass that token only to the YAML-managed `github` variable-set workspace.
- The workspace MUST write `GITHUB_TOKEN` as a sensitive `env` variable.
- OAuth token IDs and non-GitHub providers MUST remain unchanged.
- Tokens MUST NOT be rendered into generated repository files.

## Acceptance criteria

- Re-running MetaCloud supplies the current token to the YAML workspace.
- Re-running that workspace updates `GITHUB_TOKEN` without a manual Terraform
  Cloud variable edit.
