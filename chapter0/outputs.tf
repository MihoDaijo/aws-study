output "ALBDNSName" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "RDSInstanceEndpoint" {
  description = "RDS Endpoint Address"
  value       = aws_db_instance.mysql.endpoint
}

output "EC2PublicIP" {
  description = "EC2 Public IP"
  value       = aws_instance.web.public_ip
}
