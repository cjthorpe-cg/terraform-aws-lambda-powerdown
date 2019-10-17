resource "aws_lambda_function" "powerdown_lambda" {
  function_name = var.function_name
  handler       = "${var.function_name}.lambda_handler"
  role          = aws_iam_role.powerdown_scheduler_role.arn
  runtime       = var.runtime
  s3_bucket     = var.s3_bucket_name
  s3_key        = aws_s3_bucket_object.object-upload.key
}
