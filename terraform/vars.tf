variable "tags_common" {
  type        = map(any)
  description = "Common tags to set for all resources"
  default = {
    Assignment = "final"
  }
}

variable "ssh_key_name" {
  type        = string
  description = "Name of SSH key to place on hosts"
  default     = "final-key"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key to add to EC2 instances"
}
