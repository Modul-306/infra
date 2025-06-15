# Automatically configure kubectl after EKS cluster is created
resource "null_resource" "kubectl_setup" {
  depends_on = [
    aws_eks_cluster.m306,
    aws_eks_node_group.fast_nodes
  ]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region us-east-1 --name ${aws_eks_cluster.m306.name}"
  }

  # Trigger re-run if cluster endpoint changes
  triggers = {
    cluster_endpoint = aws_eks_cluster.m306.endpoint
  }
}
