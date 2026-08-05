# Tasks

- [x] Restore `main.tf` and `modules/workspace/main.tf` from local absolute-path overrides.
- [x] Bump the `infra-yaml-loader` pin to 1.2.2.
- [x] Bump the renderer root pin in `modules/workspace` from 1.0.4 to 1.2.2.
- [x] Raise `required_version` to `~> 1.8` for the root module and `modules/workspace`.
- [x] Leave `modules/agent`, `modules/variable-set`, `modules/variable-set-reader` at `~> 1.3`.
- [x] Update README requirement and module tables.
- [x] Validate the root module, `modules/workspace`, and `tests/empty-yaml`.
- [x] Add `AGENTS.md` diagnostic guide.
- [ ] Publish a new driver version after merge to `main`.
- [ ] Remove the downstream `handler_version: 2.5.3` pin once the release is available.
- [ ] Evaluate exposing `terraform_version` on the `tfe_workspace` resource.
