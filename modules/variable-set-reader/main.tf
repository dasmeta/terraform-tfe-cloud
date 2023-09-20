data "tfe_variable_set" "this" {
  name         = var.name
  organization = var.org
}

data "tfe_variables" "this" {
  variable_set_id = data.tfe_variable_set.this.id
}
