# === プロジェクト共通 ===

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

# === ネットワーク ===

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet (web tier)"
  type        = string
}

variable "private_subnet_app_cidr" {
  description = "CIDR for private subnet (app tier)"
  type        = string
}

variable "private_subnet_db_cidr" {
  description = "CIDR for private subnet (db tier, AZ-a)"
  type        = string
}

variable "private_subnet_db2_cidr" {
  description = "CIDR for parivate subnet (db tier, AZ-c, RDC require 2 AZs)"
  type        = string
}

variable "az_primary" {
  description = "Primary availability zone"
  type        = string
}

variable "az_secondary" {
  description = "Secondary availability zone"
  type        = string
}

# === コンピュート ===

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

# === データベース ===

variable "db_username" {
  description = "RDS master username"
  type        = string
}

variable "db_password" {
  description = "RDS maskter password (set via terraform.tfvars, never commit)"
  type        = string
  sensitive   = true
}