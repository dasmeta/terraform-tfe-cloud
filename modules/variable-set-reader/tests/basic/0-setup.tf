terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    tfe = {
      version = "~> 0.40"
    }
  }

  required_version = ">= 1.3.0"
}
