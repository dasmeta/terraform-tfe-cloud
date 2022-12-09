provider "aws" {

  region = "eu-central-1"
}
provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}
provider "google" {

  project = "test-gcp-project"
  region = "us-east-1"
}
