variable "ssh_key_name" {
  type        = string
  description = "Name of SSH key to place on host"
}

variable "vpc_id" {
  type        = string
  description = "ID of target VPC for instance"
}

variable "subnet_id" {
  type        = string
  description = "ID of target subnet within VPC"
}
