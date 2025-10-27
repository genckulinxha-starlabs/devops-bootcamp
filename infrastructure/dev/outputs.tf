output "ec2_public_ip" {
    value = aws_eip_association.eip_assoc.public_ip
}

output "ssh_connection" {
  value = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_eip.elastic_ip.public_ip}"
}