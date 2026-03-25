# Implementation Plan: Workspace Agent Pool Assignment

**Branch**: `002-workspace-agent-pool` | **Date**: 2026-03-24 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/002-workspace-agent-pool/spec.md`

## Summary
Add agent-pool assignment support for managed Terraform Cloud workspaces with explicit wrapper passthrough:
- Support workspace-level `agent_pool_name` assignment by agent-pool name.
- Support grouped defaults via `agent_pool = { name, enabled }`.
- Enforce precedence: wrapper/workspace override > enabled group default > unset.
- Ensure root/wrapper module wiring passes `agent_pool_name` into workspace submodule `workspace` object.
- Preserve backward compatibility when no agent-pool fields are provided.

## Technical Context

**Language/Version**: Terraform `~> 1.3`  
**Primary Dependencies**: `hashicorp/tfe` provider resources/data sources  
**Storage**: Terraform state only  
**Testing**: Existing `tests/*` root scenarios + `modules/workspace/tests/*` module scenarios  
**Target Platform**: Terraform Cloud/Enterprise workspace APIs via `tfe` provider  
**Project Type**: Terraform infrastructure module  
**Performance Goals**: Correct mapping and idempotent reconciliation; no extra updates on unchanged input  
**Constraints**:
- Agent-pool reference uses **name** (clarified in spec).
- Wrapper passthrough is mandatory (`workspaces.tf` -> `workspace.agent_pool_name`).
- Existing consumers without new fields must continue to work unchanged.
**Scale/Scope**: Changes limited to root wrapper and workspace submodule schemas/wiring/tests/docs

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Gates pass:
- Module-scope change stays within `modules/workspace` plus root wrapper wiring and tests/docs.
- Interface changes are additive/optional with descriptions and validation.
- Tests/examples are updated to match behavior and precedence rules.
- No breaking interface removals are introduced.

## Project Structure

### Documentation (this feature)

```text
specs/002-workspace-agent-pool/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
modules/
└── workspace/
    ├── variables.tf
    ├── locals.tf
    ├── main.tf
    ├── README.md
    └── tests/

workspaces.tf
variables.tf
tests/
├── basic/
└── with-shared-configs/
```

**Structure Decision**: Implement effective agent-pool resolution in workspace module input/resource wiring and ensure explicit passthrough from wrapper/root module inputs.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | N/A | N/A |
