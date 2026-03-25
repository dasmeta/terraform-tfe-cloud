terraform {
  cloud {
    organization = "dasmeta-testing"
    workspaces {
      tags = ["terraform-tfe-cloud-test", "dev"]
      # name = "terraform-tfe-cloud-test"
    }
  }
}
