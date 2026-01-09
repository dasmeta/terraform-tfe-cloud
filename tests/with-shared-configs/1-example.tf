module "basic" {
  source = "../.."

  org         = "dasmeta-testing"
  token       = ""
  rootdir     = "_terraform"
  targetdir   = "_terraform"
  yamldir     = "."
  git_enabled = false

  aws                    = { variable_set_name = "with-shared-configs_aws_credentials_not_used" }
  tfe_token_variable_set = { enabled = false }
}
