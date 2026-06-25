# Infra YAML Fetched Integration

## Why

`terraform-tfe-cloud` duplicated YAML discovery, shared-config merge, and
workspace filtering in `locals.tf`. That logic now lives in
`dasmeta/generic/renderer//modules/infra-yaml-fetched`.

The Terraform Cloud driver should consume the shared submodule and keep only
Terraform Cloud workspace orchestration in this repository.

## What

- call `infra-yaml-fetched` from registry version `1.1.1`
- remove duplicated YAML locals from the driver root module
- keep workspace module generation and Terraform Cloud resources unchanged

## Acceptance Criteria

- driver root module uses `dasmeta/generic/renderer//modules/infra-yaml-fetched`
- duplicated YAML merge/filter locals are removed from `locals.tf`
- existing workspace YAML examples continue to work without format changes
