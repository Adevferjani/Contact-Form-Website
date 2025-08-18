# CloudFront distribution for S3 website
resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled         = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = "S3Origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"  # S3 doesn't support HTTPS
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"  # Force HTTPS
    min_ttl                = 0
    default_ttl            = 3600    # 1 hour caching
    max_ttl                = 86400   # 1 day max caching
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"  # No geo-blocking
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true  # Use default CloudFront cert
  }
}