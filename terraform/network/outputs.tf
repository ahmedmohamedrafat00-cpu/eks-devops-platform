output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "ansible_security_group_id" {
  description = "Security group ID for Ansible control machine"
  value       = aws_security_group.ansible_sg.id
}
