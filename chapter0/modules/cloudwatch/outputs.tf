output "cpu_alarm_name" {
  description = "Name of the CloudWatch CPU Utilization alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_utilization_alarm.alarm_name
}

output "alarm_topic_arn" {
  description = "SNS Topic ARN for alarm"
  value       = aws_sns_topic.alarm_topic.arn
}
