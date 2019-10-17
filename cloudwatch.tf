resource "aws_cloudwatch_event_rule" "schedule" {
  description         = "Execute the powerdown Lambda function based on the following schedule."
  name                = "check-powerdown-schedule"
  role_arn            = aws_iam_role.powerdown_scheduler_role.arn
  schedule_expression = "cron(1 * ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "schedule" {
  arn       = aws_lambda_function.powerdown_lambda.arn
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = aws_lambda_function.powerdown_lambda.function_name
}

resource "aws_lambda_permission" "permit_invocation_via_cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.powerdown_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
  statement_id  = "PermitInvocationViaCloudWatch"
}
