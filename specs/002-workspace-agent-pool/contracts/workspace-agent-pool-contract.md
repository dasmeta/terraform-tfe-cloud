# Contract: Workspace Agent Pool Assignment

## Inputs
- Group-level optional agent pool object:
  - `name` (string)
  - `enabled` (bool)
- Workspace-level optional override:
  - `agent_pool_name` (string)

## Wrapper passthrough contract
- Root/wrapper module MUST pass workspace item `agent_pool_name` into workspace submodule `workspace.agent_pool_name`.
- Passthrough MUST preserve value (after existing null/trim handling in submodule), without replacing it with group value when workspace-level value is present.

## Resolution
- Effective agent pool for each workspace resolves by precedence:
  1. Workspace `agent_pool_name`
  2. Group `agent_pool.name` only when `enabled=true`
  3. No explicit assignment

## Validation
- Invalid/unknown agent-pool names must cause apply failure with actionable error.
- Empty string values are invalid when assignment is enabled.

## Backward compatibility
- Existing configurations that do not set agent-pool inputs must continue to behave as before.
