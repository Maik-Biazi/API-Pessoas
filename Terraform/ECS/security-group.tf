resource "aws_security_group" "sgalb" {
  name   = "sg${local.tag-name}-alb"
  vpc_id = local.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "ecs_tasks" {
  name   = "sgtask${local.tag-name}"
  vpc_id = local.vpc.id
ingress {
  from_port       = var.ecs.app_port
  to_port         = var.ecs.app_port
  protocol        = "tcp"
  security_groups = [aws_security_group.sgalb.id]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}