locals {
  prefix = "${var.student_name}-${var.app_name}"
}

variable "student_name" {
  type = string
}

variable "app_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_address_space" {
  type = string
}

variable "subnets" {
  type = map(object({
    address_space = string
  }))
}

variable "rg_name" {
  type = string
}

variable "hub_rg_name" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "hub_vnet_id" {
  type = string
}
