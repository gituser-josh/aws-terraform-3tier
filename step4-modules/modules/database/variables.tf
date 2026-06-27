variable "project_name" {
  description = "Project/environment name used for resource naming"
  type        = string
}

variable "db_subnet_ids" {
  description = "Subnet IDs for the DB subnet group (2 AZs, from network module)"
  type        = list(string)
}

variable "db_sg_id" {
  description = "Security group ID for DB tier (from network module)"
  type        = string
}

variable "db_username" {
  description = "RDS master username"
  type        = string
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}