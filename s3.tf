data "template_file" "s3_index_html" {
  template = "${path.module}/files/index.html"
}

resource "aws_s3_bucket" "day01" {
  bucket = "acad-terraform"
  acl    = "private"

  force_destroy = true

  tags = {
    Name    = "terraform-day01"
    Course  = "CloudBasics"
    Purpose = "Day 1 Lab 05"
  }
}

resource "aws_s3_bucket_object" "html_object" {
  bucket = aws_s3_bucket.day01.id
  key    = "index.html"
  source = data.template_file.s3_index_html.rendered
}
