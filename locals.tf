locals {
  name_specials_clean         = replace(var.name, "/[^a-zA-Z0-9_-]+/", "_")
  project_name_specials_clean = var.workspace.project != null ? replace(var.workspace.project, "/[^a-zA-Z0-9 _-]+/", "") : null
  linked_workspaces_mapping   = { for workspace in coalesce(var.linked_workspaces, []) : workspace => "data.tfe_outputs.this[\"${workspace}\"].values.results" }
  main_content = templatefile(
    "${path.module}/templates/main.tftpl",
    {
      source  = var.module_source
      version = var.module_version
      variables = { for key, value in var.module_vars : key =>
        format(
          replace(jsonencode(value), "/(${join("|", keys(local.linked_workspaces_mapping))})/", "%s"),
          [for key in flatten(regexall("(${join("|", keys(local.linked_workspaces_mapping))})", jsonencode(value))) : try(local.linked_workspaces_mapping[key], "")]...
      ) }
      linked_workspaces = jsonencode(coalesce(var.linked_workspaces, []))
      workspace         = var.workspace
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
