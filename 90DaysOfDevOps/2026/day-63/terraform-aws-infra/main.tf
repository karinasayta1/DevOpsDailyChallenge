##################################
# VPC
##################################

resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-vpc"
  }

}

##################################
# Public Subnet
##################################

resource "aws_subnet" "public" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }

}

##################################
# Internet Gateway
##################################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }

}

##################################
# Route Table
##################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }

}

##################################
# Route Table Association
##################################

resource "aws_route_table_association" "public" {

  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id

}

##################################
# Security Group
##################################

resource "aws_security_group" "main" {

  name        = "${var.project_name}-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "${var.project_name}-sg"
  }

}

##################################
# EC2 Instance
##################################

resource "aws_instance" "main" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.main.id
  ]

  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-server"
  }

  lifecycle {
    create_before_destroy = true
  }

}

##################################
# S3 Bucket
##################################

resource "aws_s3_bucket" "logs" {

  bucket = "${var.project_name}-${var.environment}-logs"

  depends_on = [
    aws_instance.main
  ]

}