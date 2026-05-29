moved {
  from = local_file.this["README.md"]
  to   = module.renderer.local_file.this["README.md"]
}

moved {
  from = local_file.this["main.tf"]
  to   = module.renderer.local_file.this["main.tf"]
}

moved {
  from = local_file.this["outputs.tf"]
  to   = module.renderer.local_file.this["outputs.tf"]
}

moved {
  from = local_file.this["providers.tf"]
  to   = module.renderer.local_file.this["providers.tf"]
}

moved {
  from = local_file.this["versions.tf"]
  to   = module.renderer.local_file.this["versions.tf"]
}
