# Terraform EC2 Static Website Project

This project deploys a static website on an AWS EC2 instance using Terraform. It includes a complete infrastructure setup with VPC, security groups, and automated web server configuration.

## 📋 Project Structure

```
terraform-ec2-static-website/
├── main.tf          # Main infrastructure configuration
├── variables.tf     # Variable definitions
├── outputs.tf       # Output values
├── provider.tf      # Provider configuration
├── index.html       # Website content
└── styles.css       # Website styling
```

## 🚀 Features

- **Complete VPC Setup**: Custom VPC with public subnet and internet gateway
- **Security Configuration**: Security group with HTTP, HTTPS, and SSH access
- **Elastic IP**: Static public IP address for the instance
- **Automated Deployment**: User data script automatically installs and configures Apache
- **Static Website**: Beautiful responsive HTML/CSS website
- **Infrastructure as Code**: All infrastructure defined in Terraform

## 📦 Prerequisites

Before you begin, ensure you have:

1. **Terraform** installed (version >= 1.0)
2. **AWS Account** with appropriate permissions
3. **AWS CLI** configured with credentials
4. **SSH Key Pair** for EC2 access

## 🔧 Configuration

### 1. Generate SSH Key Pair (if you don't have one)

```bash
# On Linux/Mac
ssh-keygen -t rsa -b 4096 -f ~/.ssh/terraform-key

# On Windows (PowerShell)
ssh-keygen -t rsa -b 4096 -f $env:USERPROFILE\.ssh\terraform-key
```

### 2. Update Variables

Edit `variables.tf` or create a `terraform.tfvars` file:

```hcl
project_name    = "my-static-website"
aws_region      = "us-east-1"
instance_type   = "t2.micro"
ssh_public_key  = "ssh-rsa AAAAB3NzaC1yc2E... your-public-key"
```

### 3. Update AMI ID

Find the latest Amazon Linux 2 AMI for your region:

```bash
aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" \
  --query "Images | sort_by(@, &CreationDate) | [-1].ImageId" \
  --output text
```

Update the `ami_id` variable with the output.

## 🚀 Deployment Steps

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Validate Configuration

```bash
terraform validate
```

### 3. Plan Deployment

```bash
terraform plan
```

### 4. Apply Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm.

### 5. Get Outputs

```bash
terraform output
```

You'll see:
- VPC ID
- Subnet ID
- Security Group ID
- Instance ID
- Public IP
- Website URL
- SSH connection command

## 🌐 Access Your Website

After successful deployment, access your website at:

```
http://<instance-public-ip>
```

The public IP will be shown in the Terraform outputs as `website_url`.

## 🔐 SSH Access

Connect to your EC2 instance:

```bash
# Linux/Mac
ssh -i ~/.ssh/terraform-key ec2-user@<instance-public-ip>

# Windows (PowerShell)
ssh -i $env:USERPROFILE\.ssh\terraform-key ec2-user@<instance-public-ip>
```

## 📝 Customization

### Update Website Content

1. Edit `index.html` and `styles.css`
2. Run `terraform apply` to update the instance

### Change Instance Type

Update `instance_type` in `variables.tf` or `terraform.tfvars`:

```hcl
instance_type = "t2.small"  # or t3.micro, t3.small, etc.
```

### Modify Security Group Rules

Edit the security group in `main.tf` to add/remove ports:

```hcl
ingress {
  description = "Custom Port"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted to confirm.

## 💰 Cost Estimation

Approximate AWS costs (us-east-1 region):

- **EC2 t2.micro**: ~$8.50/month (Free Tier eligible)
- **Elastic IP**: Free while attached to running instance
- **Data Transfer**: First 1GB free, then $0.09/GB

**Note**: Always check current AWS pricing and monitor your usage.

## 🐛 Troubleshooting

### Website Not Accessible

1. Check security group rules allow HTTP (port 80)
2. Verify instance is running: `aws ec2 describe-instances`
3. Check Apache service: SSH into instance and run `sudo systemctl status httpd`

### SSH Connection Failed

1. Verify security group allows SSH (port 22) from your IP
2. Ensure correct key pair is being used
3. Check key permissions: `chmod 400 ~/.ssh/terraform-key` (Linux/Mac)

### Terraform Errors

1. Ensure AWS credentials are configured: `aws configure`
2. Check IAM permissions include EC2, VPC, and related services
3. Verify AMI ID is valid for your region

## 📚 Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Apache HTTP Server Documentation](https://httpd.apache.org/docs/)

## 📄 License

This project is open source and available for learning purposes.

## 🤝 Contributing

Feel free to fork, modify, and use this project for your learning journey!

---

**Happy Learning! 🚀**
