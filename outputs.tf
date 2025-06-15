# Outputs for application URLs
output "backend_load_balancer_url" {
  description = "Backend Load Balancer URL"
  value       = "http://${data.kubernetes_service.backend_service.status.0.load_balancer.0.ingress.0.hostname}:8000"
}

output "frontend_prod_load_balancer_url" {
  description = "Frontend Production Load Balancer URL"
  value       = "http://${data.kubernetes_service.frontend_prod_service.status.0.load_balancer.0.ingress.0.hostname}"
}

output "frontend_staging_load_balancer_url" {
  description = "Frontend Staging Load Balancer URL"
  value       = "http://${data.kubernetes_service.frontend_staging_service.status.0.load_balancer.0.ingress.0.hostname}"
}

output "rds_endpoint" {
  description = "RDS Cluster Endpoint"
  value       = aws_rds_cluster.m306.endpoint
  sensitive   = true
}

# Data sources to get service information
data "kubernetes_service" "backend_service" {
  metadata {
    name      = "prod-m306-helm-backend-backend"
    namespace = "m306"
  }
  depends_on = [helm_release.prod-backend]
}

data "kubernetes_service" "frontend_prod_service" {
  metadata {
    name      = "prod-m306-helm-frontend-frontend"
    namespace = "m306"
  }
  depends_on = [helm_release.prod-frontend]
}

data "kubernetes_service" "frontend_staging_service" {
  metadata {
    name      = "staging-m306-helm-frontend-frontend"
    namespace = "m306"
  }
  depends_on = [helm_release.staging-frontend]
}
