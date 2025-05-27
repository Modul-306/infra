data "aws_iam_role" "labrole" {
  name = "LabRole"
}

data "aws_ecr_authorization_token" "token" {}