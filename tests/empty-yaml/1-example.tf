module "this" {
  source = "../.."

  org       = "dasmeta-testing"
  token     = "test-token"
  yamldir   = "${path.module}/example-infra"
  rootdir   = "output"
  targetdir = "${path.module}/output"

  git_enabled = false
  aws = {
    enabled = false
  }
  tfe_token_variable_set = {
    enabled = false
  }
}
