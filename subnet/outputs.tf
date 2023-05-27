

output "public_subnet_ids" {
  value = [aws_subnet.subnet["subnet1"].id, aws_subnet.subnet["subnet2"].id]
}

output "private_subnet_ids" {
  value = [aws_subnet.subnet["subnet3"].id, aws_subnet.subnet["subnet4"].id]
}
