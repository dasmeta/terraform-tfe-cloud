# Implementation Plan: Optional AWS Variable Set

**Branch**: `004-aws-variable-set-optional` | **Date**: 2026-03-24 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/004-aws-variable-set-optional/spec.md`

## Summary

Add optional/configurable creation for the AWS credentials variable set with default enabled behavior preserved, and introduce root `moved {}` state migration blocks so existing state is moved to indexed addresses (`[0]`) without resource recreation.

## Technical Context

**Language/Version**: Terraform `~> 1.3`
**Primary Dependencies**: `hashicorp/tfe` provider, existing local module graph (`modules/variable-set`)
**Storage**: Terraform state
**Testing**: Existing root test scenarios (`tests/*`) plus migration-safe validation run
**Target Platform**: Terraform Cloud-managed resources via root module
**Project Type**: Terraform root/module repository
**Performance Goals**: No unexpected resource churn on unchanged applies
**Constraints**:
- AWS variable set creation must remain enabled by default.
- Must support disabling AWS variable set creation.
- Must avoid AWS variable set recreation during migration by using `moved {}` blocks in root `moved.tf`.
**Scale/Scope**: Root module inputs/resources/docs/tests for AWS variable set creation toggling.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Pre-design gate: PASS.
- Change scope remains in root module and related docs/tests.
- Interface is additive (`aws.enabled`) with backward-compatible default.
- Migration requirement explicitly handled via `moved {}` blocks.

Post-design gate: PASS.
- Design artifacts include migration path and compatibility guarantees.
- No unapproved breaking behavior introduced.

## Project Structure

### Documentation (this feature)

```text
specs/004-aws-variable-set-optional/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
variables.tf
variable-sets.tf
moved.tf
README.md
tests/
└── ...
```

**Structure Decision**: Implement in root module where AWS variable set module is declared; keep migration state moves explicit in root `moved.tf`.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | N/A | N/A |
