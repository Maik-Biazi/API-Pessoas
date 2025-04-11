resource "aws_alb" "this" {
  name            = "alb-${local.tag-name}"
  subnets         = local.subnets.public.id
  security_groups = [aws_security_group.sgalb.id]

}

resource "aws_alb_target_group" "this" {
  vpc_id      = local.vpc.id
  name        = "alb-target-${local.tag-name}"
  port        = var.ecs.app_port  
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    unhealthy_threshold = "2"
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.this.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.id
  }


}