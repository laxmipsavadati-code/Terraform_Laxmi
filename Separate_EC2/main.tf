terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

# Find the latest Ubuntu 24.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Flask EC2 Instance
resource "aws_instance" "flask" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id = aws_subnet.public_1.id

  vpc_security_group_ids = [
    aws_security_group.flask_sg.id
  ]

  user_data = file("${path.module}/user_data_flask.sh")

  user_data_replace_on_change = true

  tags = {
    Name = "${var.project_name}-Flask-EC2"
  }
}

# Express EC2 Instance
resource "aws_instance" "express" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id = aws_subnet.public_2.id

  vpc_security_group_ids = [
    aws_security_group.express_sg.id
  ]

  user_data = file("${path.module}/user_data_express.sh")

  user_data_replace_on_change = true

  tags = {
    Name = "${var.project_name}-Express-EC2"
  }
}
