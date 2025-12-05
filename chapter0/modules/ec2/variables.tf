# chapter0/modules/ec2/variables.tf  ← これだけにする

variable "name" {
  type        = string
  description = "Name tag for the EC2 instance"
  validation {
    condition     = length(trimspace(var.name)) > 0 && length(var.name) <= 128
    error_message = "name must be 1–128 characters (non-empty)."
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  validation {
    condition     = can(regex("^[a-z0-9]+\\.[a-z0-9]+$", var.instance_type))
    error_message = "instance_type must look like family.size (e.g., t3.micro)."
  }
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to launch the instance in"
  validation {
    condition     = can(regex("^subnet-[0-9a-fA-F]{8,}$", var.subnet_id))
    error_message = "subnet_id must look like subnet-xxxxxxxx."
  }
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach"
  validation {
    condition     = length(var.security_group_ids) >= 1 && alltrue([for id in var.security_group_ids : can(regex("^sg-[0-9a-fA-F]{8,}$", id))])
    error_message = "security_group_ids must be a non-empty list of sg-xxxxxxxx."
  }
}

variable "key_name" {
  type        = string
  description = "Key pair name"
  validation {
    condition     = length(trimspace(var.key_name)) > 0
    error_message = "key_name must be non-empty."
  }
}

variable "user_data" {
  type        = string
  description = "User data script to run at instance boot"
  default     = null
}

variable "ami" {
  type        = string
  description = "AMI ID to use for the instance (optional if using SSM inside the module)"
  default     = null
}
