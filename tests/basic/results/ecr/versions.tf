terraform {
  backend "s3" {

    bucket = "test-state-bucket"
    key = "state.tfstate"
    region = "us-east-1"
  }
  
  required_providers {
  
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
      configuration_aliases = ["aws.virginia"]
    }
  
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0.0"
      configuration_aliases = []
    }
  
  }

  required_version = ">= 1.3.0"
}
