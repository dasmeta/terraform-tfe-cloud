# Feature Specification: Optional AWS Variable Set

**Feature Branch**: `004-aws-variable-set-optional`  
**Created**: 2026-03-24  
**Status**: Draft  
**Input**: User description: "lets implement this @dasmeta/terraform-tfe-cloud/variables.tf:77 @variable-sets.tf (3-5) so that aws creadentials variable set creation will be optional/configurable with default enabled=true"

## Clarifications

### Session 2026-03-24

- Q: How should existing Terraform state be handled when changing AWS variable set module addressing to optional/count-based resources? → A: Add root `moved {}` blocks in `moved.tf` to move state to indexed addresses (`[0]`) and avoid recreation.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Keep Current Default Behavior (Priority: P1)

As a platform engineer, I want AWS credentials variable set creation to stay enabled by default so existing setups continue to work without configuration changes.

**Why this priority**: Backward compatibility is critical for existing module consumers.

**Independent Test**: Apply configuration without setting any new AWS toggle input and verify AWS credentials variable set is still created.

**Acceptance Scenarios**:

1. **Given** a configuration that does not define an AWS enable toggle, **When** the module is applied, **Then** AWS credentials variable set is created as before.
2. **Given** an existing environment using default AWS settings, **When** it is re-applied after this feature, **Then** there is no unexpected change in behavior.

---

### User Story 2 - Allow Disabling AWS Variable Set Creation (Priority: P2)

As a platform engineer, I want to disable AWS credentials variable set creation when a repository does not use AWS so module output is cleaner and avoids unnecessary resources.

**Why this priority**: Optionality is needed for multi-cloud and non-AWS usage patterns.

**Independent Test**: Set AWS toggle to disabled, apply, and verify AWS credentials variable set is not created.

**Acceptance Scenarios**:

1. **Given** AWS toggle is explicitly disabled, **When** the module is applied, **Then** AWS credentials variable set is not created.

---

### User Story 3 - Keep Other Variable Set Flows Unaffected (Priority: P3)

As a platform engineer, I want non-AWS variable set behavior to remain unchanged so enabling optional AWS behavior does not break other module features.

**Why this priority**: Isolated change reduces regression risk and rollout complexity.

**Independent Test**: Apply with AWS disabled and verify other variable set behaviors continue to work as before.

**Acceptance Scenarios**:

1. **Given** AWS variable set creation is disabled, **When** module is applied, **Then** unrelated variable set resources still behave consistently.

### Edge Cases

- AWS toggle is provided but AWS credentials fields are still populated.
- AWS toggle is disabled in one environment and enabled in another with same module version.
- Existing state contains AWS variable set from earlier runs and toggle is later disabled.
- AWS toggle is omitted entirely by legacy callers.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST support an AWS configuration flag that controls whether AWS credentials variable set is created.
- **FR-002**: System MUST default AWS variable set creation control to enabled.
- **FR-003**: System MUST skip AWS credentials variable set creation when AWS creation control is disabled.
- **FR-004**: System MUST preserve existing behavior for callers that do not provide the new AWS creation control.
- **FR-005**: System MUST keep non-AWS variable set functionality unchanged regardless of AWS creation control value.
- **FR-006**: System MUST document the new AWS creation control and its default behavior.
- **FR-007**: System MUST include root-level Terraform `moved {}` blocks in `moved.tf` to migrate existing AWS variable set state to indexed addresses when introducing optional/count-based creation.

### Key Entities *(include if feature involves data)*

- **AWS Variable Set Config**: Input configuration controlling AWS credentials variable set behavior, including `enabled` and naming fields.
- **AWS Credentials Variable Set**: Optional variable set resource containing AWS credential variables for workspaces.
- **Root Module Consumer Config**: Caller-supplied root configuration that may or may not specify the new AWS toggle.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of existing caller configurations that omit the new AWS toggle retain previous behavior after upgrade.
- **SC-002**: 100% of test scenarios with AWS toggle disabled complete without creating AWS credentials variable set.
- **SC-003**: Re-applying unchanged configs with AWS toggle enabled or disabled results in no unexpected resource churn.
- **SC-004**: Module documentation includes a clear example for both enabled and disabled AWS variable set modes.
- **SC-005**: Existing state migrates without AWS variable set recreation in migration validation scenarios.

## Assumptions

- Existing users rely on current default creation behavior for AWS variable set.
- Optional AWS creation control is scoped only to AWS credentials variable set, not to other variable sets.
