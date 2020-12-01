resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "cloudbasics_public_rt"
  }

}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.internet_cidr
    nat_gateway_id = aws_nat_gateway.ng.id
  }

  tags = {
    Name = "cloudbasics_private_rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.web_subnet.id
}

resource "aws_route_table_association" "private_rt_assoc_1" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.app_subnet.id
}

resource "aws_route_table_association" "private_rt_assoc_2" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.data_subnet.id
}