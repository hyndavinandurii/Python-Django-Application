resource "aws_ecs_task_definition" "django_task" {
  family                   = "django-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  # Define the CPU and memory at the task level
  cpu                      = "256"  # Minimum 256 CPU units (0.25 vCPU)
  memory                   = "512"  # Minimum 512 MiB of memory

  container_definitions    = jsonencode([{
    name      = "django-container"
    image     = "${aws_ecr_repository.django_app.repository_url}:latest"
    cpu       = 256  # CPU units allocated to the container
    memory    = 512  # Memory allocated to the container (in MiB)
    essential = true
    portMappings = [
      {
        containerPort = 8000
        hostPort      = 8000
        protocol      = "tcp"
      }
    ]
  }])
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
