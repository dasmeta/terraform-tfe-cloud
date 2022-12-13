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