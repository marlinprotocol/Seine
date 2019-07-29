# Inputs
variable "project" {
  type        = "string"
  description = "Project name"
}

################ eu-north-1 begin ################

# Outputs
output "eu-north-1" {
  value = module.eu-north-1
}

# Provider
provider "aws" {
  alias  = "eu-north-1"
  region = "eu-north-1"
}

# eu-north-1 network
module "eu-north-1" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.0.0.0/16"

  providers = {
    aws = "aws.eu-north-1"
  }
}

# Peering with ap-south-1
module "eu-north-1-ap-south-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.ap-south-1.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.ap-south-1.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.1.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.ap-south-1"
  }
}

# Peering with eu-west-3
module "eu-north-1-eu-west-3" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.eu-west-3.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.eu-west-3.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.2.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.eu-west-3"
  }
}

# Peering with eu-west-2
module "eu-north-1-eu-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.eu-west-2.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.eu-west-2.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.3.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.eu-west-2"
  }
}

# Peering with eu-west-1
module "eu-north-1-eu-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.eu-west-1.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.eu-west-1.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.4.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.eu-west-1"
  }
}

# Peering with ap-northeast-2
module "eu-north-1-ap-northeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.ap-northeast-2.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.ap-northeast-2.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.5.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.ap-northeast-2"
  }
}

# Peering with ap-northeast-1
module "eu-north-1-ap-northeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.ap-northeast-1.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.ap-northeast-1.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.6.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.ap-northeast-1"
  }
}

# Peering with sa-east-1
module "eu-north-1-sa-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.sa-east-1.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.sa-east-1.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.7.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.sa-east-1"
  }
}

# Peering with ca-central-1
module "eu-north-1-ca-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.ca-central-1.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.ca-central-1.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.8.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.ca-central-1"
  }
}

# Peering with ap-southeast-1
module "eu-north-1-ap-southeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.ap-southeast-1.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.ap-southeast-1.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.9.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.ap-southeast-1"
  }
}

# Peering with ap-southeast-2
module "eu-north-1-ap-southeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.ap-southeast-2.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.ap-southeast-2.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.10.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.ap-southeast-2"
  }
}

# Peering with eu-central-1
module "eu-north-1-eu-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.eu-central-1.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.eu-central-1.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.11.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.eu-central-1"
  }
}

# Peering with us-east-1
module "eu-north-1-us-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.us-east-1.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.us-east-1.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.12.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "eu-north-1-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "eu-north-1-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "eu-north-1-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-north-1.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.eu-north-1.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.0.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.us-west-2"
  }
}

################ eu-north-1 end ################


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
  vpc_block = "10.1.0.0/16"

  providers = {
    aws = "aws.ap-south-1"
  }
}

# Peering with eu-west-3
module "ap-south-1-eu-west-3" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.eu-west-3.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.eu-west-3.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.2.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.eu-west-3"
  }
}

# Peering with eu-west-2
module "ap-south-1-eu-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.eu-west-2.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.eu-west-2.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.3.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.eu-west-2"
  }
}

# Peering with eu-west-1
module "ap-south-1-eu-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.eu-west-1.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.eu-west-1.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.4.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.eu-west-1"
  }
}

# Peering with ap-northeast-2
module "ap-south-1-ap-northeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.ap-northeast-2.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.ap-northeast-2.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.5.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.ap-northeast-2"
  }
}

# Peering with ap-northeast-1
module "ap-south-1-ap-northeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.ap-northeast-1.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.ap-northeast-1.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.6.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.ap-northeast-1"
  }
}

# Peering with sa-east-1
module "ap-south-1-sa-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.sa-east-1.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.sa-east-1.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.7.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.sa-east-1"
  }
}

# Peering with ca-central-1
module "ap-south-1-ca-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.ca-central-1.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.ca-central-1.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.8.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.ca-central-1"
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
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.9.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.ap-southeast-1"
  }
}

# Peering with ap-southeast-2
module "ap-south-1-ap-southeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.ap-southeast-2.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.ap-southeast-2.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.10.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.ap-southeast-2"
  }
}

# Peering with eu-central-1
module "ap-south-1-eu-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.eu-central-1.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.eu-central-1.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.11.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.eu-central-1"
  }
}

# Peering with us-east-1
module "ap-south-1-us-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.us-east-1.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.us-east-1.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.12.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "ap-south-1-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "ap-south-1-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "ap-south-1-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-south-1.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.ap-south-1.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.1.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.us-west-2"
  }
}

################ ap-south-1 end ################


################ eu-west-3 begin ################

# Outputs
output "eu-west-3" {
  value = module.eu-west-3
}

