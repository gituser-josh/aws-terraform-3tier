variable "project_name" {
  description = "Project/environment name used for resource naming"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "public_subnet_id" {
  description = "Subnet ID for web tier (from network module)"
  type        = string
}

variable "private_app_subnet_id" {
  description = "Subnet ID for app tier (from network module)"
  type        = string
}

variable "web_sg_id" {
  description = "Security group ID for web tier (from network module)"
  type        = string
}

variable "app_sg_id" {
  description = "Security group ID for app tier (from network module)"
  type        = string
}