# Feature Specification: Workspace Agent Pool Assignment

**Feature Branch**: `002-workspace-agent-pool`  
**Created**: 2026-03-23  
**Status**: Draft  
**Input**: User description: "lets add ability to set agent pool for workspaces we create/manage here @main.tf (14-15) and allow to pass the group config here: @workspaces.tf (1-3)"

## Clarifications

### Session 2026-03-23

- Q: Which identifier should workspace/group configuration use for agent pool assignment (ID, name, or both)? → A: Use agent pool **name**.
- Q: How should group-level agent-pool configuration be modeled? → A: Use grouped object with `name` and `enabled`.
- Q: Should the root/wrapper module explicitly pass `agent_pool_name` into the workspace submodule `workspace` object? → A: Yes, wrapper passthrough is required.

### Session 2026-03-24

- Q: How should module behavior handle provider constraints that `agent_pool_id` requires agent execution mode and must not be combined with incompatible operations settings? → A: When assignment is set, enforce agent execution-mode compatibility in module-managed workspace settings.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Assign Agent Pool To Workspaces (Priority: P1)

As a platform engineer managing Terraform Cloud workspaces through this module, I want to assign each managed workspace to a specific agent pool so that runs execute on the intended private worker capacity.

**Why this priority**: Correct agent routing is a core operational requirement for managed workspaces; without it, runs may execute in an unintended environment.

**Independent Test**: Create or update one workspace with an explicit agent pool assignment and verify the workspace reflects that assignment.

**Acceptance Scenarios**:

1. **Given** an existing agent pool and a workspace configuration that includes an agent-pool name reference, **When** the module is applied, **Then** the managed workspace is associated with that agent pool.
2. **Given** a managed workspace already assigned to one agent pool, **When** the workspace configuration is updated to a different valid pool, **Then** the workspace assignment changes to the new pool without creating duplicate workspaces.
3. **Given** a workspace item includes `agent_pool_name` in wrapper/root input, **When** the wrapper module calls the workspace submodule, **Then** `workspace.agent_pool_name` is passed through unchanged.
4. **Given** an effective agent-pool assignment is set, **When** workspace settings are reconciled, **Then** execution-mode/operations settings are kept compatible with agent-pool assignment requirements.

---

### User Story 2 - Pass Group-Level Defaults (Priority: P2)

As a platform engineer using grouped workspace configuration in root module wiring, I want to pass agent-pool settings through group-level configuration so that multiple workspaces can inherit a shared default without repeating values.

**Why this priority**: Group-level defaults reduce repetition and misconfiguration risk when many workspaces should share the same execution policy.

**Independent Test**: Provide group-level configuration including agent-pool assignment, apply, and verify all target workspaces receive the expected assignment unless explicitly overridden.

**Acceptance Scenarios**:

1. **Given** a group configuration with an agent-pool object (`name`, `enabled`) and multiple workspace items in that group, **When** the module is applied, **Then** each workspace in the group is assigned to the configured pool when `enabled` is true.
2. **Given** a workspace that explicitly sets a different pool than its group default, **When** the module is applied, **Then** the workspace-level value takes precedence over the group default.

---

### User Story 3 - Safe Validation And Error Feedback (Priority: P3)

As a platform engineer, I want clear validation and error behavior for invalid or missing agent-pool references so that failed applies are easy to diagnose and correct.

**Why this priority**: Predictable failures and actionable errors reduce operational delays and accidental drift.

**Independent Test**: Apply with an invalid agent-pool reference and verify the operation fails with a clear error and no silent fallback behavior.

**Acceptance Scenarios**:

1. **Given** a workspace or group configuration with an invalid agent-pool reference, **When** the module is applied, **Then** the apply fails with a clear error indicating the invalid reference.

### Edge Cases

- What happens when both group-level and workspace-level agent-pool settings are omitted? In this case, behavior should remain compatible with current defaults and must not break existing workspace management flows.
- What happens when group-level agent-pool object has `enabled=false` but `name` is set? In this case, the assignment should be treated as disabled and no pool should be enforced from group defaults.
- What happens when a referenced agent pool is removed outside of this module? In this case, apply should fail with actionable feedback rather than silently clearing assignment.
- How does the system behave when only some workspaces in a group override the group default? In this case, inheritance and overrides should be deterministic and consistent across applies.
- How does the system handle re-apply with no changes to agent-pool settings? In this case, apply should be idempotent and produce no unexpected updates.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow managed workspaces to be associated with an agent pool through module inputs using agent-pool **name**.
- **FR-002**: System MUST support passing grouped agent-pool configuration (`name`, `enabled`) from grouped/root-level workspace configuration into workspace module calls.
- **FR-008**: System MUST ensure root/wrapper module wiring passes workspace-level `agent_pool_name` into the workspace submodule `workspace` object.
- **FR-003**: System MUST define deterministic precedence when both group-level and workspace-level agent-pool settings exist, with workspace-level taking priority.
- **FR-004**: System MUST preserve backward-compatible behavior for configurations that do not define agent-pool settings.
- **FR-005**: System MUST validate agent-pool name references and fail with clear, actionable errors when names are invalid or unavailable.
- **FR-006**: System MUST keep workspace reconciliation idempotent; repeated applies with unchanged inputs must not cause unnecessary workspace updates.
- **FR-007**: System MUST allow updating agent-pool assignment on existing managed workspaces through normal apply flows.
- **FR-009**: System MUST ensure that when an agent-pool assignment is set, module-managed workspace settings remain compatible with agent execution-mode constraints and do not use incompatible operations configuration.

### Key Entities *(include if feature involves data)*

- **Workspace Configuration**: Input object representing a managed workspace and its properties, including optional workspace-level agent-pool assignment.
- **Workspace Group Configuration**: Higher-level grouping input that can provide default settings, including an agent-pool object with `name` and `enabled`, to member workspaces.
- **Agent Pool Reference**: Agent-pool **name** used to associate a workspace with a Terraform Cloud agent pool.
- **Managed Workspace**: Terraform Cloud workspace resource managed by the module and reconciled from effective configuration.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of newly created workspaces configured with agent-pool settings are associated with the intended pool after apply.
- **SC-002**: 100% of workspace updates that change only agent-pool assignment complete without creating duplicate workspaces.
- **SC-003**: At least 95% of invalid agent-pool configurations fail with actionable error messages on the first apply attempt.
- **SC-004**: Re-applying unchanged workspace/group configuration results in zero unexpected workspace modifications in validation scenarios.
