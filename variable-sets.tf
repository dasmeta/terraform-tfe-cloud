# create variable set
module "aws_credentials_variable_set" {
  source  = "dasmeta/cloud/tfe//modules/variable-set"
  version = "1.0.2"

  name = "aws_credentials"
  org  = var.org

  variables = [
    {
      key       = "AWS_ACCESS_KEY_ID"
      value     = var.aws.access_key_id
      category  = "env"
      sensitive = true
    },
    {
      key       = "AWS_SECRET_ACCESS_KEY"
      value     = var.aws.secret_access_key
      category  = "env"
      sensitive = true
    },
    {
      key       = "AWS_DEFAULT_REGION"
      value     = var.aws.default_region
      category  = "env"
      sensitive = false
    }
  ]
}
