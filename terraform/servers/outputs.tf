output "key_pair_name" {
  value = aws_key_pair.eks_devops.key_name
}

output "key_pair_fingerprint" {
  value = aws_key_pair.eks_devops.fingerprint
}
