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