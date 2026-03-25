---
description: "Task list for Terraform Cloud agents module (agent-only)"
---

# Tasks: Terraform Cloud Agents Module

**Input**: Design documents from `/specs/001-tfc-agent-operator/` (`spec.md`, `plan.md`)
**Prerequisites**: `plan.md` (required), `spec.md` (required for user stories)
**Tests**: Include module examples/scenarios aligned to the spec’s independent user stories (no separate unit/contract test suite is required by this spec).

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [X] T001 Refactor `modules/agent/versions.tf` to use required providers (`tfe` + `helm`).
- [X] T002 Refactor `modules/agent/variables.tf` to implement the new interface:
  - top-level `name` + `replicas` inputs (with `replicas` defaulting to 1)
  - pod `resources` defaults/overrides with requests/limits defaulting to `500m/512Mi`
  - no optional extra entity provisioning in the agent-only rewrite
  - rename `common` -> `helm`, rename `base_chart_*` -> `chart_*`, and add `extra_config` passthrough appended at the end of `helm_release.values`
  - ensure the generated TFC agent token is treated as sensitive (not output) and injected into Helm via a sensitive-safe path
- [X] T003 Update `modules/agent/main.tf` wiring to remove operator/CR-based resources and instead:
  - provision TFC agent pool/token via `tfe`
  - deploy Kubernetes agent workload via `dasmeta/base` using Helm
- [X] T004 Update `modules/agent/output.tf` to expose only non-sensitive verification signals (pool/token IDs, helm release name, etc.).

---
## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

⚠️ CRITICAL**: No user story work can begin until this phase is complete

**Checkpoint**: Foundation ready - User Story 1 implementation can now begin.

- [X] T005 Implement TFC agent pool provisioning with `tfe` in `modules/agent/main.tf` (driven by `name`).
- [X] T006 Implement TFC agent token provisioning with `tfe` in `modules/agent/main.tf` (token value treated as `sensitive`).
- [X] T007 Implement Kubernetes agent deployment via `helm_release` using the shared `dasmeta/base` chart:
  - required `replicas` from `replicas`
  - configure pod `resources` (requests/limits) with defaults
  - create/store token in Kubernetes Secret and consume it via base chart secret linking
  - append `extra_config` as the last entry in `helm_release.values`
- [X] T008 Implement deterministic naming/addressing from `name` so idempotency + deletion semantics are correct:
  - removing/changing `name`/`replicas` removes the corresponding TFC resources
  - changing `replicas` updates the Helm deployment without creating duplicates

---
## Phase 3: User Story 1 - Provision Agents (Priority: P1) 🎯 MVP

**Goal**: A user can apply the module with a minimal `name`/`replicas` configuration and end up with:
- exactly one TFC agent pool
- exactly one TFC agent token
- a Helm-managed Kubernetes agent deployment scaled according to `replicas`

**Independent Test**: Apply the MVP scenario and manually verify that the TFC agents become available for Terraform Cloud operations.

### Implementation for User Story 1

- [X] T009 Add/modify MVP example scenario:
  - update `modules/agent/tests/mvp-agent-enrollment/0-setup.tf`
  - update `modules/agent/tests/mvp-agent-enrollment/1-example.tf`
- [X] T010 Update `modules/agent/README.md` with:
  - new `name`/`replicas` interface examples
  - verification steps to confirm agents become available in TFC
- [X] T011 Ensure `modules/agent` outputs include non-sensitive IDs/names that help verify convergence.

---
## Phase 4: User Story 2 - Update Replicas (Priority: P2)

**Goal**: Users can update scaling settings (replicas) safely and re-apply without duplicate enrollment resources.

**Independent Test**: Apply once with initial `name`/`replicas`, then re-apply after changing `replicas`; verify convergence and no duplicates.

### Implementation for User Story 2

- [X] T012 Update `modules/agent/tests/update-agent-pool-token/0-setup.tf` if needed for the new interface.
- [X] T013 Update `modules/agent/tests/update-agent-pool-token/1-example.tf` to change `replicas` only (token/pool identity stable unless `name` identity changes).
- [X] T014 Update README to describe what happens on `name`/`replicas` removal and scaling changes (expected behavior).

---
## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [X] T019 Update README + examples to reflect the new `name`/`replicas` interface and naming strategy.
- [X] T020 Add destroy/cleanup guidance for removing/changing `name`/`replicas` (pool/token deletion + helm deployment removal expectations).
