#variable "private_subnets" {
# type = list(string)
#default = [
# "subnet-aaaa1111",
#"subnet-bbbb2222"
#]
#}
#variable "cluster_name" {
# type    = string
#default = "eks-devops-cluster"
#}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-devops-cluster"
}

variable "kubernetes_version" {
  type    = string
  default = "1.30"
}

