# Plan

1. Detect GitHub configurations that provide a raw token rather than an OAuth
   token ID.
2. Look up the bootstrapped `github` variable set in the configured Terraform
   Cloud organization.
3. Manage its sensitive `GITHUB_TOKEN` value from `git_token`.
4. Validate the root Terraform configuration.
