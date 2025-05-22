# RDS Instance
resource "aws_db_instance" "m306" {
  allocated_storage    = 20
  engine               = "postgresql"
  engine_version       = "17.2"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = var.db_password
  parameter_group_name = "default.postgres17"
  skip_final_snapshot  = true

  db_name = "m306db"

  # Add IAM role association
  iam_database_authentication_enabled = true
}

# Associate IAM role with RDS instance
resource "aws_db_instance_role_association" "m306_role" {
  db_instance_identifier = aws_db_instance.m306.id
  feature_name           = "S3_INTEGRATION"
  role_arn               = data.aws_iam_role.labrole.arn
}

# S3 Bucket
resource "aws_s3_bucket" "m306" {
  bucket = "bucket-m306"
}