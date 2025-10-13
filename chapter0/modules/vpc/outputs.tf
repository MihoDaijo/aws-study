# VPC ID
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

# VPC CIDR
output "vpc_cidr" {
  value       = aws_vpc.main.cidr_block
  description = "The CIDR block of the VPC"
}

# DNS サポートが有効か
output "dns_support_enabled" {
  value       = aws_vpc.main.enable_dns_support
  description = "Whether DNS support is enabled for the VPC"
}

# DNS ホストネームが有効か
output "dns_hostnames_enabled" {
  value       = aws_vpc.main.enable_dns_hostnames
  description = "Whether DNS hostnames are enabled for the VPC"
}
