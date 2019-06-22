output "database_host" {
  value = module.database.database_host

  sensitive = true
}

output "database_name" {
  value = module.database.database_name

  sensitive = true
}

output "aws_ssm_parameter_database_username_arn" {
  value = module.database.aws_ssm_parameter_database_username_arn

  sensitive = true
}

output "aws_ssm_parameter_database_password_arn" {
  value = module.database.aws_ssm_parameter_database_password_arn

  sensitive = true
}
