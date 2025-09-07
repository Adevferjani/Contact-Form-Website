# Lambda function to process form submissions
resource "aws_lambda_function" "form_handler" {
  function_name    = "form-submission-handler"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.13"
  s3_bucket        = aws_s3_bucket.lambda_code_bucket.id
  s3_key           = aws_s3_object.lambda_code.key
  source_code_hash = filebase64sha256("../src/backend/lambda_function.zip")  # Detect code changes

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.submissions_table.name  # Pass DynamoDB table name
    }
  }

  timeout = 30  # Execution timeout in seconds.
}