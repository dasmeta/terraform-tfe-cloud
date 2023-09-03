locals {
  name_specials_clean         = replace(var.name, "/[^a-zA-Z0-9_-]+/", "_")
  project_name_specials_clean = var.workspace.project != null ? replace(var.workspace.project, "/[^a-zA-Z0-9 _-]+/", "") : null
  linked_workspaces_mapping   = { for workspace in coalesce(var.linked_workspaces, []) : workspace => "data.tfe_outputs.this[\\\"${workspace}\\\"].values.results" }
  note                        = "This file and its content are generated based on config, pleas check README.md for more details"
  module_nested_provider      = { for provider in var.module_providers : "${provider.name}${try(provider.alias, "") != "" ? ".${provider.alias}" : ""}" => "${provider.name}${try(provider.alias, "") != "" ? ".${provider.alias}" : ""}" if try(provider.module_nested_provider, false) }

  # main.tf file content
  main_content = templatefile(
    "${path.module}/templates/main.tf.tftpl",
    {
      note                   = local.note
      source                 = var.module_source
      version                = var.module_version
      module_nested_provider = local.module_nested_provider == {} ? null : local.module_nested_provider
      # variables              = {}
      variables = { for key, value in var.module_vars : key =>
        jsondecode(
          format(
            replace(
              jsonencode(value),
              "/(${join("|", keys(local.linked_workspaces_mapping))})/",
              "%s"
            ),
            [
              for key in flatten(
                regexall(
                  "(${join("|", keys(local.linked_workspaces_mapping))})",
                  jsonencode(value)
                )
              ) : try(local.linked_workspaces_mapping[key], "")
            ]...
          )
        )
      }
      linked_workspaces = jsonencode(coalesce(var.linked_workspaces, []))
      workspace         = var.workspace
    }
  )

  module_providers_grouped = { for provider in var.module_providers : provider.name => provider... }
  # versions.tf file content
  versions_content = templatefile(
    "${path.module}/templates/versions.tf.tftpl",
    {
      note              = local.note
      name              = local.name_specials_clean
      terraform_version = var.terraform_version
      providers = [for group in local.module_providers_grouped : {
        name                  = group[0].name
        version               = group[0].version
        source                = coalesce(try(group[0].source, null), "hashicorp/${group[0].name}")
        configuration_aliases = replace(jsonencode([for item in group : "${group[0].name}.${try(item.alias, null)}" if try(item.alias, null) != null]), "\"", "")
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

  # providers.tf file content
  providers_content = templatefile(
    "${path.module}/templates/providers.tf.tftpl",
    {
      note = local.note
      providers = [for provider in var.module_providers : merge(provider, {
        alias = try(provider.alias, null)
        variables = { for key, value in try(provider.variables, {}) : key =>
          jsondecode(format(
            replace(jsonencode(value), "/(${join("|", keys(local.linked_workspaces_mapping))})/", "%s"),
            [for key in flatten(regexall("(${join("|", keys(local.linked_workspaces_mapping))})", jsonencode(value))) : try(local.linked_workspaces_mapping[key], "")]...
          )) if !try(contains(keys(local.provider_custom_var_blocks[provider.name]), key), false)
        }
        blocks = { for key, value in try(provider.blocks, {}) : key =>
          jsondecode(format(
            replace(jsonencode(value), "/(${join("|", keys(local.linked_workspaces_mapping))})/", "%s"),
            [for key in flatten(regexall("(${join("|", keys(local.linked_workspaces_mapping))})", jsonencode(value))) : try(local.linked_workspaces_mapping[key], "")]...
          )) if !try(contains(keys(local.provider_custom_var_blocks[provider.name]), key), false)
        }
        custom_var_blocks = { for key, value in try(module.provider_custom_vars_default_merged["${provider.name}${try(provider.alias, null) == null ? "" : "-${provider.alias}"}"].merged) : key => value if try(contains(keys(local.provider_custom_var_blocks[provider.name]), key), false) }
      })]
    }
  )

  # outputs.tf file content
  outputs_content = templatefile(
    "${path.module}/templates/outputs.tf.tftpl",
    {
      note      = local.note
      sensitive = try(var.output.sensitive, null)
    }
  )

  # README.md file content
  readme_content = templatefile(
    "${path.module}/templates/README.md.tftpl",
    {
      workspace_name = local.name_specials_clean
      module_source  = var.module_source
      module_version = var.module_version
    }
  )

  files_to_generate = [
    {
      name    = "main.tf"
      content = local.main_content
    },
    {
      name    = "versions.tf"
      content = local.versions_content
    },
    {
      name    = "providers.tf"
      content = local.providers_content
    },
    {
      name    = "outputs.tf"
      content = local.outputs_content
    },
    {
      name    = "README.md"
      content = local.readme_content
    },
  ]

  provider_custom_var_blocks = {
    aws = {
      default_tags = {
        tags = {
          ManagedBy               = "terraform"
          AppliedFrom             = "terraform-cloud"
          TerraformModuleSource   = var.module_source
          TerraformModuleVersion  = var.module_version
          TerraformCloudWorkspace = local.name_specials_clean
        }
      }
    }
  }

  project_id = try(tfe_project.project[0].id, var.workspace.project_id)
}

module "provider_custom_vars_default_merged" {
  source  = "cloudposse/config/yaml//modules/deepmerge"
  version = "1.0.2"

  for_each = { for provider in var.module_providers : "${provider.name}${try(provider.alias, null) == null ? "" : "-${provider.alias}"}" => provider }

  maps = [
    try(each.value.variables, {}),
    try(local.provider_custom_var_blocks[each.value.name], {})
  ]
}


output "test-data" {
  value = [for provider in var.module_providers : merge(provider, {
    blocks = { for key, value in try(provider.blocks, {}) : key =>
      format(
        replace(jsonencode(value), "/(${join("|", keys(local.linked_workspaces_mapping))})/", "%s"),
        [for key in flatten(regexall("(${join("|", keys(local.linked_workspaces_mapping))})", jsonencode(value))) : try(local.linked_workspaces_mapping[key], "")]...
      ) if !try(contains(keys(local.provider_custom_var_blocks[provider.name]), key), false)
    }
  })]
}
