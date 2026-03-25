module "basic" {
  source = "../.."
  # source = "dasmeta/cloud/tfe"

  org         = var.tfc_organization
  token       = ""
  rootdir     = "_terraform"
  targetdir   = "_terraform"
  yamldir     = "."
  git_enabled = false

  aws                    = { enabled = false, variable_set_name = "with-agent-pool_aws_credentials_not_used" }
  tfe_token_variable_set = { enabled = false }
}

# Verification notes:
# - Workspace should resolve `agent_pool_name` from top-level yaml field.
# - Workspace settings should use execution_mode `agent` when pool is set.
# - Re-applying unchanged config should remain idempotent.
