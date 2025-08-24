resource "aws_lb" "alb" {
  name               = "${var.prefix}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.private[*].id

  tags = {
    Name = "${var.prefix}-alb"
  }
}

resource "aws_lb_target_group" "web" {
  name        = "${var.prefix}-web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    path                = "/health"
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "api_account" {
  name        = "${var.prefix}-api-account-tg"
  port        = 7080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    protocol            = "HTTP"
    path                = "/health"
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "api_inventory" {
  name        = "${var.prefix}-api-inventory-tg"
  port        = 7082
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    protocol            = "HTTP"
    path                = "/health"
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "api_shopping" {
  name        = "${var.prefix}-api-shopping-tg"
  port        = 7084
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    protocol            = "HTTP"
    path                = "/health"
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# resource "aws_lb_listener" "alb" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Not Found"
#       status_code  = "404"
#     }
#   }
# }

resource "aws_lb_listener_rule" "api_consumers" {
  listener_arn = aws_lb_listener.alb.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_account.arn
  }

  condition {
    path_pattern {
      values = ["/api/consumers*"]
    }
  }
}

resource "aws_lb_listener_rule" "api_products" {
  listener_arn = aws_lb_listener.alb.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_inventory.arn
  }

  condition {
    path_pattern {
      values = ["/api/products*"]
    }
  }
}

resource "aws_lb_listener_rule" "api_cart" {
  listener_arn = aws_lb_listener.alb.arn
  priority     = 300

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_shopping.arn
  }

  condition {
    path_pattern {
      values = ["/api/cart*"]
    }
  }
}