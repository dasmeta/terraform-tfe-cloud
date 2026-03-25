# Research: Terraform Cloud Agent Operator Module (agent-only)

## What was researched
- How the Terraform Cloud agent “pool” and “token” are provisioned using the `tfe` provider.
- How the Kubernetes-side agent workload is deployed using the shared `dasmeta/base` Helm chart via `helm_release`.
- How to pass the Terraform Cloud agent token into the Helm chart securely.

## Findings
- Terraform Cloud execution capacity is represented by a Terraform Cloud agent pool; agent enrollment credentials are represented by a Terraform Cloud agent token.
- The Kubernetes-side agent workload is deployed as a Helm release of `dasmeta/base`, with its replica count controlled by the chart’s `replicaCount`.
- The token value must be treated as sensitive; the module should inject it into the chart using a sensitive-safe mechanism (for example, a `helm_release` `set_sensitive`-style path) rather than embedding the raw token into non-sensitive `values`.

## Relevant interface assumptions (from `spec.md`)
- The module is driven by top-level `name` and `replicas`.
- Helm configuration is grouped under the `helm` object.
- Additional Helm overrides can be appended via `extra_config`, applied last in the `helm_release.values` list.
