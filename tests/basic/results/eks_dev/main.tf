module "eks_dev" {
  source  = "dasmeta/eks/aws"
  version = "1.2.3"

  availability_zones = []
  cidr = "10.1.0.0/16"
  cluster_name = "dev"
  private_subnets = ["10.1.1.0/24","10.1.2.0/24","10.1.3.0/24"]
  public_subnets = ["10.1.4.0/24","10.1.5.0/24","10.1.6.0/24"]
  users = []
  vpc_name = "dev"
}