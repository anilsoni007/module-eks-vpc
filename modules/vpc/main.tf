resource "aws_vpc" "sandbox-vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "createdBy" = "Terraform"
    "Name"      = "Sandbox-vpc-TF"
  }
}

resource "aws_subnet" "priv_sub" {
  count             = length(var.private_Subnet_cidr)
  vpc_id            = aws_vpc.sandbox-vpc.id
  cidr_block        = var.private_Subnet_cidr[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    Name = "priv-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "pub_sub" {
  count                   = length(var.public_Subnet_cidr)
  vpc_id                  = aws_vpc.sandbox-vpc.id
  cidr_block              = var.public_Subnet_cidr[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.sandbox-vpc.id
  tags = {
    Name = "sandbox-igw-tf"
  }
}

resource "aws_eip" "sandbox_eip" {
  count  = length(var.public_Subnet_cidr)
  domain = "vpc"
  tags = {
    "Name" = "eip-sandbox-vpc-${count.index + 1}"
  }
}


resource "aws_nat_gateway" "my-ngw" {
  count         = length(var.public_Subnet_cidr)
  allocation_id = aws_eip.sandbox_eip[count.index].id
  subnet_id     = aws_subnet.pub_sub[count.index].id

  tags = {
    Name = "gw-NAT-TF=${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.sandbox-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "pub-rt-sandbox"
  }
}

resource "aws_route_table" "priv_rt" {
  count  = length(var.private_Subnet_cidr)
  vpc_id = aws_vpc.sandbox-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-ngw[count.index].id
  }
  tags = {
    Name = "priv-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "pub_rt_association" {
  count          = length(var.public_Subnet_cidr)
  subnet_id      = aws_subnet.pub_sub[count.index].id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "priv_rt_association" {
  count          = length(var.private_Subnet_cidr)
  subnet_id      = aws_subnet.priv_sub[count.index].id
  route_table_id = aws_route_table.priv_rt[count.index].id
}
