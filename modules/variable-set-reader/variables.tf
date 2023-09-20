variable "name" {
  type        = string
  description = "Terraform cloud variable set name"
}

variable "org" {
  type        = string
  description = "The terraform cloud organization name where variable set and variables will be created"
}

variable "tfc_token" {
  type        = string
  description = "Terraform Cloud token so that workspace can load variable set values."
  sensitive   = true
}
