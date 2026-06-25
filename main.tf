module "infra_yaml_fetched" {
  #checkov:skip=CKV_TF_1: Registry module source uses version pin (CKV_TF_2)
  source  = "dasmeta/generic/renderer//modules/infra-yaml-fetched"
  version = "1.1.1"

  yamldir = var.yamldir
}
