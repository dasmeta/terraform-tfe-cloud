data "utils_stack_config_yaml" "config" {
  input                  = [for stack in var.stacks : format("%s/%s.yaml", var.stack_config_local_path, stack)]
  process_stack_deps     = var.stack_deps_processing_enabled
  process_component_deps = var.component_deps_processing_enabled
}

locals {
  workspaces     = yamldecode(file("${var.workspaces_config_path}"))
  # variable_sets  = yamldecode(file("${var.variable_set_config_path}"))
  workspace_tags = { for workspace_name, config in local.workspaces : workspace_name => config.tag_names }
  workspace_id_map = { for workspace_name, _ in local.workspaces : workspace_name => module.tfc_workspace[workspace_name].id
  }

  decoded = [for i in data.utils_stack_config_yaml.config.output : yamldecode(i)]

  config = [
    for stack in local.decoded : {
      imports = stack.imports,
      components = {
        terraform = stack.components.terraform
      }
    }
  ]
}

module "workspace" {
  source   = "modules/workspace"
  for_each = local.workspaces

  workspace_name                       = each.key
  organization_name                    = var.organization_name
  tag_names                            = try(each.value.tag_names, [])
  # terraform_variables                  = try(each.value.terraform_variables, {})
  env_variables                        = try(each.value.env_variables, {})
  speculative_enabled                  = try(each.value.speculative_enabled, null)
  run_trigger_workspaces               = try(each.value.run_trigger_workspaces, [])
  auto_apply                           = try(each.value.auto_apply, null)
  allow_destroy_plan                   = try(each.value.allow_destroy_plan, false)
  terraform_version                    = try(each.value.terraform_version, null)
  trigger_prefixes                     = try(each.value.trigger_prefixes, null)
  working_directory                    = try(each.value.working_directory, null)
  ssh_key_id                           = try(each.value.ssh_key, null)
  execution_mode                       = try(each.value.execution_mode, "remote")
  default_management_workspace_trigger = var.default_management_workspace_trigger

  vcs_repo = var.vcs_oauth_token_id == null ? [] : [{
    identifier     = each.value.git
    branch         = try(each.value.git_branch, "main")
    oauth_token_id = var.vcs_oauth_token_id
  }]

}