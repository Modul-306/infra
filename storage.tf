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
}

# S3 Bucket
resource "aws_s3_bucket" "m306" {
  bucket = "bucket-m306"
}