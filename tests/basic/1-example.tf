module "basic" {
  source = "../.."

  org   = "test-organisation"
  token = "test-token"

  config = {
    root       = "_terraform"
    target_dir = "_terraform"
    yaml_dir   = "example-infra"
  }
}
