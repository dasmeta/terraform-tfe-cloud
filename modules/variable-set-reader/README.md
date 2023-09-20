# variable-set-reader

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.40 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | ~> 0.40 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_variable_set.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/variable_set) | data source |
| [tfe_variables.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/variables) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Terraform cloud variable set name | `string` | n/a | yes |
| <a name="input_org"></a> [org](#input\_org) | The terraform cloud organization name where variable set and variables will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_values"></a> [values](#output\_values) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
