# Why
We needed way to run terraform modules using yaml files as it is much simpler.

## How
We have decided to use terraform cloud to execute terraform code.
We have decided that it is right to have workspace per module as we do not want giant module dependencies.
We have created terraform module that can parse yaml files, create workspaces and make TFC to execute code / modules.

Current implementation is very basic:
1. accepts module source/version, variables, dependencies and uses variables from other workspaces if allowed.

## Caveats
Modules does generate terraform code from yamls and sets up workspaces but since the code is not yet in git repository first run will fail.
After another apply is run from local and resulting code is committed to git repo it will pick up code and execute terraform plan/apply flow in terraform cloud.

## How to use
0. Create workspace in terraform cloud.
1. Create folders/sub-folders and place module yaml files in the folders. The folder names and yaml files name will be used to generate tf cloud workspace name, usually grouping by folders account/environment/product can be used.
2. Yaml files point to modules and provide terraform module standard attributes source/version/variables/providers, like done in tests/basic/example-infra folder
3. Supply variables to the module like done in basic tests
4. Terraform apply will create workspaces and code (by default in _terraform folder).
5. Commit/Push the code and TFC will pick up and apply changes as requested.

## ToDo
1. Modify module to not create workspace immediately but only when code is committed (this might create issue with race condition, workspaces can be created but TFC might have had already tried to execute code).
2. There is an issue with some providers (more details in jira).
3. Get this repo be managed by terraform module manager terraform repo.
4. The aws integration is very tight and aws supposed as base/common provider, so that aws credentials tf cloud variable set being created automatically. Consider to have aws variable-set creations optional/configurable and support more providers.
5. When we have more aws account beside root like dev/prod we have to create separate variable sets with each accounts separate dedicated user. This makes it not possible to have custom managed access permissions for aws sso signed-in users. Find better solution.

## For module developers
1. To enable custom Git hooks for this repository, run the following command in your terminal
```bash
git config --global core.hooksPath ./githooks
```

## Release Notes
- version 2.5.3 brings several improvements
  - creates "tfe-token" variable set which can be attached to yaml module for tf cloud resource creation (like aws dev account env variable)
  -  new `variable_sets` yaml attribute which allows to attach variable set to module by nam. Previously only way to do this was `variable_set_ids` list with variable set ids. Old form still available but it is recommended to use new name list form of passing additional variable sets
  -  `linked_workspaces` yaml attribute can be completely removed as we have implemented auto-detection for this listing
  -  shared _.yaml config files ability based on yaml format anchor/alias ability, this allows to create reusable yaml configs like provider block configs in _.yaml files use in module that are in folder/subfolder where the file is created
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_deepmerge"></a> [deepmerge](#requirement\_deepmerge) | ~> 1.1 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.40 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | ~> 0.40 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_credentials_variable_set"></a> [aws\_credentials\_variable\_set](#module\_aws\_credentials\_variable\_set) | ./modules/variable-set | n/a |
| <a name="module_tfe_token_variable_set"></a> [tfe\_token\_variable\_set](#module\_tfe\_token\_variable\_set) | ./modules/variable-set | n/a |
| <a name="module_workspaces"></a> [workspaces](#module\_workspaces) | ./modules/workspace | n/a |

## Resources

| Name | Type |
|------|------|
| [tfe_oauth_client.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/oauth_client) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_apply"></a> [auto\_apply](#input\_auto\_apply) | To have workspaces automatically apply after plan is done successfully. | `bool` | `false` | no |
| <a name="input_aws"></a> [aws](#input\_aws) | The aws env variables set used as default in all workspaces | <pre>object({<br/>    # enabled           = optional(bool, true) # TODO: uncomment to make this variable set optional to create<br/>    variable_set_name = optional(string, "aws_credentials")<br/>    access_key_id     = optional(string, "")<br/>    secret_access_key = optional(string, "")<br/>    session_token     = optional(string, "")<br/>    security_token    = optional(string, "")<br/>    default_region    = optional(string, "")<br/>    region            = optional(string, "")<br/>  })</pre> | `{}` | no |
| <a name="input_git_branch"></a> [git\_branch](#input\_git\_branch) | The GitHub branch name; if null, the repo's default branch is used | `string` | `null` | no |
| <a name="input_git_enabled"></a> [git\_enabled](#input\_git\_enabled) | Whether to create tfe oauth connection with git repo | `bool` | `true` | no |
| <a name="input_git_oauth_client_name"></a> [git\_oauth\_client\_name](#input\_git\_oauth\_client\_name) | The name of tfe oauth connection with git repo | `string` | `"git-oauth-client"` | no |
| <a name="input_git_org"></a> [git\_org](#input\_git\_org) | The github org/owner name | `string` | `""` | no |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | The vsc(github, gitlab, ...) provider id | `string` | `"gitlab"` | no |
| <a name="input_git_repo"></a> [git\_repo](#input\_git\_repo) | The github repo name without org prefix | `string` | `""` | no |
| <a name="input_git_token"></a> [git\_token](#input\_git\_token) | The vsc(github, gitlab, ...) personal access token. TFC oauth token can be created manually or externally and oken supplied via this variable. | `string` | `""` | no |
| <a name="input_org"></a> [org](#input\_org) | The terraform cloud org name | `string` | n/a | yes |
| <a name="input_rootdir"></a> [rootdir](#input\_rootdir) | The directory on git repo where the workspaces creator main.tf file located | `string` | `"./_terraform/"` | no |
| <a name="input_targetdir"></a> [targetdir](#input\_targetdir) | The directory where tf cloud workspace corresponding workspaces will be created | `string` | `"./../_terraform/"` | no |
| <a name="input_tfe_token_variable_set"></a> [tfe\_token\_variable\_set](#input\_tfe\_token\_variable\_set) | The tfe token variable set configs, this token can be used for tfe provider auth in workspaces to create tfe resources like additional variable sets. | <pre>object({<br/>    enabled = optional(bool, true)<br/>    name    = optional(string, "tfe-token")<br/>  })</pre> | `{}` | no |
| <a name="input_token"></a> [token](#input\_token) | The terraform cloud token | `string` | n/a | yes |
| <a name="input_yamldir"></a> [yamldir](#input\_yamldir) | The directory where yamls located | `string` | `"."` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
