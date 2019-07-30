terraform {
  backend "s3" {
    bucket = "marlin-terraform"
    key    = "aws-backend/terraform.tfstate"
    region = "us-east-2"
  }
}
