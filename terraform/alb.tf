resource "aws_lb" "alb" {
  name               = "web-server-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_server_sg.id]
  subnets            = [var.subnets_id]

  enable_deletion_protection = false

  tags = {
    Name = "web-server-alb"
  }
}

resource "aws_lb_target_group" "tg" {
  name        = "web-server-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id


  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "web-server-tg"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

## Typically, this should be configured to 443 and forward internally to 80, but that would require that a certificate also be created to support this

resource "aws_lb_target_group_attachment" "web_server" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web_server.id
  port             = 80
}
