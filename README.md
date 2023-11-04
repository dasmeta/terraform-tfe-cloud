# Why
We needed way to run terraform modules using yaml files as it is much simpler.

## How
We have decided to use terraform cloud to execute terraform code.
We have decided that it is right to have workspace per module as we do not want giant module dependencies.
We have created terraform module that can parse yaml files, create workspaces and make TFC to execute code / modules.

Current implementation si very basic:
1. accepts module source/version, variables, dependencies and uses variables from other workspaces if allowed.

## Caviats
Modules does generate terraform code from yamls and sets up workspaces but since the code is not yet in git repository first run will fail.
After another apply is run from local and resulting code is comitted to git repo it will pick up code and executel.

## How to use
0. Create workspace in terrqform cloud
1. Create folder and place yaml files in the folder
2. Yaml files point to modules and provide variables like done in tests/basic/example-infra folder
3. Supply variables to the module like done in basic tests
4. Terraform apply will create workspaces and code (by default in _terraform folder).
5. Commit the code and TFC will pick up and apply changes as requested.

## ToDo
1. Modify module to not create workspace immidiately but only when code is comitted (this might create issue with race condition, workspaces can be creared but TFC mighhave had already tried to execute code).
2. There is an issue with some providers (more details in jira).
3. Currently some generated code is escaped which is wrong.
4. Get this repo be managed by terraform module manager terraform repo.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.47.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_provider_custom_vars_default_merged"></a> [provider\_custom\_vars\_default\_merged](#module\_provider\_custom\_vars\_default\_merged) | cloudposse/config/yaml//modules/deepmerge | 1.0.2 |

## Resources

| Name | Type |
|------|------|
| [local_file.this](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tfe_project.project](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project) | resource |
| [tfe_workspace.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |
| [tfe_workspace_variable_set.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_variable_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_linked_workspaces"></a> [linked\_workspaces](#input\_linked\_workspaces) | The list of workspaces from where we can pull outputs and use in our module variables | `list(string)` | `null` | no |
| <a name="input_module_providers"></a> [module\_providers](#input\_module\_providers) | The list of providers to add in providers.tf | `any` | `[]` | no |
| <a name="input_module_source"></a> [module\_source](#input\_module\_source) | The module source | `string` | n/a | yes |
| <a name="input_module_vars"></a> [module\_vars](#input\_module\_vars) | The module variables | `any` | `{}` | no |
| <a name="input_module_version"></a> [module\_version](#input\_module\_version) | The module version | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | module/repo-folder/workspace name and uniq identifier | `string` | n/a | yes |
| <a name="input_output"></a> [output](#input\_output) | The module output | `any` | `[]` | no |
| <a name="input_repo"></a> [repo](#input\_repo) | git/vcs repository configurations | <pre>object({<br>    identifier         = string                  # <organization>/<repository> format repo identifier<br>    branch             = optional(string, null)  # will default to repo default branch if not set<br>    ingress_submodules = optional(string, false) # whether to fetch submodules a]when cloning vcs<br>    oauth_token_id     = optional(string, null)  # the auth token generated by resource tfe_oauth_client<br>    tags_regex         = optional(string, null)  # regular expression used to trigger Workspace run for matching Git tags<br>  })</pre> | `null` | no |
| <a name="input_target_dir"></a> [target\_dir](#input\_target\_dir) | The directory where new module folder will be created, this will be terraform project repository root url | `string` | `"./"` | no |
| <a name="input_terraform_backend"></a> [terraform\_backend](#input\_terraform\_backend) | Allows to set terraform backend configurations | <pre>object({<br>    name    = string<br>    configs = optional(any, {})<br>  })</pre> | <pre>{<br>  "configs": null,<br>  "name": null<br>}</pre> | no |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | The required\_version variable value for terraform{} block in versions.tf | `string` | `">= 1.3.0"` | no |
| <a name="input_variable_set_ids"></a> [variable\_set\_ids](#input\_variable\_set\_ids) | The list of variable set ids to attach to workspace | `list(string)` | `null` | no |
| <a name="input_workspace"></a> [workspace](#input\_workspace) | Terraform cloud workspace configurations | <pre>object({<br>    org                 = string<br>    tags                = optional(list(string), null)<br>    description         = optional(string, null)<br>    directory           = optional(string, "./") # this seems supposed to be the root directory of git repo<br>    global_remote_state = optional(bool, true)   # allow org workspaces access to this workspace state, TODO: there is a way to implement specific workspaces whitelisting using remote_state_consumer_ids, needs apply and testing<br>    project             = optional(string, null) # name of the project to be created and where the workspace should be created<br>    project_id          = optional(string, null) # ID of the project which already exists, if none of project and project_id is provided Default Project is used for storing workspaces<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The ID of terraform cloud project |
| <a name="output_test-data"></a> [test-data](#output\_test-data) | n/a |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | The ID of created terraform cloud workspace |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_credentials_variable_set"></a> [aws\_credentials\_variable\_set](#module\_aws\_credentials\_variable\_set) | ./modules/variable-set | n/a |
| <a name="module_workspaces"></a> [workspaces](#module\_workspaces) | ./modules/workspace | n/a |

## Resources

| Name | Type |
|------|------|
| [tfe_oauth_client.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/oauth_client) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_apply"></a> [auto\_apply](#input\_auto\_apply) | To have workspaces automatically apply after plan is done successfully. | `bool` | `false` | no |
| <a name="input_aws"></a> [aws](#input\_aws) | Cloud Access (goes to shared variable set, should be adjusted) | `map(any)` | <pre>{<br>  "access_key_id": "",<br>  "aws_security_token": "",<br>  "aws_session_token": "",<br>  "default_region": "",<br>  "region": "",<br>  "secret_access_key": ""<br>}</pre> | no |
| <a name="input_git_org"></a> [git\_org](#input\_git\_org) | The github org/owner name | `string` | n/a | yes |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | The vsc(github, gitlab, ...) provider id | `string` | `"gitlab"` | no |
| <a name="input_git_repo"></a> [git\_repo](#input\_git\_repo) | The github repo name without org prefix | `string` | n/a | yes |
| <a name="input_git_token"></a> [git\_token](#input\_git\_token) | The vsc(github, gitlab, ...) personal access token. TFC oauth token can be created manually or externally and oken supplied via this variable. | `string` | n/a | yes |
| <a name="input_org"></a> [org](#input\_org) | The terraform cloud org name | `string` | n/a | yes |
| <a name="input_rootdir"></a> [rootdir](#input\_rootdir) | The directory on git repo where the workspaces creator main.tf file located | `string` | `"./_terraform/"` | no |
| <a name="input_targetdir"></a> [targetdir](#input\_targetdir) | The directory where tf cloud workspace corresponding workspaces will be created | `string` | `"./../_terraform/"` | no |
| <a name="input_token"></a> [token](#input\_token) | The terraform cloud token | `string` | n/a | yes |
| <a name="input_yamldir"></a> [yamldir](#input\_yamldir) | The directory where yamls located | `string` | `"."` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
