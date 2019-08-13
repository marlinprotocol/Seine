# Project
locals {
  project = "parity_private_1"
}

# Network
module "network" {
  source  = "../network"
  project = local.project
}

# IAM role
resource "aws_iam_role" "relay" {
  provider    = aws.us-east-2
  name = "${local.project}_relay"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM profile
resource "aws_iam_instance_profile" "relay" {
  provider    = aws.us-east-2
  name = "${local.project}_relay"
  role = "${aws_iam_role.relay.name}"
}

# Monitoring subnet
data "aws_subnet" "monitoring" {
  provider = aws.us-east-2
  id = "subnet-06663c1f3455564a4"
}

# Monitoring route table
data "aws_route_table" "monitoring" {
  provider = aws.us-east-2
  subnet_id = data.aws_subnet.monitoring.id
}

# IAM role
resource "aws_iam_role" "eth" {
  provider    = aws.us-east-2
  name = "${local.project}_eth"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM profile
resource "aws_iam_instance_profile" "eth" {
  provider    = aws.us-east-2
  name = "${local.project}_eth"
  role = "${aws_iam_role.eth.name}"
}

################ eu-north-1 begin ################

# Provider
provider "aws" {
  alias  = "eu-north-1"
  region = "eu-north-1"
}

# Monitoring Peering
module "eu-north-1-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.eu-north-1.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.eu-north-1.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.0/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.eu-north-1"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_eu-north-1" {
  provider    = aws.eu-north-1
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.eu-north-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_eu-north-1" {
  provider    = aws.eu-north-1
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.eu-north-1.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_eu-north-1" {
  provider    = aws.eu-north-1
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.eu-north-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_eu-north-1" {
  provider    = aws.eu-north-1
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.eu-north-1.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_eu-north-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.eu-north-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_eu-north-1.id,
    aws_security_group.egress_eu-north-1.id,
    aws_security_group.discovery_eu-north-1.id,
    aws_security_group.internal_eu-north-1.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.eu-north-1
  }
}

# Ethereum
resource "aws_security_group" "eth_eu-north-1" {
  provider    = aws.eu-north-1
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.eu-north-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ eu-north-1 end ################


################ ap-south-1 begin ################

# Provider
provider "aws" {
  alias  = "ap-south-1"
  region = "ap-south-1"
}

# Monitoring Peering
module "ap-south-1-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.ap-south-1.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.ap-south-1.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.16/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.ap-south-1"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_ap-south-1" {
  provider    = aws.ap-south-1
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.ap-south-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_ap-south-1" {
  provider    = aws.ap-south-1
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.ap-south-1.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_ap-south-1" {
  provider    = aws.ap-south-1
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.ap-south-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_ap-south-1" {
  provider    = aws.ap-south-1
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.ap-south-1.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_ap-south-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.ap-south-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_ap-south-1.id,
    aws_security_group.egress_ap-south-1.id,
    aws_security_group.discovery_ap-south-1.id,
    aws_security_group.internal_ap-south-1.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.ap-south-1
  }
}

# Ethereum
resource "aws_security_group" "eth_ap-south-1" {
  provider    = aws.ap-south-1
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.ap-south-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ ap-south-1 end ################


################ eu-west-3 begin ################

# Provider
provider "aws" {
  alias  = "eu-west-3"
  region = "eu-west-3"
}

# Monitoring Peering
module "eu-west-3-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.eu-west-3.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.eu-west-3.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.32/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.eu-west-3"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_eu-west-3" {
  provider    = aws.eu-west-3
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.eu-west-3.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_eu-west-3" {
  provider    = aws.eu-west-3
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.eu-west-3.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_eu-west-3" {
  provider    = aws.eu-west-3
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.eu-west-3.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_eu-west-3" {
  provider    = aws.eu-west-3
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.eu-west-3.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_eu-west-3" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.eu-west-3.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_eu-west-3.id,
    aws_security_group.egress_eu-west-3.id,
    aws_security_group.discovery_eu-west-3.id,
    aws_security_group.internal_eu-west-3.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.eu-west-3
  }
}

# Ethereum
resource "aws_security_group" "eth_eu-west-3" {
  provider    = aws.eu-west-3
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.eu-west-3.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ eu-west-3 end ################


################ eu-west-2 begin ################

# Provider
provider "aws" {
  alias  = "eu-west-2"
  region = "eu-west-2"
}

# Monitoring Peering
module "eu-west-2-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.eu-west-2.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.eu-west-2.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.48/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.eu-west-2"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_eu-west-2" {
  provider    = aws.eu-west-2
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.eu-west-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_eu-west-2" {
  provider    = aws.eu-west-2
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.eu-west-2.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_eu-west-2" {
  provider    = aws.eu-west-2
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.eu-west-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_eu-west-2" {
  provider    = aws.eu-west-2
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.eu-west-2.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_eu-west-2" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.eu-west-2.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_eu-west-2.id,
    aws_security_group.egress_eu-west-2.id,
    aws_security_group.discovery_eu-west-2.id,
    aws_security_group.internal_eu-west-2.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.eu-west-2
  }
}

