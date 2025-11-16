# PHASE 6 RESOURCES - LOAD BALANCERS

resource "aws_lb" "alb" {
  name               = "${var.prefix}-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = local.public_subnet_ids

  tags = {
    Name = "${var.prefix}-nlb"
  }
}

resource "aws_lb_target_group" "web" {
  name        = "${var.prefix}-web-tg"
  port        = 7000
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    protocol            = "TCP"
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "api_account" {
  name        = "${var.prefix}-api-account-tg"
  port        = 7080
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.default.id
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
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.default.id
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
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    protocol            = "HTTP"
    path                = "/health"
    unhealthy_threshold = 2
  }
}

# NLB listeners for each service (no path-based routing)
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "7000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_listener" "api_account" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "7080"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_account.arn
  }
}

resource "aws_lb_listener" "api_inventory" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "7082"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_inventory.arn
  }
}

resource "aws_lb_listener" "api_shopping" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "7084"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_shopping.arn
  }
}