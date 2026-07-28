
locals {
  scm_providers = {
    github = {
      provider = "github"
      http_url = "https://github.com"
      api_url  = "https://api.github.com"
    }
    gitlab = {
      provider = "gitlab_hosted"
      http_url = "https://gitlab.com"
      api_url  = "https://gitlab.com/api/v4"
    }
    bitbucket = {
      provider = "bitbucket_hosted"
      http_url = "https://bitbucket.org"
      api_url  = "https://api.bitbucket.org/2.0"
    }
  }

  # check to see if token is actually SCM token or TFC token ID
  create_oauth_client = var.git_enabled && substr(var.git_token, 0, 3) != "ot-"

  # if token is TFC token ID then resource should not be created and provided token should be used
  oauth_token_id = local.create_oauth_client ? tfe_oauth_client.this[0].oauth_token_id : var.git_token

  yaml_files = module.infra_yaml_loader.yaml_files

  # A raw GitHub token can authenticate both the Terraform Cloud VCS OAuth
  # client and the GitHub provider used by generated workspaces. OAuth token
  # IDs cannot be converted back into a GitHub token, so they are excluded.
  manage_github_provider_token = var.git_enabled && var.git_provider == "github" && local.create_oauth_client
}
