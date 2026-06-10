# === プロジェクト共通 ===

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "my3tier"
}

# === ネットワーク ===

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet (web tier)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_app_cidr" {
  description = "CIDR for private subnet (app tier)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_db_cidr" {
  description = "CIDR for private subnet (db tier, AZ-a)"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_db2_cidr" {
  description = "CIDR for parivate subnet (db tier, AZ-c, RDC require 2 AZs)"
  type        = string
  default     = "10.0.4.0/24"
}

variable "az_primary" {
  description = "Primary availability zone"
  type        = string
  default     = "ap-northeast-1a"
}

variable "az_secondary" {
  description = "Secondary availability zone"
  type        = string
  default     = "ap-northeast-1c"
}

# === コンピュート ===

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# === データベース ===

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "RDS maskter password (set via terraform.tfvars, never commit)"
  type        = string
  sensitive   = true
}