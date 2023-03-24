locals {
  prefix_shared = "${var.rg_name}-srd-${var.project_name}"
  prefix        = "${var.rg_name}-${var.environment}-${var.project_name}"
}

variable "rg_name" {
  type    = string
  default = "chm-student0"
}

variable "environment" {
  type    = string
}

variable "project_name" {
  type    = string
  default = "lab"
}

variable "vnet_address_space" {
  type    = string
  default = "10.1.0.0/16"
}

locals {
  app_address_prefix       = cidrsubnet(var.vnet_address_space, 8, 0)
  data_address_prefix      = cidrsubnet(var.vnet_address_space, 8, 1)
  endpoints_address_prefix = cidrsubnet(var.vnet_address_space, 8, 2)
}
