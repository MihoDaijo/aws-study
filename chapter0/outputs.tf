output "alb_dns_name" {
  description = "ALB の DNS 名"
  value       = module.alb.dns_name
}

output "rds_endpoint" {
  description = "RDS のエンドポイントアドレス"
  value = module.rds.rds_endpoint
}

output "ec2_public_ip" {
  description = "EC2 のパブリックIP"
  value       = module.ec2.public_ip
}

output "cpu_alarm_name" {
  description = "CPUアラーム名"
  value       = module.cloudwatch.cpu_alarm_name
}

output "waf_web_acl_arn" {
  description = "WAF WebACL の ARN"
  value       = module.waf.web_acl_arn
}
