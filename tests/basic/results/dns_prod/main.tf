module "dns_prod" {
  source  = "dasmeta/dns/aws"
  version = "1.2.3"

  create_zone = true
  records = []
  zone_name = "prod.example.com"
}