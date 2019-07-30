# Provider
provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

# Bucket
resource "aws_s3_bucket" "aws-backend" {
  provider = "aws.us-east-2"
  bucket   = "marlin-terraform"
  region   = "us-east-2"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    noncurrent_version_expiration {
      days = 30
    }
  }
}
