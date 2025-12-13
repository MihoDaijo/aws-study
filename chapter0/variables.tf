variable "my_home_ip" {
  description = "Your home IP address in CIDR notation"
  type        = string
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

variable "name_prefix" {
  description = "Prefix used for naming AWS resources"
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name for EC2 instance"
  type        = string
}

variable "notification_email" {
  description = "SNS 通知を送信するメールアドレス"
  type        = string
}

variable "enable_alb" {
  type    = bool
  default = false
}

variable "enable_rds" {
  type    = bool
  default = false
}

variable "enable_waf" {
  type    = bool
  default = false
}

variable "enable_cloudwatch" {
  type    = bool
  default = false
}

variable "enable_iam_github_oidc" {
  type    = bool
  default = false
}
