variable "name" {
  description = "Name of the WAF Web ACL"
  type        = string
}

variable "resource_arn" {
  description = "ARN of the resource to associate with WAF"
  type        = string
}
