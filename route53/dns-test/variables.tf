variable "r53_domain" {
  description = "(string:required) /e.g., xyz.com/"
  type        = string
  default     = ""
}

variable "ip_addr_record" {
  description = "(list(string):required) /e.g., 9.9.9.9/"
  type        = list(string)
  default     = ["1.1.1.1"]
}

