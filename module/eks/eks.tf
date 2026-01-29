resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
})

    tags = {
        Name = "${var.cluster_name}-eks-cluster-role"
    }
  
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_policy_attachment" {
    role       = aws_iam_role.eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"


}

resource "aws_eks_cluster" "name" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = aws_subnet.private_subnet[*].id
  }

    tags = {
        Name = "${var.cluster_name}-eks-cluster"
    }
  
}

resource "aws_iam_role" "eks_nodegroup_role" {
    name = "${var.cluster_name}-eks-nodegroup-role"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
            Service = "ec2.amazonaws.com"
            }
        },
        ]
    })
    
        tags = {
            Name = "${var.cluster_name}-eks-nodegroup-role"
        }
  
}
resource "aws_iam_role_policy_attachment" "eks_nodegroup_role_policy_attachment" {
    role       = aws_iam_role.eks_nodegroup_role.name
    for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    ])
    policy_arn = each.value
}

resource "aws_eks_node_group" "node_group" {
    for_each = var.node_groups
  cluster_name    = aws_eks_cluster.name.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = var.subnet_id
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

    tags = {
        Name = "${var.cluster_name}-eks-node-group"
    }
  capacity_type = "ON_DEMAND"
  instance_types  = ["t3.medium"]
  
}