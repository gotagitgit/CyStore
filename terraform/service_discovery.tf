# PHASE 8 RESOURCES - SERVICE DISCOVERY (OPTIONAL FOR NLB)

resource "aws_service_discovery_private_dns_namespace" "main" {
  name = "microservices.private"
  vpc  = data.aws_vpc.default.id
}

resource "aws_service_discovery_service" "api_account" {
  name = "api-account"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
}

resource "aws_service_discovery_service" "api_inventory" {
  name = "api-inventory"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
}

resource "aws_service_discovery_service" "api_shopping" {
  name = "api-shopping"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
}