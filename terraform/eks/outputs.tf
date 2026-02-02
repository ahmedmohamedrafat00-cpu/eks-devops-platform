output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "nodegroup_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "nodegroup_name" {
  value = aws_eks_node_group.default.node_group_name
}

output "app_backend_ecr_url" {
  value = aws_ecr_repository.app_backend.repository_url
}
