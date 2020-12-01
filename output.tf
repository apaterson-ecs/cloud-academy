output "private_key" {
  value = tls_private_key.ec2.private_key_pem
}

output "public_key" {
  value = tls_private_key.ec2.public_key_openssh
}

output "linux_public_ip" {
  value = aws_instance.day01_linux.public_ip
}

output "rds_password" {
  value = random_password.password.result
}

output "s3_website_endpoint" {
  value = aws_s3_bucket.day2lab4.website_endpoint
}