terraform {
  cloud {
    # export TF_TOKEN_app_terraform_io=<your-token>
    organization = "Demo-Dasmeta" # set value of var.tfc_organization, we need set as constant here as variables may not be used here
    workspaces {
      name = "test-with-agent-pool"
    }
  }
}

# set via `export TF_VAR_tfc_organization=<your-organization-name>`, make sure the token is team or user one and not organization
variable "tfc_organization" {
  type        = string
  description = "HCP Terraform organization name."
  default     = "Demo-Dasmeta"
}

provider "tfe" {} # to set token use `export TF_TOKEN_app_terraform_io=<your-token>`
