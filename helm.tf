# Kubernetes Namespace
resource "kubernetes_namespace" "m306" {
  metadata {
    name = "m306"
  }
}

# Kubernetes Service Account
resource "kubernetes_service_account" "sa" {
  metadata {
    name      = "labrole-sa"
    namespace = "m306"
    annotations = {
      "eks.amazonaws.com/role-arn" = data.aws_iam_role.labrole.arn
    }
  }
}

resource "helm_release" "prod-backend" {
  name       = "prod-m306-helm-backend"
  repository = "oci://${aws_ecr_repository.backend_helm_prod.registry_id}.dkr.ecr.us-east-1.amazonaws.com"

  chart     = "prod-m306-helm-backend"
  version   = "0.1.1"
  namespace = "m306"

  # Ensure ECR authentication is properly configured
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password

  # Override image and service account
  set {
    name  = "image.repository"
    value = aws_ecr_repository.backend_prod.repository_url
  }

  set {
    name  = "image.tag"
    value = "latest"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.sa.metadata[0].name
  }

  set {
    name  = "env.DB_HOST"
    value = aws_rds_cluster.m306.endpoint
  }

  set {
    name  = "env.DB_PORT"
    value = tostring(aws_rds_cluster.m306.port)
  }

  set {
    name  = "env.DB_NAME"
    value = aws_rds_cluster.m306.database_name
  }

  set {
    name  = "env.DB_USER"
    value = aws_rds_cluster.m306.master_username
  }

  set {
    name  = "env.DB_PASSWORD"
    value = aws_rds_cluster.m306.master_password
  }
}