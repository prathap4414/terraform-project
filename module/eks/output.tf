output "eks_entrypoint" {
    value = aws_eks_cluster.name.endpoint
  
}

output "cluster_name" {
    value = aws_eks_cluster.name.name
}
output "vpc_id" {
    value = aws_vpc_my_vpc.id
  
}