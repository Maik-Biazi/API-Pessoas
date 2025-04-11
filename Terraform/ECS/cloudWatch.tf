resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${local.tag-name}"
  retention_in_days = var.log_retention_days
}