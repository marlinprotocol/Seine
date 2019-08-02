# Inputs
variable "project" {
  type        = string
  description = "Project name"
}

# Instance
resource "aws_instance" "beacon" {
  ami                    = ""
  instance_type          = "t3.micro"
  key_name               = ""
  vpc_security_group_ids = ""
  subnet_id              = ""
  iam_instance_profile   = ""

  tags = {
    project = "${var.project}"
    role    = "beacon"
  }

  volume_tags = {
    project = "${var.project}"
    role    = "beacon"
  }
}
