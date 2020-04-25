variable "container1_image" {
  type        = string
  description = "The image name of the second/assistant/associated application for deployment"
}

variable "container1_name" {
  type        = string
  description = "The image name of the second/assistant/associated application for deployment"
}

variable "container1_host_port" {
  type        = number
  description = "The image name of the second/assistant/associated application for deployment"
}

variable "container1_container_cpu" {
  type        = number
  description = "The image name of the second/assistant/associated application for deployment"
}

variable "container1_container_memory" {
  type        = number
  description = "The image name of the second/assistant/associated application for deployment"
}

variable "container1_container_port" {
  type        = number
  description = "The image name of the second/assistant/associated application for deployment"
}

variable "container2_image" {
  type        = string
  description = "The image name of the second/assistant/associated application for deployment"
}

variable "container2_name" {
  type        = string
  description = "The image name of the second/assistant/associated application for deployment"
}

variable "container2_memory_reservation" {
  type        = number
  description = "The image name of the second/assistant/associated application for deployment"
}

variable "container2_container_cpu" {
  type        = number
  description = "The image name of the second/assistant/associated application for deployment"
}

variable "cluster_name" {
  type        = string
  description = "The name of the ECS Cluster for the ecs-resources of this module"
}

variable "fullName" {
  type        = string
  description = "The name of the service-stack without the environment appended"
}

variable "fullNameEnv" {
  type        = string
  description = "The full Sinclair name with the environment: *ENVIRONMENT*_*NAMESPACE*_*APP*_*FUNCTION*"
}

variable "environment" {
  type        = string
  description = "The environment name"
  default     = ""
}

variable "repository_credentials" {
  type        = map(string)
  default     = null
}

variable "env_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Any environment variables to inject into the container"
}

variable "secrets" {
  type        = list(string)
  description = "The secrets for the task definition. This is a list of maps"
  default     = []
}

variable "port_mappings" {
  type = list(object({
    containerPort = number
    hostPort      = number
    protocol      = string

  }))
  description = "The port mappings to configure for the container. This is a list of maps. Each map should contain \"containerPort\", \"hostPort\", and \"protocol\", where \"protocol\" is one of \"tcp\" or \"udp\". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort"

  default = [
    {
      "containerPort" = 80
      "hostPort"      = 80
      "protocol"      = "tcp"
    }
  ]
}

variable "aws_logs_region" {
  type        = string
  description = "The region for the AWS Cloudwatch Logs group"
  default = ""
}

variable "aws_logs_group" {
  type        = string
  description = "The name for the AWS Cloudwatch Logs group"
  default = ""
}

# Task Definition
variable "launch_type" {
  type        = string
  description = "The ECS launch type (valid options: FARGATE or EC2)"
  default     = "EC2"
}

variable "network_mode" {
  type        = string
  description = "The network mode to use for the task. This is required to be `awsvpc` for `FARGATE` `launch_type`"
  default     = "bridge"
}

variable "asg_arn" {
  type        = string
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Map of key-value pairs to use for tags"
  default     = {}
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where resources are created"
}

variable "alb_security_group_id" {
  type        = string
  description = "Security group of the ALB"
}

variable "desired_count" {
  type        = string
  description = "The desired number of tasks to start with. Set this to 0 if using DAEMON Service type. (FARGATE does not suppoert DAEMON Service type)"
  default     = "1"
}

variable "deployment_maximum_percent" {
  type        = number
  description = "The upper limit of the number of tasks (as a percentage of `desired_count`) that can be running in a service during a deployment"
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  type        = number
  description = "The lower limit (as a percentage of `desired_count`) of the number of tasks that must remain running and healthy in a service during a deployment"
  default     = 100
}

variable "health_check_grace_period_seconds" {
  type        = number
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200. Only valid for services configured to use load balancers"
  default     = 0
}

variable "ecs_cluster_arn" {
  type        = string
  description = "The ECS Cluster ARN where ECS Service will be provisioned"
}

variable "propagate_tags" {
  type        = string
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION"
  default     = null
}

variable "scheduling_strategy" {
  type        = string
  description = "The scheduling strategy to use for the service. The valid values are REPLICA and DAEMON. Note that Fargate tasks do not support the DAEMON scheduling strategy."
  default     = "REPLICA"
}

variable "ordered_placement_strategy" {
  type = list(object({
    type  = string
    field = string
  }))
  description = "Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. The maximum number of ordered_placement_strategy blocks is 5. See `ordered_placement_strategy` docs https://www.terraform.io/docs/providers/aws/r/ecs_service.html#ordered_placement_strategy-1"
  default     = []
}

variable "service_placement_constraints" {
  type = list(object({
    type       = string
    expression = string
  }))
  description = "The rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10. See `placement_constraints` docs https://www.terraform.io/docs/providers/aws/r/ecs_service.html#placement_constraints-1"
  default     = []
}

variable "ecs_load_balancers" {
  type = list(object({
    container_name   = string
    container_port   = number
    elb_name         = string
    target_group_arn = string
  }))
  description = "A list of load balancer config objects for the ECS service; see `load_balancer` docs https://www.terraform.io/docs/providers/aws/r/ecs_service.html"
  default     = []
}

variable "deployment_controller_type" {
  type        = string
  description = "Type of deployment controller. Valid values are `CODE_DEPLOY` and `ECS`"
  default     = "ECS"
}

variable "ecs_security_group_ids" {
  type        = list(string)
  description = "Additional Security Group IDs to allow into ECS Service"
  default     = []
}

variable "ecs_private_subnet_ids" {
  type        = list(string)
  description = "List of Private Subnet IDs to provision ECS Service onto"
}

variable "assign_public_ip" {
  type        = bool
  description = "Assign a public IP address to the ENI (Fargate launch type only). Valid values are `true` or `false`. Default `false`"
  default     = false
}

variable "execution_role_arn" {
  type        = string
  description = "execution role arn"
  default     = ""
}
variable "task_role_arn" {
  type        = string
  description = "instance task_role_arn"
  default     = ""
}