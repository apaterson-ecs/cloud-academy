resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "cloudbasics-vpc"
    Owner = "Andrew Paterson"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "cloudbasics-ig"
  }
}

resource "aws_eip" "eip" {
  vpc = true

  depends_on = [aws_internet_gateway.ig]

  tags = {
    Name = "cloudbasics-eip"
  }
}

resource "aws_nat_gateway" "ng" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.web_subnet.id

  tags = {
    Name = "cloudbasics-ng"
  }
}