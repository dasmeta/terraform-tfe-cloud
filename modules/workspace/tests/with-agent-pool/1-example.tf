module "this" {
  source = "../../"

  name           = "with-agent-pool"
  module_source  = "dasmeta/empty/null"
  module_version = "1.2.2"

  workspace = {
    org             = var.tfc_organization
    directory       = "./"
    agent_pool_name = "tfc-agent" # make sure the agent pool named "tfc-agent" already exists in the organization
  }

  repo = {
    enabled = false
  }
}

/* Expected behavior:
   Workspace settings use execution_mode "agent" and
   assign agent pool by name "tfc-agent".
*/
