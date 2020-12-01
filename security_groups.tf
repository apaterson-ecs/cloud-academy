data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "day01" {
  vpc_id      = aws_default_vpc.default.id
  description = "Security Groups for Lab 01"

  egress {
    from_port   = 443
    protocol    = "HTTPS"
    to_port     = 443
    cidr_blocks = [var.internet_cidr]
  }

  egress {
    from_port   = 80
    protocol    = "HTTP"
    to_port     = 80
    cidr_blocks = [var.internet_cidr]
  }

  ingress {
    from_port   = 1024
    protocol    = "tcp"
    to_port     = 65535
    cidr_blocks = [var.internet_cidr]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  ingress {
    from_port   = 3389
    protocol    = "tcp"
    to_port     = 3389
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  tags = {
    Name = "day_01_sg"
  }
}

resource "aws_security_group" "windows" {
  vpc_id      = aws_vpc.vpc.id
  description = "Security Groups for Windows EC2"

  egress {
    from_port   = 443
    protocol    = "HTTPS"
    to_port     = 443
    cidr_blocks = [var.internet_cidr]
  }

  egress {
    from_port   = 80
    protocol    = "HTTP"
    to_port     = 80
    cidr_blocks = [var.internet_cidr]
  }

  ingress {
    from_port   = 3389
    protocol    = "tcp"
    to_port     = 3389
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  tags = {
    Name = "web_ec2_sg"
  }
}