module "dns_dev" {
  source  = "dasmeta/dns/aws"
  version = "1.2.3"

  create_zone = true
  records = []
  zone_name = "dev.example.com"
}