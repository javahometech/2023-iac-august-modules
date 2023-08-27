output "security_group_id" {
  value = aws_security_group.web.id
}

output "instance_ids" {
  value = aws_instance.main.*.id
}
