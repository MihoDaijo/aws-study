variable "db_identifier" {
  description = "RDSインスタンスの識別子"
  type        = string
}

variable "engine" {
  description = "RDSエンジン（例: mysql）"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "RDSエンジンのバージョン"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDSインスタンスのクラス（例: db.t3.micro）"
  type        = string
}

variable "allocated_storage" {
  description = "ストレージサイズ（GiB）"
  type        = number
}

variable "db_username" {
  description = "マスターユーザー名"
  type        = string
}

variable "db_password" {
  description = "マスターユーザーパスワード"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "作成するデータベース名"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "RDSに関連付けるセキュリティグループのリスト"
  type        = list(string)
}

variable "db_subnet_ids" {
  description = "RDSサブネットグループに使うプライベートサブネットのIDリスト"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "RDSをインターネットに公開するかどうか"
  type        = bool
}

variable "name_prefix" {
  description = "タグ名に使用するプレフィックス"
  type        = string
}
