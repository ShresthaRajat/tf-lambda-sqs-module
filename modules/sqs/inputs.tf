variable "sqs_name"{
    type = string
    description = "SQS Queue Name. Add .fifo at the end if sqs_fifo_queue=true"
}

variable "sqs_fifo_queue"{
    type = bool
    default = false
    description = "SQS FiFo Queue true or false"
}

variable "sqs_content_dedup"{
    type = bool
    default = false
    description = "SQS Queue Contect Dedepulication true or false"
}

variable "sqs_delay_secs"{
    type = number
    default = 10
    description = "SQS Queue Delay in Seconds"
}

variable "sqs_msg_size_max"{
    type = number
    default = 262144
    description = "SQS Queue Max Message Size"
}

variable "sqs_viz_timeout_secs"{
    type = number
    default = 60
    description = "SQS Queue Vizibility Timeout in Seconds"
}

variable "sqs_msg_retention_secs"{
    type = number
    default = 345600
    description = "SQS Queue Message Retention in Seconds"
}

variable "sqs_rcv_wait_secs"{
    type = number
    default = 10
    description = "SQS Queue Receive Wait Time in Seconds"
}

variable "sqs_redrive_pol"{
    type = string
    default = null
    description = "SQS Queue Redrive Policy - Dead Letter Queue"
}