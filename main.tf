locals {
  main_content = templatefile(
    "${path.module}/templates/main.tftpl",
    {
      name      = var.name
      source    = var.module_source
      version   = var.module_version
      variables = { for key, value in var.module_vars : key => jsonencode(value) }
    }
  )

  module_providers_grouped = { for provider in var.module_providers : provider.name => provider... }
  versions_content = templatefile(
    "${path.module}/templates/versions.tftpl",
    {
      terraform_version = var.terraform_version
      providers = [for group in local.module_providers_grouped : {
        name                  = group[0].name
        version               = group[0].version
        source                = coalesce(group[0].source, "hashicorp/${group[0].name}")
        configuration_aliases = jsonencode([for item in group : "${group[0].name}.${item.alias}" if item.alias != null])
      }]
      terraform_cloud = {
        org             = var.terraform_cloud.org
        workspaces_tags = jsonencode(var.terraform_cloud.workspaces_tags)
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

  outputs_content = templatefile(
    "${path.module}/templates/outputs.tftpl",
    {
      name = var.name
    }
  )

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
  count = var.terraform_cloud.generate_workspace ? 1 : 0

  name              = var.name
  organization      = var.terraform_cloud.org
  tag_names         = var.terraform_cloud.workspaces_tags
  vcs_repo          = var.terraform_cloud.git.repo
  working_directory = var.terraform_cloud.git.directory
}