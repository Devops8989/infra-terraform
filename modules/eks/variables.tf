variable "cluster_name" { type = string }
variable "cluster_version" { type = string }
//variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "tags" { type = map(string) }

variable "vpc_id" { type = string }

variable "subnet_ids" {
  type = list(string)
}
