# Quickstart: Terraform Cloud Agent Operator Module (agent-only)

## Goal
Deploy a single Terraform Cloud agent pool + token and run the corresponding agent workload in Kubernetes.

## Prerequisites
- Access to Terraform Cloud for the target `tfc_organization`.
- Permissions to install the `dasmeta/base` Helm chart into your Kubernetes cluster/namespace.

## Minimal Example
```hcl
module "agent" {
  source = "dasmeta/cloud/tfe//modules/agent"

  tfc_organization = "your-tfc-org"
  name             = "agent-demo"
  replicas         = 1
}
```

## Verification (manual)
1. Apply the configuration.
2. Confirm the Terraform Cloud agent pool and token exist.
3. Confirm the Kubernetes agent pods are running under the Helm release.
4. Confirm the enrolled agent(s) are available for Terraform Cloud operations.

## Common Customizations
- Increase Kubernetes agent capacity by changing `replicas`.
- Tune pod sizing by overriding `helm.resources.requests/limits` (defaults: cpu `500m`, memory `512Mi`).
- Override Helm chart settings via `helm` and/or apply additional values via `extra_config`.
