terraform {
  cloud {
    organization = "dasmeta-testing"
    workspaces {
      name = "terraform-tfe-cloud-test"
    }
  }
}
