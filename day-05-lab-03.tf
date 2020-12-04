resource "aws_api_gateway_rest_api" "lab" {
  name        = "cloudbasics-lab"
  description = "Cloud Basics Course API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "lab" {
  rest_api_id = aws_api_gateway_rest_api.lab.id

  parent_id = aws_api_gateway_rest_api.lab.root_resource_id
  path_part = "terraform-random-number"
}

resource "aws_api_gateway_method" "lab" {
  resource_id   = aws_api_gateway_resource.lab.id
  rest_api_id   = aws_api_gateway_rest_api.lab.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lab" {
  rest_api_id             = aws_api_gateway_rest_api.lab.id
  resource_id             = aws_api_gateway_resource.lab.id
  http_method             = aws_api_gateway_method.lab.http_method
  type                    = "AWS"
  integration_http_method = "GET"
  uri                     = aws_lambda_function.lab.invoke_arn
}

data "archive_file" "random_number" {
  type        = "zip"
  source_file = "${path.module}/files/getSimpleRandomNumber.py"
  output_path = "${path.module}/files/getSimpleRandomNumber.zip"
}

resource "aws_lambda_function" "lab" {
  function_name    = "cb_generateRandomNumber"
  filename         = data.archive_file.random_number.output_path
  source_code_hash = data.archive_file.random_number.output_base64sha256
  handler          = "lambda_function.lambda_handler"
  role             = aws_iam_role.lab.arn
  runtime          = "python2.7"
}

resource "aws_iam_role" "lab" {
  name               = "cb_generateRandomNumber_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}