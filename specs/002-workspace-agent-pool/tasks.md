---
description: "Task list for workspace agent pool assignment"
---

# Tasks: Workspace Agent Pool Assignment

**Input**: Design documents from `/specs/002-workspace-agent-pool/` (`spec.md`, `plan.md`)
**Prerequisites**: `plan.md` (required), `spec.md` (required for user stories), optional: `research.md`, `data-model.md`, `contracts/`
**Tests**: Use existing Terraform example/test scenarios to validate behavior and idempotency.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare shared schema and wiring prerequisites.

- [X] T001 Update `modules/workspace/variables.tf` to add optional workspace-level `agent_pool_name` input.
- [X] T002 Update root/group input schema (`variables.tf` and/or related group config object definitions) to support grouped `agent_pool = { name, enabled }`.
- [X] T003 [P] Update `modules/workspace/README.md` and root `README.md` input docs to describe new fields and precedence.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Implement effective value resolution and safe defaults used by all stories.

**⚠️ CRITICAL**: No user story work should be validated until this phase is complete.

- [X] T004 Implement effective agent-pool resolution logic in `modules/workspace/locals.tf` (workspace override > group enabled default > unset).
- [X] T005 Wire resolved value into workspace resource arguments in `modules/workspace/main.tf`.
- [X] T006 Add validation guards and clear errors for invalid/empty agent-pool names where assignment is enabled.
- [X] T007 Ensure backward compatibility path (no assignment when fields omitted) and no-op behavior remains unchanged.

**Checkpoint**: Foundation complete; user stories can be verified independently.

---

## Phase 3: User Story 1 - Assign Agent Pool To Workspaces (Priority: P1) 🎯 MVP

**Goal**: Associate managed workspaces with a configured agent pool by name.

**Independent Test**: Apply configuration with workspace-level `agent_pool_name` and verify assignment in managed workspace.

### Implementation for User Story 1

- [X] T008 [US1] Add/extend workspace-level example in `tests/basic/1-example.tf` (or nearest workspace test) using `agent_pool_name`.
- [X] T020 [US1] Ensure root/wrapper module passes workspace `agent_pool_name` into submodule `workspace.agent_pool_name` unchanged.
- [X] T009 [US1] Add/update assertions or verification guidance for workspace assignment behavior in scenario docs/comments.
- [X] T010 [US1] Confirm idempotent update path when changing `agent_pool_name` only.

**Checkpoint**: US1 is functional and independently testable.

---

## Phase 4: User Story 2 - Pass Group-Level Defaults (Priority: P2)

**Goal**: Allow grouped `agent_pool` defaults and workspace override precedence.

**Independent Test**: Apply with group `agent_pool = { name, enabled }` and mixed workspace overrides; verify precedence.

### Implementation for User Story 2

- [X] T011 [US2] Update `workspaces.tf` wiring to pass grouped agent-pool config into workspace module calls.
- [X] T012 [US2] Update/extend `tests/with-shared-configs/1-example.tf` to include group default plus one workspace override.
- [X] T013 [US2] Add scenario covering `enabled=false` behavior to ensure group default is not enforced when disabled.

**Checkpoint**: US1 + US2 both work and are independently verifiable.

---

## Phase 5: User Story 3 - Safe Validation And Error Feedback (Priority: P3)

**Goal**: Fail clearly for invalid agent-pool names and keep behavior deterministic.

**Independent Test**: Apply with invalid name and verify actionable error/no silent fallback.

### Implementation for User Story 3

- [X] T014 [US3] Add negative test scenario under `modules/workspace/tests/` (or root `tests/`) for invalid agent-pool name.
- [X] T015 [US3] Ensure error text clearly identifies invalid name source (workspace-level vs group-level).
- [X] T016 [US3] Document troubleshooting guidance in README for invalid/missing pool names.

**Checkpoint**: All three user stories are functional and independently testable.

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Final consistency, docs, and verification.

- [X] T017 [P] Update spec-linked artifacts if needed (`research.md`, `data-model.md`, `quickstart.md`) to reflect final field names.
- [X] T018 Run terraform validation for touched module/test paths and fix any lint/validation issues.
- [X] T019 Verify no regressions in existing workspace flows when agent-pool inputs are omitted.

---

## Dependencies & Execution Order

### Phase Dependencies

- Setup (Phase 1) -> Foundational (Phase 2) -> User Story phases (3-5) -> Polish

### Story Dependencies

- US1 depends on foundational completion.
- US2 depends on foundational completion and can build on US1 examples.
- US3 depends on foundational completion and can run after US1/US2 behavior is in place.

### Parallel Opportunities

- T003 and T017 can run in parallel with other non-conflicting documentation tasks.
- Validation tasks may run after implementation tasks complete.
