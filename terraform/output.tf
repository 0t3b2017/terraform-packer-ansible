output "elb_dns_names" {
  value = aws_elb.lab_elb.*.dns_name
}
