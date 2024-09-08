# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Coalfire VPC"
  }
}

# Create Internet Gateway and Attach it to VPC
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Coalfire IGW"
  }
}

# Create Public Subnet 1 (Sub 1)
resource "aws_subnet" "Sub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-subnet-1-cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Sub 1 - Public"
  }
}

# Create Public Subnet 2 (Sub 2)
resource "aws_subnet" "Sub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-subnet-2-cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Sub 2 - Public"
  }
}

# Create Route Table and Add Public Route
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.Sub1.id
  route_table_id = aws_route_table.public-route-table.id
}

# Associate Public Subnet 2 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id      = aws_subnet.Sub2.id
  route_table_id = aws_route_table.public-route-table.id
}

# Create Private Subnet 1 (Sub 3)
resource "aws_subnet" "Sub3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private-subnet-1-cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Sub 3 - Private"
  }
}

# Create Private Subnet 2 (Sub 4)
resource "aws_subnet" "Sub4" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private-subnet-2-cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Sub 4 - Private"
  }
}

# Allocate Elastic IP Address (EIP 1)
resource "aws_eip" "eip-for-nat-gateway-1" {
  domain = "vpc"

  tags = {
    Name = "EIP 1"
  }
}

# Allocate Elastic IP Address (EIP 2)
resource "aws_eip" "eip-for-nat-gateway-2" {
  domain = "vpc"

  tags = {
    Name = "EIP 2"
  }
}

# Create Nat Gateway 1 in Public Subnet 1
resource "aws_nat_gateway" "nat-gateway-1" {
  allocation_id     = aws_eip.eip-for-nat-gateway-1.id
  subnet_id         = aws_subnet.Sub1.id
  connectivity_type = "public"

  tags = {
    Name = "Nat Gateway Sub1 - Public"
  }
}

# Create Nat Gateway 2 in Public Subnet 2
resource "aws_nat_gateway" "nat-gateway-2" {
  allocation_id     = aws_eip.eip-for-nat-gateway-2.id
  subnet_id         = aws_subnet.Sub2.id
  connectivity_type = "public"

  tags = {
    Name = "Nat Gateway Sub2 - Public"
  }
}

# Create Private Route Table 1 and Add Route Through Nat Gateway 1
resource "aws_route_table" "private-route-table-1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-1.id
  }

  tags = {
    Name = "Private Route Table 1"
  }
}

# Associate Private Route Table 1 with "Sub 3 (Private)"
resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.Sub3.id
  route_table_id = aws_route_table.private-route-table-1.id
}

# Create Private Route Table 2 and Add Route Through Nat Gateway 2
resource "aws_route_table" "private-route-table-2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-2.id
  }

  tags = {
    Name = "Private Route Table 2"
  }
}

# Associate Private Route Table 2 with "Sub 4 (Private)"
resource "aws_route_table_association" "private-subnet-2-route-table-association" {
  subnet_id      = aws_subnet.Sub4.id
  route_table_id = aws_route_table.private-route-table-2.id
}
