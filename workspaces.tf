locals {
  yaml_files_raw = { for file in fileset(
    "${path.module}/${var.config.yamldir}",
    "**/*.yaml"
  ) : replace(file, "/.yaml$/", "") => yamldecode(file("${var.config.yamldir}/${file}")) }

  yaml_files = { for key, item in local.yaml_files_raw : key => item
  if try(item.source, null) != null && try(item.version, null) != null }
}

module "workspaces" {
  # source  = "dasmeta/cloud/tfe"
  # version = "1.0.4"
  # source = "/Users/juliaaghamyan/Desktop/dasmeta/terraform-tfe-cloud/"
  source = "git::https://github.com/dasmeta/terraform-tfe-cloud.git?ref=DMVP-fix-var"

  # for_each = { for key, item in yamldecode(file("./infra.yaml")) : key => item } # single file mode
  for_each = local.yamlfiles # folder with files mode

  name           = each.key
  module_source  = each.value.source
  module_version = each.value.version
  module_vars    = each.value.variables
  output         = try(each.value.output, null)
  target_dir     = var.config.targetdir

  module_providers  = try(each.value.providers, [])
  linked_workspaces = try(each.value.linked_workspaces, null)

  workspace = {
    org       = var.org
    directory = var.config.root
  }

  repo = {
    identifier     = "${var.git_org}/${var.git_repo}"
    oauth_token_id = tfe_oauth_client.this.oauth_token_id
  }

  variable_set_ids = concat([module.aws_credentials_variable_set.id], try(each.value.variable_set_ids, []))
}
