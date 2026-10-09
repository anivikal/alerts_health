data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["sns:Publish"]
    
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    
    resources = [aws_sns_topic.health_alerts.arn]
  }
}