variable "name" {
  type        = string
  description = "Terraform cloud variable set name"
}

variable "org" {
  type        = string
  description = "The terraform cloud organization name where variable set and variables will be created"
}

variable "description" {
  type        = string
  default     = ""
  description = "Terraform cloud variable set description"
}

variable "global" {
  type        = bool
  default     = false
  description = "Whether the variable set is global(applies on all workspaces in org) or workspace specific"
}

variable "variables" {
  type = list(object({
    key         = string
    value       = string
    category    = string # Valid values are terraform or env
    description = optional(string, "")
    hcl         = optional(bool, false)
    sensitive   = optional(bool, false)
  }))
  default     = []
  description = "The list of variables/envs"
}

variable "workspace_ids" {
  type        = list(string)
  default     = []
  description = "The list of workspaces to attach variable set to"
}
