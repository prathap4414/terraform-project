variable "region" {
  description = "AWS region"
  type        = string
}
  
variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    
}
variable "cluster_name" {
    description = "Name of the Kubernetes cluster"
    type        = string
    
}

variable "private_subnet_cidr" {
    description = "CIDR block for the private subnet"
    type        = list(string)
    
  
}
variable "public_subnet_cidr" {
    description = "CIDR block for the public subnet"
    type        = list(string)
   
  
}
