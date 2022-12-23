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

    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.41"
    }
  }

  required_version = ">= 1.3.0"
}

/**
 * This token can be set by env variable:

 export TF_VAR_github_token=ghp_xxxxxxxxxxxxxxx
**/
variable "github_token" {
  type        = string
  description = "This is the same as GITHUB_TOKEN env variable will be set. This will setup terraform cloud to git repo connection authentication"
}

/**
 *set GITHUB_TOKEN env variable for github provider setup:

 export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxx
**/
provider "github" {
  owner = local.git_org
}

/**
 * set the following env var so that aws provider will get authenticated before apply:

 export TFE_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxx
*/
provider "tfe" {}

/**
 * set the following env vars so that aws provider will get authenticated before apply:

 export AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxxxxxx
 export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxx
*/
provider "aws" {
  region = "eu-central-1"
}

locals {
  terraform_cloud_org = "dasmeta"
  git_org             = "dasmeta"
  git_repo            = "test-repo-terraform-tfe-cloud"
}

# create an empty github repository
module "github_repository" {
  source  = "dasmeta/repository/github"
  version = "0.7.2"

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
  oauth_token      = var.github_token
  service_provider = "github"
}

module "aws_user" {
  source  = "dasmeta/modules/aws//modules/aws-iam-user"
  version = "1.5.2"

  username = "test-user"
  console  = false
  policy_attachment = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/IAMUserChangePassword"
  ]
}

# create variable set
module "aws_credentials_variable_set" {
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
