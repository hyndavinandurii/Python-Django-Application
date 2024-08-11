resource "aws_ecs_task_definition" "django_task" {
  family                   = "django-task"
  container_definitions    = jsonencode([{
    name      = "django-container"
    image     = "${aws_ecr_repository.django_app.repository_url}:latest"
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [
      {
        containerPort = 8000
        hostPort      = 8000
        protocol      = "tcp"
      }
    ]
  }])
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = module.iam_roles.ecs_execution_role_arn
  task_role_arn            = module.iam_roles.ecs_task_role_arn
}
