module "vars" {
  source = "../../modules/vars"

  stack_config_local_path = var.stack_config_local_path
  stack                   = var.stack
  component_type          = var.component_type
  component               = var.component

  context = module.this.context
}

module "folders" {
  source = "../../modules/create_folder"
}
module "env" {
  source = "../../modules/env"
  stack_config_local_path = var.stack_config_local_path
  stack                   = var.stack
  component_type          = var.component_type
  component               = var.component
  context = module.this.context
}

# module "stack" {
#   source = "../../modules/stack"

#   stack   = var.stack
#   context = module.this.context
# }
