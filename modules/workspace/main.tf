module "renderer" {
  source  = "dasmeta/generic/renderer"
  version = "1.0.4"

  name       = var.name
  setup_path = var.name
  module_config = {
    source    = var.module_source
    version   = var.module_version
    variables = var.module_vars
    providers = var.module_providers
    output    = var.output
  }
  target_dir = var.target_dir
  terraform = {
    version = var.terraform_version
    backend = var.terraform_backend
    cloud   = { organization = var.workspace.org }
  }
  provider_configs = {
    aws = {
      default_tags = local.renderer_provider_default_tags.aws
    }
  }
  linked = {
    setups                  = { for workspace in coalesce(var.linked_workspaces, []) : workspace => {} }
    query                   = { organization = var.workspace.org }
    result_mapping_template = "data.tfe_outputs.this[\\\"%s\\\"].values.results"
    data_content_template   = templatefile("${path.module}/templates/tfe_outputs.tf.tftpl", {})
  }
  note = local.renderer_note
  readme = {
    generated_by_module  = "dasmeta/cloud/tfe"
    setup_label          = "tf cloud workspace name"
    module_version_label = "tf_module version"
  }
}

resource "tfe_project" "project" {
  count = var.workspace.project != null ? 1 : 0

  organization = var.workspace.org
  name         = local.project_name_specials_clean
}

data "tfe_agent_pool" "this" {
  count = (try(var.workspace.agent_pool_name, null) == null ? null : trimspace(var.workspace.agent_pool_name)) == null ? 0 : 1

  name         = trimspace(var.workspace.agent_pool_name)
  organization = var.workspace.org
}

resource "tfe_workspace" "this" {
  name              = local.name_specials_clean
  organization      = var.workspace.org
  tag_names         = var.workspace.tags
  project_id        = local.project_id
  working_directory = "${trimsuffix(var.workspace.directory, "/")}/${var.name}"

  dynamic "vcs_repo" {
    for_each = var.repo.enabled && try(var.repo.identifier, null) != null ? [var.repo] : []

    content {
      identifier         = var.repo.identifier
      branch             = try(var.repo.branch, null)
      ingress_submodules = try(var.repo.ingress_submodules, null)
      oauth_token_id     = try(nonsensitive(var.repo.oauth_token_id), var.repo.oauth_token_id)
      tags_regex         = try(var.repo.tags_regex, null)
    }
  }
}

resource "tfe_workspace_settings" "this" {
  workspace_id        = tfe_workspace.this.id
  execution_mode      = local.effective_execution_mode
  agent_pool_id       = try(data.tfe_agent_pool.this[0].id, null)
  global_remote_state = var.workspace.global_remote_state
  auto_apply          = var.auto_apply
  description         = var.workspace.description
}

data "tfe_variable_set" "this" {
  for_each = toset(var.variable_sets)

  name         = each.value
  organization = var.workspace.org
}

resource "tfe_workspace_variable_set" "this" {
  for_each = { for key, variable_set_id in concat(var.variable_set_ids, [for item in data.tfe_variable_set.this : item.id]) : key => variable_set_id }

  workspace_id    = tfe_workspace.this.id
  variable_set_id = each.value
}
