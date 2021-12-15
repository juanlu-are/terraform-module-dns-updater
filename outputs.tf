# ----------------------------------------
# Write your Terraform module outputs here
# ----------------------------------------

# MY COMMENTS:Terraform output values allow you to export structured data about your resources.
# You can use this data to configure other parts of your infrastructure with automation tools, or as a data source for another Terraform workspace

output "message" {
  description = "Your description about the value exported"
  value       = "Output value to use"
}