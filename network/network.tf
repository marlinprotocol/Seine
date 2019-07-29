# Inputs
variable "project" {
  type        = "string"
  description = "Project name"
}

################ ap-south-1 begin ################

# Outputs
output "ap-south-1" {
  value = module.ap-south-1
}

# Provider
provider "aws" {
  alias  = "ap-south-1"
  region = "ap-south-1"
}

# ap-south-1 network
module "ap-south-1" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.0.0.0/16"

  providers = {
    aws = "aws.ap-south-1"
  }
}

# Peering with ap-southeast-1
module "ap-south-1-ap-southeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.ap-southeast-1.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.ap-southeast-1.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.1.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.ap-southeast-1"
  }
}

################ ap-south-1 end ################


################ ap-southeast-1 begin ################

# Outputs
output "ap-southeast-1" {
  value = module.ap-southeast-1
}

# Provider
provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}

# ap-southeast-1 network
module "ap-southeast-1" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.1.0.0/16"

  providers = {
    aws = "aws.ap-southeast-1"
  }
}

################ ap-southeast-1 end ################


