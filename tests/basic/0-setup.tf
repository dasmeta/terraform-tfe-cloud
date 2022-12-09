terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.33"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "eu-central-1"
}
