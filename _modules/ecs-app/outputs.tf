output "service_name" {
  value = aws_ecs_service.default.name
}

output "security_group" {
  value = aws_security_group.ecs_service.id
}
