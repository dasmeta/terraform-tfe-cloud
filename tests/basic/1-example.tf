variable "tfc_token" {}
variable "git_token" {}

module "basic" {
  source = "../.."

  org   = "dasmeta-testing"
  token = var.tfc_token

  rootdir   = "_terraform"
  targetdir = "_terraform"
  yamldir   = "example-infra"

  git_provider = "github"
  git_org      = "dasmeta-testing"
  git_repo     = "test-infrastructure"
  git_token    = var.git_token

  aws = {
    access_key_id     = ""
    secret_access_key = ""
    default_region    = ""
  }

  auto_apply = true
}

# Verification notes:
# 1) Baseline: capture existing workspace execution behavior.
# 2) Apply with `tests/basic/example-infra/empty.yaml`:
#    - `tfe_workspace_settings` should manage execution behavior.
#    - `agent_pool_id` should be assigned via workspace settings (not deprecated direct workspace fields).
# 3) Change only `workspace.agent_pool_name` and re-apply:
#    only affinity should change (no duplicate workspace).
# 4) Re-run apply with no further changes: plan should be empty (idempotent).
# 5) `aws.enabled` is omitted in this scenario, so default behavior keeps AWS variable set creation enabled.
# 6) After introducing count-based AWS module instantiation, root `moved.tf` should prevent AWS variable set recreation.
