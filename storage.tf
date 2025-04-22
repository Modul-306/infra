# RDS Instance
resource "aws_db_instance" "m306" {
    allocated_storage    = 20
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t3.micro"
    username             = "admin"
    password             = "password123"
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot  = true
}

# S3 Bucket
resource "aws_s3_bucket" "m306" {
    bucket = "bucket-m306"
}