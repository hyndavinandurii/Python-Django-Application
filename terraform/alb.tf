resource "aws_lb" "django_alb" {
  name               = "django-Alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs.id]
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]  # Reference specific subnets

  enable_deletion_protection = false
  idle_timeout              = 4000
  enable_http2              = true
}

# create target group
resource "aws_lb_target_group" "django_target_group" {
  name     = "django-target-group"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance"  # Correct for EC2 launch type

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}



resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.django_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.django_target_group.arn
  }
}
