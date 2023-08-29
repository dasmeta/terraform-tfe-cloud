terraform {
  backend "remote" {}
}

module "basic" {
  source = "../.."

  org   = "dasmeta-testing"
  token = "test-token"

  config = {
    root       = "_terraform"
    target_dir = "_terraform"
    yaml_dir   = "example-infra"
  }
}
