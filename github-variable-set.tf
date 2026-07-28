data "tfe_variable_set" "github" {
  count = local.manage_github_provider_token ? 1 : 0

  name         = "github"
  organization = var.org
}

resource "tfe_variable" "github_token" {
  count = local.manage_github_provider_token ? 1 : 0

  key             = "GITHUB_TOKEN"
  value           = var.git_token
  category        = "env"
  description     = "GitHub provider authentication managed by MetaCloud"
  hcl             = false
  sensitive       = true
  variable_set_id = data.tfe_variable_set.github[0].id
}
