
resource "aws_sns_topic" "health_alerts" {
  name = "aws-health-alerts"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.health_alerts.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.health_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_event_rule" "health_events" {
  name        = "aws-health-events-rule"
  description = "notification_rule"
  event_pattern = jsonencode({
    "source" : ["aws.health"]
  })
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.health_events.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.health_alerts.arn
}