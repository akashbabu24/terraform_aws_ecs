variable "region" {
	default = "us-west-2"
}

variable "docker_image_path" {
  default     = "latest"
  description = "The docker image for the ECS task definition"
}

variable "environment" {
  type        = string
  description = "The name of the Environment"
  default     = "Dev"
}

variable "container1_image" {
  type        = string
  description = "The ECR image path of the main application i.e container1"
  default     = ""
}

variable "container2_image" {
  type        = string
  description = "The ECR image path of the secondary application i.e container2"
  default     = ""
}

