output "web_public_ip" {
  description = "Web server public IP"
  value       = module.compute.web_public_ip
}

output "app_private_ip" {
  description = "App server private IP"
  value       = module.compute.app_private_ip
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.database.rds_endpoint
}

output "vpc_id" {
  description = "VPC_ID"
  value       = module.network.vpc_id
}