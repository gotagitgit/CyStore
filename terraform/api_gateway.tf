resource "aws_api_gateway_rest_api" "main" {
  name = "${var.prefix}-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_lb" "nlb" {
  name               = "${var.prefix}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = aws_subnet.private[*].id

  tags = {
    Name = "${var.prefix}-nlb"
  }
}

resource "aws_lb_target_group" "nlb_alb" {
  name        = "${var.prefix}-nlb-alb-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
  target_type = "alb"
}

resource "aws_lb_target_group_attachment" "nlb_alb" {
  target_group_arn = aws_lb_target_group.nlb_alb.arn
  target_id        = aws_lb.alb.arn
  port             = 80
}

resource "aws_lb_listener" "nlb" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_alb.arn
  }
}

resource "aws_api_gateway_vpc_link" "main" {
  name        = "${var.prefix}-vpc-link"
  target_arns = [aws_lb.nlb.arn]
}

resource "aws_api_gateway_resource" "api" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_resource" "consumers" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "consumers"
}

resource "aws_api_gateway_resource" "products" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "products"
}

resource "aws_api_gateway_resource" "cart" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "cart"
}

resource "aws_api_gateway_method" "consumers_any" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.consumers.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "products_any" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.products.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "cart_any" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.cart.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "consumers" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.consumers.id
  http_method = aws_api_gateway_method.consumers_any.http_method

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.main.id
  uri                     = "http://${aws_lb.nlb.dns_name}/api/consumers"
}

resource "aws_api_gateway_integration" "products" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.products.id
  http_method = aws_api_gateway_method.products_any.http_method

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.main.id
  uri                     = "http://${aws_lb.nlb.dns_name}/api/products"
}

resource "aws_api_gateway_integration" "cart" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.cart.id
  http_method = aws_api_gateway_method.cart_any.http_method

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.main.id
  uri                     = "http://${aws_lb.nlb.dns_name}/api/cart"
}

resource "aws_api_gateway_deployment" "main" {
  depends_on = [
    aws_api_gateway_integration.consumers,
    aws_api_gateway_integration.products,
    aws_api_gateway_integration.cart,
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
}

resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = var.environment
}