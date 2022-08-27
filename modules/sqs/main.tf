resource "aws_sqs_queue" "queue" {
  name                        = var.sqs_name
  fifo_queue                  = var.sqs_fifo_queue
  content_based_deduplication = var.sqs_content_dedup
  delay_seconds               = var.sqs_delay_secs
  max_message_size            = var.sqs_msg_size_max
  visibility_timeout_seconds  = var.sqs_viz_timeout_secs
  message_retention_seconds   = var.sqs_msg_retention_secs
  receive_wait_time_seconds   = var.sqs_rcv_wait_secs
  redrive_policy              = var.sqs_redrive_pol
}