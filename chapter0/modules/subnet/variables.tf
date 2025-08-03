variable "vpc_id" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}
