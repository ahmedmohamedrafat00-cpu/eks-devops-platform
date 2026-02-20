data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}

data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "../eks/terraform.tfstate"
  }
}

data "terraform_remote_state" "iam" {
  backend = "local"
  config = {
    path = "../iam/terraform.tfstate"
  }
}
