# terraform/keypair.tf
# INFRA-2

resource "aws_key_pair" "user_key" {
  key_name   = local.key_name
  public_key = file(var.ssh_public_key)
}
# The key pair resource creates an AWS key pair using the provided public key.