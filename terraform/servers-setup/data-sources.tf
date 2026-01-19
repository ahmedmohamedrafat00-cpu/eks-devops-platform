# Remote state: fetch VPC outputs
data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "../network/terraform.tfstate"
  }
}

# Remote state: fetch IAM outputs
data "terraform_remote_state" "iam" {
  backend = "local"
  config = {
    path = "../iam/terraform.tfstate"
  }
}

# Your public IP
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

# Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "terraform_remote_state" "servers" {
  backend = "local"

  config = {
    path = "../servers/terraform.tfstate"
  }
}
