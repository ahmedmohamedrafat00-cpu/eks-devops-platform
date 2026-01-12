# ---------------------
# SNS Topic for Alarms
# ---------------------
resource "aws_sns_topic" "servers_alerts" {
  name = "servers-alerts-topic"
}

resource "aws_sns_topic_subscription" "servers_email" {
  topic_arn = aws_sns_topic.servers_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# ---------------------
# CloudWatch Alarms
# ---------------------

resource "aws_cloudwatch_metric_alarm" "jenkins_high_cpu" {
  alarm_name          = "HighCPU-Jenkins"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm monitors high CPU usage on the Jenkins server"

  dimensions = {
    InstanceId = aws_instance.jenkins.id
  }

  actions_enabled = true
  alarm_actions   = [aws_sns_topic.servers_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "ansible_high_cpu" {
  alarm_name          = "HighCPU-Ansible"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm monitors high CPU usage on the Ansible server"

  dimensions = {
    InstanceId = aws_instance.ansible.id
  }

  actions_enabled = true
  alarm_actions   = [aws_sns_topic.servers_alerts.arn]
}

# ---------------------
# CloudWatch Dashboard
# ---------------------

resource "aws_cloudwatch_dashboard" "servers_dashboard" {
  dashboard_name = "Servers-Dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.jenkins.id],
            [".", "CPUUtilization", "InstanceId", aws_instance.ansible.id]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "CPU Utilization (%)"
          period  = 60
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "NetworkIn", "InstanceId", aws_instance.jenkins.id],
            [".", "NetworkIn", "InstanceId", aws_instance.ansible.id],
            [".", "NetworkOut", "InstanceId", aws_instance.jenkins.id],
            [".", "NetworkOut", "InstanceId", aws_instance.ansible.id]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Network In/Out (Bytes)"
          period  = 60
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 24
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "DiskReadBytes", "InstanceId", aws_instance.jenkins.id],
            [".", "DiskReadBytes", "InstanceId", aws_instance.ansible.id],
            [".", "DiskWriteBytes", "InstanceId", aws_instance.jenkins.id],
            [".", "DiskWriteBytes", "InstanceId", aws_instance.ansible.id]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Disk Read/Write (Bytes)"
          period  = 60
        }
      }
    ]
  })
}
