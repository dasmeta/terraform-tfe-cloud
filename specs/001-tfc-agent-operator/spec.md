# Feature Specification: Terraform Cloud Agent Operator Module

**Feature Branch**: `001-tfc-agent-operator`  
**Created**: 2026-03-20  
**Status**: Draft  
**Input**: User description: "Add an `agent` sub-module to `dasmeta/terraform-tfe-cloud` that provisions Terraform Cloud agent pools/tokens (via the `tfe` provider) and deploys agents into Kubernetes (via the `dasmeta/base` Helm chart) driven by top-level `name` + `replicas` (with shared `helm` configuration for Helm/image/pod resources)."

## Clarifications

### Session 2026-03-20

- Q: If an `AgentPool`/`AgentToken` is removed from the config, should the module delete/deregister it or leave it in place? → A: A
- Q: If configuration changes to an `AgentPool`/`AgentToken` require changing managed attributes, should the module update in place or replace affected resources? → A: B
- Q: For optional Terraform Cloud entity provisioning, should Workspace/Module/Project/RunsCollector be created globally for the module deployment or per agent pool/token? → A: N/A (not supported in this rewrite)
- Q: If the token credential is provided directly as an input value, should it be treated as sensitive to avoid leaking the raw credential in outputs/logs/state? → A: A (with sensitive input handling)
- Q: Should the `hcp-terraform-operator` chart version be automatically “latest”, pinned, or user-configurable? → A: N/A (operator removed in rewrite)
- Q: Should shared `dasmeta/resource` Helm chart configuration (repository/chart/version) be exposed as module variables, and should the sensitive token secret be passed using `helm_release set_sensitive`? → A: N/A (resource chart removed in rewrite)
- Q: Should module inputs group `operator_*` attributes and `resource_*` attributes into nested objects with `optional()` fields (central/shared configuration), while keeping `operator_api_token_value` as a standalone sensitive variable; and should the `agent_pools` workflow ensure that agents are actually created/deployed (not only CRs)? → A: N/A (inputs now driven by `agent`; operator-based workflow removed)
- Q: For the module inputs, should `name` be a required stable identity (rather than deriving identity from list order)? → A: A
- Q: Should the module be rewritten to remove `hcp-terraform-operator` and `dasmeta/resource`, using the `tfe` provider for Terraform Cloud agent pools/tokens and `dasmeta/base` Helm chart for agent deployments, driven by top-level `replicas` + shared `helm` configuration? → A: A
- Q: For `name`/`replicas`, should the module create exactly one TFC agent pool and one TFC agent token, with Kubernetes deployment replicas sharing that same token? → A: A
- Q: Should the module use a single identity (one `name` overall) rather than multiple agent identities? → A: A
- Q: Should we remove HPA entirely (use replicas only), default `replicas` to `1`, and set pod `resources` requests/limits to `500m/512Mi` by default (overrideable)? → A: A
- Q: Should `name` and `replicas` be used as top-level module inputs (instead of an `agent` object)? → A: yes
- Q: Should the module rename the `common` input object to `helm`, drop `base_` prefixes so chart fields become `chart_*`, and add `extra_config` (any type) that is appended last in the `helm_release` `values` list? → A: yes
- Q: Should the module stop injecting `TFC_AGENT_TOKEN` via `set_sensitive` and instead create/use a Kubernetes Secret and reference it through base chart secret-linking support? → A: yes

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.

  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - Provision Agent Pools and Tokens (Priority: P1)
Set up Terraform Cloud agents by defining agent pools and tokens in one Terraform Cloud module, so that teams can connect execution capacity running in their environment to Terraform Cloud.

**Why this priority**: This is the core capability of the `agent` module and enables other automation by ensuring agents can register and run Terraform workloads.

**Independent Test**: Deploy the module into a non-production environment with a minimal config containing one AgentPool and one AgentToken, then validate that the corresponding agent enrollment resources are created and that the resulting agent is available for Terraform Cloud operations.

**Acceptance Scenarios**:

1. **Given** no prior deployment and a config defining exactly one agent pool and one token, **When** the module is applied, **Then** the agent pool and token resources exist in the target environment and the Terraform Cloud agent enrollment completes successfully.
2. **Given** an existing deployment where `replicas` is set, **When** the module is applied, **Then** the Kubernetes agent workload is created/updated to match the requested replica behavior and the resulting enrolled agent(s) reach an available/enabled state.

---

### User Story 2 - Update Agent Configuration (Priority: P2)
Modify an existing deployment to adjust agent deployment configuration (replicas) and related pool/token settings when needed without creating duplicate enrollment resources.

**Why this priority**: Operational updates to agent capacity are common; the module must support safe iteration so users can manage agents over time.

**Independent Test**: Deploy once with an initial `name`/`replicas` configuration, then re-apply after changing `replicas`, and validate convergence with no unexpected duplicates.

**Acceptance Scenarios**:

1. **Given** an existing deployment and an updated `replicas` value, **When** the module is applied, **Then** the Kubernetes workload updates to match the new replica count and the Terraform Cloud enrollment resources converge without duplication.
2. **Given** an existing deployment, **When** the input is re-applied with no changes, **Then** the environment converges with no new duplicate agent enrollment resources created.

