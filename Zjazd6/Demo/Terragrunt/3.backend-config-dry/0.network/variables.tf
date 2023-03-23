locals {
  prefix      = "chm-student0"
  vnet_name   = "${local.prefix}-${var.vnet_name}"
  subnet_name = "${local.prefix}-${var.subnet_name}"
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = string
}

variable "subnet_address_prefixes" {
  type = list(string)
}
