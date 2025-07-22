# Unique suffix for S3 bucket names to ensure global uniqueness
resource "random_id" "unique_suffix" {
  byte_length = 8
}

# S3 Bucket for hosting static website
resource "aws_s3_bucket" "website_bucket" {
  bucket        = "contact-form-website-${random_id.unique_suffix.hex}"
  force_destroy = true  # Allow bucket deletion with contents
}

# Configure S3 bucket as a static website
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id
  index_document {
    suffix = "index.html"
  }
}

# Secure public access settings
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = false  # Required for public website
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Bucket policy allowing public read access
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

# S3 Bucket for storing Lambda deployment package
resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "lambda-code-${random_id.unique_suffix.hex}"
}

# Upload Lambda deployment package to S3
resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_code_bucket.id
  key    = "lambda_function.zip"
  source = "lambda_function.zip"  # Local Lambda zip file
  etag   = filemd5("lambda_function.zip")  # Trigger updates on code change
}