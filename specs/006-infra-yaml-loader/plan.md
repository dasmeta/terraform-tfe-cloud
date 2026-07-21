# Plan

1. Add `main.tf` with registry `infra_yaml_loader` module
   (`dasmeta/generic/renderer//modules/infra-yaml-loader` `1.2.1`).
2. Replace duplicated YAML locals with `module.infra_yaml_loader` outputs.
3. Add a repo-local empty-YAML regression test for the shared loader.
4. Validate existing workspace YAML examples and tests.

## Validation

- `terraform init` and `terraform validate` in workspace YAML tests
- `terraform init` and no-op `terraform plan` in `tests/empty-yaml`
- workspace generation from folder-based YAML layouts
