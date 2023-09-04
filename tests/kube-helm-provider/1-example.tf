variable "tfc_token" {}
variable "git_token" {}

module "basic" {
  source = "../.."

  org   = "dasmeta-testing"
  token = var.tfc_token

  rootdir   = "_terraform"
  targetdir = "_terraform"
  yamldir   = "."

  git_provider = "github"
  git_org      = "dasmeta-testing"
  git_repo     = "test-infrastructure"
  git_token    = var.git_token

  aws = {
    access_key_id     = ""
    secret_access_key = ""
    default_region    = ""
  }
}
