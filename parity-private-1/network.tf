# Project
locals {
  project = "parity_private_1"
}

# Network
module "network" {
  source  = "../network"
  project = local.project
}
