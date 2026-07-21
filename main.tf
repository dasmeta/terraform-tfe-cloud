module "infra_yaml_loader" {
  #checkov:skip=CKV_TF_1: Registry module source uses version pin (CKV_TF_2)
  source  = "dasmeta/generic/renderer//modules/infra-yaml-loader"
  version = "1.2.1"

  yamldir = var.yamldir
}
