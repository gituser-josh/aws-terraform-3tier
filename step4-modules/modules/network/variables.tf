# network module の「引数」定義
# default を付けない = 呼び出し側が必ず値を渡す（渡し忘れをエラーで検出）

variable "project_name" {
  description = "Project/environment name used for resource naming"
  type        = string
}

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
  description = "CIDR for private subnet (db tier, primary AZ)"
  type        = string
}

variable "private_subnet_db2_cidr" {
  description = "CIDR for private subnet (db tier, secondary AZ)"
  type        = string
}

variable "az_primary" {
  description = "Primary availability zone"
  type        = string
}

variable "az_secondary" {
  description = "Secondary availablity zone"
  type        = string
}