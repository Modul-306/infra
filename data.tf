data "aws_iam_role" "labrole" {
  name = "LabRole"
}

data "aws_ecr_authorization_token" "token" {}

# EKS cluster data sources for providers
data "aws_eks_cluster" "m306" {
  name       = aws_eks_cluster.m306.name
  depends_on = [aws_eks_cluster.m306]
}

data "aws_eks_cluster_auth" "m306" {
  name       = aws_eks_cluster.m306.name
  depends_on = [aws_eks_cluster.m306]
}
