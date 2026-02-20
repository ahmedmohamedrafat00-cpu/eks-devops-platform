resource "aws_security_group" "eks_vpc_endpoint_sg" {
  name   = "eks-vpc-endpoint-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.network.outputs.ansible_security_group_id]
    description     = "HTTPS from Ansible SG"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-vpc-endpoint-sg"
  }
}

resource "aws_vpc_endpoint" "eks_api" {
  vpc_id              = data.terraform_remote_state.network.outputs.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.eks"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.terraform_remote_state.network.outputs.private_subnets
  security_group_ids  = [aws_security_group.eks_vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "eks-api-endpoint"
  }
}
