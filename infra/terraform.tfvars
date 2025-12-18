region       = "ap-south-1"
project_name = "focuslist"

cluster_name = "focuslist-eks-cluster"
eks_version  = "1.29"

vpc_cidr             = "10.0.0.0/16"
azs                  = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

ssh_cidr = "0.0.0.0/0"

node_instance_type = "t3.micro"
node_disk_size     = 20
node_desired       = 2
node_min           = 1
node_max           = 3

ecr_repositories = ["focuslist-capstone-repo"]
