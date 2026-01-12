variable "private_subnets" {
  type = list(string)
  default = [
    "subnet-aaaa1111",
    "subnet-bbbb2222"
  ]
}
variable "cluster_name" {
  type    = string
  default = "eks-devops-cluster"
}

