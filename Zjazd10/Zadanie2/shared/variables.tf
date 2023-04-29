locals {
  prefix = "${var.rg_name}-srd-${var.project_name}"
}

variable "subscription_id" {
  type    = string
  default = "1cf870b4-ddbf-4029-974a-c2d5810f703c"
}

variable "rg_name" {
  type    = string
  default = "chm-student0"
}

variable "project_name" {
  type    = string
  default = "lab"
}

variable "vnet_address_space" {
  type    = string
  default = "10.0.0.0/16"
}

locals {
  endpoints_address_prefix = cidrsubnet(var.vnet_address_space, 8, 0)
  jumphost_address_prefix  = cidrsubnet(var.vnet_address_space, 8, 1)
}
