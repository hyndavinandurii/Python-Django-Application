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
  network_mode             = "bridge"  # Use "bridge" for EC2 launch type
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}

resource "aws_autoscaling_group" "ecs_asg" {
  launch_configuration = aws_launch_configuration.ecs_lc.id
  min_size             = 1
  max_size             = 2
  vpc_zone_identifier  = aws_subnet.public.*.id

  tag {
    key                 = "Name"
    value               = "ECS Instance"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "ecs_lc" {
  name          = "ecs-launch-configuration"
  image_id      = "ami-0abcdef1234567890"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.django_cluster.name} >> /etc/ecs/ecs.config
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy_attachment" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceRole"
}
