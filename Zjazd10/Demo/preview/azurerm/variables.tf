locals {
  prefix   = "${var.env}-${var.my_account}-"
  acr_name = "${local.prefix}acr"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "my_account" {
  type    = string
  default = "student29"
}

variable "subscription_id" {
  type    = string
  default = "0685fd9c-4d40-4347-98b8-2c014be7272e"
}

variable "my_ip" {
  type    = string
  default = "87.207.140.160"
}