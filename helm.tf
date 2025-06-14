# Kubernetes Namespace
resource "kubernetes_namespace" "m306" {
  metadata {
    name = "m306"
  }

  depends_on = [
    aws_eks_cluster.m306,
    aws_eks_node_group.fast_nodes,
  ]
}

# Create ECR docker registry secret - most reliable approach
resource "kubernetes_secret" "ecr_registry_secret" {
  metadata {
    name      = "ecr-registry-secret"
    namespace = kubernetes_namespace.m306.metadata[0].name
  }

  type = "docker-registry"

  data = {
    docker-server   = "${aws_ecr_repository.backend_helm_prod.registry_id}.dkr.ecr.us-east-1.amazonaws.com"
    docker-username = data.aws_ecr_authorization_token.token.user_name
    docker-password = data.aws_ecr_authorization_token.token.password
  }

  depends_on = [
    kubernetes_namespace.m306,
    aws_eks_cluster.m306,
    aws_eks_node_group.fast_nodes
  ]
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

  depends_on = [
    kubernetes_namespace.m306,
    aws_eks_cluster.m306,
    aws_eks_node_group.fast_nodes
  ]
}

resource "helm_release" "prod-backend" {
  name      = "prod-m306-helm-backend"
  chart     = "oci://${aws_ecr_repository.backend_helm_prod.registry_id}.dkr.ecr.us-east-1.amazonaws.com/prod-m306-helm-backend"
  version   = "0.1.5"
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
    aws_rds_cluster.m306,
    aws_eks_cluster.m306,
    aws_eks_node_group.fast_nodes
  ]
}

# Create service account for AWS Load Balancer Controller using existing LabRole
resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = data.aws_iam_role.labrole.arn
    }
  }

  depends_on = [
    aws_eks_cluster.m306,
    aws_eks_node_group.fast_nodes
  ]
}

# AWS Load Balancer Controller - using existing LabRole
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.13.2"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.m306.name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws_load_balancer_controller.metadata[0].name
  }

  # Skip IAM policy creation since we're using LabRole
  set {
    name  = "enableServiceMutatorWebhook"
    value = "false"
  }

  depends_on = [
    aws_eks_cluster.m306,
    aws_eks_node_group.fast_nodes,
    kubernetes_service_account.aws_load_balancer_controller
  ]
}

# Frontend Helm Release
resource "helm_release" "prod-frontend" {
  name      = "prod-m306-helm-frontend"
  chart     = "oci://${aws_ecr_repository.frontend_helm_prod.registry_id}.dkr.ecr.us-east-1.amazonaws.com/prod-m306-helm-frontend"
  version   = "0.1.1"
  namespace = kubernetes_namespace.m306.metadata[0].name

  # ECR authentication using repository_username and repository_password
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password

  # Override image repository
  set {
    name  = "image.repository"
    value = "${aws_ecr_repository.frontend_prod.registry_id}.dkr.ecr.us-east-1.amazonaws.com/${aws_ecr_repository.frontend_prod.name}"
  }

  # Set the image tag
  set {
    name  = "image.tag"
    value = "latest"
  }

  # Set API URL to backend service
  set {
    name  = "env.API_URL"
    value = "http://prod-m306-helm-backend-backend:8000/api/v1"
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
    helm_release.prod-backend,
    aws_eks_cluster.m306,
    aws_eks_node_group.fast_nodes
  ]
}

# Frontend Staging Helm Release
resource "helm_release" "staging-frontend" {
  name      = "staging-m306-helm-frontend"
  chart     = "oci://${aws_ecr_repository.frontend_helm_staging.registry_id}.dkr.ecr.us-east-1.amazonaws.com/staging-m306-helm-frontend"
  version   = "0.1.1-main"
  namespace = kubernetes_namespace.m306.metadata[0].name

  # ECR authentication using repository_username and repository_password
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password

  # Override image repository
  set {
    name  = "image.repository"
    value = "${aws_ecr_repository.frontend_staging.registry_id}.dkr.ecr.us-east-1.amazonaws.com/${aws_ecr_repository.frontend_staging.name}"
  }

  # Set the image tag
  set {
    name  = "image.tag"
    value = "main"
  }

  # Set API URL to backend service
  set {
    name  = "env.API_URL"
    value = "http://prod-m306-helm-backend-backend:8000/api/v1"
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
    helm_release.prod-backend,
    aws_eks_cluster.m306,
    aws_eks_node_group.fast_nodes
  ]
}