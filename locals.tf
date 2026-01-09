
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

  root_shared_yaml = try(file("${var.yamldir}/_.yaml"), "")
  folders_shared_yaml = {
    for file in fileset(
      var.yamldir,
      "**/*/_.yaml"
    ) : replace(file, "/_.yaml$/", "") => try(file("${var.yamldir}/${file}"), "")
    if length(regexall("\\.terraform", file)) <= 0 # exclude files coming from .terraform folder
  }
  yaml_files_raw = {
    for file in fileset(
      var.yamldir,
      "**/*.yaml"
    ) : replace(file, "/.yaml$/", "") => try(yamldecode(join("\n", concat([local.root_shared_yaml], [for folder_name, shared_content in local.folders_shared_yaml : shared_content if strcontains(file, folder_name)], [file("${var.yamldir}/${file}")]))), {})
    if length(regexall("\\.terraform|/_\\.yaml", file)) <= 0 # exclude files coming from .terraform folder and ones names _.yaml desired for shared
  }

  yaml_files = { for key, item in local.yaml_files_raw : key => item
  if try(item.source, null) != null && try(item.version, null) != null }
}
