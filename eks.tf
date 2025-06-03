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

# Managed Node Group for fast startup
resource "aws_eks_node_group" "fast_nodes" {
  cluster_name    = aws_eks_cluster.m306.name
  node_group_name = "m306-fast-nodes"
  node_role_arn   = data.aws_iam_role.labrole.arn
  subnet_ids = [
    aws_subnet.subnet_1.id,
    aws_subnet.subnet_2.id,
    aws_subnet.subnet_3.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.micro"] # Good balance of cost and performance for fast startup
  capacity_type  = "SPOT"       # More reliable startup than spot instances

  # Use the latest Amazon Linux 2 AMI which is optimized for EKS
  ami_type = "AL2_x86_64"

  # Enable fast launch by using a launch template
  launch_template {
    name    = "eks-fast-launch"
    version = "1"
  }

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

# Launch template for the node group
resource "aws_launch_template" "eks_fast_launch" {
  name = "eks-fast-launch"

  # Pre-configure user data for faster bootstrap
  user_data = base64encode(<<-EOF
    MIME-Version: 1.0
    Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

    --==MYBOUNDARY==
    Content-Type: text/cloud-config; charset="us-ascii"

    #cloud-config
    cloud_final_modules:
    - [users-groups, always]

    --==MYBOUNDARY==
    Content-Type: text/x-shellscript; charset="us-ascii"

    #!/bin/bash
    /etc/eks/bootstrap.sh ${aws_eks_cluster.m306.name} \\
      --container-runtime containerd \\
      --kubelet-extra-args "--max-pods=110" \\
      --b64-cluster-ca ${aws_eks_cluster.m306.certificate_authority[0].data}
    --==MYBOUNDARY==--
    EOF
  )

  vpc_security_group_ids = [aws_security_group.eks.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "m306-eks-fast-node"
    }
  }
}

data "aws_eks_cluster_auth" "m306" {
  name = aws_eks_cluster.m306.name
}