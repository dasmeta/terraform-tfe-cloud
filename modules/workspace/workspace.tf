resource "tfe_workspace" "test" {
  name                = var.workspace_name
  organization        = var.organization_name
  tag_names           = var.tag_names
  speculative_enabled = var.speculative_enabled
  terraform_version   = var.terraform_version != null ? var.terraform_version : null
  trigger_prefixes    = var.trigger_prefixes
  working_directory   = var.working_directory
  auto_apply          = var.auto_apply
  allow_destroy_plan  = var.allow_destroy_plan
  ssh_key_id          = var.ssh_key_id != null ? data.tfe_ssh_key.this[0].id : null
  execution_mode      = var.execution_mode

  dynamic "vcs_repo" {
    for_each = var.vcs_repo
    content {
      identifier     = var.vcs_repo[0].identifier
      branch         = var.vcs_repo[0].branch
      oauth_token_id = var.vcs_repo[0].oauth_token_id
    }
  }
}




resource "tfe_variable" "env" {
  for_each     = var.env_variables
  key          = each.key
  value        = each.value.value
  description  = each.value.description
  sensitive    = each.value.sensitive
  workspace_id = tfe_workspace.test.id
  category     = "env"
}

resource "tfe_variable" "terraform" {
  for_each     = var.terraform_variables
  
  key          = each.key
  value        = each.value.value
  description  = each.value.description
  hcl          = each.value.hcl
  sensitive    = each.value.sensitive
  workspace_id = tfe_workspace.test.id
  category     = "terraform"
}

resource "tfe_run_trigger" "triggers" {
  count         = length(var.run_trigger_workspaces)
  workspace_id  = tfe_workspace.test.id
  sourceable_id = data.tfe_workspace.triggers[count.index].id
}
