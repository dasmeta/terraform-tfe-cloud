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
  sensitive   = true
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
variable "git_enabled" {
  type        = bool
  default     = true
  description = "Whether to create tfe oauth connection with git repo"
}
variable "git_provider" {
  type        = string
  default     = "gitlab"
  description = "The vsc(github, gitlab, ...) provider id"
}
variable "git_org" {
  type        = string
  default     = ""
  description = "The github org/owner name"
}
variable "git_repo" {
  type        = string
  default     = ""
  description = "The github repo name without org prefix"
}
variable "git_token" {
  type        = string
  default     = ""
  description = "The vsc(github, gitlab, ...) personal access token. TFC oauth token can be created manually or externally and oken supplied via this variable."
  sensitive   = true
}
variable "git_branch" {
  type        = string
  default     = null
  description = "The GitHub branch name; if null, the repo's default branch is used"
}
variable "git_oauth_client_name" {
  type        = string
  default     = "git-oauth-client"
  description = "The name of tfe oauth connection with git repo"
}

# Cloud Access (goes to shared variable set, should be adjusted)
variable "aws" {
  type = object({
    enabled           = optional(bool, true)                # Controls AWS credentials variable set creation
    variable_set_name = optional(string, "aws_credentials") # Target AWS variable set name
    access_key_id     = optional(string, "")                # AWS access key ID value
    secret_access_key = optional(string, "")                # AWS secret access key value
    session_token     = optional(string, "")                # AWS session token value
    security_token    = optional(string, "")                # AWS security token value
    default_region    = optional(string, "")                # AWS default region value
    region            = optional(string, "")                # AWS region value
  })
  default     = {}
  description = "The aws env variables set used as default in all workspaces"
}

variable "tfe_token_variable_set" {
  type = object({
    enabled = optional(bool, true)
    name    = optional(string, "tfe-token")
  })
  default     = {}
  description = "The tfe token variable set configs, this token can be used for tfe provider auth in workspaces to create tfe resources like additional variable sets."
}

variable "auto_apply" {
  type        = bool
  default     = false
  description = "To have workspaces automatically apply after plan is done successfully."
}
