# Project
locals {
  project = "parity_private_1"
}

# Network
module "network" {
  source  = "../network"
  project = local.project
}

################ eu-north-1 begin ################

# Provider
provider "aws" {
  alias  = "eu-north-1"
  region = "eu-north-1"
}

################ eu-north-1 end ################


################ ap-south-1 begin ################

# Provider
provider "aws" {
  alias  = "ap-south-1"
  region = "ap-south-1"
}

################ ap-south-1 end ################


################ eu-west-3 begin ################

# Provider
provider "aws" {
  alias  = "eu-west-3"
  region = "eu-west-3"
}

################ eu-west-3 end ################


################ eu-west-2 begin ################

# Provider
provider "aws" {
  alias  = "eu-west-2"
  region = "eu-west-2"
}

################ eu-west-2 end ################


################ eu-west-1 begin ################

# Provider
provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

################ eu-west-1 end ################


################ ap-northeast-2 begin ################

# Provider
provider "aws" {
  alias  = "ap-northeast-2"
  region = "ap-northeast-2"
}

################ ap-northeast-2 end ################


################ ap-northeast-1 begin ################

# Provider
provider "aws" {
  alias  = "ap-northeast-1"
  region = "ap-northeast-1"
}

################ ap-northeast-1 end ################


################ sa-east-1 begin ################

# Provider
provider "aws" {
  alias  = "sa-east-1"
  region = "sa-east-1"
}

################ sa-east-1 end ################


################ ca-central-1 begin ################

# Provider
provider "aws" {
  alias  = "ca-central-1"
  region = "ca-central-1"
}

################ ca-central-1 end ################


################ ap-southeast-1 begin ################

# Provider
provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}

################ ap-southeast-1 end ################


################ ap-southeast-2 begin ################

# Provider
provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}

################ ap-southeast-2 end ################


################ eu-central-1 begin ################

# Provider
provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

################ eu-central-1 end ################


################ us-east-1 begin ################

# Provider
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

################ us-east-1 end ################


################ us-east-2 begin ################

# Provider
provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

################ us-east-2 end ################


################ us-west-1 begin ################

# Provider
provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

################ us-west-1 end ################


################ us-west-2 begin ################

# Provider
provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

################ us-west-2 end ################


