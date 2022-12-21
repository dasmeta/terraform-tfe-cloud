module "this" {
  source = "../../"

  name = "test_aws_credentials"
  org  = local.terraform_cloud_org
  variables = [
    {
      key       = "AWS_ACCESS_KEY_ID"
      value     = "HERE_IS_YOUR_ACCESS_KEY"
      category  = "env"
      sensitive = true
    },
    {
      key       = "AWS_SECRET_ACCESS_KEY"
      value     = "HERE_IS_YOUR_SECRET_KEY"
      category  = "env"
      sensitive = true
    }
  ]
}