output "tfc_agent_pool_id" {
  description = "Terraform Cloud agent pool ID created for the configured agent."
  value       = tfe_agent_pool.this.id
}

output "tfc_agent_pool_name" {
  description = "Terraform Cloud agent pool name created for the configured agent."
  value       = tfe_agent_pool.this.name
}

output "tfc_agent_token_id" {
  description = "Terraform Cloud agent token resource ID (token value is not output)."
  value       = tfe_agent_token.this.id
}

output "agent_release_name" {
  description = "Helm release name for the Kubernetes agent deployment."
  value       = helm_release.agent.name
}

output "agent_namespace" {
  description = "Kubernetes namespace where the Helm release is installed."
  value       = helm_release.agent.namespace
}
