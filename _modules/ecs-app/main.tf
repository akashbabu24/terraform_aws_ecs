data "template_file" "container_definitions" {
  template = file("${path.module}/_templates/container_definitions.json")
  
  vars = {
    container1_image 						= var.container1_image
	container1_name	 						= var.container1_name
	container1_host_port				    = var.container1_host_port
    container1_container_cpu                = var.container1_container_cpu
    container1_container_memory             = var.container1_container_memory
    container1_container_port               = var.container1_container_port
	container2_image 						= var.container2_image
	container2_name	 						= var.container2_name
    container2_memory_reservation 			= var.container2_memory_reservation
    container2_container_cpu                = var.container2_container_cpu
	container1_aws_logs_group				= var.aws_logs_group
  }
}

resource "aws_ecs_task_definition" "default" {
  family                   = var.fullNameEnv
  #container_definitions    = [module.container_definition_configs.json, module.container_definition_playout.json]
  container_definitions    = data.template_file.container_definitions.rendered
  requires_compatibilities = ["EC2"]
  network_mode             = var.network_mode
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.execution_role_arn
  tags                     = var.tags
}

# Service
## Security Groups
resource "aws_security_group" "ecs_service" {
  vpc_id      = var.vpc_id
  name        = var.fullNameEnv
  tags        = var.tags
  description = "Allow ALL egress from ECS service"
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_service.id
}

resource "aws_security_group_rule" "allow_tcp_ingress1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_service.id
}

resource "aws_security_group_rule" "allow_tcp_ingress2" {
  type              = "ingress"
  from_port         = 32767
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_service.id
}

resource "aws_security_group_rule" "alb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = var.container1_container_port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group_id
  security_group_id        = aws_security_group.ecs_service.id
}

resource "aws_ecs_service" "default" {
  # Must be the same as the task definition
  name                               = var.fullNameEnv
  task_definition                    = aws_ecs_task_definition.default.arn
  desired_count                      = var.desired_count
  #deployment_maximum_percent         = var.deployment_maximum_percent
  #deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  #health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  launch_type                        = var.launch_type
  cluster                            = var.ecs_cluster_arn
  #propagate_tags                     = var.propagate_tags
  # tags                               = var.tags
  #scheduling_strategy 				 = "REPLICA"
  
  dynamic "load_balancer" {
    for_each = var.ecs_load_balancers
    content {
      container_name = load_balancer.value.container_name
      container_port = load_balancer.value.container_port
      # elb_name         = lookup(load_balancer.value, "elb_name", null)
      target_group_arn = lookup(load_balancer.value, "target_group_arn", null)
    }
  }

  
  network_configuration {
    security_groups       = [aws_security_group.ecs_service.id] #CHANGE THIS
    subnets               = var.ecs_private_subnet_ids  ## Enter the private subnet id
    assign_public_ip      = var.assign_public_ip
  }
}