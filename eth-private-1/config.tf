terraform {
  backend "s3" {
    bucket = "marlin-terraform"
    key    = "ethereum-alpha-1/terraform.tfstate"
    region = "us-east-2"
  }
}

