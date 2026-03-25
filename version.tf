terraform {
  required_providers {
    tfe = {
      version = "~> 0.74"
    }
    deepmerge = {
      source  = "isometry/deepmerge"
      version = "~> 1.1"
    }
  }

  required_version = "~> 1.3"
}
