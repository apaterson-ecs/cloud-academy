data "template_file" "academy_txt" {
  template = "${path.module}/files/academy.txt"
}

resource "aws_s3_bucket" "day2lab3" {
  bucket = "terraform-academy-versioning"
  acl    = "private"

  versioning {
    enabled = true
  }

  force_destroy = true

  tags = {
    Name    = "terraform-academy-versioning"
    Course  = "CloudBasics"
    Purpose = "Day 2 Lab 03"
  }
}

resource "aws_s3_bucket_object" "txt_object" {
  bucket = aws_s3_bucket.day2lab3.id
  key    = "academy.txt"
  source = data.template_file.academy_txt.rendered
}