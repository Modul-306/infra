# ECR Repositories
resource "aws_ecr_repository" "backend_staging" {
  name = "staging-m306-backend"
}

resource "aws_ecr_repository" "backend_prod" {
  name = "prod-m306-backend"
}

resource "aws_ecr_repository" "frontend_staging" {
  name = "staging-m306-frontend"
}

resource "aws_ecr_repository" "frontend_prod" {
  name = "prod-m306-frontend"
}