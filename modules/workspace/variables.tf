variable "organization_name" {
  description = "Organization name of terraform cloud"
  type        = string
}

variable "workspace_name" {
  description = "Workspace name in organization to create"
  type        = string
}

variable "tag_names" {
  description = ""
  type        = list(string)
  default     = ["tf"]
}

variable "vcs_repo" {
  description = "Version Control System repo for connecting to workspace"
  type = list(object({
    identifier     = string
    branch         = string
    oauth_token_id = string
  }))
  default = []
}

variable "terraform_variables" {
  description = "List of terraform variables for this workspace."
  type = map(object({
    key = string
    value       = string
    description = string
    hcl         = bool
    sensitive   = bool
  }))
  default = {}
}

variable "env_variables" {
  description = "List of environment variables for this workspace."
  type = map(object({
    key = string
    value       = string
    description = string
    hcl = bool
    sensitive   = bool
  }))
  default = {}
}

variable "default_management_workspace_trigger" {
  description = "Managed workspaces should have a run triggered when the managed workspace is executed. This variable sets the name of this workspace. If you want to disable this set the value to null."
  type        = string
  default     = null
}

variable "ssh_key_id" {
  description = "SSH key ID to use for this workspace."
  type        = string
  default     = null
}

variable "speculative_enabled" {
  description = "Whether this workspace allows speculative plans."
  type        = bool
  default     = true
}

variable "terraform_version" {
  description = "(Optional) The version of Terraform to use for this workspace. This can be either an exact version or a version constraint (like ~> 1.0.0); if you specify a constraint, the workspace will always use the newest release that meets that constraint. Defaults to the latest available version."
  type        = string
  default     = null
}

variable "trigger_prefixes" {
  description = "(Optional) List of repository-root-relative paths which describe all locations to be tracked for changes."
  type        = list(string)
  default     = []
}

variable "working_directory" {
  description = "(Optional) A relative path that Terraform will execute within. Defaults to the root of your repository."
  type        = string
  default     = null
}

variable "auto_apply" {
  description = "(Optional) Whether to automatically apply changes when a Terraform plan is successful. Defaults to `false`."
  type        = bool
  default     = false
}

variable "allow_destroy_plan" {
  description = "(Optional, default false) Whether destroy plans can be queued on the workspace."
  type        = bool
  default     = false
}

variable "execution_mode" {
  description = "Which execution mode to use. Using Terraform Cloud, valid values are `remote` or `local`. Defaults to `remote`"
  type        = string
  default     = "remote"
  validation {
    condition     = can(regex("^(remote|local)$", var.execution_mode))
    error_message = "Execution_mode must be one of 'remote' or 'local'."
  }
}

variable "run_trigger_workspaces" {
  description = "A list of workspace names which should trigger a plan run for this workspace when these workspaces run."
  type        = list(string)
  default     = []
}
