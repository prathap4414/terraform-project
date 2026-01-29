
variable "cluster_name" {
    description = "Name of the Kubernetes cluster"
    type        = string
    
}



variable "kubernetes_version" {
    description = "Kubernetes version for the EKS cluster"
    type        = string
    
  
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
}
variable "region" {
  description = "AWS region"
  type        = string
}

variable "subnet_id" {
    description = "List of subnet IDs for the EKS node group"
    type        = list(string)
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}