output "server_ids" {
  value = aws_instance.server
}

output "server_ips" {
  value = aws_instance.server[*].public_ip
}
