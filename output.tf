output "sqs-policy-name" {
  value = aws_iam_policy.policy_sqs.name
}

output "sqs-policy-arn" {
  value = aws_iam_policy.policy_sqs.arn
}

output "sqs-policy-id" {
  value = aws_iam_policy.policy_sqs.id
}