
variable "ecs" {
  description = "Configuration object for the ECS service, including CPU/memory allocations, app container port, desired count of tasks, Docker image URL, and health check path"
  type = object({
    fargate_cpu       = number
    fargate_memory    = number
    app_port          = number
    app_count         = number
    app_image         = string
    health_check_path = string
  })
  default = {
    fargate_cpu       = 256
    fargate_memory    = 512
    app_port          = 3000
    app_count         = 1
    app_image         = ""
    health_check_path = "/"
  }
}

variable "log_level" {
  description = "Defines the logging level for the application, affecting the verbosity of logs, e.g., 'info', 'debug'"
  type        = string
  default     = "info"
}

variable "log_retention_days" {
  description = "Specifies the duration in days that logs are retained in CloudWatch before being deleted, e.g., '5' days"
  type        = number
  default     = 5
}

variable "autoscaling" {
  description = "Autoscaling parameters for the ECS service, detailing minimum and maximum task counts, along with rules for autoscaling based on CPU, memory usage, and ALB request counts"
  type = object({
    min_capacity = number
    max_capacity = number
    memory_autoscaling = object({
      target             = number
      scale_in_cooldown  = number
      scale_out_cooldown = number
    })
    cpu_autoscaling = object({
      target             = number
      scale_in_cooldown  = number
      scale_out_cooldown = number
    })
    alb_autoscaling = object({
      target = number
    })
  })
  default = {
    min_capacity = 2
    max_capacity = 10
    memory_autoscaling = {
      target             = 60
      scale_in_cooldown  = 300
      scale_out_cooldown = 300
    }
    cpu_autoscaling = {
      target             = 40
      scale_in_cooldown  = 300
      scale_out_cooldown = 300
    }
    alb_autoscaling = {
      target = 1000
    }
  }
}