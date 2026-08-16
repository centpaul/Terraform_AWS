output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.application_server.id
}

output "instance_name" {
  description = "Name of the EC2 instance"
  value       = aws_instance.application_server.tags["Name"]
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.application_server.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.application_server.private_ip
}

output "public_dns" {
  description = "Public DNS hostname of the EC2 instance"
  value       = aws_instance.application_server.public_dns
}

output "ubuntu_ami_id" {
  description = "Ubuntu AMI selected by Terraform"
  value       = data.aws_ami.ubuntu_server.id
}

output "ssh_command" {
  description = "Command used to connect to the EC2 instance"
  value       = "ssh ubuntu@${aws_instance.application_server.public_ip}"
}