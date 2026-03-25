# Implementation Plan: Terraform Cloud Agents Module (agent-only)

**Branch**: `001-tfc-agent-operator` | **Date**: 2026-03-20 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-tfc-agent-operator/spec.md`

## Summary
Rewrite the `agent` sub-module to be “agent-only” (remove operator/CR-based reconciliation):
- Use the `tfe` provider to provision exactly one Terraform Cloud agent pool and exactly one agent token per module deployment.
- Deploy the Kubernetes agent workload using the shared `dasmeta/base` Helm chart, driven by `replicas`.
- Configure agent pod `resources` (requests/limits), defaulting to cpu=500m and memory=512Mi.
- Allow `extra_config` to append additional Helm values at the end of the `helm_release.values` list.

The module must converge to the desired configuration:
- If `name`/`replicas` are removed/changed, Terraform must delete/deregister the corresponding Terraform Cloud resources and remove/update the Kubernetes agent deployment.
- Re-applying unchanged inputs must not create duplicates.

Security and reproducibility requirements:
- Terraform Cloud token values are treated as sensitive and must not be exposed via module outputs/logs.
- When injecting the token into the Helm chart, the implementation must use a sensitive-safe path (e.g., Helm `set_sensitive` or equivalent) rather than embedding raw values in the normal `values` payload.

## Technical Context

**Language/Version**: Terraform `~> 1.3` (repo baseline)
**Primary Dependencies**:
- `tfe` provider to create/destroy Terraform Cloud agent pool + agent token
- Helm provider to manage the `dasmeta/base` chart deployment for the Kubernetes agent workload
- `dasmeta/base` Helm chart (replicas)
**Storage**: N/A at feature level; token credentials must be treated as sensitive in Terraform state/outputs
**Testing**: Terraform module tests/examples following existing repo patterns in `modules/*/tests/*`
**Target Platform**: Kubernetes cluster + Helm access for `dasmeta/base`, plus Terraform Cloud org permissions
**Project Type**: Terraform infrastructure module (desired-state orchestration)
**Performance Goals**: Correctness and convergence; no explicit performance SLOs specified
**Constraints**:
- No operator/CR reconciliation dependency: the module itself drives both Terraform Cloud resources (via `tfe`) and Kubernetes agent deployment (via Helm).
- Sensitive token handling must be enforced (no raw token leakage in outputs/logs).
- Helm chart versioning must default to a pinned value for reproducible deployments.
**Scale/Scope**: Exactly one Terraform Cloud agent pool + one Terraform Cloud agent token per module deployment; Kubernetes scaling controlled by `replicas`

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Gates expected to pass (no known violations):
- Scope bounded to a new sub-module under `modules/agent/`
- Interface discipline: all inputs/outputs must have descriptions; token input marked sensitive
- Examples/tests must be added so deletion/replacement/idempotency semantics are verifiable
- No breaking changes to existing modules (new functionality is opt-in via a new sub-module)

## Project Structure

### Documentation (this feature)

```text
specs/001-tfc-agent-operator/
├── plan.md              # this file
├── research.md          # optional future planning output
├── data-model.md        # optional future planning output
├── quickstart.md        # optional future planning output
├── contracts/           # optional future planning output
└── tasks.md             # generated later by /speckit.tasks
```

### Source Code (repository root)

```text
modules/
└── agent/
    ├── README.md
    ├── versions.tf
    ├── variables.tf
    ├── locals.tf             # optional: if templating/normalization is needed
    ├── main.tf
    ├── output.tf / outputs.tf
    ├── templates/           # optional: if chart values/templates are needed
    ├── tests/
    │   └── <scenario>/
    │       ├── 0-setup.tf
    │       └── 1-example.tf
    └── playground/          # optional manual validation
```

**Structure Decision**: Create/maintain a single Terraform sub-module `modules/agent/` (mirroring `modules/workspace/` conventions) that:
- exposes top-level `name`/`replicas` plus a shared `helm` configuration,
- provisions Terraform Cloud agent pool/token via `tfe`,
- deploys Kubernetes agent workload via `dasmeta/base` Helm chart.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

N/A: bounded to a new sub-module under `modules/agent/`; no constitution complexity justification expected.