# Provider
provider "aws" {
  alias  = "eu-west-3"
  region = "eu-west-3"
}

# eu-west-3 network
module "eu-west-3" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.2.0.0/16"

  providers = {
    aws = "aws.eu-west-3"
  }
}

# Peering with eu-west-2
module "eu-west-3-eu-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.eu-west-2.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.eu-west-2.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.3.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.eu-west-2"
  }
}

# Peering with eu-west-1
module "eu-west-3-eu-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.eu-west-1.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.eu-west-1.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.4.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.eu-west-1"
  }
}

# Peering with ap-northeast-2
module "eu-west-3-ap-northeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.ap-northeast-2.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.ap-northeast-2.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.5.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.ap-northeast-2"
  }
}

# Peering with ap-northeast-1
module "eu-west-3-ap-northeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.ap-northeast-1.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.ap-northeast-1.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.6.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.ap-northeast-1"
  }
}

# Peering with sa-east-1
module "eu-west-3-sa-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.sa-east-1.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.sa-east-1.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.7.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.sa-east-1"
  }
}

# Peering with ca-central-1
module "eu-west-3-ca-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.ca-central-1.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.ca-central-1.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.8.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.ca-central-1"
  }
}

# Peering with ap-southeast-1
module "eu-west-3-ap-southeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.ap-southeast-1.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.ap-southeast-1.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.9.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.ap-southeast-1"
  }
}

# Peering with ap-southeast-2
module "eu-west-3-ap-southeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.ap-southeast-2.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.ap-southeast-2.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.10.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.ap-southeast-2"
  }
}

# Peering with eu-central-1
module "eu-west-3-eu-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.eu-central-1.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.eu-central-1.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.11.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.eu-central-1"
  }
}

# Peering with us-east-1
module "eu-west-3-us-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.us-east-1.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.us-east-1.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.12.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "eu-west-3-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "eu-west-3-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "eu-west-3-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-3.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.eu-west-3.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.2.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.us-west-2"
  }
}

################ eu-west-3 end ################


################ eu-west-2 begin ################

# Outputs
output "eu-west-2" {
  value = module.eu-west-2
}

# Provider
provider "aws" {
  alias  = "eu-west-2"
  region = "eu-west-2"
}

# eu-west-2 network
module "eu-west-2" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.3.0.0/16"

  providers = {
    aws = "aws.eu-west-2"
  }
}

# Peering with eu-west-1
module "eu-west-2-eu-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-2.vpc.id
  dst_vpc_id = module.eu-west-1.vpc.id
  src_route_table_id = module.eu-west-2.route_table.id
  dst_route_table_id = module.eu-west-1.route_table.id
  src_cidr = "10.3.0.0/16"
  dst_cidr = "10.4.0.0/16"

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.eu-west-1"
  }
}

# Peering with ap-northeast-2
module "eu-west-2-ap-northeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-2.vpc.id
  dst_vpc_id = module.ap-northeast-2.vpc.id
  src_route_table_id = module.eu-west-2.route_table.id
  dst_route_table_id = module.ap-northeast-2.route_table.id
  src_cidr = "10.3.0.0/16"
  dst_cidr = "10.5.0.0/16"

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.ap-northeast-2"
  }
}

# Peering with ap-northeast-1
module "eu-west-2-ap-northeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-2.vpc.id
  dst_vpc_id = module.ap-northeast-1.vpc.id
  src_route_table_id = module.eu-west-2.route_table.id
  dst_route_table_id = module.ap-northeast-1.route_table.id
  src_cidr = "10.3.0.0/16"
  dst_cidr = "10.6.0.0/16"

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.ap-northeast-1"
  }
}

# Peering with sa-east-1
module "eu-west-2-sa-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-2.vpc.id
  dst_vpc_id = module.sa-east-1.vpc.id
  src_route_table_id = module.eu-west-2.route_table.id
  dst_route_table_id = module.sa-east-1.route_table.id
  src_cidr = "10.3.0.0/16"
  dst_cidr = "10.7.0.0/16"

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.sa-east-1"
  }
}

# Peering with ca-central-1
module "eu-west-2-ca-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-2.vpc.id
  dst_vpc_id = module.ca-central-1.vpc.id
  src_route_table_id = module.eu-west-2.route_table.id
  dst_route_table_id = module.ca-central-1.route_table.id
  src_cidr = "10.3.0.0/16"
  dst_cidr = "10.8.0.0/16"

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.ca-central-1"
  }
}

