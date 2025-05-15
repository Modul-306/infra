
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
  repository = "https://charts.helm.sh/stable"  # Replace with your Helm repo URL
  chart      = "nginx"                          # Replace with your chart name
  version    = "1.0.0"                          # Specify chart version

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
}