# terraform-tfe-cloud
The module allows to create terraform cloud standard and environment variables

## minimal example
```hcl
module "this" {
  source = "dasmeta/cloud/tfe//modules/variables"

  org       = "test-tf-cloud-org"
  name      = "test-variable-set"
  variables = [
   # your variables here
  ]
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | ~> 0.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_variable.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable_set.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) | resource |
| [tfe_workspace_variable_set.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_variable_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Terraform cloud variable set description | `string` | `""` | no |
| <a name="input_global"></a> [global](#input\_global) | Whether the variable set is global(applies on all workspaces in org) or workspace specific | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Terraform cloud variable set name | `string` | n/a | yes |
| <a name="input_org"></a> [org](#input\_org) | The terraform cloud organization name where variable set and variables will be created | `string` | n/a | yes |
| <a name="input_variables"></a> [variables](#input\_variables) | The list of variables/envs | <pre>list(object({<br>    key         = string<br>    value       = string<br>    category    = string # Valid values are terraform or env<br>    description = optional(string, "")<br>    hcl         = optional(bool, false)<br>    sensitive   = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_workspace_ids"></a> [workspace\_ids](#input\_workspace\_ids) | The list of workspaces to attach variable set to | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
