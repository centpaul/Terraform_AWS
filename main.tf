terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# --------------------------------------------------
# AWS Provider
# --------------------------------------------------

provider "aws" {
  region = var.aws_region
}

# --------------------------------------------------
# Find Latest Ubuntu AMI
# --------------------------------------------------

data "aws_ami" "ubuntu_server" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# --------------------------------------------------
# SSH Key Pair
# --------------------------------------------------
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.key_name
  public_key = var.ssh_public_key


  tags = {
    Name        = var.key_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# --------------------------------------------------
# EC2 Security Group
# --------------------------------------------------

resource "aws_security_group" "ec2_security_group" {
  name        = "${var.instance_name}-sg"
  description = "Security group for the EC2 application server"

  ingress {
    description = "Allow SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.ssh_source_address
    ]
  }

  egress {
    description = "Allow all outbound traffic"

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name        = "${var.instance_name}-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# --------------------------------------------------
# EC2 Instance
# --------------------------------------------------

resource "aws_instance" "application_server" {
  ami           = data.aws_ami.ubuntu_server.id
  instance_type = var.instance_type

  key_name = aws_key_pair.ec2_key_pair.key_name

  vpc_security_group_ids = [
    aws_security_group.ec2_security_group.id
  ]

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"

    encrypted = true
  }

  tags = {
    Name        = var.instance_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}