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
provider "github" {
  owner = local.git_org
}

locals {
  terraform_cloud_org = "dasmeta"
  git_org             = "dasmeta"
  git_repo            = "test-repo-terraform-tfe-cloud"
}

# create an empty github repository
module "github_repository" {
  source = "../../../terraform-github-repository"
  # source  = "dasmeta/repository/github"
  # version = "0.7.1"

  name           = local.git_repo
  default_branch = "main"
  visibility     = "private"
  files          = [for file in fileset("./results", "**") : { remote_path = file, local_path = "results/${file}" }]
}

# for oauth_token_id generation
resource "tfe_oauth_client" "this" {
  name             = "test-github-oauth-client"
  organization     = local.terraform_cloud_org
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = "ghp_xxxxxxxxxxxxxxx"
  service_provider = "github"
}

module "aws_user" {
  source  = "dasmeta/modules/aws//modules/aws-iam-user"
  version = "1.5.1"

  username = "test-user"
  console  = false
  policy_attachment = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/IAMUserChangePassword"
  ]
}

# create variable set
module "variable_set" {
  source = "../../modules/variable-set"

  name = "test_aws_credentials"
  org  = local.terraform_cloud_org
  variables = [
    {
      key       = "AWS_ACCESS_KEY_ID"
      value     = module.aws_user.iam_access_key_id
      category  = "env"
      sensitive = true
    },
    {
      key       = "AWS_SECRET_ACCESS_KEY"
      value     = module.aws_user.iam_access_key_secret
      category  = "env"
      sensitive = true
    }
  ]
}