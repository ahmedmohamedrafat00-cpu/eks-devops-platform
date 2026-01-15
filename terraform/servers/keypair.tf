resource "aws_key_pair" "eks_devops" {
  key_name   = "eks-devops-key"
  public_key = file("~/.ssh/eks-devops-key.pub")
}
