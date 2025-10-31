# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr // e.g., "10.0.0.0/16"
  enable_dns_hostnames = true // Enable DNS hostnames for instances in the VPC
  enable_dns_support   = true // Enable DNS support in the VPC

  tags = {
    Name = "${var.project_name}-vpc" // e.g., "static-website-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id // Attach to the main VPC

  tags = {
    Name = "${var.project_name}-igw" // e.g., "static-website-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id // Associate with the main VPC
  cidr_block              = var.subnet_cidr // e.g., "10.0.1.0/24"
  availability_zone       = var.availability_zone // e.g., "us-east-1a"
  map_public_ip_on_launch = true // Auto-assign public IPs to instances in this subnet

  tags = {
    Name = "${var.project_name}-public-subnet" // e.g., "static-website-public-subnet"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id // Associate with the main VPC

  route {
    cidr_block = "0.0.0.0/0" // Default route to the internet
    gateway_id = aws_internet_gateway.main.id // Attach to the internet gateway
  }

  tags = {
    Name = "${var.project_name}-public-rt" // e.g., "static-website-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id // Associate with the public subnet 
  route_table_id = aws_route_table.public.id // Associate with the public route table
}

# Security Group
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg" // e.g., "static-website-web-sg"
  description = "Security group for web server" // Description of the security group
  vpc_id      = aws_vpc.main.id // Associate with the main VPC 

  // Inbound Rules
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  // HTTPS Rule
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  // SSH Rule
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Outbound Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg" // e.g., "static-website-web-sg"
  }
}

# Key Pair
// Generate a new private/public keypair locally (in-memory) and register the public key with AWS
resource "tls_private_key" "web" {
  algorithm = "RSA" // Use RSA algorithm
  rsa_bits  = 4096 // Key size
}

resource "aws_key_pair" "web" {
  key_name   = "${var.project_name}-key"
  # Use the generated public key in OpenSSH format
  public_key = tls_private_key.web.public_key_openssh // Use the generated public key
}

# Sensitive output provides the private key PEM so you can save it locally.
# WARNING: this will expose the private key in state and outputs. Save it securely and then
# remove it from state or rotate the key if needed.
output "generated_private_key_pem" {
  description = "Private key (PEM) for the generated key pair - save this securely"
  value       = tls_private_key.web.private_key_pem
  sensitive   = true
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = var.ami_id // e.g., Amazon Linux 2 AMI ID
  instance_type          = var.instance_type // e.g., "t2.micro"
  key_name               = aws_key_pair.web.key_name // Use the created key pair
  vpc_security_group_ids = [aws_security_group.web.id] // Attach the web security group
  subnet_id              = aws_subnet.public.id // Use the public subnet

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              
              # Copy website files
              cat > /var/www/html/index.html <<'HTML'
              ${file("${path.module}/index.html")}
              HTML
              
              cat > /var/www/html/styles.css <<'CSS'
              ${file("${path.module}/styles.css")}
              CSS
              
              sudo systemctl restart httpd
              EOF

  tags = {
    Name = "${var.project_name}-web-server" // e.g., "static-website-web-server"
  }
}

# Elastic IP
resource "aws_eip" "web" {
  instance = aws_instance.web.id // Associate with the web EC2 instance
  domain   = "vpc" // Use VPC domain 

  tags = {
    Name = "${var.project_name}-eip" // e.g., "static-website-eip"
  }
}
