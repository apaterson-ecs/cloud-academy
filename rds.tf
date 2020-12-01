resource "aws_db_instance" "rds" {
  instance_class         = "db.t2.micro"
  engine                 = "mysql"
  engine_version         = "5.7"
  name                   = "terraform-rds-mysql"
  username               = "admin"
  password               = random_password.password.result
  vpc_security_group_ids = [aws_security_group.rds.id]

  tags = {
    Name = "terraform-rds-mysql"
    Course = "CloudBasics"
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
  subnet_id                   = aws_default_subnet.default_sn_az1.id
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
  vpc_id      = aws_default_vpc.default.id
  description = "Security Group for RDS MySQL"

  tags = {
    Name = "rds-mysql-sg"
    Course = "CloudBasics"
    Purpose = "Day 2 Lab 02"
  }
}

resource "aws_security_group_rule" "rds" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.rds.id
  to_port           = 3306
  type              = "ingress"
}

resource "aws_security_group" "ec2" {
  vpc_id      = aws_default_vpc.default.id
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
    Name = "ec2-rds-mysql-sg"
    Course = "CloudBasics"
    Purpose = "Day 2 Lab 02"
  }
}