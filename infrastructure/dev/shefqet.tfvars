aws_region     = "eu-north-1"
#ami_id         = "ami-0123456789abcdef0"  # Replace with Packer AMI ID, we have automated this in later modules
instance_type  = "t3.micro"
ssh_public_key = "/home/sheeffii/.ssh/id_rsa.pub"  # Path to SSH public key
#key_name       = "dev4-key"
current_user = "shefqet"

# Override default tags if needed and add Provisioner tag 
tags = {
  Name        = "dev4-infra"
  Owner       = "Shefqet"
  Environment = "dev"
  Provisioner = "Terraform"
}
