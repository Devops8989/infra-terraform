variable "cluster_name" { type = string }
variable "oidc_provider_arn" { type = string }
variable "oidc_provider_url" { type = string } # e.g. https://oidc.eks.<region>.amazonaws.com/id/XXXX
variable "tags" { type = map(string) }
//variable "tags" { type = map(string) default = {} }
