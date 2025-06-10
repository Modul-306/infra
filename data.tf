data "aws_iam_role" "labrole" {
  name = "LabRole"
}

data "aws_ecr_authorization_token" "token" {}

# IAM Policy for AWS Load Balancer Controller
resource "aws_iam_policy" "aws_load_balancer_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/iam_policy.json")
}

# Attach the policy to the LabRole
resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = data.aws_iam_role.labrole.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}