resource "aws_subnet" "web_subnet" {
  cidr_block        = var.subnet_cidr_web
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.subnet_az

  tags = {
    Name = "cb_subnet_web"
  }
}

resource "aws_subnet" "app_subnet" {
  cidr_block        = var.subnet_cidr_app
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.subnet_az

  tags = {
    Name = "cb_subnet_app"
  }
}

resource "aws_subnet" "data_subnet" {
  cidr_block        = var.subnet_cidr_data
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.subnet_az

  tags = {
    Name = "cb_subnet_data"
  }
}

resource "aws_subnet" "data_subnet_b" {
  cidr_block        = var.subnet_cidr_data_b
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.subnet_az_b

  tags = {
    Name = "cb_subnet_data"
  }
}