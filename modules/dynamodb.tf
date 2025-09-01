# DynamoDB table for storing form submissions
resource "aws_dynamodb_table" "submissions_table" {
  name       = "ContactFormSubmissionsTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "email"
  range_key    = "timestamp"

  attribute {
    name = "email"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }
}