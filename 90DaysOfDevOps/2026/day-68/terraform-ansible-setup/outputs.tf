output "vpc_id" {
  description = "virtual private cloud id"
  value       = aws_vpc.my-vpc.id
}
output "subnet_id" {
  description = "subnet id"
  value       = aws_subnet.my-subnet.id
}
output "instance_id" {
  description = "ec2 instance id"
  value       = {for name, instance in aws_instance.my-ec2 : name => {
    public_ip = instance.public_ip
    user = var.instance_type[name].user
  }
  }
}

output "security_group_id" {
  description = "security group id"
  value       = aws_security_group.sg.id
}