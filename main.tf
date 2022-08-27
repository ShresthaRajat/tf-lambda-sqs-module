data "aws_caller_identity" "current" {}

# TODO: Create log groups

module "user_login_lambda" {
  source           = "./modules/lambda"
  name             = "loginQueueHandler"
  filename         = "./files/user_login.zip"
  source_code_hash = filebase64sha256("./files/user_login.zip")
  description      = "Process user logins"
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  memory_size      = "128"
  timeout          = "75"
  policy = templatefile(
    "./templates/shared/policies/awslambdasqsexerpolicy.json",
    { 
      "sqs_queues" = ["${module.aws_user_login_sqs.arn}", "${module.aws_user_login_sqs_dead.arn}"],
      "cw_logs_group" = ["arn:aws:logs:${environment}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"] 
    }
  )

  environment_vars = {
    # CLIENT_ID             = var.lambda_orderproc_client_id
    # CLIENT_SECRET         = var.lambda_orderproc_client_secret
    aws_POST_LOGIN_PROCESSING_URL = "TBD"
    REQUEST_TIMEOUT                   = "30000"
    TOKEN_REQUEST_TIMEOUT             = "10000"
  }
}

resource "aws_lambda_event_source_mapping" "userloginlambdasqs" {
  event_source_arn = module.aws_user_login_sqs.arn
  function_name    = module.user_login_lambda.arn
  batch_size       = 1
}

module "aws_user_login_sqs" {
  source               = "./modules/sqs"
  sqs_name             = "${var.environment}-user-login.fifo"
  sqs_fifo_queue       = true
  sqs_viz_timeout_secs = 150
  sqs_content_dedup    = true
  sqs_redrive_pol = jsonencode({
    deadLetterTargetArn = module.aws_user_login_sqs_dead.arn
    maxReceiveCount     = 5
  })
}

module "aws_user_login_sqs_dead" {
  source            = "./modules/sqs"
  sqs_name          = "${var.environment}-user-login-dead.fifo"
  sqs_content_dedup = true
  sqs_fifo_queue    = true
}

resource "aws_iam_policy" "policy_sqs" {
  name        = "bat-iam-sqs-policy-${var.environment}-user-login"
  path        = "/"
  description = "IAM policy for SQS Access to shared aws user login Queues"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sqs:ListQueues",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ChangeMessageVisibility",
                "sqs:GetQueueUrl",
                "sqs:GetQueueAttributes",
                "sqs:SendMessage"
            ],
            "Resource": [
              "${module.aws_user_login_sqs.arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user" "awsiam" {
  name = "awsiam"
}

resource "aws_iam_user_policy_attachment" "role_attach" {
  user       = aws_iam_user.awsiam.name
  policy_arn = aws_iam_policy.policy_sqs.arn
}
