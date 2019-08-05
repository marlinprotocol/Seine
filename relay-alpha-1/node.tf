# Inputs
variable "project" {
  type        = string
  description = "Project name"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group ids to add"
  default     = []
}

variable "subnet_id" {
  type        = string
  description = "Subnet id where instance should be provisioned"
}

# Outputs
output "instance" {
  value = aws_instance.relay
}

# AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# IAM role
resource "aws_iam_role" "relay" {
  name = "${var.project}_relay"

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
  name = "${var.project}_relay"
  role = "${aws_iam_role.relay.name}"
}

# Instance
resource "aws_instance" "relay" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t3.micro"
  key_name = "${var.key_name}"
  vpc_security_group_ids = var.security_group_ids
  subnet_id = "${var.subnet_id}"
  iam_instance_profile = "${aws_iam_instance_profile.relay.name}"

  tags = {
    project = "${var.project}"
    role = "relay"
  }

  volume_tags = {
    project = "${var.project}"
    role = "relay"
  }
}
