terraform {
  backend "remote" {}
}

module "basic" {
  source = "../.."

  org   = "dasmeta-testing"
  token = "test-token"

  rootdir   = "_terraform"
  targetdir = "_terraform"
  yamldir   = "example-infra"

  git_token    = "value"
  git_org      = "dasmeta"
  git_provider = "github"
  git_repo     = "test-infrastructure"
}
