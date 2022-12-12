terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    tfe = {
      version = "~> 0.40.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.3.0"
}

# set TFE_TOKEN env variable for github provider setup ` export TFE_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxx`
provider "tfe" {}

# set GITHUB_TOKEN env variable for github provider setup ` export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxx`
provider "github" {}

locals {
  terraform_cloud_org = "dasmeta"
  git_org             = "mrdntgrn"
  git_repo            = "test-repo-terraform-tfe-cloud"
}

# create an empty github repository
module "github_repository" {
  source  = "dasmeta/repository/github"
  version = "0.7.1"

  name           = local.git_repo
  default_branch = "main"
  visibility     = "private"
  paths          = "./results"
}

# for oauth_token_id generation
resource "tfe_oauth_client" "this" {
  name         = "test-github-oauth-client"
  organization = local.terraform_cloud_org
  api_url      = "https://api.github.com"
  http_url     = "https://github.com"
  oauth_token  = "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" # TODO: remove me before commit
  # oauth_token      = "ghp_xxxxxxxxxxxxxxx"
  service_provider = "github"
}