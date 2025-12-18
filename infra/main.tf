provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.0"
  name = "focuslist-vpc"
  cidr = "10.0.0.0/16"
  azs             = ["ap-south-1a","ap-south-1b"]
  public_subnets  = ["10.0.1.0/24","10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24","10.0.12.0/24"]
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "21.10.1"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.micro"
    }
  }
}

resource "aws_ecr_repository" "repo" {
  name                 = var.ecr_repo
  image_scanning_configuration {
    scan_on_push = true
  }
}
