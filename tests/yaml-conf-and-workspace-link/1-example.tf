# NOTE: you have to apply twice in order to have working pipelines as first time it creates git repo, generates reo files and tf workspaces. and on second apply it pushes generated files into repo
module "this" {
  source = "../../"

  for_each = { for key, item in yamldecode(
    file("./mocks/modules.yaml")
    #    file("./mocks/modules-state-cleanup.yaml") # uncomment me(comment out above line) and apply to cleanup states before destroying
  ) : key => item }

  name           = each.key
  module_source  = each.value.source
  module_version = each.value.version
  module_vars    = each.value.variables
  target_dir     = "./results/"

  module_providers  = try(each.value.providers, [])
  linked_workspaces = try(each.value.linked_workspaces, null)

  workspace = {
    org = local.terraform_cloud_org
  }

  repo = {
    identifier     = "${local.git_org}/${local.git_repo}"
    oauth_token_id = tfe_oauth_client.this.oauth_token_id
  }

  variable_set_ids = [module.aws_credentials_variable_set.id]

  depends_on = [
    module.github_repository # the github repo should be already created
  ]
}
