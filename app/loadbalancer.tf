data "aws_route53_zone" "external" {
  name = local.dev.hostedZone
}

data "aws_acm_certificate" "default" {
  domain      = local.domain_name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

module "alb" {
  source       = "../_modules/load-balancer"
  name         = local.fullName
  name_env     = local.fullNameEnv
  environment  = var.environment
  //tags         = module.aws_tags.tags
  vpc_id       = module.network.vpc_id
  subnet_ids   = module.network.public_subnet_ids
  idle_timeout = local.idle_timeout

  # TODO: make the security groups work
  # TODO: we don't ahve security groups
  # security_group_ids = ["${module.vpc.alb_security_group.id}"]
  //alb_logs_s3_region = us-west-2
  ip_type            = local.ip_type
  target_group_port  = local.container1_container_port

  # HTTPs Listener
  http_enabled           = true
  http_to_https_redirect = false
  https_enabled          = true
  https_ingress_cidr     = local.https_ingress_cidr_blocks
  https_port             = 443
  cert_arn               = data.aws_acm_certificate.default.arn

  # health check configuration
  #health_check_unhealthy_threshold = local.health_check_unhealthy_threshold
  #health_check_interval            = local.health_check_interval
  #health_check_path                = local.health_check_path

}

#Set the DNS entry for the ALB
resource "aws_route53_record" "alb_endpoint" {
  zone_id = data.aws_route53_zone.external.zone_id
  name    = local.alb_dns_endpoint
  type    = "A"
  # ttl     = "300"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = false
  }
}