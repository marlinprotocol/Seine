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
}

# Subnet
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${aws_vpc.default.cidr_block}"
  map_public_ip_on_launch = true
  provider                = "aws.ap-south-1"
}

# Route table
resource "aws_route_table" "default" {
  vpc_id   = "${aws_vpc.default.id}"
  provider = "aws.ap-south-1"
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
}

# Internet route
resource "aws_route" "internet" {
  route_table_id         = "${aws_route_table.default.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
  provider               = "aws.ap-south-1"
}


# Provider
provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}

# VPC
resource "aws_vpc" "default2" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  provider             = "aws.ap-southeast-1"
}

# Subnet
resource "aws_subnet" "default2" {
  vpc_id                  = "${aws_vpc.default2.id}"
  cidr_block              = "${aws_vpc.default2.cidr_block}"
  map_public_ip_on_launch = true
  provider                = "aws.ap-southeast-1"
}

# Route table
resource "aws_route_table" "default2" {
  vpc_id   = "${aws_vpc.default2.id}"
  provider = "aws.ap-southeast-1"
}

# Route table association
resource "aws_route_table_association" "default2" {
  subnet_id      = "${aws_subnet.default2.id}"
  route_table_id = "${aws_route_table.default2.id}"
  provider       = "aws.ap-southeast-1"
}

# Internet gateway
resource "aws_internet_gateway" "default2" {
  vpc_id   = "${aws_vpc.default2.id}"
  provider = "aws.ap-southeast-1"
}

# Internet route
resource "aws_route" "internet" {
  route_table_id         = "${aws_route_table.default2.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default2.id}"
  provider               = "aws.ap-southeast-1"
}
