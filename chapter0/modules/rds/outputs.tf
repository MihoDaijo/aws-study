output "rds_endpoint" {
  description = "RDSインスタンスのエンドポイントアドレス"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_identifier" {
  description = "RDSインスタンスの識別子"
  value       = aws_db_instance.mysql.id
}

output "rds_arn" {
  description = "RDSインスタンスのARN"
  value       = aws_db_instance.mysql.arn
}
