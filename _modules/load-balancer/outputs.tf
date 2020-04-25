output "alb_id" {
  description = "The ALB ID"
  value       = "${aws_lb.newson-alb.id}"
}

output "alb_name" {
  description = "The ALB Name"
  value       = "${aws_lb.newson-alb.name}"
}

output "alb_arn" {
  description = "The ALB ARN"
  value       = "${aws_lb.newson-alb.arn}"
}

output "alb_arn_suffix" {
  description = "The ALB ARN-suffix"
  value       = "${aws_lb.newson-alb.arn_suffix}"
}

output "alb_dns_name" {
  description = "ALB DNS-name"
  value       = "${aws_lb.newson-alb.dns_name}"
}

output "alb_zone_id" {
  description = "The ID of the ALB-Zone"
  value       = "${aws_lb.newson-alb.zone_id}"
}

output "security_group_id" {
  description = "The security group ID of the ALB"
  value       = "${aws_security_group.alb_sec_group.id}"
}

output "target_group_arn" {
  description = "The newson-alb target group ARN"
  value       = "${aws_lb_target_group.newson-alb-tg.arn}"
}

output "target_group_id" {
  description = "The newson-alb target group ID"
  value       = "${aws_lb_target_group.newson-alb-tg.id}"
}

output "http_listener_arn_80" {
  description = "The ARN of the HTTP listener"
  value       = join("", aws_lb_listener.http_80.*.arn)
}

output "http_listener_arn_8080" {
  description = "The ARN of the HTTP listener"
  value       = join("", aws_lb_listener.http_8080.*.arn)
}

output "https_listener_arn" {
  description = "The ARN of the HTTPS listener"
  value       = join("", aws_lb_listener.https.*.arn)
}

output "listener_arns" {
  description = "A list of all the listener ARNs"
  value = compact(
    concat(aws_lb_listener.http_80.*.arn, aws_lb_listener.http_8080.*.arn, aws_lb_listener.https.*.arn)
  )
}
