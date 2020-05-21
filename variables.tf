variable "domain_name" {
  description = "The domain name to configure SES."
  type        = string
}

variable "from_addresses" {
  description = "List of email addresses to catch bounces and rejections."
  type        = list(string)
}

variable "enable_verification" {
  description = "Control whether or not to verify SES DNS records."
  type        = bool
  default     = true
}

variable "enable_incoming_email" {
  description = "Control whether or not to handle incoming emails."
  type        = bool
  default     = true
}

