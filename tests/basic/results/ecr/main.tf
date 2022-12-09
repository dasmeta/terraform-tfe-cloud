module "ecr" {
  source  = "dasmeta/ecr/aws"
  version = "1.2.3"

  repositories = ["aa","bb","cc"]
}