variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "focuslist"
}

variable "cluster_name" {
  type    = string
  default = "focuslist-eks-cluster"
}

variable "eks_version" {
  type    = string
  default = "1.29"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

# For screenshots/demo, this is easiest. For real security, set to your public IP /32.
variable "ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "node_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "node_disk_size" {
  type    = number
  default = 20
}

variable "node_desired" {
  type    = number
  default = 2
}

variable "node_min" {
  type    = number
  default = 1
}

variable "node_max" {
  type    = number
  default = 3
}

variable "ecr_repositories" {
  type    = list(string)
  default = ["focuslist-capstone-repo"]
}
