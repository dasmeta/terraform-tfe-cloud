locals {
  yaml_files_raw = {
    for file in fileset(
      var.yamldir,
      "**/*.yaml"
    ) : replace(file, "/.yaml$/", "") => try(yamldecode(file("${var.yamldir}/${file}")), {})
    if length(regexall("\\.terraform", file)) <= 0 # exclude files coming from .terraform folder
  }

  yaml_files = { for key, item in local.yaml_files_raw : key => item
  if try(item.source, null) != null && try(item.version, null) != null }
}

module "workspaces" {
  source = "./modules/workspace"

  # for_each = { for key, item in yamldecode(file("./infra.yaml")) : key => item } # single file mode
  for_each = local.yaml_files # folder with files mode

  name           = each.key
  module_source  = each.value.source
  module_version = each.value.version
  module_vars    = try(each.value.variables, [])
  output         = try(each.value.output, null)
  target_dir     = var.targetdir

  module_providers  = try(each.value.providers, [])
  linked_workspaces = try(each.value.linked_workspaces, null)

  auto_apply = var.auto_apply

  workspace = {
    org       = var.org
    directory = var.rootdir
  }

  repo = {
    identifier     = "${var.git_org}/${var.git_repo}"
    oauth_token_id = local.oauth_token_id
    branch         = var.git_branch
  }

  variable_set_ids = concat([module.aws_credentials_variable_set.id], try(each.value.variable_set_ids, []))
}
