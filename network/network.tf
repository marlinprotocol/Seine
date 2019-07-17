# Network
module "mumbai_network" {
  source = "./modules/mumbai_network"
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


# Peering
resource "aws_vpc_peering_connection" "default" {
  provider    = "aws.ap-south-1"
  vpc_id      = "${module.mumbai_network.vpc_id}"
  peer_vpc_id = "${aws_vpc.default2.id}"
  peer_region = "ap-southeast-1"
}

resource "aws_vpc_peering_connection_accepter" "default" {
  provider                  = "aws.ap-southeast-1"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.default.id}"
  auto_accept               = true
}

# Peering routes
resource "aws_route" "mumbai_to_singapore" {
  provider                  = "aws.ap-south-1"
  route_table_id            = "${module.mumbai_network.route_table_id}"
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.default.id}"
}

resource "aws_route" "singapore_to_mumbai" {
  provider                  = "aws.ap-southeast-1"
  route_table_id            = "${aws_route_table.default2.id}"
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.default2.id}"
}
