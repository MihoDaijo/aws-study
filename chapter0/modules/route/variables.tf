variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "igw_id" {
  description = "The ID of the Internet Gateway"
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs"
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}
