variable "aws_region" {
  description = "AWS region where the EC2 instance will be created"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "Name assigned to the EC2 instance"
  type        = string
  default     = "terraform-ec2-server"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the AWS EC2 SSH key pair"
  type        = string
  default     = "terraform-ec2-key"
}

variable "ssh_public_key" {
  description = "SSH public key used to access the EC2 instance"
  type        = string
  sensitive   = true
}

variable "ssh_source_address" {
  description = "Public IPv4 address or CIDR allowed to connect over SSH"
  type        = string

  validation {
    condition     = var.ssh_source_address != "0.0.0.0/0"
    error_message = "SSH access must not be open to the entire internet."
  }
}

variable "root_volume_size" {
  description = "Size of the EC2 root disk in GB"
  type        = number
  default     = 8
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "development"
}