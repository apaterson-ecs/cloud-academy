data "template_file" "linux_user_data" {
  template = "${path.module}/files/linus-userdata.sh"
}

resource "aws_key_pair" "example" {
  public_key = ""
}

resource "aws_instance" "day01_linux" {
  ami                         = data.aws_ami.amazon-linux2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_default_subnet.default_sn_az1.id
  vpc_security_group_ids      = [aws_security_group.day01.id]
  user_data                   = data.template_file.linux_user_data.rendered
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  tags = {
    Name    = "linux_ec2"
    Course  = "CloudBasics"
    Purpose = "Day 1 Lab 01/03"
  }
}

resource "aws_ebs_volume" "linux" {
  availability_zone = "${var.region}a"
  size              = 50

  tags = {
    Name    = "Terraform"
    Course  = "CloudBasics"
    Purpose = "Day 1 Lab 01/03"
  }
}

resource "aws_volume_attachment" "linux" {
  device_name  = "/dev/sdb"
  instance_id  = aws_instance.day01_linux.id
  volume_id    = aws_ebs_volume.linux.id
  skip_destroy = false
}

//resource "aws_instance" "day01_windows" {
//  ami                         = data.aws_ami.windows.id
//  instance_type               = var.instance_type
//  subnet_id                   = aws_default_subnet.default_sn_az1.id
//  vpc_security_group_ids      = [aws_security_group.day01.id]
//  key_name                    = aws_key_pair.generated_key.key_name
//  iam_instance_profile        = aws_iam_role.s3_iam_role.name
//  associate_public_ip_address = true
//
//  tags = {
//    Name    = "Terraform"
//    Course  = "CloudBasics"
//    Purpose = "Day 1 Lab02/04"
//  }
//}

data "aws_ami" "amazon-linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "windows" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "platform"
    values = ["windows"]
  }
}