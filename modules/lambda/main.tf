resource "aws_lambda_function" "default" {
  function_name                  = var.name
  filename                       = var.s3_bucket == "" ? var.filename : null
  s3_bucket                      = var.filename == "" ? var.s3_bucket : null
  s3_key                         = var.filename == "" ? join("", aws_s3_object.default.*.key) : null
  s3_object_version              = var.filename == "" ? var.s3_object_version : null
  description                    = var.description
  role                           = aws_iam_role.default.arn
  handler                        = var.handler
  runtime                        = var.runtime
  memory_size                    = var.memory_size
  timeout                        = var.timeout
  layers                         = ["${var.layer}"]
  reserved_concurrent_executions = var.concurrency
  source_code_hash               = var.source_code_hash

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  dynamic "environment" {
    for_each = var.environment_vars == null ? [] : [var.environment_vars]
    content {
      variables = var.environment_vars
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_cw_group_retention" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.log_retention_period
}
