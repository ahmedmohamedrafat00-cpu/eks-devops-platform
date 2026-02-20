variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for naming/tagging"
  type        = string
  default     = "eks-devops-platform"
}

variable "key_name" {
  description = "AWS Key Pair name"
  type        = string
  default     = "eks-devops-key"
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
  default     = "~/.ssh/eks-devops-key.pub"
}
