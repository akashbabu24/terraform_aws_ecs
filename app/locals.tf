locals {

repository_credentials = {
    "credentialsParameter" : var.repository_token_arn
  }

app_name = "sample-app"

#environment = "dev"

log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = var.region
      "awslogs-group"         = aws_cloudwatch_log_group.app.name
      "awslogs-stream-prefix" = local.fullNameEnv
    }
    secretOptions = null
  }

  business_unit     = ""
  #cost_center       = "2000"
  fullName          = "${local.app_name}"
  fullNameEnv       = "${local.app_name}-${var.environment}"
  cloudwatch_prefix = local.fullNameEnv

  dev = {
    # 2 Render containers per instance with room for 1 edge-delta container, and a tiny bit for the host
      hostedZone = ""
  }

  # -------------- AWS Configuration --------------
  # ------------------------------------------
  # -------------- ASG SETTINGS --------------
  availability_zones    = ["us-west-2a", "us-west-2b", "us-west-2c"]
  instance_type         = "m5.xlarge"
  instance_ssh_key_name = ""

  #   Amazon ECS-optimized Amazon Linux 2 AMI
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
  # https://us-west-2.console.aws.amazon.com/systems-manager/parameters/%252Faws%252Fservice%252Fecs%252Foptimized-ami%252Famazon-linux-2%252Frecommended%252Fimage_id/description?region=us-west-2#
  ecs_aws_ami = "ami-0683e2d253e41f366"

  # Instance size - not service size
  # We are aiming for 2 tasks per instance (see task_max size)
  max_size         = 2
  min_size         = 2
  desired_capacity = 2

  # -------------- ALB SETTINGS --------------
  //domain_name                      = var.environment == "PROD" ? local.currentPerf.hostedZone : lower("${var.environment}.${local.currentPerf.hostedZone}")
  domain_name						 = "*.example.com"
  ip_type                          = "ipv4"
  https_ingress_cidr_blocks        = ["0.0.0.0/0"]
  https_enabled                    = "false"
  health_check_interval            = 300
  health_check_unhealthy_threshold = 4
  health_check_path                = "/entitlement/health"
  // This keeps the connection with our ALB alive longer than our ALB
  // We have a keep alive that is greater than our ALB keep alive, that way our node process never shuts down requests to the ALB
  // https://sigopt.com/blog/the-case-of-the-mysterious-aws-elb-504-errors/
  // https://adamcrowder.net/posts/node-express-api-and-aws-alb-502/
  idle_timeout = 120

  alb_dns_endpoint = "sadawsvpc"

  # -------------- ECS SETTINGS --------------
  # This is the primary ECS task
  # How many ECS-tasks do we want at idle-state?
  task_desired_count   = 2
  task_min_size        = 2
  task_max_size        = 2
  min_container_memory = 5120

  # Important: Set the memory/cpu consumption for the ECS-task
  # We are currently sized to 2 containers per EC2 instance
  container1_image = var.container1_image
  container1_name		  = ""
  container1_host_port	  = 8080
  container1_container_port = 8080
  container1_container_cpu        = 10
    container1_container_memory   = 1028  
  
  container2_image 			= var.container2_image
  container2_name  		  	= ""
  container2_memory_reservation 	= 10
  container2_container_cpu			= 0
  

  ordered_placement_strategy = [
    {
      field = "attribute:ecs.availability-zone"
      type  = "spread"
    },
    {
      field = "instanceId"
      type  = "spread"
    },
  ]

  env_variables = [
    
    {
      name  = "ENVIRONMENT"
      value = "${var.environment}"
    },

  ]

  # EC2 ASG autoscaling rules
  ecs_instance_scaling_properties = [
    {
      type               = "CPUUtilization"
      direction          = "up"
      evaluation_periods = 2
      observation        = "180"
      statistic          = "Average"
      threshold          = "50"
      cooldown           = "180"
      adjustment_type    = "PercentChangeInCapacity"
      scaleType          = "GreaterThanOrEqualToThreshold"
      scaling_adjustment = "20"
      }, {
      type               = "CPUUtilization"
      direction          = "up"
      evaluation_periods = 1
      observation        = "60"
      statistic          = "Average"
      threshold          = "70"
      cooldown           = "60"
      adjustment_type    = "PercentChangeInCapacity"
      scaleType          = "GreaterThanOrEqualToThreshold"
      scaling_adjustment = "60"
    },
    {
      type               = "MemoryUtilization"
      direction          = "up"
      evaluation_periods = 2
      observation        = "300"
      statistic          = "Average"
      threshold          = "65"
      cooldown           = "300"
      adjustment_type    = "PercentChangeInCapacity"
      scaleType          = "GreaterThanOrEqualToThreshold"
      scaling_adjustment = "20"
    },
    {
      type               = "MemoryUtilization"
      direction          = "up"
      evaluation_periods = 2
      observation        = "180"
      statistic          = "Average"
      threshold          = "80"
      cooldown           = "300"
      adjustment_type    = "PercentChangeInCapacity"
      scaleType          = "GreaterThanOrEqualToThreshold"
      scaling_adjustment = "50"
      }, {
      type               = "CPUUtilization"
      direction          = "down"
      evaluation_periods = 4
      observation        = "600"
      statistic          = "Average"
      threshold          = "30"
      cooldown           = "300"
      adjustment_type    = "PercentChangeInCapacity"
      scaleType          = "LessThanThreshold"
      scaling_adjustment = "-10"
    }
  ]

}