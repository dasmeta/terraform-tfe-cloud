# for oauth_token_id generation
resource "tfe_oauth_client" "this" {
  name             = "git-oauth-client"
  organization     = var.org # this one is terraform cloud organisation
  service_provider = local.scm_providers[var.git_provider].provider
  http_url         = local.scm_providers[var.git_provider].http_url
  api_url          = local.scm_providers[var.git_provider].api_url
  oauth_token      = var.git_token
}
