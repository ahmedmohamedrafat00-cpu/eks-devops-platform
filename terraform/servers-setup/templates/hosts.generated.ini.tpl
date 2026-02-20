[bastion]
bastion-1 ansible_host=${bastion_public_ip} ansible_user=ec2-user

[jenkins]
jenkins-1 ansible_host=${jenkins_public_ip} ansible_user=ec2-user

[controllers]
ansible-1 ansible_host=${ansible_private_ip} ansible_user=ec2-user

[all:vars]
ansible_ssh_private_key_file=${ssh_key_path}
ansible_ssh_common_args=-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${ssh_key_path} -W %h:%p ec2-user@${bastion_public_ip}"
