output "id" {
  description = "SQS Queue ID."
  value       = aws_sqs_queue.queue.id
}

output "arn" {
  description = "SQS Queue ARN."
  value       = aws_sqs_queue.queue.arn
}