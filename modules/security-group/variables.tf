variable "vpc_id" {
  type        = string
  description = "VPC ID where SG will be created"
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
