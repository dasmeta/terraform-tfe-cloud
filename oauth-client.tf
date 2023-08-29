# for oauth_token_id generation
resource "tfe_oauth_client" "this" {
  name             = "git-oauth-client"
  organization     = var.org
  api_url          = local.scm_providers[var.scm.provider].api_url
  http_url         = local.scm_providers[var.scm.provider].http_url
  oauth_token      = var.scm.auth_token
  service_provider = local.scm_providers[var.scm.provider].provider
}
