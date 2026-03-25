module "this" {
  source = "../../"

  tfc_organization = var.tfc_organization
  name             = "tfc-agentpool-a"
  replicas         = 2
}
