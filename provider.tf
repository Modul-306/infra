terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = aws_eks_cluster.m306.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.m306.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.m306.token
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.m306.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.m306.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.m306.token
  }

  registry {
    url      = aws_ecr_repository.backend_helm_prod.repository_url
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

# Get ECR authorization token
data "aws_ecr_authorization_token" "token" {}