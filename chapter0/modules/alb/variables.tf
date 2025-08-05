variable "name_prefix" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "instance_id" {
  description = "EC2 instance ID to attach to the target group"
  type        = string
}
