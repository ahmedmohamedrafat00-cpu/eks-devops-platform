resource "aws_secretsmanager_secret" "backend_db_dev" {
  name = "dev/app/backend/db"

  tags = {
    env     = "dev"
    app     = "backend"
    managed = "terraform"
  }
}

#resource "aws_secretsmanager_secret_version" "backend_db_dev" {
  #secret_id = aws_secretsmanager_secret.backend_db_dev.id

  #secret_string = jsonencode({
    #SPRING_DATASOURCE_URL      = "jdbc:postgresql://postgres:5432/app"
    #SPRING_DATASOURCE_USERNAME = "admin"
    #SPRING_DATASOURCE_PASSWORD = "admin"
  #})
#}
