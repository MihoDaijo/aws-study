resource "aws_sns_topic" "alarm_topic" {
  name = "AlarmTopic-${var.name_prefix}"
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "${var.name_prefix}-CPUUtilizationAlarm"
  alarm_description   = "CPU使用率が0.01%以上でアラーム（本番Applyテスト）"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    InstanceId = var.ec2_instance_id
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