# Peering with ap-southeast-1
module "eu-west-2-ap-southeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-2.vpc.id
  dst_vpc_id = module.ap-southeast-1.vpc.id
  src_route_table_id = module.eu-west-2.route_table.id
  dst_route_table_id = module.ap-southeast-1.route_table.id
  src_cidr = "10.3.0.0/16"
  dst_cidr = "10.9.0.0/16"

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.ap-southeast-1"
  }
}

# Peering with ap-southeast-2
module "eu-west-2-ap-southeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-2.vpc.id
  dst_vpc_id = module.ap-southeast-2.vpc.id
  src_route_table_id = module.eu-west-2.route_table.id
  dst_route_table_id = module.ap-southeast-2.route_table.id
  src_cidr = "10.3.0.0/16"
  dst_cidr = "10.10.0.0/16"

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.ap-southeast-2"
  }
}

# Peering with eu-central-1
module "eu-west-2-eu-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-2.vpc.id
  dst_vpc_id = module.eu-central-1.vpc.id
  src_route_table_id = module.eu-west-2.route_table.id
  dst_route_table_id = module.eu-central-1.route_table.id
  src_cidr = "10.3.0.0/16"
  dst_cidr = "10.11.0.0/16"

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.eu-central-1"
  }
}

# Peering with us-east-1
module "eu-west-2-us-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-2.vpc.id
  dst_vpc_id = module.us-east-1.vpc.id
  src_route_table_id = module.eu-west-2.route_table.id
  dst_route_table_id = module.us-east-1.route_table.id
  src_cidr = "10.3.0.0/16"
  dst_cidr = "10.12.0.0/16"

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "eu-west-2-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-2.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.eu-west-2.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.3.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "eu-west-2-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-2.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.eu-west-2.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.3.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "eu-west-2-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-2.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.eu-west-2.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.3.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.us-west-2"
  }
}

################ eu-west-2 end ################


################ eu-west-1 begin ################

# Outputs
output "eu-west-1" {
  value = module.eu-west-1
}

# Provider
provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

# eu-west-1 network
module "eu-west-1" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.4.0.0/16"

  providers = {
    aws = "aws.eu-west-1"
  }
}

# Peering with ap-northeast-2
module "eu-west-1-ap-northeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-1.vpc.id
  dst_vpc_id = module.ap-northeast-2.vpc.id
  src_route_table_id = module.eu-west-1.route_table.id
  dst_route_table_id = module.ap-northeast-2.route_table.id
  src_cidr = "10.4.0.0/16"
  dst_cidr = "10.5.0.0/16"

  providers = {
    aws.src = "aws.eu-west-1"
    aws.dst = "aws.ap-northeast-2"
  }
}

# Peering with ap-northeast-1
module "eu-west-1-ap-northeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-1.vpc.id
  dst_vpc_id = module.ap-northeast-1.vpc.id
  src_route_table_id = module.eu-west-1.route_table.id
  dst_route_table_id = module.ap-northeast-1.route_table.id
  src_cidr = "10.4.0.0/16"
  dst_cidr = "10.6.0.0/16"

  providers = {
    aws.src = "aws.eu-west-1"
    aws.dst = "aws.ap-northeast-1"
  }
}

# Peering with sa-east-1
module "eu-west-1-sa-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-1.vpc.id
  dst_vpc_id = module.sa-east-1.vpc.id
  src_route_table_id = module.eu-west-1.route_table.id
  dst_route_table_id = module.sa-east-1.route_table.id
  src_cidr = "10.4.0.0/16"
  dst_cidr = "10.7.0.0/16"

  providers = {
    aws.src = "aws.eu-west-1"
    aws.dst = "aws.sa-east-1"
  }
}

# Peering with ca-central-1
module "eu-west-1-ca-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-1.vpc.id
  dst_vpc_id = module.ca-central-1.vpc.id
  src_route_table_id = module.eu-west-1.route_table.id
  dst_route_table_id = module.ca-central-1.route_table.id
  src_cidr = "10.4.0.0/16"
  dst_cidr = "10.8.0.0/16"

  providers = {
    aws.src = "aws.eu-west-1"
    aws.dst = "aws.ca-central-1"
  }
}

# Peering with ap-southeast-1
module "eu-west-1-ap-southeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-1.vpc.id
  dst_vpc_id = module.ap-southeast-1.vpc.id
  src_route_table_id = module.eu-west-1.route_table.id
  dst_route_table_id = module.ap-southeast-1.route_table.id
  src_cidr = "10.4.0.0/16"
  dst_cidr = "10.9.0.0/16"

  providers = {
    aws.src = "aws.eu-west-1"
    aws.dst = "aws.ap-southeast-1"
  }
}

