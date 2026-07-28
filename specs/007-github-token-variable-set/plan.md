# Plan

1. Detect the YAML configuration that owns the `github` variable set.
2. Supply the raw token only to its Terraform Cloud workspace.
3. Render the workspace-owned `GITHUB_TOKEN` resource from that input.
4. Validate the root and affected child modules.
