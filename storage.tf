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
  storage_type         = "gp2"
  monitoring_interval  = 0  # Disable enhanced monitoring

  # Enable auto-stop after 7 days of inactivity
  auto_minor_version_upgrade = false
  deletion_protection       = false

  db_name = "m306db"

  # Network configuration
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name

  # Enable IAM authentication
  iam_database_authentication_enabled = true
}

# Create RDS subnet group
resource "aws_db_subnet_group" "rds" {
  name       = "m306-rds-subnet-group"
  subnet_ids = [
    aws_subnet.subnet_1.id,
    aws_subnet.subnet_2.id,
    aws_subnet.subnet_3.id
  ]

  tags = {
    Name = "m306-rds-subnet-group"
  }
}

# Create security group for RDS
resource "aws_security_group" "rds" {
  name        = "m306-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.network.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_eks_cluster.m306.vpc_config[0].cluster_security_group_id]
  }

  tags = {
    Name = "m306-rds-sg"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "m306" {
  bucket = "bucket-m306"
}