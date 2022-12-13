resource "tfe_variable_set" "this" {
  name         = var.name
  description  = var.description
  global       = var.global
  organization = var.org
}

resource "tfe_variable" "this" {
  for_each = { for item in var.variables : item.key => item }

  key             = each.value.key
  value           = each.value.value
  category        = each.value.category
  description     = each.value.description
  hcl             = each.value.hcl
  sensitive       = each.value.sensitive
  variable_set_id = tfe_variable_set.this.id
}

resource "tfe_workspace_variable_set" "this" {
  for_each = { for workspace in var.workspace_ids : workspace => workspace }

  workspace_id    = each.value
  variable_set_id = tfe_variable_set.this.id
}

