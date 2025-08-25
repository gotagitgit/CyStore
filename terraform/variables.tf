variable aws_profile {
  description = "The AWS profile to use"
  nullable    = true
  type        = string
}

variable aws_region {
  description = "The AWS region to use"
  nullable    = false
  type        = string
}

variable az_count {
  description = "Number of availability zones to use"
  type = number
}

variable docker_image_api_account {
  description = "Docker Hub image for API account service"
  type        = string
}

variable docker_image_api_inventory {
  description = "Docker Hub image for API inventory service"
  type        = string
}

variable docker_image_api_shopping {
  description = "Docker Hub image for API shopping service"
  type        = string
}

variable docker_image_store_web {
  description = "Docker Hub image for store web frontend"
  type        = string
}

variable environment {
  description = "Environment name"
  type = string
}

variable prefix {
  description = "Prefix for resource names"
  type = string
}

variable project {
  description = "Project name"
  type = string
}

variable subnet_newbits {
  description = "Number of additional bits to extend the VPC CIDR for subnets"
  type        = number
}

variable vpc_cidr_block {
  description = "CIDR block for VPC"
  type = string
}