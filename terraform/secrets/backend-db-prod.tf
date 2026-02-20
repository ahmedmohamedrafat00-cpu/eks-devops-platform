resource "aws_secretsmanager_secret" "backend_db_prod" {
  name = "prod/app/backend/db"

  tags = {
    env     = "prod"
    app     = "backend"
    managed = "terraform"
  }
}

resource "aws_secretsmanager_secret_version" "backend_db_prod" {
  secret_id = aws_secretsmanager_secret.backend_db_prod.id

  secret_string = jsonencode({
    SPRING_DATASOURCE_URL      = "jdbc:postgresql://postgres:5432/app"
    SPRING_DATASOURCE_USERNAME = "app_user"
    SPRING_DATASOURCE_PASSWORD = "admin"
  })
}
