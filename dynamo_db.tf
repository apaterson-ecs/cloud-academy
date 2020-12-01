resource "aws_dynamodb_table" "acad" {
  hash_key = "Artist"
  name = "Terraform-Music"

  attribute {
    name = "Artist"
    type = "S"
  }

  tags = {
    Name = "Terraform-Music"
    Course = "CloudBasics"
  }
}

resource "aws_dynamodb_table_item" "acad-item" {
  table_name = aws_dynamodb_table.acad.name
  hash_key = aws_dynamodb_table.acad.hash_key
  item = <<ITEM
{
  "Artist": {"S": "Queen"},
  "SongTitle": {"S": "Bohemian Rhapsody"},
  "Rating": {"N": "9"}
}
ITEM
}