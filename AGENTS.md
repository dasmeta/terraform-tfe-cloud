# AGENTS.md — terraform-tfe-cloud

Diagnostic guide for AI agents and engineers debugging this driver or a setup that
consumes it. Hand-maintained; keep the symptom table honest and evidence-based.

## What this repo is

The HCP Terraform (Terraform Cloud) driver: it turns a repository of workspace YAML
into HCP workspaces plus the generated Terraform files each workspace runs. Unlike
the CLI drivers it also creates **real remote resources** — workspaces, projects,
variable sets, OAuth clients, agent pools.

```
YAML ──▶ infra-yaml-loader ──▶ locals.yaml_files ──▶ modules/workspace ──┬─▶ renderer ──▶ main.tf, versions.tf,
         (registry submodule)   (this repo)          (per workspace)     │               providers.tf, outputs.tf
                                                                        ├─▶ tfe_workspace, tfe_project
                                                                        └─▶ variable sets, agent pool binding
```

- **`modules/workspace`** — per workspace: calls `dasmeta/generic/renderer` for the
  Terraform files and manages the `tfe_workspace` itself.
- **`modules/variable-set`, `modules/variable-set-reader`, `modules/agent`** —
  independently usable; no provider functions, deliberately kept at `~> 1.3`.
- Discovery and shared-config merge are **not** in this repo. They live in
  `dasmeta/generic/renderer//modules/infra-yaml-loader` — see that repo's `AGENTS.md`
  for the YAML contract and loader-stage symptoms.

**Two Terraform versions are in play.** The version running *this* module (the
management workspace) and the version each *generated* workspace runs. They are set
in different places and confusing them is the most common wasted hour here.

## Linked workspaces

This driver reads the explicit YAML `linked_workspaces` list and passes it to the
renderer as `linked.setups`. The renderer additionally detects `${path.output}`
references per workspace and rewrites them to `data.tfe_outputs[...]`. So the YAML
attribute is optional when the value is referenced anyway.

It does **not** read the loader's `auto_detected_linked_workspaces` output — but
that output is still evaluated, which is exactly how a loader defect this driver
never consumed still broke its plan.

**Nothing is inferred from directory names.** Renderer 1.2.2 removed a rule that
guessed links from `2-products/.../setups/` path shape.

## Diagnostics: symptom → cause → check

| symptom | likely cause | check / fix |
|---|---|---|
| module fails while **parsing** in HCP, no plan output | the workspace runs Terraform < 1.8; the renderer calls `provider::deepmerge::mergo` | check the **workspace's** Terraform version in HCP, not your local CLI. This module declares `~> 1.8`, so you now get a version error instead |
| `Invalid template interpolation value … have tuple` inside the loader module | loader ≤ 1.2.1 with a path matching the removed convention | bump the `infra-yaml-loader` pin to ≥ 1.2.2 |
| an upstream fix "did not land" | the loader and the renderer are **separate pins to the same repo** | check *both* `main.tf` and `modules/workspace/main.tf`; they should reference one release |
| a workspace is not created at all | its YAML resolved to no `source`/`version`, so the loader dropped it | probe the loader directly (see the renderer repo's `AGENTS.md`) and compare `yaml_files_raw` with `yaml_files` |
| `data.tfe_outputs` for a workspace that does not exist | a literal `${...}` in `variables`/`providers` was read as a reference — there is no existence filter | search the YAML for `${` values that are not workspace paths |
| linked values arrive null | the producer workspace has never applied, or the output name differs from the reference | check the producer's outputs in HCP; the reference is `${<workspace-path>.<output>}` |
| generated workspace pins the wrong Terraform version | that comes from the `terraform_version` **input** (default `>= 1.3.0`), rendered into the generated `versions.tf` | it is independent of this module's own constraint |
| the HCP workspace runs an unexpected Terraform version | `tfe_workspace` does not set `terraform_version`, so it inherits the **organization default** | set it in HCP, or expose the field on the resource |
| provider authentication warnings during plan | the TFE provider token has narrower scope than the operations requested | expected in read-only contexts; confirm before treating as a failure |
| `variable_set_ids` vs `variable_sets` confusion | both are supported; the name list is the newer, recommended form | see the release notes in `README.md` |

## Inspecting and validating

Most harnesses under `tests/` create **real HCP resources** and need credentials —
do not run them casually. Credential-free checks:

```bash
terraform init -backend=false && terraform validate            # root module
terraform -chdir=modules/workspace validate
terraform -chdir=tests/empty-yaml init -backend=false && terraform -chdir=tests/empty-yaml plan
```

To inspect what the loader makes of a repository without touching HCP at all, use
the standalone loader probe documented in the renderer repo's `AGENTS.md`. That
isolates loader-stage problems from anything TFE-related.

## Known traps

- **Two pins to one upstream repo.** `main.tf` pins the loader submodule and
  `modules/workspace/main.tf` pins the renderer root. Different versions mean two
  tags of the same repository are downloaded.
- **Unused module outputs are still evaluated.** A defect in a loader code path this
  driver never reads can still break its plan — that is the 1.2.1 incident.
- **Three version knobs, easily confused:** this module's `required_version`; the
  `terraform_version` input rendered into each generated workspace; and the HCP
  workspace's own configured version, which this module does not set.
- **This driver creates real remote state and resources.** Unlike the Terragrunt and
  Terramate drivers, a careless apply here is not just files on disk.

## Version compatibility

| component | constraint | why |
|---|---|---|
| root module | `~> 1.8` | reaches `provider::deepmerge::mergo` through `modules/workspace` → renderer |
| `modules/workspace` | `~> 1.8` | calls the renderer root module |
| `modules/agent`, `modules/variable-set`, `modules/variable-set-reader` | `~> 1.3` | no provider functions; usable standalone |
| generated workspaces | `terraform_version` input, default `>= 1.3.0` | consumer policy, not a module requirement |

## Changing this repo

- Write a `specs/NNN-name/{spec,plan,tasks}.md` package before changing behavior.
- Prefer extending an existing harness under `tests/`; note which ones need
  credentials so reviewers know what was actually executed.
- `pre-commit` runs on commit and rewrites README tables via `terraform_docs`; stage
  its changes and re-commit rather than hand-editing generated tables.
- Conventional commits drive semantic-release: `fix` → patch, `feat` → minor.
- Never commit client-specific names into this repo — it is published.
