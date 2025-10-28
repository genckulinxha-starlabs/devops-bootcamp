resource "aws_instance" "ec2_instance" {
  ami           = local.ami_id           # Use the ami_id defined in terraform.tfvars
  instance_type = var.instance_type
  #subnet_id     = aws_subnet.public_subnet.id  
  vpc_security_group_ids = [aws_security_group.allow_access.id]
  key_name      = local.key_name         # Use the key_name defined in terraform.tfvars
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name # Use the instance profile defined in iam.tf


  # Use 'user_data' to ensure Docker starts automatically on EC2 boot
  user_data = <<-EOF
    #!/bin/bash
    # Start Docker service on boot
    sudo systemctl enable docker
    sudo systemctl start docker

    # Run a Docker container (Nginx in this case)
    sudo docker run -d -p 80:80 --name webserver nginx
  EOF
  #OR
  # user_data = file("../scripts/install_docker.sh")  # Path to your bash script

  tags = var.tags
}

# Allocate an Elastic IP
resource "aws_eip" "elastic_ip" { 
  domain = "vpc"
  tags   = var.tags
}

# Associate the Elastic IP with the EC2 instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ec2_instance.id 
  allocation_id = aws_eip.elastic_ip.id
}

resource "null_resource" "after_eip_setup" {
  depends_on = [aws_eip_association.eip_assoc]

  triggers = {
    instance_id = aws_instance.ec2_instance.id
    eip         = aws_eip.elastic_ip.public_ip
  }

 # INFRA-14: Optional remote-exec provisioner (runs after launch)
  provisioner "remote-exec" {
    
    inline = [
      "echo '--- Provisioner started ---'",
      "sudo systemctl is-active docker || sudo systemctl start docker",
      "echo 'Docker is running: $(sudo systemctl is-active docker)'",
      "echo '--- Checking running containers ---'",
      "sudo docker ps -a || true",
      "echo '--- Provisioner finished ---'"

    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")  # Path to private key
      host        =aws_eip.elastic_ip.public_ip
      timeout = "4m"
    }
  }
}