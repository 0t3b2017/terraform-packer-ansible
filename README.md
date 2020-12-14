# terraform-packer-ansible
Lab using Packer / Ansible / Terraform

Use the bash script init.sh to start the project.

It will create a new AMI on AWS with nginx configured by Ansible. Then it will create an ASG with 2 ELB and validate if all ELB are responding ok through HTTP (status code 200)
