#resource "aws_security_group" "eks_vpc_endpoint_sg" {
 # name   = "eks-vpc-endpoint-sg"
  #vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  #ingress {
   # from_port       = 443
    #to_port         = 443
    #protocol        = "tcp"
    #security_groups = [
      #data.terraform_remote_state.network.outputs.ansible_security_group_id
    #]
  #}
#}

#resource "aws_vpc_endpoint" "eks_api" {
  #vpc_id              = data.terraform_remote_state.network.outputs.vpc_id
  #service_name        = "com.amazonaws.us-east-1.eks"
  #vpc_endpoint_type   = "Interface"
  #subnet_ids          = data.terraform_remote_state.network.outputs.private_subnets
  #security_group_ids  = [aws_security_group.eks_vpc_endpoint_sg.id]
  #private_dns_enabled = true
#}
