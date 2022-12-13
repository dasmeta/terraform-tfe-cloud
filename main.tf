locals {
  name_specials_clean = replace(var.name, "/\\W+/", "_")
  main_content = templatefile(
    "${path.module}/templates/main.tftpl",
    {
      source    = var.module_source
      version   = var.module_version
      variables = { for key, value in var.module_vars : key => jsonencode(value) }
    }
  )

  module_providers_grouped = { for provider in var.module_providers : provider.name => provider... }
  versions_content = templatefile(
    "${path.module}/templates/versions.tftpl",
    {
      name              = local.name_specials_clean
      terraform_version = var.terraform_version
      providers = [for group in local.module_providers_grouped : {
        name                  = group[0].name
        version               = group[0].version
        source                = coalesce(group[0].source, "hashicorp/${group[0].name}")
        configuration_aliases = replace(jsonencode([for item in group : "${group[0].name}.${item.alias}" if item.alias != null]), "\"", "")
      }]
      terraform_cloud = {
        org             = var.workspace.org
        workspaces_tags = jsonencode(var.workspace.tags)
      }
      terraform_backend = {
        name    = var.terraform_backend.name
        configs = { for key, value in var.terraform_backend.configs : key => jsonencode(value) }
      }
    }
  )

  providers_content = templatefile(
    "${path.module}/templates/providers.tftpl",
    {
      providers = var.module_providers
    }
  )

  outputs_content = templatefile("${path.module}/templates/outputs.tftpl", {})

  files_to_generate = [
    {
      name    = "main"
      content = local.main_content
    },
    {
      name    = "versions"
      content = local.versions_content
    },
    {
      name    = "providers"
      content = local.providers_content
    },
    {
      name    = "outputs"
      content = local.outputs_content
    },
  ]

}

resource "local_file" "this" {
  for_each = { for file in local.files_to_generate : file.name => file }

  content  = each.value.content
  filename = "${trimsuffix(var.target_dir, "/")}/${var.name}/${each.value.name}.tf"
}

resource "tfe_workspace" "this" {
  name         = local.name_specials_clean
  description  = var.workspace.description
  organization = var.workspace.org
  tag_names    = var.workspace.tags

  working_directory = "${var.workspace.directory}${var.name}"

  dynamic "vcs_repo" {
    for_each = try(var.repo.identifier, null) == null ? [] : [var.repo]

    content {
      identifier         = var.repo.identifier
      branch             = try(var.repo.branch, null)
      ingress_submodules = try(var.repo.ingress_submodules, null)
      oauth_token_id     = try(var.repo.oauth_token_id, null)
      tags_regex         = try(var.repo.tags_regex, null)
    }
  }
}

resource "tfe_workspace_variable_set" "this" {
  for_each = { for key, variable_set_id in var.variable_set_ids : key => variable_set_id }

  workspace_id    = tfe_workspace.this.id
  variable_set_id = each.value
}