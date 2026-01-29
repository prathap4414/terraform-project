output "vpc_id" {
    value = module.vpc.vpc_id
  
}

output "az_to_public_subnet" {
  value = {
    for idx, az in module.vpc.aws_availability_zones :
    az => local.public_subnet_cidr[idx]
  }
}
output "az_to_private_subnet" {
  value = {
    for idx, az in module.vpc.aws_availability_zones :
    az => local.private_subnet_cidr[idx]
  }
}
output "ec2_instance_ips" {
    value = aws_instance.web[*].public_ip
}