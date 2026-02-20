output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "jenkins_sg_id" {
  value = aws_security_group.jenkins_sg.id
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

output "ansible_sg_id" {
  value = data.terraform_remote_state.network.outputs.ansible_security_group_id
}

output "controller_private_ip" {
  value = aws_instance.ansible.private_ip
}

output "ssh_bastion" {
  value = "ssh -i ~/.ssh/deployer-one ec2-user@${aws_instance.bastion.public_ip}"
}

output "ssh_jenkins" {
  value = "ssh -i ~/.ssh/deployer-one ec2-user@${aws_instance.jenkins.public_ip}"
}

output "ssh_ansible_via_bastion" {
  value = "ssh -tt -i ~/.ssh/deployer-one -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand=\"ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/deployer-one -W %h:%p ec2-user@${aws_instance.bastion.public_ip}\" ec2-user@${aws_instance.ansible.private_ip}"
}

# One-command tunnel to open Jenkins UI locally:
# Then open: http://localhost:8080
output "ssh_jenkins_ui_tunnel" {
  value = "ssh -N -i ~/.ssh/deployer-one -L 8080:localhost:8080 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand=\"ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/deployer-one -W %h:%p ec2-user@${aws_instance.bastion.public_ip}\" ec2-user@${aws_instance.jenkins.public_ip}"
}

output "jenkins_ui_url" {
  value = "http://localhost:8080"
}
