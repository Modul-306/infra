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

# Fargate Profile
resource "aws_eks_fargate_profile" "m306" {
  cluster_name           = aws_eks_cluster.m306.name
  fargate_profile_name   = "m306-fargate-profile"
  pod_execution_role_arn = data.aws_iam_role.labrole.arn
  subnet_ids = [
    aws_subnet.subnet_1.id,
    aws_subnet.subnet_2.id,
    aws_subnet.subnet_3.id
  ]

  selector {
    namespace = "m306"
  }
}
