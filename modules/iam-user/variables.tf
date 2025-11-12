variable "user_name" {
  description = "The name of the IAM user to create"
  type        = string
}

variable "policy_arn" {
  description = "The ARN of the IAM policy to attach to the user"
  type        = string
}