# Peering with ap-southeast-2
module "eu-west-1-ap-southeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-1.vpc.id
  dst_vpc_id = module.ap-southeast-2.vpc.id
  src_route_table_id = module.eu-west-1.route_table.id
  dst_route_table_id = module.ap-southeast-2.route_table.id
  src_cidr = "10.4.0.0/16"
  dst_cidr = "10.10.0.0/16"

  providers = {
    aws.src = "aws.eu-west-1"
    aws.dst = "aws.ap-southeast-2"
  }
}

# Peering with eu-central-1
module "eu-west-1-eu-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-1.vpc.id
  dst_vpc_id = module.eu-central-1.vpc.id
  src_route_table_id = module.eu-west-1.route_table.id
  dst_route_table_id = module.eu-central-1.route_table.id
  src_cidr = "10.4.0.0/16"
  dst_cidr = "10.11.0.0/16"

  providers = {
    aws.src = "aws.eu-west-1"
    aws.dst = "aws.eu-central-1"
  }
}

# Peering with us-east-1
module "eu-west-1-us-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-1.vpc.id
  dst_vpc_id = module.us-east-1.vpc.id
  src_route_table_id = module.eu-west-1.route_table.id
  dst_route_table_id = module.us-east-1.route_table.id
  src_cidr = "10.4.0.0/16"
  dst_cidr = "10.12.0.0/16"

  providers = {
    aws.src = "aws.eu-west-1"
    aws.dst = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "eu-west-1-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-1.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.eu-west-1.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.4.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.eu-west-1"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "eu-west-1-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-1.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.eu-west-1.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.4.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.eu-west-1"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "eu-west-1-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-west-1.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.eu-west-1.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.4.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.eu-west-1"
    aws.dst = "aws.us-west-2"
  }
}

################ eu-west-1 end ################


################ ap-northeast-2 begin ################

# Outputs
output "ap-northeast-2" {
  value = module.ap-northeast-2
}

# Provider
provider "aws" {
  alias  = "ap-northeast-2"
  region = "ap-northeast-2"
}

# ap-northeast-2 network
module "ap-northeast-2" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.5.0.0/16"

  providers = {
    aws = "aws.ap-northeast-2"
  }
}

# Peering with ap-northeast-1
module "ap-northeast-2-ap-northeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-2.vpc.id
  dst_vpc_id = module.ap-northeast-1.vpc.id
  src_route_table_id = module.ap-northeast-2.route_table.id
  dst_route_table_id = module.ap-northeast-1.route_table.id
  src_cidr = "10.5.0.0/16"
  dst_cidr = "10.6.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-2"
    aws.dst = "aws.ap-northeast-1"
  }
}

# Peering with sa-east-1
module "ap-northeast-2-sa-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-2.vpc.id
  dst_vpc_id = module.sa-east-1.vpc.id
  src_route_table_id = module.ap-northeast-2.route_table.id
  dst_route_table_id = module.sa-east-1.route_table.id
  src_cidr = "10.5.0.0/16"
  dst_cidr = "10.7.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-2"
    aws.dst = "aws.sa-east-1"
  }
}

# Peering with ca-central-1
module "ap-northeast-2-ca-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-2.vpc.id
  dst_vpc_id = module.ca-central-1.vpc.id
  src_route_table_id = module.ap-northeast-2.route_table.id
  dst_route_table_id = module.ca-central-1.route_table.id
  src_cidr = "10.5.0.0/16"
  dst_cidr = "10.8.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-2"
    aws.dst = "aws.ca-central-1"
  }
}

# Peering with ap-southeast-1
module "ap-northeast-2-ap-southeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-2.vpc.id
  dst_vpc_id = module.ap-southeast-1.vpc.id
  src_route_table_id = module.ap-northeast-2.route_table.id
  dst_route_table_id = module.ap-southeast-1.route_table.id
  src_cidr = "10.5.0.0/16"
  dst_cidr = "10.9.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-2"
    aws.dst = "aws.ap-southeast-1"
  }
}

# Peering with ap-southeast-2
module "ap-northeast-2-ap-southeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-2.vpc.id
  dst_vpc_id = module.ap-southeast-2.vpc.id
  src_route_table_id = module.ap-northeast-2.route_table.id
  dst_route_table_id = module.ap-southeast-2.route_table.id
  src_cidr = "10.5.0.0/16"
  dst_cidr = "10.10.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-2"
    aws.dst = "aws.ap-southeast-2"
  }
}

