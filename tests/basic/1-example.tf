module "basic" {
  source = "../.."

  org   = "dasmeta-testing"
  token = "ojODA5TvvwpL1A.atlasv1.6ifl0D5Q3zaonS3GPc5aXSLo4HWxCScaXf3u0sSVy4Eb4I62HAcs75W9l4EO9iBkFyE"

  rootdir   = "_terraform"
  targetdir = "_terraform"
  yamldir   = "example-infra"

  git_provider = "github"
  git_org      = "dasmeta-testing"
  git_repo     = "test-infrastructure"
  git_token    = "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"

  aws = {
    access_key_id     = ""
    secret_access_key = ""
    default_region    = ""
  }

  auto_apply = true
}