# Ethereum
resource "aws_security_group" "eth_eu-west-2" {
  provider    = aws.eu-west-2
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.eu-west-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ eu-west-2 end ################


################ eu-west-1 begin ################

# Provider
provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

# Monitoring Peering
module "eu-west-1-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.eu-west-1.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.eu-west-1.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.64/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.eu-west-1"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_eu-west-1" {
  provider    = aws.eu-west-1
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.eu-west-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_eu-west-1" {
  provider    = aws.eu-west-1
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.eu-west-1.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_eu-west-1" {
  provider    = aws.eu-west-1
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.eu-west-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_eu-west-1" {
  provider    = aws.eu-west-1
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.eu-west-1.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_eu-west-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.eu-west-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_eu-west-1.id,
    aws_security_group.egress_eu-west-1.id,
    aws_security_group.discovery_eu-west-1.id,
    aws_security_group.internal_eu-west-1.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.eu-west-1
  }
}

# Ethereum
resource "aws_security_group" "eth_eu-west-1" {
  provider    = aws.eu-west-1
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.eu-west-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ eu-west-1 end ################


################ ap-northeast-2 begin ################

# Provider
provider "aws" {
  alias  = "ap-northeast-2"
  region = "ap-northeast-2"
}

# Monitoring Peering
module "ap-northeast-2-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.ap-northeast-2.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.ap-northeast-2.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.80/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.ap-northeast-2"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_ap-northeast-2" {
  provider    = aws.ap-northeast-2
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.ap-northeast-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_ap-northeast-2" {
  provider    = aws.ap-northeast-2
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.ap-northeast-2.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_ap-northeast-2" {
  provider    = aws.ap-northeast-2
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.ap-northeast-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_ap-northeast-2" {
  provider    = aws.ap-northeast-2
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.ap-northeast-2.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_ap-northeast-2" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.ap-northeast-2.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_ap-northeast-2.id,
    aws_security_group.egress_ap-northeast-2.id,
    aws_security_group.discovery_ap-northeast-2.id,
    aws_security_group.internal_ap-northeast-2.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.ap-northeast-2
  }
}

# Ethereum
resource "aws_security_group" "eth_ap-northeast-2" {
  provider    = aws.ap-northeast-2
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.ap-northeast-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ ap-northeast-2 end ################


################ ap-northeast-1 begin ################

# Provider
provider "aws" {
  alias  = "ap-northeast-1"
  region = "ap-northeast-1"
}

# Monitoring Peering
module "ap-northeast-1-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.ap-northeast-1.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.ap-northeast-1.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.96/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.ap-northeast-1"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_ap-northeast-1" {
  provider    = aws.ap-northeast-1
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.ap-northeast-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_ap-northeast-1" {
  provider    = aws.ap-northeast-1
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.ap-northeast-1.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_ap-northeast-1" {
  provider    = aws.ap-northeast-1
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.ap-northeast-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_ap-northeast-1" {
  provider    = aws.ap-northeast-1
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.ap-northeast-1.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_ap-northeast-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.ap-northeast-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_ap-northeast-1.id,
    aws_security_group.egress_ap-northeast-1.id,
    aws_security_group.discovery_ap-northeast-1.id,
    aws_security_group.internal_ap-northeast-1.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.ap-northeast-1
  }
}

# Ethereum
resource "aws_security_group" "eth_ap-northeast-1" {
  provider    = aws.ap-northeast-1
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.ap-northeast-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ ap-northeast-1 end ################


################ sa-east-1 begin ################

# Provider
provider "aws" {
  alias  = "sa-east-1"
  region = "sa-east-1"
}

# Monitoring Peering
module "sa-east-1-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.sa-east-1.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.sa-east-1.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.112/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.sa-east-1"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_sa-east-1" {
  provider    = aws.sa-east-1
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.sa-east-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_sa-east-1" {
  provider    = aws.sa-east-1
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.sa-east-1.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_sa-east-1" {
  provider    = aws.sa-east-1
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.sa-east-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_sa-east-1" {
  provider    = aws.sa-east-1
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.sa-east-1.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_sa-east-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.sa-east-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_sa-east-1.id,
    aws_security_group.egress_sa-east-1.id,
    aws_security_group.discovery_sa-east-1.id,
    aws_security_group.internal_sa-east-1.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.sa-east-1
  }
}

