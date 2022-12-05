module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = var.ambiente
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
    cluster_settings = {
    "name": "containerInsights",
    "value": "enabled"
  }
  }
}

resource "aws_ecs_task_definition" "ECS-Task" {
  family                   = "ECS-Task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn = aws_iam_role.cargo.arn
  container_definitions    = jsonencode([
  {
    "name": var.ambiente
    "image": "168090453096.dkr.ecr.us-east-1.amazonaws.com/bootcampimpacta:v1"
    "cpu": 256
    "memory": 512
    "essential": true
    "portMappings" = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
  }
])
}

resource "aws_ecs_service" "ECS-Service" {
  name            = "ECS-Service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.ECS-Task.arn
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.alvo.arn
    container_name   = var.ambiente
    container_port   = 80
  }

  network_configuration {
    subnets = module.vpc.private_subnets
    security_groups = [aws_security_group.private.id]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight = 1
  }
}