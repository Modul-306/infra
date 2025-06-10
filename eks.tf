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

  # Enable CloudWatch logging for all log types
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id,
      aws_subnet.public_subnet_3.id
    ]
    security_group_ids = [aws_security_group.eks.id]
  }

  depends_on = [
    data.aws_iam_role.labrole,
    aws_security_group.eks
  ]

}


# Managed Node Group for fast startup
resource "aws_eks_node_group" "fast_nodes" {
  cluster_name    = aws_eks_cluster.m306.name
  node_group_name = "m306-fast-nodes"
  node_role_arn   = data.aws_iam_role.labrole.arn
  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
    aws_subnet.public_subnet_3.id
  ]

  scaling_config {
    desired_size = 2 # Increased from 1 to 2 nodes
    max_size     = 4 # Increased from 3 to 4 nodes
    min_size     = 1
  }

  instance_types = ["t3.small"] # Upgraded from t3.micro - supports up to 11 pods per node
  capacity_type  = "ON_DEMAND"  # Changed from SPOT for better reliability

  # Use the latest Amazon Linux 2 AMI which is optimized for EKS
  ami_type = "AL2_x86_64"

  # Optimize for faster startup
  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_eks_cluster.m306
  ]

  tags = {
    Name = "m306-fast-nodes"
  }
}

data "aws_eks_cluster_auth" "m306" {
  name = aws_eks_cluster.m306.name
}