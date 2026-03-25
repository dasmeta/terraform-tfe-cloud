# Data Model: Terraform Cloud Agent Operator Module (agent-only)

## Primary Inputs
- `tfc_organization` (string): Terraform Cloud organization for provisioning pool/token resources.
- `name` (string): Stable identity for the Terraform Cloud agent pool/token and the Kubernetes agent enrollment identity.
- `replicas` (number, default `1`): Number of Kubernetes agent pods deployed for the workload.
- `helm` (object): Grouped Helm configuration (namespace/release settings, chart source, image settings, pod resources, and agent auto-update behavior).
- `extra_config` (any, optional): Additional Helm chart configuration appended last.

## Primary Managed Entities (Desired State)
- Terraform Cloud Agent Pool (`tfc-agent-pool`)
  - Identity key: `name`
- Terraform Cloud Agent Token (`tfc-agent-token`)
  - Identity key: `name` (linked to the created pool)
  - Sensitivity: token value is sensitive and must not be emitted.
- Kubernetes Agent Deployment (`helm_release` for `dasmeta/base`)
  - Identity key: Helm release name and namespace (from `helm` settings)
  - Scaling: replica count controlled by `replicas`
  - Pod resources: configured under `helm.resources`

## Relationships
- A single module deployment creates exactly one Agent Pool and one Agent Token.
- Kubernetes agent pods share the single token produced for the module deployment.
- `extra_config` modifies/overrides Helm configuration after the module-generated defaults.
