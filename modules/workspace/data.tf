

data "tfe_workspace" "triggers" {
  count        = length(var.run_trigger_workspaces)
  name         = var.run_trigger_workspaces[count.index]
  organization = var.organization_name
}

data "tfe_ssh_key" "this" {
  count        = var.ssh_key_id != null ? 1 : 0
  name         = var.ssh_key_id
  organization = var.organization_name
}
