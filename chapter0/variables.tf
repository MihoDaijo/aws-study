variable "name_prefix" {
  description = "リソース名に付加するプレフィックス"
  type        = string
  default     = "aws-study-tf"
}

variable "my_home_ip" {
  description = "自宅のIPアドレス（CIDR形式）"
  type        = string
}

variable "db_username" {
  description = "RDS のマスターユーザー名"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS のマスターパスワード"
  type        = string
  sensitive   = true
}
