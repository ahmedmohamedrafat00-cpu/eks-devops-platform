resource "aws_ecr_repository" "app_backend" {
  name = "app-backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
}

