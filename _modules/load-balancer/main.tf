locals {
  name = "${var.name}"
  name_env = "${var.name_env}"
}

resource "aws_security_group" "alb_sec_group" {
  description = "Security Group rules specific to ECS ALB."
  vpc_id      = "${var.vpc_id}"
  name        = "${local.name_env}-alb-sg"
  #tags        = "${var.tags}"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb_sec_group.id}"
}

resource "aws_security_group_rule" "http_ingress" {
  count             = "${var.http_enabled ? 1 : 0}"
  type              = "ingress"
  from_port         = "${var.http_port}"
  to_port           = "${var.http_port}"
  protocol          = "tcp"
  cidr_blocks       = "${var.http_ingress_cidr}"
  security_group_id = "${aws_security_group.alb_sec_group.id}"
}

resource "aws_security_group_rule" "https_ingress" {
  count             = "${var.https_enabled ? 1 : 0}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "${var.https_port}"
  to_port           = "${var.https_port}"
  cidr_blocks       = "${var.https_ingress_cidr}"
  security_group_id = "${aws_security_group.alb_sec_group.id}"
}

resource "aws_security_group_rule" "http_8080_ingress" {
  count             = "${var.https_enabled ? 1 : 0}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "8080"
  to_port           = "8080"
  cidr_blocks       = "${var.https_ingress_cidr}"
  security_group_id = "${aws_security_group.alb_sec_group.id}"
}

resource "aws_lb" "newson-alb" {
  load_balancer_type               = "application"
  name                             = "${local.name_env}-alb"
  internal                         = "${var.internal}"
  idle_timeout                     = "${var.idle_timeout}"
  subnets                          = "${var.subnet_ids}"
  ip_address_type                  = "${var.ip_type}"
//security_groups				   = "${var.security_group_ids}"

  security_groups = compact(
    concat(var.security_group_ids, [aws_security_group.alb_sec_group.id]),
  )
}

//creating only one target group instead of 2 in the existing setup.

resource "aws_lb_target_group" "newson-alb-tg" {
  name                 = "${local.name_env}-alb-target"
  port                 = "${var.target_group_port}"
  protocol             = "${var.target_group_protocol}"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"
  target_type 		   = "ip"
  health_check{
	path = "/playout"
	interval = "300"
	healthy_threshold = "2"
	unhealthy_threshold = "5"
	matcher = "200-299"
  }

  lifecycle {
    create_before_destroy = true
  }
}

//for port 80
resource "aws_lb_listener" "http_80" {
  count             = "${var.http_enabled ? 1 : 0}"
  load_balancer_arn = "${aws_lb.newson-alb.arn}"
  port              = "${var.http_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.newson-alb-tg.arn}"
    type             = "forward"
  }
}

//for port 443
resource "aws_lb_listener" "https" {
  count             = "${var.https_enabled ? 1 : 0}"
  load_balancer_arn = "${aws_lb.newson-alb.arn}"

  port       = "${var.https_port}"
  protocol   = "HTTPS"
  ssl_policy = "${var.https_ssl_policy}"
  certificate_arn   = "${var.cert_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.newson-alb-tg.arn}"
    type             = "forward"
  }
}

//for port 8080
resource "aws_lb_listener" "http_8080" {
  count             = "${var.http_enabled ? 1 : 0}"
  load_balancer_arn = "${aws_lb.newson-alb.arn}"
  port              = 8080
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.newson-alb-tg.arn}"
    type             = "forward"
  }
}

//Listener rules for target group 1
resource "aws_lb_listener_rule" "TG_rules" {
  count = length(var.paths)
 // name  = "aws_lb_listener_rule_TG_${count.index}"
  
  action {
    target_group_arn = "${aws_lb_target_group.newson-alb-tg.arn}"
    type = "forward"
  }
  condition {
    field  = "path-pattern"
    values = [var.paths[count.index]]
	//values = var.paths
  }

  listener_arn = "${aws_lb_listener.https[0].arn}"
  priority = count.index + 1
}


//Listener rules for target group 2
//resource "aws_lb_listener_rule" "TG2_rules" {
//  count = length(var.paths2)
//  name  = "aws_lb_listener_rule_TG_2_${count.index}"
  
//  action {
//    target_group_arn = "${aws_lb_target_group.default.arn}"
//    type = "forward"
//  }
//  condition {
//    field  = "host-header"
//    values = var.paths2[count.index]
//  }
 // listener_arn = "${data.aws_alb_listener.default.arn}"
 // priority = count.index
//}