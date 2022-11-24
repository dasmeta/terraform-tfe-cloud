locals {
  need_default_workspace_trigger   = var.workspace_name != var.default_management_workspace_trigger ? true : false
  create_default_workspace_trigger = local.need_default_workspace_trigger && var.default_management_workspace_trigger != null ? 1 : 0
}
