module "this" {
  source = "../../"

  for_each = { for key, item in yamldecode(file("./mocks/modules.yaml")) : key => item }

  name           = each.key
  module_source  = each.value.source
  module_version = each.value.version
  module_vars    = each.value.variables
  target_dir     = "./results/"

  module_providers = [
    {
      name    = "aws"
      version = "~> 4.0.0"

      custom_vars = {
        region = "eu-central-1"
      }
    },
    {
      name    = "aws"
      alias   = "virginia"
      version = "~> 4.0.0"

      custom_vars = {
        region = "us-east-1"
      }
    },
    {
      name    = "google"
      version = "~> 4.0.0"

      custom_vars = {
        project = "test-gcp-project"
        region  = "us-east-1"
      }
    }
  ]

  # terraform_cloud = {
  #   org             = "my-terraform-cloud-org"
  #   workspaces_tags = [each.key]
  # }

  terraform_backend = {
    name = "s3"
    configs = {
      bucket = "test-state-bucket"
      key    = "state.tfstate"
      region = "us-east-1"
    }
  }
}