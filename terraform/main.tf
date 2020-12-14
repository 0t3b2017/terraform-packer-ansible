# Define the provider to use
provider "aws" {
  profile = "default"
  region = var.region
}

# Define the backend for the tfstates
terraform {
  backend "s3" {
    bucket = "lab-tfstates-terraform2"
    key = "terraform.tfstate"
    region = "us-west-1"
  }
}
