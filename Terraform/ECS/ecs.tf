resource "aws_ecs_cluster" "this" {
  name = "aws_ecs_cluster_${local.tag-name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

}

resource "aws_ecs_task_definition" "task_definition_api" {
  family                   = "task-definition-${local.tag-name}"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = null
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs.fargate_cpu
  memory                   = var.ecs.fargate_memory

  container_definitions = jsonencode([{
    name  = "${local.tag-name}"
    image = "484907529967.dkr.ecr.us-east-1.amazonaws.com/api-pessoas:latest"

    logConfiguration = {
      logDriver = "awslogs",
      Options = {
        "awslogs-group"         = "/ecs/kxc",
        "awslogs-region"        = "us-east-1",
        "awslogs-stream-prefix" = "ecs"
      }

    }
    portMappings = [{
      containerPort = var.ecs.app_port
      hostPort      = var.ecs.app_port
    }]

  }])

}

resource "aws_ecs_service" "ecs_services" {
  name                              = local.tag-name
  cluster                           = aws_ecs_cluster.this.id
  task_definition                   = aws_ecs_task_definition.task_definition_api.arn
  desired_count                     = var.ecs.app_count
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 30

  network_configuration {
    subnets          = local.subnets.private.id
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false

  }
  load_balancer {
    target_group_arn = aws_alb_target_group.this.id
    container_name   = local.tag-name
    container_port   = var.ecs.app_port 
  }
  depends_on = [
    aws_alb_listener.http
  ]
}