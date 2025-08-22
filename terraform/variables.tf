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

variable vpc_cidr_block {
  description = "CIDR block for VPC"
  type = string
}