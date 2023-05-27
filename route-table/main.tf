
resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_name}-${var.is_public ? "public" : "private"}-rtb"
  }
}

resource "aws_route" "public_route" {
  count                  = var.is_public ? 1 : 0
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

resource "aws_route" "private_route" {
  count                  = var.is_public ? 0 : 1
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
  #gateway_id = var.internet_gateway_id
}
