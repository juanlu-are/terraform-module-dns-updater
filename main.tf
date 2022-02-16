/**
* # Terraform
*
* <All exercise description has been made for each Terraform block used below in the section "MY COMMENTS">
*
*
* ## Usage
*
* ### Quick Example
*
* ```hcl
* module "dns_" {
*   source = ""
*   input1 = <>
*   input2 = <>
* } 
* ```
*
*/
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM RUNTIME REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.

  # MY COMMENTS: this block contains Terraform "DNS UPDATER" settings, including the Terraform minimum version (0.13.5) and the required providers it will use to provision our infrastructure,
  # installing them from the Terraform Registry by default. In this exercise, the DNS provider's source is defined as hashicorp/dns with also a version constraint.

  required_version = ">= 0.13.5"
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.2.0"
    }
  }
}
  # MY COMMENTS: here I've configured the specified provider as the one installed using your script with dockers.
  provider "dns" {
    update {
      server = "127.0.0.1"
    }
  }

# ------------------------------------------
# Write your local resources here
# ------------------------------------------

# MY COMMENTS: Terraform locals are named values that I can refer to in my configuration.
# It assigns a name to an expression, so I can use it multiple times within a module without repeating it.
# I have used Terraform's fileset function [fileset(path, pattern)] to pick up any new files (only json extension) added in the specified directory.
# And I have also used Terraform's jsondecode function to load local variables from an external json file.
# Finally my presentation was a success!!!

locals {
  inputs = [
    for fn in fileset("${path.module}", "examples/exercise/input-json/*.json") :
    jsondecode(file("${path.module}/${fn}"))
  ]

# MY COMMENTS: below this line you can find the local value to pickup any cname*.json files.

  cname_inputs = [
    for fn in fileset("${path.module}", "examples/exercise/input-json/cname*.json") :
    jsondecode(file("${path.module}/${fn}"))
  ]
  
}


# ------------------------------------------
# Write your Terraform resources here
# ------------------------------------------

# MY COMMENTS: the resource block defines components of my infrastructure. In this case, it creates a A type DNS record set.
# I am using here Terraform syntax with for_each and each.value to loop over the parameters of each json file parsed from locals.

resource "dns_a_record_set" "www" {
 # for_each = toset(local.inputs)
  for_each = {for record in local.inputs: record.addresses => record}
  zone = var.zone
  name = "www"
  addresses = each.value.addresses
  ttl = each.value.ttl
}

# MY COMMENTS: below this line you can find the resource to create CNAME type DNS record.

resource "dns_cname_record" "foo" {
  for_each = toset(local.cname_inputs)
  zone  = var.zone
  name  = "foo"
  cname = each.value.cname
  ttl   = each.value.ttl
}