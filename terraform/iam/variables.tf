variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "enable_irsa" {
  description = "Create IRSA roles (requires EKS cluster + OIDC provider to exist)"
  type        = bool
  default     = false
}
