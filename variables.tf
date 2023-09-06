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
variable "yamldir" {
  type        = string
  default     = "."
  description = "The directory where yamls located"
}

variable "targetdir" {
  type        = string
  default     = "./../_terraform/"
  description = "The directory where tf cloud workspace corresponding workspaces will be created"
}

variable "rootdir" {
  type        = string
  default     = "./_terraform/"
  description = "The directory on git repo where the workspaces creator main.tf file located "
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

variable "git_provider" {
  type        = string
  default     = "gitlab"
  description = "The vsc(github, gitlab, ...) provider id"
}

variable "git_org" {
  type        = string
  description = "The github org/owner name"
}
variable "git_repo" {
  type        = string
  description = "The github repo name without org prefix"
}
variable "git_token" {
  type        = string
  description = "The vsc(github, gitlab, ...) personal access token"
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

variable "auto_apply" {
  type        = bool
  default     = false
  description = "To have workspaces automatically apply after plan is done successfully."
}
