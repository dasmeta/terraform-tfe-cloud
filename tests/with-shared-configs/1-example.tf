module "basic" {
  source = "../.."

  org         = "dasmeta-testing"
  token       = ""
  rootdir     = "_terraform"
  targetdir   = "_terraform"
  yamldir     = "."
  git_enabled = false

  aws                    = { enabled = false, variable_set_name = "with-shared-configs_aws_credentials_not_used" }
  tfe_token_variable_set = { enabled = false }
}

# Verification notes:
# - Shared yaml anchors/aliases should be merged into module configs.
# - Workspace generation from shared configs should be deterministic.
# - With `aws.enabled = false`, AWS credentials variable set must not be created.
# - Non-AWS behavior (workspace parsing/creation and shared config merging) must remain unchanged.
