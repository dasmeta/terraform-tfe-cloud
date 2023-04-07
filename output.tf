output "debug" {
  value = {
    module_providers_grouped = local.module_providers_grouped
    provider_custom_vars     = module.provider_custom_vars_default_merged
  }
}
