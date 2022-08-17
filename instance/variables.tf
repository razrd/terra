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

variable "create_instance_profile" {
  default = false
  description = "(boolean:optional) enables creation of iam. "
  type = bool
}

variable "instance_profile" {
  default = ""
  description = "(string:optional) When create_instance_profile is false set this. "
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
  description = "(string:optional) Metadata http endpoint state for the instance"
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

variable "root_vl_kms_key_id" {
  default = ""
  description = "(string:optional) KMS Key for the root volume"
}

variable "root_vl_encrypt" {
  default = false
  description = "(bool) Encrypt the root volume with AWS Key"
}

variable "user_data" {
  default = [""]
  type    = list(string)
  description = "(string:optional) user data to execute commands.  "
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
  description = "EBS optimise boolean flag true or false, doesnt really matter with AWS"
  default = false
}

variable "iam_s3_bucket_ref" {
  description = "(string:required) S3 bucket for IAM read/write, mainly used for tf state"
  default = "lab01s3tf"
}

variable "role_permissions_boundary" {
  description = "(string:optional) permission boundary"
  default = ""
  type = string
}