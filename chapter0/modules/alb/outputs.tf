output "alb_arn" {
  value       = aws_lb.alb.arn
  description = "ARN of the ALB"
}

output "dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}
