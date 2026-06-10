# === Read existing AWS resourcces (data sources) ===

# Use default VPC (auto-created by AWS in every region)
data "aws_vpc" "default" {
  default = true
}

# Get all subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Find latest Amazon Linux 2023 AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# === Create new resources ===

# Security group: allow HTTP from anywhere
resource "aws_security_group" "hello" {
  name        = "terraform-hello-sg"
  description = "Terraform Step 1 hello-world SG"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ALL outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-hello-sg"
  }
}

# EC2 instance with nginx via user_data
resource "aws_instance" "hello" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.hello.id]

  user_data = <<-USERDATA
      #!/bin/bash
      dnf install -y nginx
      systemctl enable --now nginx
      echo "<h1>Hello from Terraform Step 1</h1><p>Host: $(hostname)</p>" > /usr/share/nginx/html/index.html
    USERDATA

  tags = {
    Name = "terraform-hello-ec2"
  }
}

# === Outputs (visible after apply) ===

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.hello.id
}

output "instance_public_ip" {
  description = "EC2 public IP (open in browser)"
  value       = aws_instance.hello.public_ip
}

output "sg_id" {
  description = "Security Group ID"
  value       = aws_security_group.hello.id
}