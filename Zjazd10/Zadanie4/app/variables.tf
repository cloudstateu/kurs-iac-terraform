locals {
  prefix_shared = "${var.shared_rg_name}-srd-${var.project_name}"
  prefix        = "${var.rg_name}-${var.environment}-${var.project_name}"
}

variable "subscription_id" {
  type = string
}

variable "shared_subscription_id" {
  type = string
}

variable "rg_name" {
  type    = string
  default = "chm-student0"
}

variable "shared_rg_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type    = string
  default = "lab"
}

variable "vnet_address_space" {
  type    = string
  default = "10.1.0.0/16"
}

variable "shared_state_config" {
  type = object({
    resource_group_name  = string
    storage_account_name = string
    container_name       = string
    key                  = string
    subscription_id      = string
  })
}

locals {
  my_ip_address            = trimspace(data.http.my_ip_address.response_body)
  app_address_prefix       = cidrsubnet(var.vnet_address_space, 8, 0)
  data_address_prefix      = cidrsubnet(var.vnet_address_space, 8, 1)
  endpoints_address_prefix = cidrsubnet(var.vnet_address_space, 8, 2)
}
