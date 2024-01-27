output "user_arns" {
  value = values(aws_iam_user.user)[*].arn
}

output "prod_instance_id" {
  value = aws_instance.my_server["Prod"].id
}

output "prod_instance_ids_all" {
  value = values(aws_instance.my_server)[*].id
}

output "bastian_public_ip" {
  value = var.create_bastian == "YES" ? aws_instance.bastian_server["bastion"].public_ip : null
}