# Ethereum
resource "aws_security_group" "eth_sa-east-1" {
  provider    = aws.sa-east-1
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.sa-east-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ sa-east-1 end ################


################ ca-central-1 begin ################

# Provider
provider "aws" {
  alias  = "ca-central-1"
  region = "ca-central-1"
}

# Monitoring Peering
module "ca-central-1-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.ca-central-1.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.ca-central-1.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.128/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.ca-central-1"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_ca-central-1" {
  provider    = aws.ca-central-1
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.ca-central-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_ca-central-1" {
  provider    = aws.ca-central-1
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.ca-central-1.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_ca-central-1" {
  provider    = aws.ca-central-1
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.ca-central-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_ca-central-1" {
  provider    = aws.ca-central-1
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.ca-central-1.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_ca-central-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.ca-central-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_ca-central-1.id,
    aws_security_group.egress_ca-central-1.id,
    aws_security_group.discovery_ca-central-1.id,
    aws_security_group.internal_ca-central-1.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.ca-central-1
  }
}

# Ethereum
resource "aws_security_group" "eth_ca-central-1" {
  provider    = aws.ca-central-1
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.ca-central-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ ca-central-1 end ################


################ ap-southeast-1 begin ################

# Provider
provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}

# Monitoring Peering
module "ap-southeast-1-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.ap-southeast-1.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.ap-southeast-1.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.144/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.ap-southeast-1"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_ap-southeast-1" {
  provider    = aws.ap-southeast-1
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.ap-southeast-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_ap-southeast-1" {
  provider    = aws.ap-southeast-1
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.ap-southeast-1.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_ap-southeast-1" {
  provider    = aws.ap-southeast-1
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.ap-southeast-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_ap-southeast-1" {
  provider    = aws.ap-southeast-1
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.ap-southeast-1.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_ap-southeast-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.ap-southeast-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_ap-southeast-1.id,
    aws_security_group.egress_ap-southeast-1.id,
    aws_security_group.discovery_ap-southeast-1.id,
    aws_security_group.internal_ap-southeast-1.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.ap-southeast-1
  }
}

# Ethereum
resource "aws_security_group" "eth_ap-southeast-1" {
  provider    = aws.ap-southeast-1
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.ap-southeast-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ ap-southeast-1 end ################


################ ap-southeast-2 begin ################

# Provider
provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}

# Monitoring Peering
module "ap-southeast-2-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.ap-southeast-2.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.ap-southeast-2.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.160/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.ap-southeast-2"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_ap-southeast-2" {
  provider    = aws.ap-southeast-2
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.ap-southeast-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_ap-southeast-2" {
  provider    = aws.ap-southeast-2
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.ap-southeast-2.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_ap-southeast-2" {
  provider    = aws.ap-southeast-2
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.ap-southeast-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_ap-southeast-2" {
  provider    = aws.ap-southeast-2
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.ap-southeast-2.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_ap-southeast-2" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.ap-southeast-2.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_ap-southeast-2.id,
    aws_security_group.egress_ap-southeast-2.id,
    aws_security_group.discovery_ap-southeast-2.id,
    aws_security_group.internal_ap-southeast-2.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.ap-southeast-2
  }
}

# Ethereum
resource "aws_security_group" "eth_ap-southeast-2" {
  provider    = aws.ap-southeast-2
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.ap-southeast-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ ap-southeast-2 end ################


################ eu-central-1 begin ################

# Provider
provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

# Monitoring Peering
module "eu-central-1-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.eu-central-1.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.eu-central-1.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.176/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.eu-central-1"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_eu-central-1" {
  provider    = aws.eu-central-1
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.eu-central-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_eu-central-1" {
  provider    = aws.eu-central-1
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.eu-central-1.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_eu-central-1" {
  provider    = aws.eu-central-1
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.eu-central-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_eu-central-1" {
  provider    = aws.eu-central-1
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.eu-central-1.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_eu-central-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.eu-central-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_eu-central-1.id,
    aws_security_group.egress_eu-central-1.id,
    aws_security_group.discovery_eu-central-1.id,
    aws_security_group.internal_eu-central-1.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.eu-central-1
  }
}

# Ethereum
resource "aws_security_group" "eth_eu-central-1" {
  provider    = aws.eu-central-1
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.eu-central-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ eu-central-1 end ################


################ us-east-1 begin ################

# Provider
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# Monitoring Peering
module "us-east-1-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.us-east-1.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.us-east-1.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.192/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.us-east-1"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_us-east-1" {
  provider    = aws.us-east-1
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.us-east-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_us-east-1" {
  provider    = aws.us-east-1
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.us-east-1.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_us-east-1" {
  provider    = aws.us-east-1
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.us-east-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_us-east-1" {
  provider    = aws.us-east-1
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.us-east-1.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_us-east-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.us-east-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_us-east-1.id,
    aws_security_group.egress_us-east-1.id,
    aws_security_group.discovery_us-east-1.id,
    aws_security_group.internal_us-east-1.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.us-east-1
  }
}

