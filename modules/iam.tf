# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_exec" {
  name_prefix = "lambda-exec-role-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach basic Lambda execution policy (CloudWatch logging)
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Custom policy for DynamoDB write access
resource "aws_iam_role_policy" "dynamodb_access" {
  name_prefix = "dynamodb-access-"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["dynamodb:PutItem"]
      Effect   = "Allow"
      Resource = aws_dynamodb_table.submissions_table.arn
    }]
  })
}