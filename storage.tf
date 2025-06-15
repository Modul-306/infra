# Aurora PostgreSQL Cluster
resource "aws_rds_cluster" "m306" {
  cluster_identifier  = "m306-aurora-cluster"
  engine              = "aurora-postgresql"
  engine_version      = "17.4" # Removed trailing space
  database_name       = "m306db"
  master_username     = "m306user"
  master_password     = var.db_password
  skip_final_snapshot = true
  apply_immediately   = true


  # Network configuration
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_public.name
}


resource "aws_rds_cluster_instance" "m306" {
  cluster_identifier = aws_rds_cluster.m306.id
  instance_class     = "db.t3.medium" # Using supported burstable instance class for Vocareum Labs
  engine             = aws_rds_cluster.m306.engine
  engine_version     = aws_rds_cluster.m306.engine_version
  identifier         = "m306-aurora-instance"
}

# Create RDS subnet group using public subnets
resource "aws_db_subnet_group" "rds_public" {
  name = "m306-rds-public-subnet-group"
  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
    aws_subnet.public_subnet_3.id
  ]

  tags = {
    Name = "m306-rds-public-subnet-group"
  }
}


resource "aws_security_group" "rds" {
  name        = "m306-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.network.id

  # Allow PostgreSQL access from EKS nodes
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks.id] # Use EKS security group instead
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "m306-rds-sg"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "m306" {
  bucket = "bucket-m306"
}