terraform {
  required_version = "~> 1.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.40"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# set via `export TF_VAR_tfc_organization=<your-organization-name>`
variable "tfc_organization" {
  type        = string
  description = "HCP Terraform organization name."
  default     = "Demo-Dasmeta"
}

provider "tfe" {}        # to set token use `export TFE_TOKEN=<your-token>`
provider "helm" {}       # to set token use `export KUBE_CONFIG_PATH=<your-kubernetes-config-path>`
provider "kubernetes" {} # to set token use `export KUBE_CONFIG_PATH=<your-kubernetes-config-path>`
