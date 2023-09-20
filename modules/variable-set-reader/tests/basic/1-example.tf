variable "tfc_token" {}
module "basic" {
  source = "../.."
  name   = "aws_credentials"
  org    = "dasmeta"

  tfc_token = var.tfc_token
}
