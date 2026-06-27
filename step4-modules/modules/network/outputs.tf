# network module の「戻り値」— compute / database module が必要とする ID 群

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public subnet ID (web tier)"
  value       = aws_subnet.public.id
}

output "private_app_subnet_id" {
  description = "Private subnet ID (app tier)"
  value       = aws_subnet.private_app.id
}

output "private_db_subnet_ids" {
  description = "Private sunbet IDs for DB tier (2 AZs for RDS subnet group)"
  value       = [aws_subnet.private_db.id, aws_subnet.private_db2.id]
}

output "web_sg_id" {
  description = "Web tier security group ID"
  value       = aws_security_group.web.id
}

output "app_sg_id" {
  description = "App tier security group ID"
  value       = aws_security_group.app.id
}

output "db_sg_id" {
  description = "DB tier security group ID"
  value       = aws_security_group.db.id
}