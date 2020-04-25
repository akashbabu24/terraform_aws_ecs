module "ecs-app" {
  source = "../_modules/ecs-app"
  fullName        = local.fullName
  fullNameEnv     = local.fullNameEnv
  environment     = var.environment
  vpc_id          = module.network.vpc_id
  cluster_name    = aws_ecs_cluster.default.name
  ecs_cluster_arn = aws_ecs_cluster.default.arn
  asg_arn = module.ASG.ecs_asg_arn

  
  # Container info
  container1_image 			= local.container1_image
	container1_name	 			= local.container1_name
	container1_host_port				   = local.container1_host_port
    container1_container_cpu                = local.container1_container_cpu
    container1_container_memory             = local.container1_container_memory
    container1_container_port               = local.container1_container_port
  container2_image 			= local.container2_image
	container2_name	 			= local.container2_name
    container2_memory_reservation 			= local.container2_memory_reservation
    container2_container_cpu                = local.container2_container_cpu

  //min_capacity                = local.task_min_size
  //max_capacity                = local.task_max_size
  //ecs_container_scaling_rules = local.ecs_container_scaling_rules
  desired_count               = local.task_desired_count
  scheduling_strategy         = "REPLICA"
  deployment_maximum_percent  = "200"

  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 120
  ordered_placement_strategy         = local.ordered_placement_strategy

  ecs_load_balancers         = local.load_balancers
  alb_security_group_id      = module.alb.security_group_id
  deployment_controller_type = "ECS"
  network_mode               = "awsvpc"
  assign_public_ip           = "false"
  launch_type                = "EC2"
  aws_logs_region            = var.region
  env_variables              = local.env_variables
  
  //port_mappings = [
    //{
      //"containerPort" = local.container_port
      //"hostPort"      = local.container_port
      //"protocol"      = "tcp"
    //}
  //]
  # TODO: ECS autoscaling configuration needs to be done
  //autoscaling_scale_up_adjustment   = "2"
  //scale_up_cooldown                 = "60"
  //autoscaling_scale_down_adjustment = "-1"
  //autoscaling_scale_down_cooldown   = "300"
  //repository_credentials            = local.repository_credentials

  # TODO: make the security groups work
  //ecs_security_group_ids = [module.alb.security_group_id]
  ecs_private_subnet_ids = module.network.private_subnet_ids

  # Use cloudwatch for now
  //log_configuration = local.log_configuration
  aws_logs_group = aws_cloudwatch_log_group.app.name
  
  #execution_role_arn = aws_iam_role.ec2_assume_role.arn
  #task_role_arn 	 = aws_iam_role.ec2_assume_role.arn
  execution_role_arn = aws_iam_role.ecs-service-role.arn
  task_role_arn = aws_iam_role.ecs-service-role.arn

  #depends_on              = ["module.alb"]
}
