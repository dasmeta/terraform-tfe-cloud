module "aws_credentials_variable_set" {
  source = "./modules/variable-set"

  # count       = var.aws.enabled ? 1 : 0 # it is supposed that this module can be used with other cloud providers also TODO: uncomment to have this variable set optional to create

  name = var.aws.variable_set_name
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
    },
    {
      key       = "AWS_REGION"
      value     = var.aws.region
      category  = "env"
      sensitive = false
    },
    {
      key       = "AWS_SESSION_TOKEN"
      value     = var.aws.session_token
      category  = "env"
      sensitive = true
    },
    {
      key       = "AWS_SECURITY_TOKEN"
      value     = var.aws.security_token
      category  = "env"
      sensitive = true
    },
  ]
}

module "tfe_token_variable_set" {
  source = "./modules/variable-set"

  count = var.tfe_token_variable_set.enabled ? 1 : 0

  description = "TFE token for the current organization"
  global      = false
  name        = var.tfe_token_variable_set.name
  org         = var.org
  variables = [
    {
      "category" : "env",
      "key" : "TFE_TOKEN",
      "sensitive" : true,
      "value" : var.token
    }
  ]
}
