# PHASE 5 RESOURCES - ECS FOUNDATION

resource "aws_ecs_cluster" "main" {
  name = "${var.prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.prefix}-ecs-cluster"
  }
}

resource "aws_ecs_task_definition" "store_web" {
  family                   = "${var.prefix}-store-web"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name  = "store-web"
      image = var.docker_image_store_web
      portMappings = [
        {
          containerPort = 7000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "store-web"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "api_account" {
  family                   = "${var.prefix}-api-account"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name  = "api-account"
      image = var.docker_image_api_account
      portMappings = [
        {
          containerPort = 7080
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "api-account"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "api_inventory" {
  family                   = "${var.prefix}-api-inventory"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name  = "api-inventory"
      image = var.docker_image_api_inventory
      portMappings = [
        {
          containerPort = 7082
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "api-inventory"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "api_shopping" {
  family                   = "${var.prefix}-api-shopping"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name  = "api-shopping"
      image = var.docker_image_api_shopping
      portMappings = [
        {
          containerPort = 7084
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "api-shopping"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "store_web" {
  name            = "${var.prefix}-store-web"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.store_web.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = local.public_subnet_ids
    security_groups  = [aws_security_group.alb.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "store-web"
    container_port   = 7000
  }

  depends_on = [aws_lb_listener.web]
}

resource "aws_ecs_service" "api_account" {
  name            = "${var.prefix}-api-account"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api_account.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = length(local.private_subnet_ids) > 0 ? local.private_subnet_ids : [for subnet in aws_subnet.private : subnet.id]
    security_groups = [aws_security_group.ecs.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api_account.arn
    container_name   = "api-account"
    container_port   = 7080
  }

  depends_on = [aws_lb_listener.api_account]
}

resource "aws_ecs_service" "api_inventory" {
  name            = "${var.prefix}-api-inventory"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api_inventory.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = length(local.private_subnet_ids) > 0 ? local.private_subnet_ids : [for subnet in aws_subnet.private : subnet.id]
    security_groups = [aws_security_group.ecs.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api_inventory.arn
    container_name   = "api-inventory"
    container_port   = 7082
  }

  depends_on = [aws_lb_listener.api_inventory]
}

resource "aws_ecs_service" "api_shopping" {
  name            = "${var.prefix}-api-shopping"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api_shopping.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = length(local.private_subnet_ids) > 0 ? local.private_subnet_ids : [for subnet in aws_subnet.private : subnet.id]
    security_groups = [aws_security_group.ecs.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api_shopping.arn
    container_name   = "api-shopping"
    container_port   = 7084
  }

  depends_on = [aws_lb_listener.api_shopping]
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.prefix}"
  retention_in_days = 7
}