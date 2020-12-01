resource "aws_s3_bucket" "day2lab5" {
  bucket = "terraform-academy-lifecycle-rule"
  acl    = "public-read"

  lifecycle_rule {
    id = "transition-after-30-days"
    enabled = true

    tags = {
      "FileType" = "textfile"
    }

    transition {
      storage_class = "STANDARD_IA"
      days = 30
    }
  }

  force_destroy = true

  tags = {
    Name    = "terraform-academy-lifecycle-rule"
    Course  = "CloudBasics"
    Purpose = "Day 2 Lab 05"
  }
}