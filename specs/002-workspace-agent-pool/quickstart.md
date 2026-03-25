# Quickstart: Workspace Agent Pool Assignment

## Goal
Assign Terraform Cloud agent pools to managed workspaces using workspace-level override and group-level defaults.

## Example shape

```hcl
# group-level default
agent_pool = {
  name    = "shared-runner-pool"
  enabled = true
}

# workspace-level override
workspace = {
  name            = "app-prod"
  agent_pool_name = "dedicated-prod-pool"
}
```

## Verification
1. Apply configuration with group-level `agent_pool`.
2. Confirm workspaces without overrides receive the group pool.
3. Confirm workspaces with `agent_pool_name` use the override.
4. Confirm wrapper/root wiring passes workspace item `agent_pool_name` into submodule `workspace.agent_pool_name`.
5. Re-apply with no changes and verify idempotency (no unexpected updates).
