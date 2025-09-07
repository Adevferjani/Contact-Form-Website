# OUTPUTS FOR INFRASTRUCTURE
# Primary website URL (via CloudFront)
output "website_url" {
  description = "Public URL of the contact form website"
  value       = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

# API Gateway Endpoint
output "api_endpoint" {
  description = "Base URL for form submission API"
  value       = aws_apigatewayv2_api.contact_form_api.api_endpoint
}

# Full submission endpoint
output "submit_endpoint" {
  description = "Complete URL for form submissions"
  value       = "${aws_apigatewayv2_api.contact_form_api.api_endpoint}/submit"
}

# DynamoDB Table
output "dynamodb_table_name" {
  description = "Name of the submissions storage table"
  value       = aws_dynamodb_table.submissions_table.name
}

# S3 Buckets
output "website_bucket_name" {
  description = "Name of the S3 bucket hosting static website"
  value       = aws_s3_bucket.website_bucket.bucket
}

output "lambda_bucket_name" {
  description = "Name of the S3 bucket storing Lambda code"
  value       = aws_s3_bucket.lambda_code_bucket.bucket
}

# Lambda Function
output "lambda_function_name" {
  description = "Name of the form processing Lambda function"
  value       = aws_lambda_function.form_handler.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function for permission management"
  value       = aws_lambda_function.form_handler.arn
}

# CloudFront Distribution
output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

# IAM Role
output "lambda_execution_role_arn" {
  description = "ARN of the IAM role used by Lambda function"
  value       = aws_iam_role.lambda_exec.arn
}

# API Gateway
output "api_gateway_id" {
  description = "ID of the API Gateway HTTP API"
  value       = aws_apigatewayv2_api.contact_form_api.id
}

# CloudWatch Log Group
output "api_gw_log_group_name" {
  description = "CloudWatch log group for API Gateway access logs"
  value       = aws_cloudwatch_log_group.api_gw.name
}