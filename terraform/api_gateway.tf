# PHASE 9-10 RESOURCES - API GATEWAY WITH PATH ROUTING

resource "aws_api_gateway_rest_api" "main" {
  name = "${var.prefix}-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_vpc_link" "main" {
  name        = "${var.prefix}-vpc-link"
  target_arns = [aws_lb.alb.arn]
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

resource "aws_api_gateway_method" "consumers_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.consumers.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "products_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.products.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "cart_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.cart.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "consumers" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.consumers.id
  http_method = aws_api_gateway_method.consumers_proxy.http_method

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.main.id
  uri                     = "http://${aws_lb.alb.dns_name}:7080/api/consumers/{proxy}"
}

resource "aws_api_gateway_integration" "products" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.products.id
  http_method = aws_api_gateway_method.products_proxy.http_method

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.main.id
  uri                     = "http://${aws_lb.alb.dns_name}:7082/api/products/{proxy}"
}

resource "aws_api_gateway_integration" "cart" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.cart.id
  http_method = aws_api_gateway_method.cart_proxy.http_method

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.main.id
  uri                     = "http://${aws_lb.alb.dns_name}:7084/api/cart/{proxy}"
}

resource "aws_api_gateway_deployment" "main" {
  depends_on = [
    aws_api_gateway_integration.consumers,
    aws_api_gateway_integration.products,
    aws_api_gateway_integration.cart,
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = var.environment
  
  depends_on = [aws_api_gateway_vpc_link.main]
}

# resource "aws_api_gateway_resource" "api" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   parent_id   = aws_api_gateway_rest_api.main.root_resource_id
#   path_part   = "api"
# }

# resource "aws_api_gateway_resource" "consumers" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   parent_id   = aws_api_gateway_resource.api.id
#   path_part   = "consumers"
# }

# resource "aws_api_gateway_resource" "products" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   parent_id   = aws_api_gateway_resource.api.id
#   path_part   = "products"
# }

# resource "aws_api_gateway_resource" "cart" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   parent_id   = aws_api_gateway_resource.api.id
#   path_part   = "cart"
# }

# resource "aws_api_gateway_method" "consumers_any" {
#   rest_api_id   = aws_api_gateway_rest_api.main.id
#   resource_id   = aws_api_gateway_resource.consumers.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "products_any" {
#   rest_api_id   = aws_api_gateway_rest_api.main.id
#   resource_id   = aws_api_gateway_resource.products.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "cart_any" {
#   rest_api_id   = aws_api_gateway_rest_api.main.id
#   resource_id   = aws_api_gateway_resource.cart.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "consumers" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   resource_id = aws_api_gateway_resource.consumers.id
#   http_method = aws_api_gateway_method.consumers_any.http_method

#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = aws_api_gateway_vpc_link.main.id
#   uri                     = "http://${aws_lb.nlb.dns_name}/api/consumers"
# }

# resource "aws_api_gateway_integration" "products" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   resource_id = aws_api_gateway_resource.products.id
#   http_method = aws_api_gateway_method.products_any.http_method

#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = aws_api_gateway_vpc_link.main.id
#   uri                     = "http://${aws_lb.nlb.dns_name}/api/products"
# }

# resource "aws_api_gateway_integration" "cart" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   resource_id = aws_api_gateway_resource.cart.id
#   http_method = aws_api_gateway_method.cart_any.http_method

#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = aws_api_gateway_vpc_link.main.id
#   uri                     = "http://${aws_lb.nlb.dns_name}/api/cart"
# }

# resource "aws_api_gateway_deployment" "main" {
#   depends_on = [
#     aws_api_gateway_integration.consumers,
#     aws_api_gateway_integration.products,
#     aws_api_gateway_integration.cart,
#   ]

#   rest_api_id = aws_api_gateway_rest_api.main.id
# }

# resource "aws_api_gateway_stage" "main" {
#   deployment_id = aws_api_gateway_deployment.main.id
#   rest_api_id   = aws_api_gateway_rest_api.main.id
#   stage_name    = var.environment
# }