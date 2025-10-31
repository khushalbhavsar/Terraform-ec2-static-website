// variables.tf
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "static-website" // e.g., "static-website"
}

// AWS Region
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

// VPC CIDR Block
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

// Subnet CIDR Block
variable "subnet_cidr" {
  description = "CIDR block for subnet"
  type        = string
  default     = "10.0.1.0/24"
}

// Availability Zone
variable "availability_zone" {
  description = "Availability zone for subnet"
  type        = string
  default     = "us-east-1a"
}

// EC2 Instance Type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

// AMI ID for EC2 Instance
variable "ami_id" {
  description = "AMI ID for EC2 instance (Amazon Linux 2)"
  type        = string
  default     = "ami-0bdd88bd06d16ba03" # Amazon Linux 2 AMI (update this for your region)
}

// SSH Public Key
variable "ssh_public_key" {
  description = "SSH public key content (OpenSSH format). Provide the key text, not a file path."
  type        = string
  # Example value: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ... user@host"
  # Leave empty and provide via -var or terraform.tfvars if you prefer.
  default     = ""
}