# Peering with eu-central-1
module "ap-northeast-2-eu-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-2.vpc.id
  dst_vpc_id = module.eu-central-1.vpc.id
  src_route_table_id = module.ap-northeast-2.route_table.id
  dst_route_table_id = module.eu-central-1.route_table.id
  src_cidr = "10.5.0.0/16"
  dst_cidr = "10.11.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-2"
    aws.dst = "aws.eu-central-1"
  }
}

# Peering with us-east-1
module "ap-northeast-2-us-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-2.vpc.id
  dst_vpc_id = module.us-east-1.vpc.id
  src_route_table_id = module.ap-northeast-2.route_table.id
  dst_route_table_id = module.us-east-1.route_table.id
  src_cidr = "10.5.0.0/16"
  dst_cidr = "10.12.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-2"
    aws.dst = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "ap-northeast-2-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-2.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.ap-northeast-2.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.5.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-2"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "ap-northeast-2-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-2.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.ap-northeast-2.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.5.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-2"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "ap-northeast-2-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-2.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.ap-northeast-2.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.5.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-2"
    aws.dst = "aws.us-west-2"
  }
}

################ ap-northeast-2 end ################


################ ap-northeast-1 begin ################

# Outputs
output "ap-northeast-1" {
  value = module.ap-northeast-1
}

# Provider
provider "aws" {
  alias  = "ap-northeast-1"
  region = "ap-northeast-1"
}

# ap-northeast-1 network
module "ap-northeast-1" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.6.0.0/16"

  providers = {
    aws = "aws.ap-northeast-1"
  }
}

# Peering with sa-east-1
module "ap-northeast-1-sa-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-1.vpc.id
  dst_vpc_id = module.sa-east-1.vpc.id
  src_route_table_id = module.ap-northeast-1.route_table.id
  dst_route_table_id = module.sa-east-1.route_table.id
  src_cidr = "10.6.0.0/16"
  dst_cidr = "10.7.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-1"
    aws.dst = "aws.sa-east-1"
  }
}

# Peering with ca-central-1
module "ap-northeast-1-ca-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-1.vpc.id
  dst_vpc_id = module.ca-central-1.vpc.id
  src_route_table_id = module.ap-northeast-1.route_table.id
  dst_route_table_id = module.ca-central-1.route_table.id
  src_cidr = "10.6.0.0/16"
  dst_cidr = "10.8.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-1"
    aws.dst = "aws.ca-central-1"
  }
}

# Peering with ap-southeast-1
module "ap-northeast-1-ap-southeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-1.vpc.id
  dst_vpc_id = module.ap-southeast-1.vpc.id
  src_route_table_id = module.ap-northeast-1.route_table.id
  dst_route_table_id = module.ap-southeast-1.route_table.id
  src_cidr = "10.6.0.0/16"
  dst_cidr = "10.9.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-1"
    aws.dst = "aws.ap-southeast-1"
  }
}

# Peering with ap-southeast-2
module "ap-northeast-1-ap-southeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-1.vpc.id
  dst_vpc_id = module.ap-southeast-2.vpc.id
  src_route_table_id = module.ap-northeast-1.route_table.id
  dst_route_table_id = module.ap-southeast-2.route_table.id
  src_cidr = "10.6.0.0/16"
  dst_cidr = "10.10.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-1"
    aws.dst = "aws.ap-southeast-2"
  }
}

# Peering with eu-central-1
module "ap-northeast-1-eu-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-1.vpc.id
  dst_vpc_id = module.eu-central-1.vpc.id
  src_route_table_id = module.ap-northeast-1.route_table.id
  dst_route_table_id = module.eu-central-1.route_table.id
  src_cidr = "10.6.0.0/16"
  dst_cidr = "10.11.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-1"
    aws.dst = "aws.eu-central-1"
  }
}

# Peering with us-east-1
module "ap-northeast-1-us-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-1.vpc.id
  dst_vpc_id = module.us-east-1.vpc.id
  src_route_table_id = module.ap-northeast-1.route_table.id
  dst_route_table_id = module.us-east-1.route_table.id
  src_cidr = "10.6.0.0/16"
  dst_cidr = "10.12.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-1"
    aws.dst = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "ap-northeast-1-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-1.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.ap-northeast-1.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.6.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-1"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "ap-northeast-1-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-1.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.ap-northeast-1.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.6.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-1"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "ap-northeast-1-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-northeast-1.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.ap-northeast-1.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.6.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.ap-northeast-1"
    aws.dst = "aws.us-west-2"
  }
}

################ ap-northeast-1 end ################


################ sa-east-1 begin ################

# Outputs
output "sa-east-1" {
  value = module.sa-east-1
}

# Provider
provider "aws" {
  alias  = "sa-east-1"
  region = "sa-east-1"
}

