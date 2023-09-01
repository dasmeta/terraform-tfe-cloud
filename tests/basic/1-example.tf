terraform {
  cloud {
    organization = "dasmeta-testing"
    workspaces {
      name = "terraform-tfe-cloud-test"
    }
  }
}

module "basic" {
  source = "../.."

  org   = "dasmeta-testing"
  token = "< TFC token >"

  rootdir   = "_terraform"
  targetdir = "_terraform"
  yamldir   = "example-infra"

  git_provider = "github"
  git_org      = "dasmeta-testing"
  git_repo     = "test-infrastructure"
  git_token    = "< github oauth token >"

  aws = {
    access_key_id     = ""
    secret_access_key = ""
    default_region    = ""
  }
}
