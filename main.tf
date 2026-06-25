module "infra_yaml_fetched" {
  count = var.yaml_files == null ? 1 : 0

  source  = "dasmeta/generic/renderer//modules/infra-yaml-fetched"
  version = "1.1.0"

  yamldir = var.yamldir
}
