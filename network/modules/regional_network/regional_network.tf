# Provider
provider "aws" {
  alias  = "ap-south-1"
  region = "ap-south-1"
}

# VPC
resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  provider             = "aws.ap-south-1"

  tags = {
    project = "marlin-terraform"
  }
}

# Subnet
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${aws_vpc.default.cidr_block}"
  map_public_ip_on_launch = true
  provider                = "aws.ap-south-1"

  tags = {
    project = "marlin-terraform"
  }
}

# Route table
resource "aws_route_table" "default" {
  vpc_id   = "${aws_vpc.default.id}"
  provider = "aws.ap-south-1"

  tags = {
    project = "marlin-terraform"
  }
}

# Route table association
resource "aws_route_table_association" "default" {
  subnet_id      = "${aws_subnet.default.id}"
  route_table_id = "${aws_route_table.default.id}"
  provider       = "aws.ap-south-1"
}

# Internet gateway
resource "aws_internet_gateway" "default" {
  vpc_id   = "${aws_vpc.default.id}"
  provider = "aws.ap-south-1"

  tags = {
    project = "marlin-terraform"
  }
}

# Internet route
resource "aws_route" "internet" {
  route_table_id         = "${aws_route_table.default.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
  provider               = "aws.ap-south-1"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "route_table_id" {
  value = "${aws_route_table.default.id}"
}
