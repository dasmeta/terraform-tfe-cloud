# Implementation Plan

## Scope

Move both upstream pins to renderer 1.2.2 and align the Terraform version constraint
with the provider functions this driver emits, so the failure that forced the
downstream `handler_version` pin cannot recur silently.

## Current State

- `main.tf` pins the loader submodule at 1.2.1.
- `modules/workspace/main.tf` pins the renderer root module at 1.0.4 — a different
  tag of the same repository.
- `version.tf` and `modules/workspace/versions.tf` declare `~> 1.3` while the
  renderer calls `provider::deepmerge::mergo`.
- `locals.tf` consumes only `module.infra_yaml_loader.yaml_files`; the loader's
  `auto_detected_linked_workspaces` output is never read, yet it is still evaluated.
- Both `main.tf` files were found carrying local absolute-path source overrides from
  earlier debugging; they must be restored to registry pins.

## Steps

1. Restore `main.tf` and `modules/workspace/main.tf` from the index, discarding the
   local-path overrides.
2. Bump the loader pin to 1.2.2 in `main.tf`.
3. Bump the renderer pin to 1.2.2 in `modules/workspace/main.tf`.
4. Raise `required_version` to `~> 1.8` in the root module, `modules/workspace`, and
   the affected test roots; update README requirement and module tables.
5. Leave `modules/agent`, `modules/variable-set`, and `modules/variable-set-reader`
   at `~> 1.3`.
6. Validate the root module, `modules/workspace`, and the credential-free test
   harness.

## Validation

- Reviewed `v1.0.4..v1.2.2` in `terraform-renderer-generic`: the only root-module
  changes are the `~> 1.8` constraint and omitting the invalid `version` argument
  for local module sources.
- `terraform validate` — root module, `modules/workspace`, `tests/empty-yaml`
- `terraform plan` — `tests/empty-yaml` (no changes, no check warnings)
- `terraform fmt -check -recursive .`
- `pre-commit` hooks on commit, including `terraform_docs`
- Remaining harnesses (`tests/basic`, `kube-helm-provider`, `with-agent-pool`,
  workspace and agent module tests) create real HCP resources and were not run.

## Breaking Changes

Consumers on a Terraform version below 1.8 will now get an explicit version error
instead of a parse failure. That is the intended outcome: the module has needed 1.8
since it started emitting provider-defined functions.

No YAML contract change.

## Follow-Up

- Publish a new driver version, then remove the `handler_version: 2.5.3` pin
  downstream and declare any setup-to-cluster links explicitly.
- Consider exposing `terraform_version` on the `tfe_workspace` resource so managed
  workspaces stop inheriting the HCP organization default.
