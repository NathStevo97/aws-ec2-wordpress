resource "aws_lb" "nginx-alb" {
  name                       = "${var.resource_name_prefix}-nginx-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = module.vpc.public_subnets
  security_groups            = [aws_security_group.default.id]
  enable_deletion_protection = false
  tags = {
    Name = "Nginx-alb"
  }
}

resource "aws_lb_target_group" "nginx-alb" {
  name     = "${var.resource_name_prefix}-nginx-alb"
  port     = 80
  protocol = "HTTP"
  stickiness {
    type = "lb_cookie"
  }
  vpc_id = module.vpc.vpc_id
}


resource "aws_lb_listener" "nginx-alb" {
  load_balancer_arn = aws_lb.nginx-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-alb.arn
  }
}
