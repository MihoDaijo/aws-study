variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "my_home_ip" {
  description = "Your home IP address for SSH access"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}
