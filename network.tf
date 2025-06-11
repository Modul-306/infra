resource "aws_vpc" "network" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "m306-vpc"
  }
}

# ------------------------
# Public Subnets
# ------------------------
# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.network.id
  tags = {
    Name = "m306-igw"
  }
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "m306-public-rt"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.network.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                             = "m306-public-subnet-1"
    "kubernetes.io/role/elb"         = "1"
    "kubernetes.io/cluster/eks-m306" = "shared"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.network.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                             = "m306-public-subnet-2"
    "kubernetes.io/role/elb"         = "1"
    "kubernetes.io/cluster/eks-m306" = "shared"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.network.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name                             = "m306-public-subnet-3"
    "kubernetes.io/role/elb"         = "1"
    "kubernetes.io/cluster/eks-m306" = "shared"
  }
}

# Associate route table with subnets
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public.id
}


# ------------------------
# Private Subnets
# ------------------------
# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.network.id

  tags = {
    Name = "m306-private-rt"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.network.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false # Ensure this is false for private subnets

  tags = {
    Name = "m306-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.network.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false # Ensure this is false for private subnets

  tags = {
    Name = "m306-private-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id                  = aws_vpc.network.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = false # Ensure this is false for private subnets

  tags = {
    Name = "m306-private-subnet-3"
  }
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_subnet_3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private.id
}