data "aws_iam_role" "labrole" {
  name = "LabRole"
}

data "aws_ecr_authorization_token" "token" {}

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