data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_default_subnet" "default_sn_az1" {
  availability_zone = "${var.region}a"

  tags = {
    Name = "Default subnet for ${var.region}a"
  }
}

//resource "aws_default_subnet" "default_sn_az2" {
//  availability_zone = "${var.region}b"
//
//  tags = {
//    Name = "Default subnet for ${var.region}b"
//  }
//}
//
//resource "aws_default_subnet" "default_sn_az3" {
//  availability_zone = "${var.region}c"
//
//  tags = {
//    Name = "Default subnet for ${var.region}c"
//  }
//}


resource "aws_subnet" "web_subnet" {
  cidr_block = var.subnet_cidr_web
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.subnet_az

  tags = {
    Name = "cb_subnet_web"
  }
}

resource "aws_subnet" "app_subnet" {
  cidr_block = var.subnet_cidr_app
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.subnet_az

  tags = {
    Name = "cb_subnet_app"
  }
}

resource "aws_subnet" "data_subnet" {
  cidr_block = var.subnet_cidr_data
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.subnet_az

  tags = {
    Name = "cb_subnet_data"
  }
}