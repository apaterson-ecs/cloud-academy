resource "aws_network_acl" "web" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_network_acl" "app" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_network_acl" "data" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_network_acl_rule" "web_https" {
  network_acl_id = aws_network_acl.web.id
  protocol = "HTTPS"
  rule_action = "allow"
  rule_number = 10
  cidr_block = var.internet_cidr
  from_port = 443
  to_port = 443
  egress = true
}

resource "aws_network_acl_rule" "web_http" {
  network_acl_id = aws_network_acl.web.id
  protocol = "HTTP"
  rule_action = "allow"
  rule_number = 20
  cidr_block = var.internet_cidr
  from_port = 80
  to_port = 80
  egress = true
}

resource "aws_network_acl_rule" "web_inbound" {
  network_acl_id = aws_network_acl.web.id
  protocol = "tcp"
  rule_action = "ALLOW"
  rule_number = 10
  cidr_block = var.internet_cidr
  from_port = 1024
  to_port = 65535
  egress = false
}

resource "aws_network_acl_rule" "app_to_web" {
  network_acl_id = aws_network_acl.app.id
  protocol = -1
  rule_action = "ALLOW"
  rule_number = 10
  cidr_block = var.subnet_cidr_web
  from_port = 0
  to_port = 0
  egress = true
}

resource "aws_network_acl_rule" "inbound_to_app" {
  network_acl_id = aws_network_acl.app.id
  protocol = -1
  rule_action = "ALLOW"
  rule_number = 10
  cidr_block = var.subnet_cidr_web
  from_port = 0
  to_port = 0
  egress = false
}

resource "aws_network_acl_rule" "db_to_app" {
  network_acl_id = aws_network_acl.data.id
  protocol = -1
  rule_action = "ALLOW"
  rule_number = 10
  cidr_block = var.subnet_cidr_app
  from_port = 0
  to_port = 0
  egress = true
}

resource "aws_network_acl_rule" "inbound_to_data" {
  network_acl_id = aws_network_acl.data.id
  protocol = -1
  rule_action = "ALLOW"
  rule_number = 10
  cidr_block = var.subnet_cidr_app
  from_port = 0
  to_port = 0
  egress = false
}