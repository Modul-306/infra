# ECR Repositories
resource "aws_ecr_repository" "backend_staging" {
  name = "staging-m306-backend"
  image_tag_mutability = "MUTABLE"
  force_delete = true
}

resource "aws_ecr_repository" "backend_prod" {
  name = "prod-m306-backend"
  image_tag_mutability = "MUTABLE"
  force_delete = true
}

resource "aws_ecr_repository" "frontend_staging" {
  name = "staging-m306-frontend"
  image_tag_mutability = "MUTABLE"
  force_delete = true
}

resource "aws_ecr_repository" "frontend_prod" {
  name = "prod-m306-frontend"
  image_tag_mutability = "MUTABLE"
  force_delete = true
}

# Helm Repositories
resource "aws_ecr_repository" "frontend_helm_prod" {
  name = "prod-m306-helm-frontend"
  image_tag_mutability = "MUTABLE"
  force_delete = true
}

resource "aws_ecr_repository" "frontend_helm_staging" {
  name = "staging-m306-helm-frontend"
  image_tag_mutability = "MUTABLE"
  force_delete = true
}

resource "aws_ecr_repository" "backend_helm_prod" {
  name = "prod-m306-helm-backend"
  image_tag_mutability = "MUTABLE"
  force_delete = true
}

resource "aws_ecr_repository" "backend_helm_staging" {
  name = "staging-m306-helm-backend"
  image_tag_mutability = "MUTABLE"
  force_delete = true
}