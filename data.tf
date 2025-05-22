data "aws_iam_role" "labrole" {
  name = "LabRole"
}
data "aws_ecr_authorization_token" "token" {}

# ECR policy document
data "aws_iam_policy_document" "ecr_access" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
}

# Attach ECR policy to LabRole
resource "aws_iam_role_policy" "ecr_access" {
  name   = "ecr-access-policy"
  role   = data.aws_iam_role.labrole.id
  policy = data.aws_iam_policy_document.ecr_access.json
}