output "web_public_ip" {
  description = "Web server public IP"
  value       = aws_instance.web.public_ip
}

output "app_private_ip" {
  description = "App sever private iP"
  value       = aws_instance.app.private_ip
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.main.endpoint
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}