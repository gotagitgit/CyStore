data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "default" {
  count = length(data.aws_subnets.default.ids)
  id    = data.aws_subnets.default.ids[count.index]
}

# Use existing default subnets
locals {
  public_subnet_ids = [for s in data.aws_subnet.default : s.id if s.map_public_ip_on_launch]
  private_subnet_ids = [for s in data.aws_subnet.default : s.id if !s.map_public_ip_on_launch]
}

# Create private subnets if none exist
resource "aws_subnet" "private" {
  count             = length(local.private_subnet_ids) > 0 ? 0 : var.az_count
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = cidrsubnet(data.aws_vpc.default.cidr_block, 8, count.index + 100)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.prefix}-private-subnet-${count.index}"
  }
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Use default route table for public subnets

resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "${var.prefix}-private-rt"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  
  tags = {
    Name = "${var.prefix}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = local.public_subnet_ids[0]

  tags = {
    Name = "${var.prefix}-nat-gateway"
  }

  depends_on = [data.aws_internet_gateway.default]
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private" {
  count          = length(local.private_subnet_ids) > 0 ? length(local.private_subnet_ids) : var.az_count
  subnet_id      = length(local.private_subnet_ids) > 0 ? local.private_subnet_ids[count.index] : aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}