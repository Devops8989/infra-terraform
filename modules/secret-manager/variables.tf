variable "secret_name" {
  type        = string
  description = "Name of the secret"
}

variable "description" {
  type        = string
  description = "Description of the secret"
  default     = ""
}

variable "secret_value" {
  type        = string
  description = "Secret value to store (JSON or plain string)"
  sensitive   = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
