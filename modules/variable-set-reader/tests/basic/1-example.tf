variable "tfc_token" {}
module "basic" {
  source = "../.."
  name   = "some-test-variable-set"
  org    = "dasmeta-testing"

  tfc_token = var.tfc_token
}
