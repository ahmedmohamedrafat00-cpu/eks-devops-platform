resource "aws_security_group" "ansible_sg" {
  name        = "ansible-sg"
  description = "Security group for Ansible control machine"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "EKS API access from within VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-sg"
  }
}
