resource "aws_ecs_service" "django_service" {
  name            = "django-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.django_task.arn
  desired_count   = 1
  launch_type     = "EC2"
  load_balancer {
    target_group_arn = aws_lb_target_group.django_target_group.arn
    container_name   = "django-container"
    container_port   = 8000
  }

  depends_on = [aws_lb_listener.http]
}
