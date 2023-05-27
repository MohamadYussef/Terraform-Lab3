
resource "aws_route_table_association" "association" {
  for_each = aws_subnet.subnet

  subnet_id      = each.value.id
  route_table_id = each.value.map_public_ip_on_launch ? var.public_rtb_id : var.private_rtb_id
}

resource "aws_subnet" "subnet" {
  for_each = var.subnets

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.type == "public" ? true : false

  tags = {
    Name = "${var.env_name}-${each.value.type}-${each.key}"
  }
}
