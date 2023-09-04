locals {
  module_path   = path.module
  file_contents = file("${path.module}/../../../tests/debug-escape-issue/example-infra/module-3.yaml")
  yaml          = yamldecode(local.file_contents)

  variables      = local.yaml.variables
  modules        = local.yaml.linked_workspaces
  modules_string = join("|", local.modules)

  # "${module-1.variable-1}"  # => "${data.tfe_outputs.this["module-1"].values.variable-1}"
  # module-1 => data.tfe_outputs.this["module-1"].values
  # result: "${data.tfe_outputs.this[\"module-1\"].values.result.variable-1}"

  modules_with_values = {
    for value in local.modules : value => "data.tfe_outputs.this[\"${value}\"].values"
  }

  variables_encoded = {
    for key, value in local.variables : key => jsonencode(value)
  }

  # variables_example = {
  #   "variable-1"        = "\"${module-1.variable-1}\""
  #   "variable-2"        = "\"something ${module-1.variable-1} and ${module-2.variable-1} else\""
  #   "variable-3"        = "\"module 2 ${module-2.variable-1} else\""
  #   "variable-4"        = "\"module 1 ${module-1.variable-1} else\""
  #   "variable-7"        = "\"module 1 ${module-3.variable-1} else\""
  #   "variable-list-5"   = "[\"module 2 ${module-2.variable-1} else\",\"module 1 ${module-1.variable-1} else\"]"
  #   "variable-object-6" = "{\"module 2 ${module-2.variable-1} else\":\"module 1 ${module-1.variable-1} else\"}"
  # }
  whatever = "/(module-1|module-2|module-3)/data.tfe_outputs.this[\"$1\"].values"
  # modules_example = {
  #   "module-1" = "data.tfe_outputs.this[\"module-1\"].values"
  #   "module-2" = "data.tfe_outputs.this[\"module-2\"].values"
  # }

  variables_replaced = {
    for key, value in local.variables_encoded : key => replace(value, "/(${local.modules_string})/", "data.tfe_outputs.this[\\\"$1\\\"].values")
    # reduce(str, [for k, v in local.replacements : {search = k, replace = v}],
    #   function(acc, values) {
    #     replace(acc, values.search, values.replace)
    #   }
    # )
  }

  variables_final = {
    for key, value in local.variables_replaced : key => jsondecode(value)
  }

  json = jsondecode("\"a\\\"b\"")

  contents = templatefile("template.tftpl", {
    variables = local.variables_final
  })
}
