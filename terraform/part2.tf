# cloudwatch metrics and cloudtrail auditing for part 2
# using recommended alarms from AWS:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Best_Practice_Recommended_Alarms_AWS_Services.html#EC2

resource "aws_cloudwatch_metric_alarm" "cpu-alarm" {
  alarm_name          = "final-cpu-util-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  datapoints_to_alarm = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Best practices alarm for average CPU Utilization above 80%"
}


resource "aws_cloudwatch_metric_alarm" "status-check-failed-alarm" {
  alarm_name          = "final-status-check-failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "Best practices alarm for failed instance status checks"
}

resource "aws_cloudwatch_metric_alarm" "network-out-alarm" {
  alarm_name          = "final-network-out-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  datapoints_to_alarm = 3
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 1000
  alarm_description   = "Alarm for high network traffic bytes out"
}

