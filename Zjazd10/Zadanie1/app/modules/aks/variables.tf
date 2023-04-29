variable "aks_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "rg" {
  type = object({
    id       = string
    name     = string
    location = string
  })
}

variable "acr" {
  type = object({
    id = string
  })
}

variable "dns_prefix" {
  type = string
}

variable "network" {
  type = object({
    vnet_id   = string
    vnet_name = string
    subnet_id = string
  })
}

variable "log_analytics_workspace_id" {
  type = string
}
