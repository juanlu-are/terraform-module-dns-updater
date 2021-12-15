# ------------------------------------------
# Write your Terraform variable inputs here
# ------------------------------------------

# MY COMMENTS: variables let you customize aspects of Terraform modules without altering the module's own source code

variable "zone" {
  description = "DNS zone configuration"
  type        = string
  default     = "example.com."
}

