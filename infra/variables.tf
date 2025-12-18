variable "region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "focuslist-eks-cluster"
}

variable "ecr_repo" {
  description = "ECR repository name"
  type        = string
  default     = "focuslist-capstone-repo"
}
