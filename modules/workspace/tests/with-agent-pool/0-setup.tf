terraform {
  required_version = "~> 1.3"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.74"
    }
  }
}

# set via `export TF_VAR_tfc_organization=<your-organization-name>`
variable "tfc_organization" {
  type        = string
  description = "HCP Terraform organization name."
  default     = "Demo-Dasmeta"
}

provider "tfe" {} # to set token use `export TFE_TOKEN=<your-token>`
