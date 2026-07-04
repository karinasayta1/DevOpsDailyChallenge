
##################################
# VPC ID
##################################

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

##################################
# Public Subnet ID
##################################

output "subnet_id" {
  description = "ID of the Public Subnet"
  value       = aws_subnet.public.id
}

##################################
# EC2 Instance ID
##################################

output "instance_id" {
  description = "ID of the EC2 Instance"
  value       = aws_instance.main.id
}

##################################
# EC2 Public IP
##################################

output "instance_public_ip" {
  description = "Public IP of the EC2 Instance"
  value       = aws_instance.main.public_ip
}

##################################
# EC2 Public DNS
##################################

output "instance_public_dns" {
  description = "Public DNS of the EC2 Instance"
  value       = aws_instance.main.public_dns
}

##################################
# Security Group ID
##################################

output "security_group_id" {
  description = "ID of the Security Group"
  value       = aws_security_group.main.id
}