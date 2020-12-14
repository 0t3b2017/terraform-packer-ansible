# Create security group for EC2
resource "aws_security_group" "lab_sg_instance" {
  name = "terraform-instance"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the key pair
resource "aws_key_pair" "lab_kp" {
  key_name = var.key_name
  public_key = file(var.public_key_path)
}

# Create the Launch Configuration
resource "aws_launch_configuration" "lab_lc" {
  image_id              = data.aws_ami.packer_image.id
  instance_type         = "t2.micro"
  security_groups       = [aws_security_group.lab_sg_instance.id]
  key_name              = aws_key_pair.lab_kp.key_name
  lifecycle {
    create_before_destroy = true
  }
}

## Create AutoScaling Group
resource "aws_autoscaling_group" "lab_asg" {
  launch_configuration = aws_launch_configuration.lab_lc.id
  availability_zones = data.aws_availability_zones.available.names
  min_size = 2
  max_size = 4
  load_balancers = aws_elb.lab_elb.*.name
  health_check_type = "ELB"
  tags = concat(
    [
      {
        key = "Name"
        value = "terraform-asg"
        propagate_at_launch = "true"
      }
    ]
  )
}
