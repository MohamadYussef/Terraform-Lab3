output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "default_sg_id" {
  value = aws_security_group.sg-default.id
}
