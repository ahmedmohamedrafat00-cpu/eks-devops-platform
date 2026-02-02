resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  key_name      = data.terraform_remote_state.servers.outputs.key_pair_name
  subnet_id     = data.terraform_remote_state.network.outputs.public_subnets[0]
  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]
  associate_public_ip_address = true
  tags                        = { Name = "bastion" }
}
resource "aws_instance" "ansible" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.medium"
  subnet_id     = data.terraform_remote_state.network.outputs.private_subnets[0]
  vpc_security_group_ids = [
    data.terraform_remote_state.network.outputs.ansible_security_group_id
  ]
  key_name = data.terraform_remote_state.servers.outputs.key_pair_name

  iam_instance_profile = data.terraform_remote_state.iam.outputs.ansible_instance_profile_name

  tags = { Name = "ansible-control" }
}
resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.medium"
  subnet_id     = data.terraform_remote_state.network.outputs.public_subnets[1]
  vpc_security_group_ids = [
    aws_security_group.jenkins_sg.id
  ]
  associate_public_ip_address = true
  key_name                    = data.terraform_remote_state.servers.outputs.key_pair_name

  iam_instance_profile = data.terraform_remote_state.iam.outputs.jenkins_instance_profile_name

  tags = { Name = "jenkins-server" }
}
