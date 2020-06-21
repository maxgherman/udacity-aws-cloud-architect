provider "aws" {
  region  = var.region
  profile = "default"
}

# gerated lambda archive. refeence: https://www.terraform.io/docs/providers/archive/d/archive_file.html

data "archive_file" "archive" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = var.output_archive_name
}


# reference: https://www.terraform.io/docs/providers/aws/r/lambda_function.html

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_lambda_function" "greet_lambda" {
  filename      = var.output_archive_name
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.lambda_handler

  source_code_hash = data.archive_file.archive.output_base64sha256

  runtime = var.runtime

  depends_on = [aws_iam_role_policy_attachment.lambda_logs]

  environment {
    variables = {
      greeting = "Hi there!"
    }
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
