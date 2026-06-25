# Plan

1. Add `main.tf` with registry `infra_yaml_fetched` module
   (`dasmeta/generic/renderer//modules/infra-yaml-fetched` `1.1.1`).
2. Replace duplicated YAML locals with `module.infra_yaml_fetched` outputs.
3. Validate existing workspace YAML examples and tests.

## Validation

- `terraform init` and `terraform validate` in workspace YAML tests
- workspace generation from folder-based YAML layouts
