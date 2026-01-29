output "vpc_id" {
    value = aws_vpc.my_vpc.id
  
}
output "private_subnet_ids" {
    value = aws_subnet.private_subnet[*].id
  
}
output "public_subnet_ids" {
    value = aws_subnet.public_subnet[*].id
  
}
output "aws_availability_zones" {
    value = local.azs
}
