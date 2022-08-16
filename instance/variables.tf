variable "instance_count" {
  type = number
  default = 1
}

variable "ami" {
}

variable "instance_type" {
}

variable "key_name" {
}

variable "sgs" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "termination_protection" {
  default = false
}

variable "public_ip" {
  default = false
}

variable "metadata_hop_limit" {
  default     = 3
  description = "(Optional) Metadata hop limit for the instance"
}

variable "metadata_instance_tags" {
  default     = "enabled"
  description = "(Optional) Metadata tags read for the instance"
}

variable "metadata_http_endpoint" {
  default     = "enabled"
  description = "(Optional) Metadata http endpoint state for the instance"
}

variable "root_vl_type" {
  default = "gp2"
}

variable "root_vl_size" {
  default = "8"
}

variable "root_vl_delete" {
  default = true
}

variable "user_data" {
  default = [""]
  type    = list(string)
}

variable "name" {
}

variable "environment" {
}

variable "project" {
}

variable "ebs_block_devices" {
  type = list(map(string))
  default = []
}

variable "tags" {
  description = "Optional tags"
  type        = map(string)
  default     = {}
}

variable "cpu_credits" {
  type        = string
  description = "The type of cpu credits to use"
  default     = "standard"
}

variable "is_ebs_optimised" {
  description = "EBS optimise boolean flag true or false"
  default = false
}