# Data Model: Workspace Agent Pool Assignment

## Entities

- **Workspace Group Config**
  - Represents shared defaults for a set of workspaces.
  - New optional field:
    - `agent_pool.name` (string)
    - `agent_pool.enabled` (bool)

- **Workspace Config**
  - Represents a single managed workspace item.
  - New optional field:
    - `agent_pool_name` (string) as explicit override
  - Wrapper passthrough requirement:
    - Root/wrapper must map workspace item `agent_pool_name` into submodule input `workspace.agent_pool_name` unchanged.

- **Effective Workspace Agent Pool**
  - Computed value used by workspace resource reconciliation.
  - Precedence:
    1. Workspace-level `agent_pool_name`
    2. Group-level `agent_pool.name` when `agent_pool.enabled=true`
    3. Unset (existing default behavior)

## Validation rules
- If configured name is empty/invalid, apply fails with actionable error.
- Group-level `enabled=false` disables group default even if `name` is provided.
