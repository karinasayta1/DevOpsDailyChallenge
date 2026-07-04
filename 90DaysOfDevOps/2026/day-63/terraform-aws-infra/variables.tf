
##########################################
# AWS Region
##########################################

variable "region" {
  description = "AWS Region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

##########################################
# VPC CIDR Block
##########################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

##########################################
# Public Subnet CIDR
##########################################

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

##########################################
# EC2 Instance Type
##########################################

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

##########################################
# Project Name
##########################################

variable "project_name" {
  description = "Project Name"

  type = string
}

##########################################
# Environment
##########################################

variable "environment" {
  description = "Deployment Environment"
  type        = string
  default     = "dev"
}

##########################################
# Allowed Ports
##########################################

variable "allowed_ports" {
  description = "List of allowed ports"

  type = list(number)

  default = [
    22,
    80,
    443
  ]
}

##########################################
# Extra Tags
##########################################

variable "extra_tags" {
  description = "Additional Tags"

  type = map(string)

  default = {}
}