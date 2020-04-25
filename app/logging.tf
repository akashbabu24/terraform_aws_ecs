resource "aws_cloudwatch_log_group" "app" {
  name = "${local.fullNameEnv}-logs"
  retention_in_days = 30
}