# sa-east-1 network
module "sa-east-1" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.7.0.0/16"

  providers = {
    aws = "aws.sa-east-1"
  }
}

# Peering with ca-central-1
module "sa-east-1-ca-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.sa-east-1.vpc.id
  dst_vpc_id = module.ca-central-1.vpc.id
  src_route_table_id = module.sa-east-1.route_table.id
  dst_route_table_id = module.ca-central-1.route_table.id
  src_cidr = "10.7.0.0/16"
  dst_cidr = "10.8.0.0/16"

  providers = {
    aws.src = "aws.sa-east-1"
    aws.dst = "aws.ca-central-1"
  }
}

# Peering with ap-southeast-1
module "sa-east-1-ap-southeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.sa-east-1.vpc.id
  dst_vpc_id = module.ap-southeast-1.vpc.id
  src_route_table_id = module.sa-east-1.route_table.id
  dst_route_table_id = module.ap-southeast-1.route_table.id
  src_cidr = "10.7.0.0/16"
  dst_cidr = "10.9.0.0/16"

  providers = {
    aws.src = "aws.sa-east-1"
    aws.dst = "aws.ap-southeast-1"
  }
}

# Peering with ap-southeast-2
module "sa-east-1-ap-southeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.sa-east-1.vpc.id
  dst_vpc_id = module.ap-southeast-2.vpc.id
  src_route_table_id = module.sa-east-1.route_table.id
  dst_route_table_id = module.ap-southeast-2.route_table.id
  src_cidr = "10.7.0.0/16"
  dst_cidr = "10.10.0.0/16"

  providers = {
    aws.src = "aws.sa-east-1"
    aws.dst = "aws.ap-southeast-2"
  }
}

# Peering with eu-central-1
module "sa-east-1-eu-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.sa-east-1.vpc.id
  dst_vpc_id = module.eu-central-1.vpc.id
  src_route_table_id = module.sa-east-1.route_table.id
  dst_route_table_id = module.eu-central-1.route_table.id
  src_cidr = "10.7.0.0/16"
  dst_cidr = "10.11.0.0/16"

  providers = {
    aws.src = "aws.sa-east-1"
    aws.dst = "aws.eu-central-1"
  }
}

# Peering with us-east-1
module "sa-east-1-us-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.sa-east-1.vpc.id
  dst_vpc_id = module.us-east-1.vpc.id
  src_route_table_id = module.sa-east-1.route_table.id
  dst_route_table_id = module.us-east-1.route_table.id
  src_cidr = "10.7.0.0/16"
  dst_cidr = "10.12.0.0/16"

  providers = {
    aws.src = "aws.sa-east-1"
    aws.dst = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "sa-east-1-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.sa-east-1.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.sa-east-1.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.7.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.sa-east-1"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "sa-east-1-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.sa-east-1.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.sa-east-1.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.7.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.sa-east-1"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "sa-east-1-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.sa-east-1.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.sa-east-1.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.7.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.sa-east-1"
    aws.dst = "aws.us-west-2"
  }
}

################ sa-east-1 end ################


################ ca-central-1 begin ################

# Outputs
output "ca-central-1" {
  value = module.ca-central-1
}

# Provider
provider "aws" {
  alias  = "ca-central-1"
  region = "ca-central-1"
}

# ca-central-1 network
module "ca-central-1" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.8.0.0/16"

  providers = {
    aws = "aws.ca-central-1"
  }
}

# Peering with ap-southeast-1
module "ca-central-1-ap-southeast-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ca-central-1.vpc.id
  dst_vpc_id = module.ap-southeast-1.vpc.id
  src_route_table_id = module.ca-central-1.route_table.id
  dst_route_table_id = module.ap-southeast-1.route_table.id
  src_cidr = "10.8.0.0/16"
  dst_cidr = "10.9.0.0/16"

  providers = {
    aws.src = "aws.ca-central-1"
    aws.dst = "aws.ap-southeast-1"
  }
}

# Peering with ap-southeast-2
module "ca-central-1-ap-southeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ca-central-1.vpc.id
  dst_vpc_id = module.ap-southeast-2.vpc.id
  src_route_table_id = module.ca-central-1.route_table.id
  dst_route_table_id = module.ap-southeast-2.route_table.id
  src_cidr = "10.8.0.0/16"
  dst_cidr = "10.10.0.0/16"

  providers = {
    aws.src = "aws.ca-central-1"
    aws.dst = "aws.ap-southeast-2"
  }
}

