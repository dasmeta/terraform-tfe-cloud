#### This folder content has been generated from by using special terraform code generator module. It is supposed not direct/manual change should be go into files in this folder if there is no special need(like when one debugging) or making hotfix. Please follow the flow/format and instruction on how to manage this content using configuration files (most possible it is .yaml file in root of repo) and corresponding CI/CD action(or terraform generator code next to .yaml file)

#### the module can be found here https://github.com/dasmeta/terraform-tfe-cloud


```txt
tf cloud workspace name: component-1
tf module source: dasmeta/account/aws
tf_module version: 1.2.2
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | dasmeta/account/aws | 1.2.2 |

## Resources

| Name | Type |
|------|------|
| [tfe_outputs.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/outputs) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_results"></a> [results](#output\_results) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
