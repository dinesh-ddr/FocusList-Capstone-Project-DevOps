provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"
  name = "focuslist-vpc"
  cidr = "10.0.0.0/16"
  azs             = ["ap-south-1a","ap-south-1b"]
  public_subnets  = ["10.0.1.0/24","10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24","10.0.12.0/24"]
 enable_nat_gateway = true
  single_nat_gateway = true
public_subnet_tags = {
  "kubernetes.io/role/elb" = "1"
  "kubernetes.io/cluster/${var.cluster_name}" = "shared"
}

private_subnet_tags = {
  "kubernetes.io/role/internal-elb" = "1"
  "kubernetes.io/cluster/${var.cluster_name}" = "shared"
}

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.10.1"

  # v21 uses "name" instead of cluster_name
  name               = var.cluster_name
  kubernetes_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # helpful defaults
  endpoint_public_access                    = true
  enable_cluster_creator_admin_permissions  = true

  # v21 uses eks_managed_node_groups instead of node_groups
  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.micro"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }
}



resource "aws_ecr_repository" "repo" {
  name                 = var.ecr_repo
  image_scanning_configuration {
    scan_on_push = true
  }
}
