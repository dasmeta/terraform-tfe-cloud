locals {
  descriptor_stack = lookup(module.always.descriptors, "stack", null)
  stack_name = var.stack != null ? var.stack : (
    local.descriptor_stack != null ? local.descriptor_stack : (
      module.always.tenant != null && module.always.tenant != "" ? format("%s-%s-%s", module.always.tenant, module.always.environment, module.always.stage) : (
        format("%s-%s", module.always.environment, module.always.stage)
      )
    )
  )
}
