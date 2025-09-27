variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC Provider ARN from EKS module"
}

variable "oidc_provider_url" {
  type        = string
  description = "OIDC Provider URL from EKS module"
}

variable "tags" {
  type    = map(string)
  default = {}
}
