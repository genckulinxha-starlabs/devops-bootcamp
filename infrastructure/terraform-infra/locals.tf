
locals {
  #current_user = trimspace(chomp(shell("whoami"))), i can delete local and use just var.current_user after i added terraform.tfvars
  key_name     = "ssh-key-${var.current_user}"
}


data "local_file" "packer_manifest" {
  filename = "../packer/packer-manifest.json"
}

locals {
  packer_data = jsondecode(data.local_file.packer_manifest.content)
  ami_id      = split(":", local.packer_data.builds[0].artifact_id)[1]
}
