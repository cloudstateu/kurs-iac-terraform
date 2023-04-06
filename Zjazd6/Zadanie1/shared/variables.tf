locals {
  prefix = "${var.rg_name}-srd-${var.project_name}"
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
}
