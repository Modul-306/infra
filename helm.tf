# Kubernetes Namespace
resource "kubernetes_namespace" "m306" {
  metadata {
    name = "m306"
  }
}

# Create ECR docker registry secret - most reliable approach
resource "kubernetes_secret" "ecr_registry_secret" {
  metadata {
    name      = "ecr-registry-secret"
    namespace = kubernetes_namespace.m306.metadata[0].name
  }

  type = "docker-registry"

  data = {
    docker-server = "${aws_ecr_repository.backend_helm_prod.registry_id}.dkr.ecr.us-east-1.amazonaws.com"
    docker-username = data.aws_ecr_authorization_token.token.user_name
    docker-password = data.aws_ecr_authorization_token.token.password
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
  name      = "prod-m306-helm-backend"
  chart     = "oci://${aws_ecr_repository.backend_helm_prod.registry_id}.dkr.ecr.us-east-1.amazonaws.com/prod-m306-helm-backend"
  version   = "0.1.3"
  namespace = kubernetes_namespace.m306.metadata[0].name

  # ECR authentication using repository_username and repository_password
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

  # Use the image pull secret
  set {
    name  = "imagePullSecrets[0].name"
    value = kubernetes_secret.ecr_registry_secret.metadata[0].name
  }

  depends_on = [
    kubernetes_namespace.m306,
    kubernetes_service_account.sa,
    kubernetes_secret.ecr_registry_secret,
    aws_rds_cluster.m306
  ]
}