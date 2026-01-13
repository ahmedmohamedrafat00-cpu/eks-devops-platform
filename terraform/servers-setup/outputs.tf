output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "ansible_private_ip" {
  description = "Private IP of Ansible control machine"
  value       = aws_instance.ansible.private_ip
}
