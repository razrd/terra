variable main_region {
  type        = string
  default     = "us-east-1"
  description = "String(Required) AWS Region"
}

variable "vpc_name" {
  type        = string
  default     = "custom_vpc_01"
  description = "String(Optional) VPC NAME"
}

variable "create_vpc" {
  description = "Controls if VPC should be created"
  type        = bool
  default     = true
}

variable cidr_block {
  type        = string
  default     = "10.0.0.0/16"
  description = "String(Optional) CIDR Block for VPC"
}
