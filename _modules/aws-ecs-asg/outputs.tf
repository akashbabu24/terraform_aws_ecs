output "ecs_asg_id" {
  value = aws_autoscaling_group.ecs-cluster-asg2.id
}

output "ecs_asg_arn" {
  value = aws_autoscaling_group.ecs-cluster-asg2.arn
}

output "ecs_asg_name" {
  value = aws_autoscaling_group.ecs-cluster-asg2.name
}