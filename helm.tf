# Kubernetes Service Account
resource "kubernetes_service_account" "sa" {
  metadata {
    name      = "labrole-sa"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = data.aws_iam_role.labrole.arn
    }
  }
}

resource "helm_release" "prod-backend" {
  name       = "prod-backend"
  repository = aws_ecr_repository.backend_helm_prod.repository_url
  chart      = aws_ecr_repository.backend_helm_prod.name
  version    = "latest"
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
    value = aws_rds_cluster.m306.port
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