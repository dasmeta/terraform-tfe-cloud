locals {
  agent_token_description = "tfc-agent-token-${var.name}"
  agent_token_secret_name = "${var.name}-agent-token"
  agent_token_secret_key  = "TFC_AGENT_TOKEN"
}
