terraform {
  required_version = "~> 1.3"

  required_providers {
    tfe = {
      version = "~> 0.74"
    }
    deepmerge = {
      source  = "isometry/deepmerge"
      version = "~> 1.1"
    }
  }
}
