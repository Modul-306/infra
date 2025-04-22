resource "aws_eks_cluster" "m306" {
  name = "eks-m306"

  role_arn = data.aws_iam_role.labrole.arn
  version  = "1.31"

  compute_config {
    enabled       = true
    node_pools    = ["general-purpose"]
    node_role_arn = data.aws_iam_role.labrole.arn
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = [
      aws_subnet.subnet_1.id,
      aws_subnet.subnet_2.id,
      aws_subnet.subnet_3.id
    ]
  }
}

# ECR Repository
resource "aws_ecr_repository" "example" {
  name = "repo-m306"
}