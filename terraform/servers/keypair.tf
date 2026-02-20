resource "aws_key_pair" "eks_devops" {
  key_name   = var.key_name
  public_key = file(pathexpand(var.public_key_path))

  tags = {
    Project = var.project_name
    Name    = var.key_name
  }
}
