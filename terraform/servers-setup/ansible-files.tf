variable "ssh_key_path" {
  description = "Absolute path to the SSH private key used to access EC2 instances"
  type        = string
  default     = "/home/ahmed/.ssh/deployer-one"
}

locals {
  ansible_inventory_path = "${path.module}/../../ansible/inventory/hosts.generated.ini"
}

resource "local_file" "ansible_inventory" {
  filename = local.ansible_inventory_path
  content = templatefile("${path.module}/templates/hosts.generated.ini.tpl", {
    bastion_public_ip  = aws_instance.bastion.public_ip
    jenkins_public_ip  = aws_instance.jenkins.public_ip
    ansible_private_ip = aws_instance.ansible.private_ip
    ssh_key_path       = var.ssh_key_path
  })
}
