variable "name" {
  type        = string
  description = "Name of the application/service"
}

variable "name_env" {
  type        = string
  description = "Name of the application/service with Env"
}

variable "environment" {
  type        = string
  description = "environment (e.g. `prod`, `dev`, `staging`)"
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to associate with ALB"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to associate with ALB"
  default = [""]
}

variable "ip_type" {
  type        = string
  default     = "ipv4"
  description = " `ipv4` or `dualstack`."
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "A list of additional security group IDs to allow access to ALB"
}

variable "internal" {
  type        = bool
  default     = false
  description = "A boolean flag to determine whether the ALB should be internal or external"
}

variable "http_port" {
  type        = number
  default     = 80
  description = "The port for the HTTP listener"
}

variable "http_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable HTTP listener"
}

variable "http_to_https_redirect" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable HTTP to HTTPS Redirect"
}

variable "http_ingress_cidr" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDR blocks to allow in HTTP security group"
}

variable "cert_arn" {
  type        = string
  default     = ""
  description = "The ARN of the SSL certificate for the HTTPS listener"
}

variable "https_port" {
  type        = number
  default     = 443
  description = "The port for the HTTPS listener"
}

variable "https_enabled" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable HTTPS listener"
}

variable "https_ingress_cidr" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDR blocks to allow in HTTPS security group"
}

variable "https_ssl_policy" {
  type        = string
  description = "The name of the SSL Policy for the listener"
  default     = ""
}

variable "http2_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable HTTP/2"
}

variable "idle_timeout" {
  type        = number
  default     = 30
  description = "The time in seconds that the connection is allowed to be idle"
}

variable "deregistration_delay" {
  type        = number
  default     = 60
  description = "The amount of time to wait in seconds before changing the state of a deregistering target to unused"
}

variable "health_check_path" {
  type        = string
  default     = "/"
  description = "The destination for the health check request"
}

variable "health_check_timeout" {
  type        = number
  default     = 50
  description = "AMount of time to wait before failing a health check request"
}

variable "health_check_healthy_threshold" {
  type        = number
  default     = 5
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "health_check_unhealthy_threshold" {
  type        = number
  default     = 5
  description = "The number of consecutive health check failures required before considering the target unhealthy"
}

variable "health_check_interval" {
  type        = number
  default     = 100
  description = "The duration in seconds in between health checks"
}

variable "health_check_matcher" {
  type        = string
  default     = "200-299"
  description = "The HTTP response codes to indicate a healthy check"
}

variable "target_group_port" {
  type        = number
  default     = 80
  description = "The port for the default target group"
}

variable "target_group_protocol" {
  type        = string
  default     = "HTTP"
  description = "The protocol to be used for the default target group."
}

variable "paths" {
  type        = list(string)
  default     = []
  description = "The comma-separated values for path-patterns for listener rules"
}
