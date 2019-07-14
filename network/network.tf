# VPC
resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

# Subnet
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${aws_vpc.default.cidr_block}"
  map_public_ip_on_launch = true
}

# Route table
resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

# Internet gateway
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}
