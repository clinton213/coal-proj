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
  allocation_id = aws_eip.eip-for-nat-gateway-1.id
  subnet_id     = aws_subnet.Sub1.id

  tags = {
    Name = "Nat Gateway Sub1 - Public"
  }
}

# Create Nat Gateway 2 in Public Subnet 2
resource "aws_nat_gateway" "nat-gateway-2" {
  allocation_id = aws_eip.eip-for-nat-gateway-2.id
  subnet_id     = aws_subnet.Sub2.id

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
