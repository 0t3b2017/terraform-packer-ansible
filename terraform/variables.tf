variable "az_count" {
  default = 2
}

variable "region" {
  description = "AWS region for hosting this project"
  default = "us-west-1"
}

variable "public_key_path" {
  description = "Path to the SSH Public Key to add to instances"
  default = "/home/jcruz/.ssh/aws_labs.pub"
}

variable "key_name" {
  description = "Key name for SSH into EC2"
  default = "aws_labs"
}

