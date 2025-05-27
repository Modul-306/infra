resource "aws_security_group" "eks" {
  name        = "m306-eks-sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.network.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic from anywhere for API server"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "m306-eks-sg"
  }
}

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
    security_group_ids = [aws_security_group.eks.id]
  }

  depends_on = [
    data.aws_iam_role.labrole,
    aws_security_group.eks
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
    namespace = "default"
  }

  selector {
    namespace = "kube-system"
  }

  selector {
    namespace = "m306"
  }

  selector {
    namespace = "m306-staging"
  }
}

data "aws_eks_cluster_auth" "m306" {
  name = aws_eks_cluster.m306.name
}