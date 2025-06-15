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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.m306.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.m306.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.m306.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.m306.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.m306.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.m306.token
  }
}

# Data sources are in data.tf to avoid circular dependencies
