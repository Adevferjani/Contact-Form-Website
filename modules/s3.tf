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
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM policy document for CloudFront access only
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.website_bucket.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

# Bucket policy allowing only CloudFront access via OAI
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

# S3 Bucket for storing Lambda deployment package
resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "lambda-code-${random_id.unique_suffix.hex}"
}

locals {
  lambda_zip_path = "../src/backend/lambda_function.zip"
}

# Upload Lambda deployment package to S3
resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_code_bucket.id
  key    = "lambda_function.zip"
  source = local.lambda_zip_path
  etag   = filemd5(local.lambda_zip_path)
}