# Adopt Renderer 1.2.2

## Why

This driver is the one that failed in production. Release 2.5.9 could not plan in
HCP Terraform, and the workaround was pinning `handler_version: 2.5.3` downstream.
Two upstream defects caused it, both fixed by renderer 1.2.2.

**Provider-defined functions.** The renderer root module calls
`provider::deepmerge::mergo`, which Terraform supports only from 1.8. This driver
declared `required_version = "~> 1.3"`, so an HCP workspace on 1.3.0 failed while
**parsing** the module rather than reporting an unsupported Terraform version.

**Directory-inferred linking.** Loader 1.2.1 aborts evaluation for any workspace
path matching a hardcoded convention (`2-products/<product>/<cluster>/setups/<name>`)
by interpolating `regex()` capture lists into a string:

```
Error: Invalid template interpolation value
  Cannot include the given value in a string template: string required, but have tuple.
```

Notably this driver never reads the loader's `auto_detected_linked_workspaces` — it
uses the explicit `linked_workspaces` list plus the renderer's own per-workspace
interpolation detection. The plan still failed, because unused module outputs are
evaluated anyway.

This driver also carried **two pins to the same upstream repository**: the loader
submodule at 1.2.1 and the renderer root module at 1.0.4, so two tags were
downloaded side by side.

## What

- Bump both upstream pins to **1.2.2**: the loader in `main.tf` and the renderer in
  `modules/workspace/main.tf`.
- Raise `required_version` to `~> 1.8` for the root module and `modules/workspace`.
  `modules/agent`, `modules/variable-set`, and `modules/variable-set-reader` keep
  `~> 1.3` — they use no provider functions and are usable standalone.
- Add `AGENTS.md`, a diagnostic guide for this driver.

## Acceptance Criteria

- both pins reference the same upstream release
- no workspace path can abort evaluation, whatever the directory layout
- a workspace on a Terraform version below 1.8 reports an unsupported version
  instead of failing to parse
- explicit `linked_workspaces` and interpolation-detected references still generate
  `tfe_outputs` data blocks and rewritten variable values
- module code and README requirement tables agree on the version constraints

## Notes

- Renderer 1.0.4 to 1.2.2 changes exactly one thing in generated output: a local
  module source no longer emits an invalid `version` argument.
- The `tfe_workspace` resource still does not set `terraform_version`, so a managed
  workspace inherits the HCP organization default — which is what placed the failing
  workspace on 1.3.0. Raising this module's own constraint turns that into a clear
  error, but exposing the field would let the module fix it outright. Out of scope
  here; worth a follow-up.
- No YAML contract change for consumers. A repository that relied on the implicit
  setup-to-cluster link must declare it, as every other managed repository does.
- Most test harnesses in this repo create real HCP resources and need credentials,
  so validation here is `terraform validate` plus the credential-free `empty-yaml`
  harness.
