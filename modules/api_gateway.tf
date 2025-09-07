# HTTP API Gateway configuration
resource "aws_apigatewayv2_api" "contact_form_api" {
  name         = "contact-form-api"
  protocol_type = "HTTP"
  description   = "Contact Form API Gateway"
  version       = "1.0"

  # CORS configuration for browser access
  cors_configuration {
    allow_origins  = ["*"]      # Allow all origins
    allow_methods  = ["POST"]   # Only allow POST requests
    allow_headers  = ["content-type"]
    expose_headers = ["content-type"]
    max_age        = 3600       # Browser cache duration (seconds)
  }
}

# Integration between API Gateway and Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.contact_form_api.id
  integration_type       = "AWS_PROXY"  # Lambda proxy integration
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.form_handler.invoke_arn
  payload_format_version = "2.0"        # Recommended for Lambda
  timeout_milliseconds   = 30000        # Match Lambda timeout
}

# API route configuration
resource "aws_apigatewayv2_route" "submit_route" {
  api_id    = aws_apigatewayv2_api.contact_form_api.id
  route_key = "POST /submit"  # Endpoint path
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# API deployment stage configuration
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.contact_form_api.id
  name        = "$default"    # Default stage
  auto_deploy = true          # Automatic deployments on changes

  default_route_settings {
    detailed_metrics_enabled = false
    throttling_burst_limit   = 5000   # Default burst capacity
    throttling_rate_limit    = 10000  # Default steady-state rate
  }

  # CloudWatch access logging
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn
    format = jsonencode({
      requestId       = "$context.requestId",
      ip              = "$context.identity.sourceIp",
      requestTime     = "$context.requestTime",
      httpMethod      = "$context.httpMethod",
      routeKey        = "$context.routeKey",
      status          = "$context.status",
      protocol        = "$context.protocol",
      responseLength  = "$context.responseLength"
    })
  }
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "api_gw" {
  name_prefix              = "/aws/apigateway/${aws_apigatewayv2_api.contact_form_api.name}"
  retention_in_days = 7  # Log retention period
}

# Grant API Gateway permission to invoke Lambda
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.form_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.contact_form_api.execution_arn}/*/*/submit"
}