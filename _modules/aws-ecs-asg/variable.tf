variable "ecs_logging" {
  default     = "[\"json-file\",\"awslogs\"]"
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
}

variable "cluster_name" {
  description = "The exact name of the ECS Cluster"
}

variable "environment" {
  description = "The name of the environment"
}

variable "custom_userdata" {
  type        = string
  default     = ""
  description = "Inject extra command in the instance template to be run on boot"
}

variable "cloudwatch_prefix" {
  default     = ""
  description = "Gecs_loggingives cloudwatch logs a prefix (see user-data)"
}

variable "ami" {
  default     = ""
  description = "The ECS-optimized AMI to launch with each ec2 instances"
}

variable "instance_type" {
  default     = "m5.large"
  description = "Name of the AWS instance type"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Comma separated list of security group ids"
  default     = []
}

variable "iam_instance_profile_name" {
  description = "The IAM Instance Profile (e.g. right side of Name=AmazonECSContainerInstanceRole)"
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
  default     = ""
}

variable "detailed_monitoring" {
  type    = bool
  default = true
}

variable "associate_public_ip_address" {
  description = "Should we auto-add new IPs"
  default     = false
}

variable "availability_zones" {
  description = "Comma separated list of EC2 availability zones to launch instances, must be within region"
}

variable "subnet_ids" {
	type        = list(string)
  description = "Comma separated list of subnet ids, must match the availability zones"
}

variable "min_size" {
  default     = "1"
  description = "Minimum number of instances to run in the group"
}

variable "max_size" {
  default     = "5"
  description = "Maximum number of instances to run in the group"
}

variable "desired_capacity" {
  default     = "1"
  description = "Desired number of instances to run in the group"
}

variable "health_check_grace_period" {
  default     = "300"
  description = "Time after instance comes into service before checking health"
}

variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances"
  type        = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}
