resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "jenkins_sg" {
  name   = "jenkins-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
  description     = "Allow EKS API access from Ansible"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  security_groups = [
    data.terraform_remote_state.network.outputs.ansible_security_group_id
  ]
}

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
