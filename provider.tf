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
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.m306.name]
  }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.m306.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.m306.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.m306.name]
      command     = "aws"
    }
  }
}
