data "template_file" "index_html" {
  template = "${path.module}/files/s3-website.html"
}

data "template_file" "error_html" {
  template = "${path.module}/files/error.html"
}

resource "aws_s3_bucket" "day2lab4" {
  bucket = "terraform-academy-static-website"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  force_destroy = true

  tags = {
    Name    = "terraform-academy-static-website"
    Course  = "CloudBasics"
    Purpose = "Day 2 Lab 04"
  }
}

resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.day2lab4.id
  key    = "index.html"
  source = data.template_file.index_html.rendered
}

resource "aws_s3_bucket_object" "error_html" {
  bucket = aws_s3_bucket.day2lab4.id
  key    = "error.html"
  source = data.template_file.error_html.rendered
}