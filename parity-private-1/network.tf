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

# Relay
module "relay_eu-north-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.eu-north-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.eu-north-1
  }
}

################ eu-north-1 end ################


################ ap-south-1 begin ################

# Provider
provider "aws" {
  alias  = "ap-south-1"
  region = "ap-south-1"
}

# Relay
module "relay_ap-south-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.ap-south-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.ap-south-1
  }
}

################ ap-south-1 end ################


################ eu-west-3 begin ################

# Provider
provider "aws" {
  alias  = "eu-west-3"
  region = "eu-west-3"
}

# Relay
module "relay_eu-west-3" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.eu-west-3.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.eu-west-3
  }
}

################ eu-west-3 end ################


################ eu-west-2 begin ################

# Provider
provider "aws" {
  alias  = "eu-west-2"
  region = "eu-west-2"
}

# Relay
module "relay_eu-west-2" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.eu-west-2.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.eu-west-2
  }
}

################ eu-west-2 end ################


################ eu-west-1 begin ################

# Provider
provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

# Relay
module "relay_eu-west-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.eu-west-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.eu-west-1
  }
}

################ eu-west-1 end ################


################ ap-northeast-2 begin ################

# Provider
provider "aws" {
  alias  = "ap-northeast-2"
  region = "ap-northeast-2"
}

# Relay
module "relay_ap-northeast-2" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.ap-northeast-2.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.ap-northeast-2
  }
}

################ ap-northeast-2 end ################


################ ap-northeast-1 begin ################

# Provider
provider "aws" {
  alias  = "ap-northeast-1"
  region = "ap-northeast-1"
}

# Relay
module "relay_ap-northeast-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.ap-northeast-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.ap-northeast-1
  }
}

################ ap-northeast-1 end ################


################ sa-east-1 begin ################

# Provider
provider "aws" {
  alias  = "sa-east-1"
  region = "sa-east-1"
}

# Relay
module "relay_sa-east-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.sa-east-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.sa-east-1
  }
}

################ sa-east-1 end ################


################ ca-central-1 begin ################

# Provider
provider "aws" {
  alias  = "ca-central-1"
  region = "ca-central-1"
}

# Relay
module "relay_ca-central-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.ca-central-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.ca-central-1
  }
}

################ ca-central-1 end ################


################ ap-southeast-1 begin ################

# Provider
provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}

# Relay
module "relay_ap-southeast-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.ap-southeast-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.ap-southeast-1
  }
}

################ ap-southeast-1 end ################


################ ap-southeast-2 begin ################

# Provider
provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}

# Relay
module "relay_ap-southeast-2" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.ap-southeast-2.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.ap-southeast-2
  }
}

################ ap-southeast-2 end ################


################ eu-central-1 begin ################

# Provider
provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

# Relay
module "relay_eu-central-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.eu-central-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.eu-central-1
  }
}

################ eu-central-1 end ################


################ us-east-1 begin ################

# Provider
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# Relay
module "relay_us-east-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.us-east-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.us-east-1
  }
}

################ us-east-1 end ################


################ us-east-2 begin ################

# Provider
provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

# Relay
module "relay_us-east-2" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.us-east-2.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.us-east-2
  }
}

################ us-east-2 end ################


################ us-west-1 begin ################

# Provider
provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

# Relay
module "relay_us-west-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.us-west-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.us-west-1
  }
}

################ us-west-1 end ################


################ us-west-2 begin ################

# Provider
provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

# Relay
module "relay_us-west-2" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.us-west-2.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = []

  providers = {
    aws = aws.us-west-2
  }
}

################ us-west-2 end ################


