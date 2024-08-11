# ECS Cluster Configuration
resource "aws_ecs_cluster" "main" {
  name = "django-cluster"
}
