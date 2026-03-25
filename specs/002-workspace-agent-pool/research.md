# Research: Workspace Agent Pool Assignment

## Decision 1: Use agent pool name as identifier
- **Decision**: Resolve workspace assignment by `agent_pool_name` (name-based lookup), not by direct ID input.
- **Rationale**: Name-based assignment matches user intent and existing module ergonomics, and avoids exposing or requiring IDs in YAML/root configs.
- **Alternatives considered**:
  - Pass `agent_pool_id` directly: rejected due to poorer UX and less readable configuration.
  - Support both name and ID: rejected for now to reduce interface complexity and precedence ambiguity.

## Decision 2: Model group defaults as object with enable switch
- **Decision**: Group-level config uses `agent_pool = { name, enabled }`.
- **Rationale**: Explicit `enabled` supports safe toggling/disable behavior without deleting shared config blocks.
- **Alternatives considered**:
  - Single `agent_pool_name` group string: rejected because it cannot represent explicit disable state.
  - Nested complex policy object: rejected as unnecessary for current scope.

## Decision 3: Precedence and fallback strategy
- **Decision**: Effective assignment resolves as:
  1. workspace-level `agent_pool_name`
  2. group-level `agent_pool.name` when `enabled = true`
  3. unset (existing behavior)
- **Rationale**: Workspace-specific intent should override shared defaults, while preserving backward compatibility.
- **Alternatives considered**:
  - Group value always wins: rejected because it blocks per-workspace overrides.
  - Merge/conflict error: rejected due to unnecessary operational friction.

## Decision 4: Require wrapper passthrough wiring
- **Decision**: Root/wrapper module must pass workspace-level `agent_pool_name` into submodule `workspace` object unchanged.
- **Rationale**: Without explicit passthrough, feature appears supported in submodule but is unusable from primary root entrypoint.
- **Alternatives considered**:
  - Submodule-only support: rejected because wrapper is the normal integration path.
  - Introduce separate wrapper-only field name: rejected to avoid drift and mapping confusion.
