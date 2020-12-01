resource "tls_private_key" "ec2" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name = "cloudbasics"
  public_key = tls_private_key.ec2.public_key_openssh
}