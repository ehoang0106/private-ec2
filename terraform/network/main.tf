#vpc
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "my-vpc"
  }
}

#subnets

resource "aws_subnet" "my-private-subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "my-private-subnet"
  }
}

resource "aws_subnet" "my-public-subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "my-public-subnet"
  }
}

#internet gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-igw"
  }
}

#EIP for NAT gateway

resource "aws_eip" "my-nat-eip" {
  tags = {
    Name = "my-nat-eip"
  }
}

#NAT gateway
resource "aws_nat_gateway" "my-nat-gateway" {
  allocation_id = aws_eip.my-nat-eip.id
  subnet_id     = aws_subnet.my-public-subnet.id

  tags = {
    Name = "my-nat-gateway"
  }
}

#route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name = "my-public-route-table"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.my-public-subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-private-route-table"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my-nat-gateway.id
}

#associate public subnet with private route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.my-private-subnet.id
  route_table_id = aws_route_table.private.id
}