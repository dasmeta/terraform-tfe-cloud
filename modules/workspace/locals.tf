locals {
  name_specials_clean         = replace(var.name, "/[^a-zA-Z0-9_-]+/", "_")
  project_name_specials_clean = var.workspace.project != null ? replace(var.workspace.project, "/[^a-zA-Z0-9 _-]+/", "") : null
  effective_execution_mode    = var.workspace.agent_pool_name == null ? null : "agent"
  renderer_note               = "This file and its content are generated based on config, pleas check README.md for more details"
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
