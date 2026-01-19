output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "jenkins_sg_id" {
  value = aws_security_group.jenkins_sg.id
}

output "ansible_sg_id" {
  value = aws_security_group.ansible_sg.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "ansible_private_ip" {
  value = aws_instance.ansible.private_ip
}
