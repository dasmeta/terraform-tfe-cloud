# Contract: Terraform Cloud Agent Operator Module (agent-only)

## Interface Contract (inputs)
- `tfc_organization` (string): Terraform Cloud organization used for provisioning pool/token.
- `name` (string, required): Stable identity for pool/token and Kubernetes agent enrollment.
- `replicas` (number, default `1`): Kubernetes replica count for the agent workload.
- `helm` (object, default `{}`): Helm chart configuration grouped for the agent deployment.
- `extra_config` (any, optional): Additional Helm chart values appended last.

## Behavioral Contract (desired state convergence)
- The module creates exactly one Terraform Cloud agent pool and one Terraform Cloud agent token per module deployment.
- The Kubernetes agent workload uses the single token created by the module.
- Changing `replicas` updates the Kubernetes workload to match the new replica count without creating duplicate enrollment credentials.
- Changing/removing `name` replaces/deregisters the Terraform Cloud pool/token and updates/removes the Kubernetes workload accordingly.

## Security Contract
- The Terraform Cloud agent token value is sensitive and must not be output.
- Token injection into the Helm chart must use a sensitive-safe mechanism (not a non-sensitive `values` payload).

## Acceptance Checks (verifiable outcomes)
- Terraform Cloud pool/token exist after apply.
- Kubernetes pods from the Helm release become ready.
- Enrolled agent(s) show available/connected state in Terraform Cloud.
- Re-applying with no changes is idempotent (no unexpected duplicates).
