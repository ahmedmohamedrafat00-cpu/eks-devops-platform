variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-devops-cluster"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.34"
}
