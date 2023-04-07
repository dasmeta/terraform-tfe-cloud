output "workspace_id" {
  value       = tfe_workspace.this.id
  description = "The ID of created terraform cloud workspace"
}

output "project_id" {
  value       = local.project_id
  description = "The ID of terraform cloud project"
}
