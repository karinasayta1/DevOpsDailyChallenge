variable "region" {
  description = "Region to create resources"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "vpc cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "subnet cidr block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Type of ec2 instance"
  type        = map(object({
    ami = string
    user = string
    os_family = string
    i_type = string
  }))
  default     = {
    "control node" = {
        ami = "ami-05d2d839d4f73aafb" #ubuntu 24 LTS
        user = "ubuntu"
        os_family = "ubuntu"
        i_type = "t3.micro"
    }
    "web server" = {
        ami = "ami-05d2d839d4f73aafb" #ubuntu 24 LTS
        user = "ubuntu"
        os_family = "ubuntu"
        i_type = "t3.micro"
    }
    "app server" = {
        ami = "ami-05d2d839d4f73aafb" #ubuntu 24 LTS
        user = "ubuntu"
        os_family = "ubuntu"
        i_type = "t3.micro"
    }
    "db server" = {
        ami = "ami-05d2d839d4f73aafb" #ubuntu 24 LTS
        user = "ubuntu"
        os_family = "ubuntu"
        i_type = "t3.micro"
    }
  }
}

variable "project_name" {
  description = "project name"
  default = "Ansible Project"
  type        = string
}

variable "allowed_ports" {
  description = "Ports"
  type        = list(number)
  default     = [22, 80, 443, 81, 8080]
}
