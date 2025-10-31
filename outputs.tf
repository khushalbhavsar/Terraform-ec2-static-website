// Outputs for the infrastructure components
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

// Outputs for subnet, security group, and instance details
output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

// Outputs for security group and instance details
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web.id
}

// Outputs for EC2 instance details
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

// Outputs for EC2 instance IP addresses and website URL
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.web.public_ip
}

// Outputs for EC2 instance private IP address
output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web.private_ip
}

// Output for website URL
output "website_url" {
  description = "URL of the static website"
  value       = "http://${aws_eip.web.public_ip}"
}

// Output for SSH connection command
output "ssh_connection" {
  description = "SSH connection command"
  value       = "ssh -i <your-key.pem> ec2-user@${aws_eip.web.public_ip}"
}
