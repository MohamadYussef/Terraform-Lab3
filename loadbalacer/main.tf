resource "aws_lb" "load_balancer" {
  name               = var.load_balancer_name
  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  security_groups    = [var.security_groups]
  subnets            = var.subnet_id

  tags = {
    Name = var.load_balancer_name
  }
}

resource "aws_lb_listener" "load_balancer_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = var.default_action_type
    target_group_arn = aws_lb_target_group.target_servers.arn
  }
}

resource "aws_lb_target_group" "target_servers" {
  name     = var.target_group_name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  tags = {
    Name = var.target_group_name
  }
}

resource "aws_lb_target_group_attachment" "target_servers_attachment" {

  count            = 2 #length(var.target_ids)
  target_group_arn = aws_lb_target_group.target_servers.arn
  target_id        = var.target_ids[count.index].id
  port             = var.port
}
