resource "local_file" "this" {
  for_each = { for file in local.files_to_generate : file.name => file }

  content  = each.value.content
  filename = "${trimsuffix(var.target_dir, "/")}/${var.name}/${each.value.name}.tf"
}

resource "tfe_project" "project" {
  count = var.workspace.project != "" ? 1 : 0

  organization = var.workspace.org
  name         = local.project_name_specials_clean
}

resource "tfe_workspace" "this" {
  name                = local.name_specials_clean
  description         = var.workspace.description
  organization        = var.workspace.org
  tag_names           = var.workspace.tags
  global_remote_state = var.workspace.global_remote_state
  project_id          = tfe_project.project[0].id
  working_directory   = "${var.workspace.directory}${var.name}"

  dynamic "vcs_repo" {
    for_each = try(var.repo.identifier, null) == null ? [] : [var.repo]

    content {
      identifier         = var.repo.identifier
      branch             = try(var.repo.branch, null)
      ingress_submodules = try(var.repo.ingress_submodules, null)
      oauth_token_id     = try(var.repo.oauth_token_id, null)
      tags_regex         = try(var.repo.tags_regex, null)
    }
  }
}

resource "tfe_workspace_variable_set" "this" {
  for_each = { for key, variable_set_id in coalesce(var.variable_set_ids, []) : key => variable_set_id }

  workspace_id    = tfe_workspace.this.id
  variable_set_id = each.value
}
