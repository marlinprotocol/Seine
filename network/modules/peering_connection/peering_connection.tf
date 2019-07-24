# Providers
provider "aws" {
  alias = "src"
}

provider "aws" {
  alias = "dst"
}

# Inputs
variable "project" {
  type        = "string"
  description = "Project name"
}

variable "src_vpc_id" {
  type        = "string"
  description = "Source VPC"
}

variable "dst_vpc_id" {
  type        = "string"
  description = "Destination VPC"
}

variable "src_route_table_id" {
  type        = "string"
  description = "Source route table"
}

variable "dst_route_table_id" {
  type        = "string"
  description = "Destination route table"
}

variable "src_cidr" {
  type        = "string"
  description = "Source CIDR"
}

variable "dst_cidr" {
  type        = "string"
  description = "Destination CIDR"
}

# Peering
data "aws_region" "dst" {
  provider = "aws.dst"
}

resource "aws_vpc_peering_connection" "default" {
  provider    = "aws.src"
  vpc_id      = var.src_vpc_id
  peer_vpc_id = var.dst_vpc_id
  peer_region = data.aws_region.dst.name

  tags = {
    project = "${var.project}"
  }
}

resource "aws_vpc_peering_connection_accepter" "default" {
  provider                  = "aws.dst"
  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
  auto_accept               = true

  tags = {
    project = "${var.project}"
  }
}

# Peering routes
resource "aws_route" "src_to_dst" {
  provider                  = "aws.src"
  route_table_id            = var.src_route_table_id
  destination_cidr_block    = var.dst_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
}

resource "aws_route" "dst_to_src" {
  provider                  = "aws.dst"
  route_table_id            = var.dst_route_table_id
  destination_cidr_block    = var.src_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
}
