# Workspace Module Shared Renderer Integration

## Why

`terraform-tfe-cloud/modules/workspace` currently mixes two responsibilities:

- generic Terraform file rendering
- Terraform Cloud-specific workspace orchestration

That makes the module harder to share with other drivers and duplicates logic
that now belongs in `terraform-renderer-generic`.

## What

Refactor `modules/workspace` into a Terraform Cloud-specific wrapper that uses
`terraform-renderer-generic` through a local relative source path for generic
rendering.

The workspace module should keep only:

- `tfe_*` resources
- Terraform Cloud project/workspace/agent pool/variable set logic
- Terraform Cloud-specific linked-output data source behavior
- Terraform Cloud-specific metadata/defaults that should not live in the shared
  renderer

## Design

### Wrapper Boundary

`modules/workspace` should normalize its Terraform Cloud-specific inputs, derive
any TFC-specific linked-workspace mappings, and pass the generic rendering
payload to `terraform-renderer-generic`.

### Shared Interface

The workspace module should consume the shared renderer through its grouped
`module_config` interface rather than maintaining local parallel generic file
templates.

### Validation

The existing workspace-focused tests must continue to prove behavior, especially:

- `tests/yaml-conf-and-workspace-link`
- `tests/with-agent-pool`

## Acceptance Criteria

- `modules/workspace` no longer owns parallel generic rendering templates as the
  primary implementation path
- the module consumes `terraform-renderer-generic` via a local relative path
- Terraform Cloud-specific resources and behavior remain in `modules/workspace`
- the existing workspace tests still validate successfully