# Peering with eu-central-1
module "ca-central-1-eu-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ca-central-1.vpc.id
  dst_vpc_id = module.eu-central-1.vpc.id
  src_route_table_id = module.ca-central-1.route_table.id
  dst_route_table_id = module.eu-central-1.route_table.id
  src_cidr = "10.8.0.0/16"
  dst_cidr = "10.11.0.0/16"

  providers = {
    aws.src = "aws.ca-central-1"
    aws.dst = "aws.eu-central-1"
  }
}

# Peering with us-east-1
module "ca-central-1-us-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ca-central-1.vpc.id
  dst_vpc_id = module.us-east-1.vpc.id
  src_route_table_id = module.ca-central-1.route_table.id
  dst_route_table_id = module.us-east-1.route_table.id
  src_cidr = "10.8.0.0/16"
  dst_cidr = "10.12.0.0/16"

  providers = {
    aws.src = "aws.ca-central-1"
    aws.dst = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "ca-central-1-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ca-central-1.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.ca-central-1.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.8.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.ca-central-1"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "ca-central-1-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ca-central-1.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.ca-central-1.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.8.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.ca-central-1"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "ca-central-1-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ca-central-1.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.ca-central-1.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.8.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.ca-central-1"
    aws.dst = "aws.us-west-2"
  }
}

################ ca-central-1 end ################


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
  vpc_block = "10.9.0.0/16"

  providers = {
    aws = "aws.ap-southeast-1"
  }
}

# Peering with ap-southeast-2
module "ap-southeast-1-ap-southeast-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-southeast-1.vpc.id
  dst_vpc_id = module.ap-southeast-2.vpc.id
  src_route_table_id = module.ap-southeast-1.route_table.id
  dst_route_table_id = module.ap-southeast-2.route_table.id
  src_cidr = "10.9.0.0/16"
  dst_cidr = "10.10.0.0/16"

  providers = {
    aws.src = "aws.ap-southeast-1"
    aws.dst = "aws.ap-southeast-2"
  }
}

# Peering with eu-central-1
module "ap-southeast-1-eu-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-southeast-1.vpc.id
  dst_vpc_id = module.eu-central-1.vpc.id
  src_route_table_id = module.ap-southeast-1.route_table.id
  dst_route_table_id = module.eu-central-1.route_table.id
  src_cidr = "10.9.0.0/16"
  dst_cidr = "10.11.0.0/16"

  providers = {
    aws.src = "aws.ap-southeast-1"
    aws.dst = "aws.eu-central-1"
  }
}

# Peering with us-east-1
module "ap-southeast-1-us-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-southeast-1.vpc.id
  dst_vpc_id = module.us-east-1.vpc.id
  src_route_table_id = module.ap-southeast-1.route_table.id
  dst_route_table_id = module.us-east-1.route_table.id
  src_cidr = "10.9.0.0/16"
  dst_cidr = "10.12.0.0/16"

  providers = {
    aws.src = "aws.ap-southeast-1"
    aws.dst = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "ap-southeast-1-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-southeast-1.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.ap-southeast-1.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.9.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.ap-southeast-1"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "ap-southeast-1-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-southeast-1.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.ap-southeast-1.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.9.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.ap-southeast-1"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "ap-southeast-1-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-southeast-1.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.ap-southeast-1.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.9.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.ap-southeast-1"
    aws.dst = "aws.us-west-2"
  }
}

################ ap-southeast-1 end ################


################ ap-southeast-2 begin ################

# Outputs
output "ap-southeast-2" {
  value = module.ap-southeast-2
}

# Provider
provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}

# ap-southeast-2 network
module "ap-southeast-2" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.10.0.0/16"

  providers = {
    aws = "aws.ap-southeast-2"
  }
}

# Peering with eu-central-1
module "ap-southeast-2-eu-central-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-southeast-2.vpc.id
  dst_vpc_id = module.eu-central-1.vpc.id
  src_route_table_id = module.ap-southeast-2.route_table.id
  dst_route_table_id = module.eu-central-1.route_table.id
  src_cidr = "10.10.0.0/16"
  dst_cidr = "10.11.0.0/16"

  providers = {
    aws.src = "aws.ap-southeast-2"
    aws.dst = "aws.eu-central-1"
  }
}

# Peering with us-east-1
module "ap-southeast-2-us-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-southeast-2.vpc.id
  dst_vpc_id = module.us-east-1.vpc.id
  src_route_table_id = module.ap-southeast-2.route_table.id
  dst_route_table_id = module.us-east-1.route_table.id
  src_cidr = "10.10.0.0/16"
  dst_cidr = "10.12.0.0/16"

  providers = {
    aws.src = "aws.ap-southeast-2"
    aws.dst = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "ap-southeast-2-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-southeast-2.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.ap-southeast-2.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.10.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.ap-southeast-2"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "ap-southeast-2-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-southeast-2.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.ap-southeast-2.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.10.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.ap-southeast-2"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "ap-southeast-2-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.ap-southeast-2.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.ap-southeast-2.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.10.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.ap-southeast-2"
    aws.dst = "aws.us-west-2"
  }
}

