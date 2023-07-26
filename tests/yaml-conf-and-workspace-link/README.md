## in order to run this test you will need to set some env variables for provider authentication and set one variable. Here are the ones you will need to have set:
```sh
 export TF_VAR_github_token=ghp_xxxxxxxxxxxxxxx
 export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxx
 export TFE_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxx
 export AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxxxxxx
 export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxx
```

the TF_VAR_github_token and GITHUB_TOKEN are same and contain user github personal access token, check the docs here:
https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

for TFE_TOKEN check the docs here:
https://registry.terraform.io/providers/hashicorp/tfe/latest/docs

for aws access tokens you will need to have a user having api/cli access to create aws user


## NOTE about running the `terraform apply`
 you will need to run twice the terraform apply to have at firs the files generated and then pushed into git repo

## NOTE about `terraform destroy`
 you will need to run switch config yaml file (this is in `./1-example.tf` file) from `modules.yaml` to `modules-state-cleanup.yaml` and apply twice for cleaning terraform state to be able to remove terraform workspace having non empty state
 also make sure that the workspace is not locked(there are pending actions like waiting for approve of planned)

 please manually remove github repository `test-repo-terraform-tfe-cloud` as it is getting archived(TODO: check if e can permanently delete git repo in terraform destroy) after destruction an second run fails with repo exist error
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.41 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 4.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.40 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_test"></a> [test](#provider\_test) | n/a |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | ~> 0.40 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_credentials_variable_set"></a> [aws\_credentials\_variable\_set](#module\_aws\_credentials\_variable\_set) | ../../modules/variable-set | n/a |
| <a name="module_aws_user"></a> [aws\_user](#module\_aws\_user) | dasmeta/modules/aws//modules/aws-iam-user | 1.5.2 |
| <a name="module_github_repository"></a> [github\_repository](#module\_github\_repository) | dasmeta/repository/github | 0.7.2 |
| <a name="module_this"></a> [this](#module\_this) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| test_assertions.dummy | resource |
| [tfe_oauth_client.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/oauth_client) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | This is the same as GITHUB\_TOKEN env variable will be set. This will setup terraform cloud to git repo connection authentication | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
