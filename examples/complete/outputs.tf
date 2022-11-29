output "vars" {
  value       = module.vars.vars
  description = "vars for the component"
}
# resource "local_file" "foo" {
#     content     = replace(replace(replace(jsonencode(module.vars.vars), ",", ",\n"), ":", "="), "\"", "")
#     filename = "${path.module}/local_file.tf"
# }
# resource "null_resource" "local" {
#   triggers = {
#     template = "${module.vars.vars}"
#   }

#   provisioner "local-exec" {
#     command = "echo \"${module.vars.vars}\" > my-output.tf"
#   }
# }
