locals {
  prefix   = "${var.env}${var.name}"
  acr_name = "${local.prefix}acr"
}

variable "env" {
  type = string
}

variable "name" {
  type    = string
  default = "student29"
}

variable "sku" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "instance" {
    type = string
    default = "01"
}