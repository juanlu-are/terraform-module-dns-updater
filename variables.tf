# ------------------------------------------
# Write your Terraform variable inputs here
# ------------------------------------------

variable "zone" {
  description = "DNS zone configuration"
  type        = string
  default     = "example.com."
}

