# Provider
provider "aws" {
  alias  = "ap-south-1"
  region = "ap-south-1"
}

# Provider
provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}

# Mumbai network
module "mumbai_network" {
  source = "./modules/mumbai_network"
}

# Singapore network
module "singapore_network" {
  source = "./modules/singapore_network"
}

# Peering
resource "aws_vpc_peering_connection" "default" {
  provider    = "aws.ap-south-1"
  vpc_id      = "${module.mumbai_network.vpc_id}"
  peer_vpc_id = "${module.singapore_network.vpc_id}"
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
  route_table_id            = "${module.singapore_network.route_table_id}"
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.default2.id}"
}