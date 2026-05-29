locals {
  name_specials_clean             = replace(var.name, "/[^a-zA-Z0-9_-]+/", "_")
  project_name_specials_clean     = var.workspace.project != null ? replace(var.workspace.project, "/[^a-zA-Z0-9 _-]+/", "") : null
  effective_execution_mode        = var.workspace.agent_pool_name == null ? null : "agent"
  auto_detected_linked_workspaces = [for item in flatten([for content in concat([for var_value in var.module_vars : var_value], var.module_providers) : regexall("\\$${([^}]+)}", jsonencode(content))]) : replace(item, "/\\..+/", "")]
  linked_workspaces               = distinct(concat(coalesce(var.linked_workspaces, []), local.auto_detected_linked_workspaces))
  linked_workspaces_mapping       = { for workspace in local.linked_workspaces : workspace => "data.tfe_outputs.this[\\\"${workspace}\\\"].values.results" }
  note                            = "This file and its content are generated based on config, pleas check README.md for more details"
  renderer_main_tf_extra_content = length(local.linked_workspaces) == 0 ? null : templatefile(
    "${path.module}/templates/tfe_outputs.tf.tftpl",
    {
      note              = local.note
      linked_workspaces = jsonencode(local.linked_workspaces)
      workspace_org     = var.workspace.org
    }
  )
  renderer_provider_default_tags = {
    aws = {
      enabled             = true
      managed_by          = "terraform"
      applied_from        = "terraform-cloud"
      workspace_tag_name  = "TerraformCloudWorkspace"
      workspace_tag_value = local.name_specials_clean
      extra_tags          = {}
    }
  }

  project_id = try(tfe_project.project[0].id, var.workspace.project_id)
}
