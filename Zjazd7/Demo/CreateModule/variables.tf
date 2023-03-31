locals {
  prefix   = "${var.env}-${var.my_account}-"
  acr_name = "${local.prefix}vm"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "my_account" {
  type    = string
  default = "student29"
}