---

### User Story 3 - Optional Terraform Cloud Entity Provisioning (Priority: P3) (Not Supported)
Optional extra Terraform Cloud entity provisioning (Workspace/Module/Project/RunsCollector) is not supported in this rewrite.

**Why this priority**: N/A (optional entity provisioning is not implemented in this rewrite).

**Independent Test**: N/A (not supported; only core agent provisioning is available).

**Acceptance Scenarios**: N/A (optional entity provisioning is not supported).

---

This spec defines two user stories covering the MVP: core agent provisioning and update/idempotency (optional entity provisioning is not implemented in this rewrite).

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

- What happens when `name` is missing/empty or other required inputs are invalid (e.g., `replicas` missing)?
- What happens when a required token value/credential is missing or empty?
- How does the module behave when users provide invalid values (e.g., `replicas < 1`)? In this case, the module should fail validation and explain what needs to be corrected.
- How does the module surface failures when Terraform Cloud API calls fail (for pool/token provisioning) or when the Kubernetes agent Helm deployment fails? In this case, the deployment should fail with a clear, actionable error describing that convergence cannot proceed.
- What happens when `name`/`replicas` are removed/changed such that the corresponding TFC agent pool/token should no longer exist? In this case, the module should delete/deregister the corresponding resources so the target environment matches the new desired state.
- How does the module handle partial convergence (some resources succeed, others fail) so users can safely re-apply? In this case, a re-apply should converge to the desired final state without creating duplicates.
- How does the module behave when the requested agent pool/token configuration changes require replacement? In this case, the module should replace the affected resources so the target environment matches the new desired state.
- What happens if Kubernetes Secret creation or secret reference wiring fails while Terraform Cloud pool/token creation succeeds? In this case, the apply should fail clearly and a re-apply should reconcile to the intended state.

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
-->

### Functional Requirements
- **FR-001**: System MUST provision Terraform Cloud agent pool and agent token using the `tfe` provider, driven by top-level `name` + `replicas`.
- **FR-002**: System MUST deploy the Kubernetes-side agent workload using the `dasmeta/base` Helm chart, driven by top-level `replicas` + shared `helm` configuration (pod `resources` requests/limits).
- **FR-003**: System MUST expose top-level inputs `name` and `replicas` (defaulting to `1`) and shared `helm` configuration for Helm/image/pod `resources` (defaulting to cpu=500m and memory=512Mi).
- **FR-004**: System MUST ensure desired-state convergence and idempotency: re-applying unchanged inputs does not create duplicate TFC agent pool/token resources or duplicate Helm deployments, and removing/changing `name`/`replicas` deletes/deregisters the corresponding TFC resources and removes the associated K8s deployment.
- **FR-005**: System MUST treat TFC agent tokens as sensitive; token values MUST not be emitted in module outputs/logs and MUST be written to a Kubernetes Secret and consumed by the base chart via secret reference/linking (not as plain Helm `values` payload).
- **FR-006**: System MUST NOT attempt optional Terraform Cloud entity provisioning in this rewrite (extra entities are not part of the interface).
- **FR-007**: System MUST validate required `name`/`replicas` inputs and fail fast with clear, actionable error messages when inputs are missing or invalid.

**Assumptions**:
- Users provide all required identity/configuration inputs for the target Terraform Cloud organization/environment.
- The target environment has the necessary permissions to call Terraform Cloud APIs (for agent pool/token provisioning) and to install Helm charts in Kubernetes (for agent deployment).

**Acceptance coverage**:
- User Story 1 validates FR-001 through FR-004 (core agent provisioning).
- User Story 2 validates parts of FR-002/FR-003/FR-004 (safe updates + idempotency).
- Edge Cases validate FR-005 (input validation and actionable failure behavior).
- User Story 2 validates FR-007 (input validation and failure behavior).

### Key Entities *(include if feature involves data)*

- **TFC AgentPool**: Terraform Cloud execution capacity pool provisioned via the `tfe` provider for the configured `name` input.
- **TFC AgentToken**: Terraform Cloud enrollment credential provisioned via the `tfe` provider for the configured `name` input.
- **Kubernetes Secret**: Secret object holding `TFC_AGENT_TOKEN`, created/managed for the Helm deployment and referenced by the base chart.
- **Kubernetes Agent Deployment**: Helm-managed agent deployment created via the `dasmeta/base` chart driven by `replicas` + shared `helm` configuration.
- **Terraform Cloud Agent**: Enrolled agent(s) in Terraform Cloud resulting from Kubernetes agent deployments using the configured token(s).

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: In a fresh non-production environment, all configured AgentPool and AgentToken resources converge successfully and the corresponding Terraform Cloud agents become available within 15 minutes of applying the module.
- **SC-002**: Re-applying the module with unchanged inputs does not increase the number of agent enrollment resources (no duplicates) and completes without requiring manual cleanup.
- **SC-004**: For a set of test deployments (at least 5 representative scenarios), at least 90% of deployments succeed on the first attempt without manual intervention beyond providing valid input configuration.