# Ethereum
resource "aws_security_group" "eth_us-east-1" {
  provider    = aws.us-east-1
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.us-east-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ us-east-1 end ################


################ us-east-2 begin ################

# Provider
provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

# Monitoring Peering
module "us-east-2-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.us-east-2.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.us-east-2.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.208/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.us-east-2"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_us-east-2" {
  provider    = aws.us-east-2
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.us-east-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_us-east-2" {
  provider    = aws.us-east-2
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.us-east-2.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_us-east-2" {
  provider    = aws.us-east-2
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.us-east-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_us-east-2" {
  provider    = aws.us-east-2
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.us-east-2.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_us-east-2" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.us-east-2.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_us-east-2.id,
    aws_security_group.egress_us-east-2.id,
    aws_security_group.discovery_us-east-2.id,
    aws_security_group.internal_us-east-2.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.us-east-2
  }
}

# Ethereum
resource "aws_security_group" "eth_us-east-2" {
  provider    = aws.us-east-2
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.us-east-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ us-east-2 end ################


################ us-west-1 begin ################

# Provider
provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

# Monitoring Peering
module "us-west-1-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.us-west-1.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.us-west-1.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.224/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.us-west-1"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_us-west-1" {
  provider    = aws.us-west-1
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.us-west-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_us-west-1" {
  provider    = aws.us-west-1
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.us-west-1.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_us-west-1" {
  provider    = aws.us-west-1
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.us-west-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_us-west-1" {
  provider    = aws.us-west-1
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.us-west-1.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_us-west-1" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.us-west-1.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_us-west-1.id,
    aws_security_group.egress_us-west-1.id,
    aws_security_group.discovery_us-west-1.id,
    aws_security_group.internal_us-west-1.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.us-west-1
  }
}

# Ethereum
resource "aws_security_group" "eth_us-west-1" {
  provider    = aws.us-west-1
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.us-west-1.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ us-west-1 end ################


################ us-west-2 begin ################

# Provider
provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

# Monitoring Peering
module "us-west-2-monitoring" {
  source = "../network/modules/peering_connection"
  project = local.project
  src_vpc_id = module.network.us-west-2.vpc.id
  dst_vpc_id = data.aws_subnet.monitoring.vpc_id
  src_route_table_id = module.network.us-west-2.route_table.id
  dst_route_table_id = data.aws_route_table.monitoring.id
  src_cidr = "192.168.32.240/28"
  dst_cidr = data.aws_subnet.monitoring.cidr_block

  providers = {
    aws.src = "aws.us-west-2"
    aws.dst = "aws.us-east-2"
  }
}

# SSH
resource "aws_security_group" "ssh_us-west-2" {
  provider    = aws.us-west-2
  name_prefix = "ssh-"
  description = "SSH access"
  vpc_id      = module.network.us-west-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

# Egress
resource "aws_security_group" "egress_us-west-2" {
  provider    = aws.us-west-2
  name_prefix = "egress-"
  description = "Egress traffic"
  vpc_id      = module.network.us-west-2.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Discovery
resource "aws_security_group" "discovery_us-west-2" {
  provider    = aws.us-west-2
  name_prefix = "discovery-"
  description = "Discovery beacon access"
  vpc_id      = module.network.us-west-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8002
    to_port     = 8002
    protocol    = "udp"
  }

  tags = {
    project = local.project
  }
}

# Internal
resource "aws_security_group" "internal_us-west-2" {
  provider    = aws.us-west-2
  name_prefix = "internal-"
  description = "Internal traffic"
  vpc_id      = module.network.us-west-2.vpc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    project = local.project
  }
}

# Relay
module "relay_us-west-2" {
  source             = "../relay-alpha-1"
  project            = local.project
  subnet_id          = module.network.us-west-2.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_us-west-2.id,
    aws_security_group.egress_us-west-2.id,
    aws_security_group.discovery_us-west-2.id,
    aws_security_group.internal_us-west-2.id
  ]
  iam_instance_profile = aws_iam_instance_profile.relay.name

  providers = {
    aws = aws.us-west-2
  }
}

# Ethereum
resource "aws_security_group" "eth_us-west-2" {
  provider    = aws.us-west-2
  name_prefix = "eth-"
  description = "Ethereum traffic"
  vpc_id      = module.network.us-west-2.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
  }

  tags = {
    project = local.project
  }
}

################ us-west-2 end ################


# Beacon
module "beacon" {
  source             = "../beacon-alpha-1"
  project            = local.project
  subnet_id          = module.network.us-east-2.subnet.id
  key_name           = "ltcdemo"
  security_group_ids = [
    aws_security_group.ssh_us-east-2.id,
    aws_security_group.egress_us-east-2.id,
    aws_security_group.discovery_us-east-2.id
  ]

  providers = {
    aws = aws.us-east-2
  }
}
