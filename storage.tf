# Aurora PostgreSQL Cluster
resource "aws_rds_cluster" "m306" {
  cluster_identifier     = "m306-aurora-cluster"
  engine                = "aurora-postgresql"
  engine_version        = "17.2"
  database_name         = "m306db"
  master_username       = "admin"
  master_password       = var.db_password
  skip_final_snapshot   = true
  apply_immediately     = true
  
  # Network configuration
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name

  # IAM authentication
  iam_database_authentication_enabled = true

  # Serverless v2 configuration
  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 1.0
  }
}

# Aurora PostgreSQL Instance (Serverless v2)
resource "aws_rds_cluster_instance" "m306" {
  cluster_identifier = aws_rds_cluster.m306.id
  instance_class    = "db.serverless"
  engine            = aws_rds_cluster.m306.engine
  engine_version    = aws_rds_cluster.m306.engine_version
  identifier        = "m306-aurora-instance"
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

# Create security group for Aurora
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