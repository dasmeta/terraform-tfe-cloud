# Data Model: Workspace Settings Migration

## Entities

- **Workspace Configuration**
  - Existing workspace input object consumed by module.
  - Relevant attributes:
    - `agent_pool_name` (optional)
    - execution-mode related input (explicit or derived from compatibility logic)
  - Purpose: drives effective settings for each managed workspace.

- **Workspace Settings State**
  - Effective per-workspace execution behavior after apply.
  - Attributes:
    - effective execution mode
    - effective agent pool affinity
    - whether value is explicitly managed or inherited

- **Organization Default Settings**
  - Organization-level defaults used where workspace does not explicitly override.
  - Attributes:
    - default execution mode policy
    - compatible defaults for agent-based execution controls

- **Migration Compatibility Rule**
  - Policy object representing behavior-preserving transitions.
  - Attributes:
    - old behavior source
    - new settings target
    - explicit rule for unset execution mode handling

## Relationships

- Workspace Configuration -> Workspace Settings State (one-to-one effective result).
- Organization Default Settings -> Workspace Settings State (fallback/inheritance path).
- Migration Compatibility Rule constrains updates from prior state to new managed state.

## Validation Rules

- Agent-pool assignment must only be applied when execution settings are compatible with agent-based runs.
- Unsetting execution mode must follow an explicit module rule; no silent implicit fallback assumptions.
- Incompatible combinations fail with actionable validation messages.
- Reapplying unchanged inputs must not alter effective settings state.