################ ap-southeast-2 end ################


################ eu-central-1 begin ################

# Outputs
output "eu-central-1" {
  value = module.eu-central-1
}

# Provider
provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

# eu-central-1 network
module "eu-central-1" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.11.0.0/16"

  providers = {
    aws = "aws.eu-central-1"
  }
}

# Peering with us-east-1
module "eu-central-1-us-east-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-central-1.vpc.id
  dst_vpc_id = module.us-east-1.vpc.id
  src_route_table_id = module.eu-central-1.route_table.id
  dst_route_table_id = module.us-east-1.route_table.id
  src_cidr = "10.11.0.0/16"
  dst_cidr = "10.12.0.0/16"

  providers = {
    aws.src = "aws.eu-central-1"
    aws.dst = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "eu-central-1-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-central-1.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.eu-central-1.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.11.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.eu-central-1"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "eu-central-1-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-central-1.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.eu-central-1.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.11.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.eu-central-1"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "eu-central-1-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.eu-central-1.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.eu-central-1.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.11.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.eu-central-1"
    aws.dst = "aws.us-west-2"
  }
}

################ eu-central-1 end ################


################ us-east-1 begin ################

# Outputs
output "us-east-1" {
  value = module.us-east-1
}

# Provider
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# us-east-1 network
module "us-east-1" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.12.0.0/16"

  providers = {
    aws = "aws.us-east-1"
  }
}

# Peering with us-east-2
module "us-east-1-us-east-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.us-east-1.vpc.id
  dst_vpc_id = module.us-east-2.vpc.id
  src_route_table_id = module.us-east-1.route_table.id
  dst_route_table_id = module.us-east-2.route_table.id
  src_cidr = "10.12.0.0/16"
  dst_cidr = "10.13.0.0/16"

  providers = {
    aws.src = "aws.us-east-1"
    aws.dst = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "us-east-1-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.us-east-1.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.us-east-1.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.12.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.us-east-1"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "us-east-1-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.us-east-1.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.us-east-1.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.12.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.us-east-1"
    aws.dst = "aws.us-west-2"
  }
}

################ us-east-1 end ################


################ us-east-2 begin ################

# Outputs
output "us-east-2" {
  value = module.us-east-2
}

# Provider
provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

# us-east-2 network
module "us-east-2" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.13.0.0/16"

  providers = {
    aws = "aws.us-east-2"
  }
}

# Peering with us-west-1
module "us-east-2-us-west-1" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.us-east-2.vpc.id
  dst_vpc_id = module.us-west-1.vpc.id
  src_route_table_id = module.us-east-2.route_table.id
  dst_route_table_id = module.us-west-1.route_table.id
  src_cidr = "10.13.0.0/16"
  dst_cidr = "10.14.0.0/16"

  providers = {
    aws.src = "aws.us-east-2"
    aws.dst = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "us-east-2-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.us-east-2.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.us-east-2.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.13.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.us-east-2"
    aws.dst = "aws.us-west-2"
  }
}

################ us-east-2 end ################


################ us-west-1 begin ################

# Outputs
output "us-west-1" {
  value = module.us-west-1
}

# Provider
provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

# us-west-1 network
module "us-west-1" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.14.0.0/16"

  providers = {
    aws = "aws.us-west-1"
  }
}

# Peering with us-west-2
module "us-west-1-us-west-2" {
  source = "./modules/peering_connection"
  project = "${var.project}"
  src_vpc_id = module.us-west-1.vpc.id
  dst_vpc_id = module.us-west-2.vpc.id
  src_route_table_id = module.us-west-1.route_table.id
  dst_route_table_id = module.us-west-2.route_table.id
  src_cidr = "10.14.0.0/16"
  dst_cidr = "10.15.0.0/16"

  providers = {
    aws.src = "aws.us-west-1"
    aws.dst = "aws.us-west-2"
  }
}

################ us-west-1 end ################


################ us-west-2 begin ################

# Outputs
output "us-west-2" {
  value = module.us-west-2
}

# Provider
provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

# us-west-2 network
module "us-west-2" {
  source    = "./modules/regional_network"
  project   = "${var.project}"
  vpc_block = "10.15.0.0/16"

  providers = {
    aws = "aws.us-west-2"
  }
}

################ us-west-2 end ################


