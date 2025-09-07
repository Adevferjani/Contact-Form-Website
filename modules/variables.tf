variable "aws_access_key" {
  description = "AWS Access Key for API authentication"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key for API authentication"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"  # Default to North Virginia region
}