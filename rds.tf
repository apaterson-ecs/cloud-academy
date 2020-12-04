resource "aws_db_instance" "rds" {
  allocated_storage      = "5"
  instance_class         = "db.t2.micro"
  engine                 = "mysql"
  engine_version         = "5.7"
  name                   = "cb_terraform_rds_mysql"
  username               = "admin"
  password               = random_password.password.result
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.id
  final_snapshot_identifier = "cb_terraform_rds_mysql_to_delete"

  tags = {
    Name    = "cb_terraform_rds_mysql"
    Course  = "CloudBasics"
    Purpose = "Day 2 Lab 2"
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "cb_terraform_rds_subnet_group"
  subnet_ids = [aws_subnet.data_subnet.id, aws_subnet.data_subnet_b.id]

  tags = {
    Name    = "cb_terraform_rds_subnet_group"
    Course  = "CloudBasics"
    Purpose = "Day 2 Lab 2"
  }
}

resource "random_password" "password" {
  length  = 16
  special = true
}

data "template_file" "ec2-rds-userdata" {
  template = "${path.module}/files/ec2-rds.connect.sh"
}

resource "aws_instance" "rds-ec2" {
  ami                         = data.aws_ami.amazon-linux2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.data_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  user_data                   = data.template_file.ec2-rds-userdata.rendered
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  tags = {
    Name    = "rds-ec2"
    Course  = "CloudBasics"
    Purpose = "Day 2 Lab 02"
  }
}

resource "aws_security_group" "rds" {
  vpc_id      = aws_vpc.vpc.id
  description = "Security Group for RDS MySQL"

  tags = {
    Name    = "rds-mysql-sg"
    Course  = "CloudBasics"
    Purpose = "Day 2 Lab 02"
  }
}

resource "aws_security_group_rule" "rds" {
  from_port                = 3306
  protocol                 = "tcp"
  to_port                  = 3306
  type                     = "ingress"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group" "ec2" {
  vpc_id      = aws_vpc.vpc.id
  description = "Security Group for EC2 RDS MySQL"

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = [aws_security_group.rds.id]
  }

  tags = {
    Name    = "ec2-rds-mysql-sg"
    Course  = "CloudBasics"
    Purpose = "Day 2 Lab 02"
  }
}