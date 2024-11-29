output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPCのID"
}

output "subnet_id" {
  value       = aws_subnet.public_1a.id
  description = "サブネットのID"
}
