provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "prod" {
  identifier           = "prod-mysql-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  //not nice to hard code the password
  //we can automatically generate password
  username = "administrator"
  password = data.aws_secretsmanager_secret_version.rds_password.secret_string
}

//Generate a random password
resource "random_password" "main" {
  length           = 20
  special          = true
  override_special = "!()"
}

//store another way
resource "aws_secretsmanager_secret" "rds_password" {
  name                    = "/prod/rds/password"
  description             = "Password for my RDS DB"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = random_password.main.result
}

//store all rds parameters
resource "aws_secretsmanager_secret" "rds" {
  name                    = "/prod/rds/all"
  description             = "All deets RDS DB"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    rds_address  = aws_db_instance.prod.address
    rds_port     = aws_db_instance.prod.port
    rds_username = aws_db_instance.prod.username
    rds_password = random_password.main.result
  })
}

//retrive password

data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id  = aws_secretsmanager_secret.rds_password.id
  depends_on = [aws_secretsmanager_secret_version.rds_password]
}

//retrive all
data "aws_secretsmanager_secret_version" "rds" {
  secret_id  = aws_secretsmanager_secret.rds.id
  depends_on = [aws_secretsmanager_secret_version.rds]
}

output "rds_address" {
  sensitive = true
  value     = aws_db_instance.prod.address
}

output "rds_port" {
  sensitive = true
  value     = aws_db_instance.prod.port
}

output "rds_username" {
  sensitive = true
  value     = aws_db_instance.prod.username
}

output "rds_password" {
  sensitive = true
  value     = random_password.main.result
}

output "rds_all" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)
  sensitive = true
}
