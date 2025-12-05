variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "ec2_instance_id" {
  description = "ID of the EC2 instance to monitor"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU utilization threshold (%)"
  type        = number
  default     = 0.03
}

variable "notification_email" {
  description = "SNS 通知を送信するメールアドレス"
  type        = string
}
