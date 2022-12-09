module "eks_prod" {
  source  = "dasmeta/eks/aws"
  version = "1.2.3"

  availability_zones = []
  cidr = "10.2.0.0/16"
  cluster_name = "prod"
  private_subnets = ["10.2.1.0/24","10.2.2.0/24","10.2.3.0/24"]
  public_subnets = ["10.2.4.0/24","10.2.5.0/24","10.2.6.0/24"]
  users = []
  vpc_name = "prod"
}