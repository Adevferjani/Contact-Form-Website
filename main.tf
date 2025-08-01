# Render index.html with API endpoint
data "template_file" "index_html" {
  template = file("${path.module}/index.html.tpl")
  vars = {
    api_endpoint = aws_apigatewayv2_api.contact_form_api.api_endpoint
  }
}

# Upload rendered HTML to S3
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  content      = data.template_file.index_html.rendered
  content_type = "text/html"
}