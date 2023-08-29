/**
 * The variables can be set in ./terraform.tfvars file or by env variables:

 export TF_VAR_{variable-name}=xxxxxxxxxxxxxxx
**/
# for TFE setup
variable "org" {
  type        = string
  description = "The terraform cloud org name"
}
variable "token" {
  type        = string
  description = "The terraform cloud token"
}

# For code generation
variable "config" {
  type = object({
    yaml_dir   = string
    target_dir = string
    root       = string
  })

  default = {
    yaml_dir   = "."
    target_dir = "./"
    root       = "./_terraform/"
  }
  # variable "yaml_dir" {
  #   type        = string
  #   default     = "."
  #   description = "The directory where yamls located"
  # }

  # variable "target_dir" {
  #   type        = string
  #   default     = "./"
  #   description = "The directory where tf cloud workspace corresponding workspaces will be created"
  # }

  # variable "workspace_directory_root" {
  #   type        = string
  #   default     = "./_terraform/"
  #   description = "The directory on git repo where the workspaces creator main.tf file located "
  # }
}

# SCM
locals {
  scm_providers = {
    github = {
      http_url = "https://github.com"
      api_url  = "https://api.github.com"
      provider = "github"
    }
    gitlab = {
      http_url = "https://gitlab.com"
      api_url  = "https://gitlab.com/api/v4"
      provider = "gitlab_hosted"
    }
  }
}

variable "scm" {
  type = object({
    provider   = string
    org        = string
    repo       = string
    auth_token = string
  })

  default = {
    provider   = "github" # gitlab|bitbucket|...
    org        = "awesome-organisation"
    repo       = "awesome-infrastructure"
    auth_token = "54678976566tr7z8u9zt7z8"
  }

  # variable "git_service_provider" {
  #   type        = string
  #   default     = "gitlab_hosted"
  #   description = "The vsc(github, gitlab, ...) provider id"
  # }
  # variable "git_http_url" {
  #   type        = string
  #   default     = "https://gitlab.com"
  #   description = "The vsc(github, gitlab, ...) url"
  # }
  # variable "git_api_url" {
  #   type        = string
  #   default     = "https://gitlab.com/api/v4"
  #   description = "The vsc(github, gitlab, ...) url"
  # }
  # variable "git_org" {
  #   type        = string
  #   description = "The github org/owner name"
  # }
  # variable "git_repo" {
  #   type        = string
  #   description = "The github repo name without org prefix"
  # }
  # variable "git_auth_token" {
  #   type        = string
  #   description = "The vsc(github, gitlab, ...) personal access token"
  # }
}

# Cloud Access (goes to shared variable set, should be adjusted)
variable "aws" {
  type = map(any)
  default = {
    access_key_id     = ""
    secret_access_key = ""
    default_region    = ""
  }
  # variable "aws_access_key_id" {
  #   type        = string
  #   description = "The aws user access key"
  # }
  # variable "aws_secret_access_key" {
  #   type        = string
  #   description = "The aws user secret access key"
  # }
  # variable "aws_default_region" {
  #   type        = string
  #   default     = "eu-central-1"
  #   description = "The aws default region"
  # }
}
