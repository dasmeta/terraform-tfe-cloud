# terraform-tfe-cloud
The module allows to generate terraform setups in folders and push/link them with terraform cloud workspace, for examples look into "./tests" folder

## minimal example
```hcl
module "this" {
  source = "dasmeta/cloud/tfe"

  name           = "0-my-dns-setup"
  module_source  = "dasmeta/dns/aws"
  module_version = "1.0.0"
  module_vars = {
    zone_name   = dev.example.com
    create_zone = true
    records     = []
  }
}
```