# aws_instance.server1[2]: Creating...
# aws_instance.server1[3]: Creating...
# aws_instance.server1[1]: Creating...
# aws_instance.server1[0]: Creating...

output "instance_ids" {
  value = aws_instance.servers[*].id
}

output "instance_public_ips" {
  value = aws_instance.servers[*].public_ip
}

output "bastian_public_ip" {
  value = var.create_bastian == "YES" ? aws_instance.bastian_server[0].public_ip : null //if we don't do this then it will throw an error if bastian server doesn't exist
}
output "iam_users_arn" {
  value = aws_iam_user.user[*].arn
}
