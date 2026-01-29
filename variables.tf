variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}
variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "1.0.0.0/16"
  
}
variable "cluster_name" {
    description = "Name of the Kubernetes cluster"
    type        = string
    default     = "my-cluster"
}

locals {
  private_subnet_cidr = [
    for i in range(3) :
    cidrsubnet(var.vpc_cidr, 8, i + 1)
  ]

  public_subnet_cidr = [
    for i in range(3) :
    cidrsubnet(var.vpc_cidr, 8, i + 4)
  ]
}

variable "kubernetes_version" {
    description = "Kubernetes version for the EKS cluster"
    type        = string
    default     = "1.30"
  
}
variable "node_groups" {
    description = "Map of node groups"
    type        = map(object({
        instance_type = string
        capacity_type = string
        scaling_config = object({
        desired_size  = number
        min_size      = number
        max_size      = number
        })
    }))
    default     = {
        "general" = {
        instance_type = "t3.medium"
        capacity_type = "ON_DEMAND"
        scaling_config = {
            desired_size = 2
            min_size     = 1
            max_size     = 3
        }
        }
    }
  }
  variable "instance_keypair" {
    description = "Key pair name for EC2 instances"
    type        = string
    default     = "newkeypair"
    
  }