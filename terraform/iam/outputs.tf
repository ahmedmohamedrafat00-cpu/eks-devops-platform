output "ansible_role_name" {
  value = aws_iam_role.ansible_role.name
}

output "ansible_instance_profile_name" {
  value = aws_iam_instance_profile.ansible_profile.name
}

output "jenkins_role_name" {
  value = aws_iam_role.jenkins_role.name
}

output "jenkins_instance_profile_name" {
  value = aws_iam_instance_profile.jenkins_profile.name
}

output "ansible_role_arn" {
  value = aws_iam_role.ansible_role.arn
}

output "jenkins_role_arn" {
  value = aws_iam_role.jenkins_role.arn
}

output "bastion_role_arn" {
  value = aws_iam_role.bastion_role.arn
}
