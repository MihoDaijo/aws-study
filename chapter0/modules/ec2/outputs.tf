# chapter0/modules/ec2/outputs.tf

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = try(aws_instance.web.public_ip, null)  # plan時はnullになり得る
}

output "instance_type" {
  description = "EC2 instance type"
  value       = aws_instance.web.instance_type
}

output "ami" {
  description = "AMI ID"
  value       = aws_instance.web.ami
}

output "subnet_id" {
  description = "Subnet ID"
  value       = aws_instance.web.subnet_id
}

output "security_group_ids" {
  description = "Attached security group IDs"
  value       = aws_instance.web.vpc_security_group_ids
}

output "key_name" {
  description = "Key pair name"
  value       = aws_instance.web.key_name
}

output "name_tag" {
  description = "Value of the Name tag"
  value       = try(aws_instance.web.tags["Name"], null)
}
