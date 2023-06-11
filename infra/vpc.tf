resource "aws_vpc" "main" {
  cidr_block           = "10.100.0.0/20"
  enable_dns_hostnames = true

  tags = {
    Name = "k8s-vpc"
  }
}

resource "aws_subnet" "main_public" {
  vpc_id               = aws_vpc.main.id
  cidr_block           = cidrsubnet("10.100.0.0/20", 4, 10)
  availability_zone_id = local.default_az_id

  tags = {
    Name = "k8s-public-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "k8s-main-igw"
  }
}

resource "aws_route_table" "main_public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "k8s-public-subnet-rt"
  }
}

resource "aws_route" "internet_gateway" {
  route_table_id         = aws_route_table.main_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "main_public" {
  subnet_id      = aws_subnet.main_public.id
  route_table_id = aws_route_table.main_public.id
}

resource "aws_eip" "load_balancer" {
  domain = "vpc"

  tags = {
    Name = "k8s-external-loadbalancer-ip"
  }
}
