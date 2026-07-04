##################################
# Amazon Linux 2 AMI
##################################

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}
##################################
# Availability Zones
##################################

data "aws_availability_zones" "available" {

  state = "available"

}