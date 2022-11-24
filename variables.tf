variable "stack_config_local_path" {
  type        = string
  description = "Path to local stack configs"
}

variable "stacks" {
  type        = list(string)
  description = "A list of infrastructure stack names"
}

variable "stack_deps_processing_enabled" {
  type        = bool
  description = "Boolean flag to enable/disable processing all stack dependencies in the provided stack"
  default     = false
}

variable "component_deps_processing_enabled" {
  type        = bool
  description = "Boolean flag to enable/disable processing stack config dependencies for the components in the provided stack"
  default     = false
}

#============Workspace==========
variable "workspaces_config_path" {
  description = "Path to workspace configuration yaml file"
  type        = string
  default = "../done/examples/complete/yamls/workspace.yaml"
}

variable "organization_name" {
  description = "Organization name of Terraform Cloud"
  type        = string
  default = "dasmeta"
}


variable "vcs_oauth_token_id" {
  description = ""
  type        = string
  default     = null
}

variable "default_management_workspace_trigger" {
  description = "Managed workspaces should have a run triggered when the managed workspace is executed. This variable sets the name of this workspace. If you want to disable this set the value to null."
  type        = string
  default     = null
}
#===================