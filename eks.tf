resource "aws_eks_cluster" "m306" {
  name     = "eks-m306"
  role_arn = data.aws_iam_role.labrole.arn
  version  = "1.32"

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids = [
      aws_subnet.subnet_1.id,
      aws_subnet.subnet_2.id,
      aws_subnet.subnet_3.id
    ]
  }

  depends_on = [
    data.aws_iam_role.labrole
  ]
}

# Node Group for EKS
resource "aws_eks_node_group" "m306" {
  cluster_name    = aws_eks_cluster.m306.name
  node_group_name = "m306-node-group"
  node_role_arn   = data.aws_iam_role.labrole.arn
  subnet_ids = [
    aws_subnet.subnet_1.id,
    aws_subnet.subnet_2.id,
    aws_subnet.subnet_3.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.micro"]
}

# ECR Repository
resource "aws_ecr_repository" "staging" {
  name = "repo-m306-staging"
}

resource "aws_ecr_repository" "prod" {
  name = "repo-m306-prod"
}