---
description: "Task list for workspace settings migration"
---

# Tasks: Workspace Settings Migration

**Input**: Design documents from `/specs/003-workspace-settings-migration/`
**Prerequisites**: `plan.md` (required), `spec.md` (required), `research.md`, `data-model.md`, `contracts/`, `quickstart.md`
**Tests**: Use existing Terraform module/test scenarios and add migration-focused scenarios for deprecated field replacement, unset behavior, and idempotency.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare schemas/docs for migration-oriented inputs and scenarios.

- [X] T001 Update `specs/003-workspace-settings-migration/quickstart.md` verification flow with explicit baseline-before/after migration checks.
- [X] T002 [P] Add migration note section to `modules/workspace/README.md` describing behavior changes around execution-mode/affinity management.
- [X] T003 [P] Add/update root `README.md` section for organization defaults vs workspace settings precedence.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Implement core migration behavior and compatibility controls.

**⚠️ CRITICAL**: No user story validation should proceed before this phase is complete.

- [X] T004 Add/adjust `modules/workspace/variables.tf` inputs to model explicit execution-mode management intent and safe unset behavior.
- [X] T005 Implement migration locals in `modules/workspace/locals.tf` for effective workspace settings resolution and precedence.
- [X] T006 Refactor `modules/workspace/main.tf` to stop using deprecated direct workspace execution/affinity controls and use supported settings resources.
- [X] T007 Implement organization-default settings handling path (where applicable) in workspace/root wiring (`modules/workspace/main.tf`, `workspaces.tf`).
- [X] T008 Add validation/error paths for incompatible settings combinations and unclear unset transitions in `modules/workspace/variables.tf` and/or `locals.tf`.
- [X] T009 Ensure backward-compatible behavior for configs that do not use agent pools or do not provide new execution controls.

**Checkpoint**: Foundation complete; migration scenarios can be validated per story.

---

## Phase 3: User Story 1 - Migrate Deprecated Workspace Controls (Priority: P1) 🎯 MVP

**Goal**: Move execution-mode and agent-pool affinity behavior to supported settings controls without behavior regressions.

**Independent Test**: Apply migrated config for an agent-based workspace and verify behavior/affinity is controlled via supported settings path.

### Implementation for User Story 1

- [X] T010 [US1] Add/update migration example fixture under `tests/basic/example-infra/` with explicit agent-based workspace scenario.
- [X] T011 [US1] Update `tests/basic/1-example.tf` (or nearest scenario) to exercise migrated settings path.
- [X] T012 [US1] Add scenario guidance/assertions in test comments/docs confirming no deprecated direct controls are relied upon.
- [X] T013 [US1] Validate behavior-preserving migration for existing workspace state (no unintended mode flip).

**Checkpoint**: US1 is functional and independently testable.

---

## Phase 4: User Story 2 - Preserve Safe Defaults During Unset Operations (Priority: P2)

**Goal**: Ensure unsetting execution mode follows explicit deterministic migration rule.

**Independent Test**: Remove execution-mode input for an existing workspace and verify explicit managed outcome (no implicit fallback assumption).

### Implementation for User Story 2

- [X] T014 [US2] Add/update scenario fixture that transitions from explicit execution mode to unset input in `tests/` fixtures.
- [X] T015 [US2] Implement/verify explicit unset rule behavior in `modules/workspace/locals.tf` + `main.tf`.
- [X] T016 [US2] Add validation/error messaging for ambiguous unset requests in `modules/workspace/variables.tf`.
- [X] T017 [US2] Confirm idempotency after unset transition (re-apply unchanged config = no unexpected updates).

**Checkpoint**: US1 + US2 both work and are independently verifiable.

---

## Phase 5: User Story 3 - Clarify Organization vs Workspace Settings Ownership (Priority: P3)

**Goal**: Make precedence and ownership between org defaults and workspace settings explicit and testable.

**Independent Test**: Run one scenario with org defaults only and one with workspace override; verify precedence and outcome consistency.

### Implementation for User Story 3

- [X] T018 [US3] Add precedence-focused scenario under `tests/with-shared-configs/` (or nearest shared-config tests).
- [X] T019 [US3] Update `workspaces.tf` wiring for clear propagation of workspace-level vs default-setting intents.
- [X] T020 [US3] Document precedence and ownership in `README.md` and `modules/workspace/README.md` with migration-safe examples.
- [X] T021 [US3] Validate actionable error output when organization/workspace settings conflict.

**Checkpoint**: All three user stories are functional and independently testable.

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Final consistency and full validation.

- [X] T022 [P] Update `specs/003-workspace-settings-migration/contracts/workspace-settings-migration-contract.md` if implementation naming differs.
- [X] T023 Run Terraform formatting and validation for touched module and test paths; fix issues.
- [X] T024 Run regression check for workspace flows without agent pools or explicit execution-mode input.
- [X] T025 Verify quickstart end-to-end and adjust docs if verification steps differ from actual behavior.

---

## Dependencies & Execution Order

### Phase Dependencies

- Setup (Phase 1) -> Foundational (Phase 2) -> User Stories (Phases 3-5) -> Polish

### Story Dependencies

- US1 depends on foundational completion.
- US2 depends on foundational completion; can build atop US1 scenarios.
- US3 depends on foundational completion and wiring clarity from earlier phases.

### Parallel Opportunities

- T002 and T003 are parallel documentation updates.
- Within later phases, scenario-fixture tasks and docs tasks marked `[P]` can run in parallel when they do not touch same files.
