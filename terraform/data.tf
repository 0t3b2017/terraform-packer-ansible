data "aws_availability_zones" "available" {}

data "aws_ami" "packer_image" {
  most_recent = true

  filter {
    name = "name"
    values = ["lab-packer-automation*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["315433485717"] # My AWS Account
}
