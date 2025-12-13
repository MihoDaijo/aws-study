output "alb_dns_name" {
  description = "ALB の DNS 名（enable_alb=false のときは null）"
  value       = try(module.alb[0].dns_name, null)
}

output "rds_endpoint" {
  description = "RDS のエンドポイントアドレス（enable_rds=false のときは null）"
  value       = try(module.rds[0].rds_endpoint, null)
}

output "ec2_public_ip" {
  description = "EC2 のパブリックIP"
  value       = module.ec2.public_ip
}

output "cpu_alarm_name" {
  description = "CPUアラーム名（enable_cloudwatch=false のときは null）"
  value       = try(module.cloudwatch[0].cpu_alarm_name, null)
}

output "waf_web_acl_arn" {
  description = "WAF WebACL の ARN（enable_waf=false のときは null）"
  value       = try(module.waf[0].web_acl_arn, null)
}

output "ec2_sg_id" {
  description = "EC2 security group ID"
  value       = module.security_group.ec2_sg_id
}

output "alb_sg_id" {
  description = "ALB security group ID"
  value       = module.security_group.alb_sg_id
}

output "rds_sg_id" {
  description = "RDS security group ID"
  value       = module.security_group.rds_sg_id
}
