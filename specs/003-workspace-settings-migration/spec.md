# Feature Specification: Workspace Settings Migration

**Feature Branch**: `003-workspace-settings-migration`  
**Created**: 2026-03-24  
**Status**: Draft  
**Input**: User description: "in latest 0.74.1 tfe provider version we have deprecations: setting execution mode and agent pool affinity directly on workspace is deprecated in favor of using both tfe_workspace_settings and tfe_organization_default_settings, with caution that unsetting execution_mode leaves prior value unmanaged instead of reverting to remote."

## Clarifications

### Session 2026-03-24

- Q: Should we avoid creating many Terraform `validation {}` blocks in variables and only add them when there is a special need? → A: Yes, default to no variable validation blocks unless there is a specific safety/compliance need.
- Q: Should we remove `manage_execution_mode` and simplify execution behavior? → A: Yes; remove it. Default `execution_mode` to `null` when unset, and force `agent` when `agent_pool_name` is set.

### Session 2026-03-25

- Q: Should we move additional shared workspace properties from `tfe_workspace` to `tfe_workspace_settings` (specifically `description` and `auto_apply`), while keeping `tag_names` on `tfe_workspace`? → A: Yes. Manage `description` and `auto_apply` via `tfe_workspace_settings` and remove the `count` gating conditional from that settings resource; keep `tag_names` on `tfe_workspace` since there is no similar `tag_names` option in `tfe_workspace_settings`.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Migrate Deprecated Workspace Controls (Priority: P1)

As a platform engineer, I want workspace execution mode and agent pool affinity to be managed through supported settings controls so that workspace management remains compatible with current provider behavior.

**Why this priority**: Deprecated behavior risks future breakage and unpredictable workspace state management.

**Independent Test**: Apply against a workspace with explicit agent-pool assignment and verify execution behavior remains controlled without using deprecated workspace fields.

**Acceptance Scenarios**:

1. **Given** a managed workspace configured for agent-based runs, **When** configuration is applied, **Then** execution behavior and agent pool assignment are controlled via supported settings resources.
2. **Given** an existing workspace previously relying on deprecated direct fields, **When** migration is applied, **Then** workspace behavior remains consistent and no unintended reset to remote execution occurs.

---

### User Story 2 - Preserve Safe Defaults During Unset Operations (Priority: P2)

As a platform engineer, I want safe handling when execution mode is unset so that prior settings are not accidentally left unmanaged without explicit intent.

**Why this priority**: Unset behavior changed and can silently leave prior values unmanaged, causing operational drift.

**Independent Test**: Remove explicit execution-mode input in a controlled scenario and verify module behavior is deterministic and documented.

**Acceptance Scenarios**:

1. **Given** a workspace where execution mode was previously set, **When** execution mode input is removed, **Then** module behavior follows an explicit safe rule and does not rely on implicit provider fallback.

---

### User Story 3 - Clarify Organization vs Workspace Settings Ownership (Priority: P3)

As a platform engineer, I want clear ownership boundaries between organization defaults and workspace-specific settings so that teams know where changes should be made.

**Why this priority**: Mixed ownership can cause conflicting expectations and accidental overrides.

**Independent Test**: Review one scenario with organization defaults and one with workspace override, then verify outcomes match documented precedence.

**Acceptance Scenarios**:

1. **Given** organization-level defaults and workspace-level explicit values, **When** both are present, **Then** documented precedence is applied consistently.

### Edge Cases

- A workspace has existing legacy execution mode values but no explicit new settings input.
- Agent pool is configured for a workspace that is not allowed by organization policy.
- Organization defaults change after workspace-specific settings were previously applied.
- Execution mode input is removed from configuration for an existing workspace.
- Migration is applied repeatedly with no input changes.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST stop relying on deprecated direct workspace execution-mode and agent-pool-affinity controls for managed workspaces.
- **FR-002**: System MUST manage workspace execution behavior through supported settings controls that align with current provider guidance.
- **FR-003**: System MUST manage organization-level default execution behavior through organization-default settings controls where applicable.
- **FR-004**: System MUST define deterministic precedence when both organization defaults and workspace-level settings exist.
- **FR-005**: System MUST define explicit behavior for execution-mode unsetting: leave `execution_mode` unset (`null`) unless `agent_pool_name` is set, in which case execution mode MUST be `agent`.
- **FR-006**: System MUST preserve existing workspace behavior during migration unless an explicit input change requests different behavior.
- **FR-007**: System MUST preserve compatibility for configurations that do not use agent pools.
- **FR-008**: System MUST provide actionable validation or error feedback when settings combinations are incompatible.
- **FR-009**: System MUST remain idempotent for unchanged inputs after migration.
- **FR-010**: System MUST avoid adding variable-level Terraform `validation {}` blocks by default; use them only for explicit safety/compliance-critical needs.

### Key Entities *(include if feature involves data)*

- **Workspace Settings**: Per-workspace execution behavior and affinity controls managed with supported settings resources.
- **Organization Default Settings**: Organization-wide defaults that apply when workspace-level overrides are absent.
- **Execution Mode State**: Effective run mode for a workspace, including explicit set, inherited default, and explicit unset handling.
- **Agent Pool Affinity**: Effective association between a workspace and eligible agent pool capacity.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of migrated workspace scenarios complete without using deprecated direct workspace execution-mode/agent-pool-affinity controls.
- **SC-002**: 100% of migration test scenarios preserve prior effective run behavior unless inputs explicitly request a change.
- **SC-003**: 100% of unchanged re-apply runs after migration result in no unexpected setting updates.
- **SC-004**: At least 95% of invalid settings combinations fail on first apply with actionable guidance.

## Assumptions

- Workspace-level settings remain the primary mechanism for explicit per-workspace behavior.
- Organization defaults are used only when workspace-level behavior is not explicitly set.
- Existing consumers expect backward-compatible behavior through migration.
