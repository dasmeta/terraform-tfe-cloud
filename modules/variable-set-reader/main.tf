data "tfe_variable_set" "this" {
  name         = var.name
  organization = var.org
}

data "tfe_variables" "this" {
  variable_set_id = data.tfe_variable_set.this.id
}

locals {
  results = { for value in data.tfe_variables.this.variables : value.name => value.value }
}
