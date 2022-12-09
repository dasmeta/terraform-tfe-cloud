variable "name" {
  type        = string
  description = "module/folder/workspace name and uniq identifier"
}

variable "module_source" {
  type        = string
  description = "The module source"
}

variable "module_version" {
  type        = string
  description = "The module version"
}

variable "module_vars" {
  type        = any
  default     = {}
  description = "The module variables"
}

variable "target_dir" {
  type        = string
  default     = "./"
  description = "The directory where new module folder will be created"
}

variable "terraform_version" {
  type        = string
  default     = ">= 1.3.0"
  description = "The required_version variable value for terraform{} block in versions.tf"
}

variable "module_providers" {
  type = list(object({
    name        = string
    version     = string
    source      = optional(string)
    alias       = optional(string)
    custom_vars = optional(any, {})
  }))
  default     = []
  description = "The list of providers to add in providers.tf"
}

variable "terraform_cloud" {
  type = object({
    org                = string
    workspaces_tags    = list(string)
    generate_workspace = bool
    git = object({
      repo      = any # TODO: this seems supports multiple arguments
      directory = string
    })
  })
  default     = { org = null, workspaces_tags = null, generate_workspace = false, git = { repo = null, directory = null } }
  description = "Allows to set terraform cloud configurations"
}

variable "terraform_backend" {
  type = object({
    name    = string
    configs = optional(any, {})
  })
  default     = { name = null, configs = null }
  description = "Allows to set terraform backend configurations"
}
