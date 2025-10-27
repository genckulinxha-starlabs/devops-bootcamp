packer {
  required_plugins {
    amazon = {
      version = " >= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Variables
variable "aws_region" {
  type        = string
  default     = "eu-north-1"
  description = "AWS region for building the AMI"
}

variable "ami_owner" {
  type        = string
  default     = "Shefqet" 
  description = "Owner tag for the AMI"
}

# Source (Amazon Linux 2023 - recommended for longer support)

source "amazon-ebs" "docker_ami" {
  ami_name        = "docker-ready-ami-{{timestamp}}"
  # ami_name = "docker-ready-ami-{{isotime | clean_ami_name}}"
  ami_description = "Amazon Linux 2023 with Docker pre-installed"
  instance_type   = "t3.micro"
  region          = var.aws_region

  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["amazon"]
    most_recent = true
  }

  ssh_username = "ec2-user"

  tags = {
    Name  = "docker-ready-ami"
    Owner = var.ami_owner
  }
}

# Build & Provisioning

build {
  name    = "docker-ami"
  sources = ["source.amazon-ebs.docker_ami"]

  provisioner "shell" {
    inline = [
      "set -e", // Exit immediately on any command failure
      "sudo dnf update -y",
      "sudo dnf install -y docker", 
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo usermod -aG docker ec2-user",
      "docker --version || echo 'Docker installation failed'"
    ]
  }

   post-processor "manifest" {
    output = "packer-manifest.json"
  }
}