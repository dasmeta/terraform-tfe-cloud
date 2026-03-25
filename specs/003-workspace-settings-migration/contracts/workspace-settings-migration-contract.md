# Contract: Workspace Settings Migration

## Scope

Defines expected behavior for migrating workspace execution controls from deprecated direct workspace fields to supported settings resources.

## Inputs

- Workspace-level execution/agent-pool intent (including optional `agent_pool_name`).
- Organization-level default execution settings where applicable.
- Existing managed workspace state from prior applies.

## Resolution Rules

1. Effective execution and affinity settings are resolved through `tfe_workspace_settings`.
2. Workspace-level explicit settings take precedence over organization defaults.
3. If execution mode is unset and no agent pool is set, execution mode remains unset (`null`).
4. If agent pool is set, execution mode is forced to `agent`.
5. Agent-pool affinity is only set when execution settings are compatible.

## Validation Rules

- Deprecated direct workspace controls are not used for migrated behavior.
- Incompatible settings combinations must fail with actionable errors.
- Unclear unset transitions are rejected or normalized by explicit rule.

## Backward Compatibility

- Existing configurations remain functionally stable unless inputs explicitly request changes.
- Migration should avoid unexpected execution-mode flips on unchanged inputs.
- Re-apply with unchanged inputs is idempotent.
