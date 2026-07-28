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
  main_tf_extra_content = local.github_variable_set_workspaces[each.key] ? trimspace(<<-EOT
    variable "github_token" {
      type      = string
      sensitive = true
    }

    resource "tfe_variable" "github_token" {
      key             = "GITHUB_TOKEN"
      value           = var.github_token
      category        = "env"
      description     = "GitHub provider authentication managed by MetaCloud"
      hcl             = false
      sensitive       = true
      variable_set_id = module.this.id
    }
  EOT
  ) : null

  module_providers  = try(each.value.providers, [])
  linked_workspaces = try(each.value.linked_workspaces, [])

  auto_apply = var.auto_apply

  workspace_variables = local.github_variable_set_workspaces[each.key] ? [{
    key         = "github_token"
    value       = var.git_token
    category    = "terraform"
    description = "GitHub token supplied by MetaCloud for the YAML-managed github variable set"
    sensitive   = true
  }] : []

  workspace = {
    org             = var.org
    directory       = var.rootdir
    agent_pool_name = try(each.value.agent_pool_name, null)
  }

  repo = {
    enabled        = var.git_enabled
    identifier     = "${var.git_org}/${var.git_repo}"
    oauth_token_id = local.oauth_token_id
    branch         = var.git_branch
  }

  variable_sets    = try(each.value.variable_sets, [])
  variable_set_ids = concat(module.aws_credentials_variable_set[*].id, try(each.value.variable_set_ids, []))
}
