# Implementation Plan: Workspace Settings Migration

**Branch**: `003-workspace-settings-migration` | **Date**: 2026-03-24 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/003-workspace-settings-migration/spec.md`

## Summary

Migrate deprecated workspace execution-mode and agent-pool affinity controls to supported settings resources, preserving current behavior and idempotency. The plan introduces explicit handling for unsetting execution mode and documents precedence between workspace-level settings and organization defaults.

## Technical Context

**Language/Version**: Terraform `~> 1.3`  
**Primary Dependencies**: `hashicorp/tfe` provider (`~> 0.74` target behavior), existing `local` and helper modules  
**Storage**: Terraform state only  
**Testing**: Existing repo Terraform scenarios plus targeted migration scenarios  
**Target Platform**: Terraform Cloud/Enterprise via `tfe` provider  
**Project Type**: Terraform module/repo for TFC workspace generation and management  
**Performance Goals**: No added churn on unchanged applies; migration remains deterministic and idempotent  
**Constraints**:
- Avoid deprecated direct workspace controls for execution mode and agent-pool affinity.
- Explicitly manage unset behavior to avoid leaving execution mode unintentionally unmanaged.
- Preserve compatibility for existing callers where possible.
**Scale/Scope**: Changes centered on `modules/workspace`, root `workspaces.tf`, docs, and tests.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Pre-design gate: PASS.
- Scope remains within module boundaries (`modules/workspace` + root wiring/docs/tests).
- Interface changes are additive or migration-safe and documented.
- Tests/examples will be updated with any behavior changes.
- No governance conflict detected.

Post-design gate: PASS.
- Design artifacts define migration behavior and test expectations.
- Breaking behavior is explicitly identified and handled with validation/rules.

## Project Structure

### Documentation (this feature)

```text
specs/003-workspace-settings-migration/
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
    ├── main.tf
    ├── variables.tf
    ├── locals.tf
    ├── README.md
    └── tests/

workspaces.tf
README.md
tests/
```

**Structure Decision**: Keep migration contained to current workspace module and wrapper wiring; avoid broad repo refactors.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | N/A | N/A |
