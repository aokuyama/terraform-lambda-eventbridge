resource "aws_cloudwatch_event_rule" "lambda" {
  for_each            = var.lambda
  name                = each.key
  event_pattern       = null
  schedule_expression = each.value.schedule
  lifecycle {
    ignore_changes = [
      is_enabled
    ]
  }
  description = each.value.description
}

resource "aws_cloudwatch_event_target" "lambda-target" {
  for_each = var.lambda
  rule     = aws_cloudwatch_event_rule.lambda[each.key].name
  arn      = "arn:aws:lambda:${var.region}:${data.aws_caller_identity.self.account_id}:function:${each.value.function_name}"
  input    = jsonencode(each.value.input)
}

resource "aws_lambda_permission" "event_target" {
  for_each      = var.lambda
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda[each.key].arn
}
