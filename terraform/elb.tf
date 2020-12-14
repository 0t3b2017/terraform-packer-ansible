## Create Security Group for ELB
resource "aws_security_group" "lab_sg_elb" {
  name = "terraform-sg-elb"
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Create the ELB
resource "aws_elb" "lab_elb" {
  name = format("lab-elb-%03d", count.index + 1)
  count = var.az_count
  security_groups = [aws_security_group.lab_sg_elb.id]
  availability_zones = [data.aws_availability_zones.available.names[count.index]]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = "80"
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}
