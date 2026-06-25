# Plan

1. Add `main.tf` with registry `infra_yaml_fetched` module
   (`dasmeta/generic/renderer//modules/infra-yaml-fetched` `1.1.0`).
2. Replace duplicated YAML locals with `module.infra_yaml_fetched` outputs.
3. Add optional `yaml_files` input for nested local development.
4. Validate existing workspace YAML examples and tests.

## Validation

- `terraform init` and `terraform validate` in workspace YAML tests
- workspace generation from folder-based YAML layouts
