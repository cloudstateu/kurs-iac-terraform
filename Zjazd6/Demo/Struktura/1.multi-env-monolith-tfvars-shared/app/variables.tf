locals {
  environments = {
    "production"  = "prd"
    "test"        = "test"
    "development" = "dev"
    "shared"      = "srd"
    "sandbox"     = "snd"
  }
  resources = {
    "resource-group"              = "rg"
    "virtual-network"             = "vnet"
    "subnet"                      = "snet"
    "database"                    = "db"
    "virtual-network-peering"     = "vnp"
    "network-security-group"      = "nsg"
    "recovery-services-vault"     = "rsv"
    "vm-backend"                  = "vm"
    "vm-frontend"                 = "vm"
    "managed-disk"                = "vol"
    "event-hub"                   = "eh"
    "event-hub-queue"             = "ehq"
    "event-hub-namespace"         = "ehn"
    "sql-database"                = "db"
    "sql-server"                  = "srv"
    "azure-load-balancer"         = "alb"
    "availability-set"            = "avs"
    "storage"                     = "sto"
    "key-vault"                   = "kv"
    "service-bus"                 = "sb"
    "service-bus-queue"           = "sbq"
    "log-analytics-workspace"     = "law"
    "vpn-gateway"                 = "vpng"
    "virtual-hub"                 = "vhub"
    "virtual-wan"                 = "vwan"
    "virtual-machine"             = "vm"
    "virtual-appliance"           = "nva"
    "route-table"                 = "rtb"
    "network-watcher"             = "nw"
    "monitor-diagnostic-settings" = "mds"
    "private-endpoint"            = "pe"
    "network-interface"           = "nic"
    "app-service-environment"     = "ase"
    "app-service-plan"            = "asp"
    "app-service"                 = "app"
    "public-ip"                   = "pip"
    "disk-encryption-set"         = "des"
    "application-gateway"         = "apg"
    "container-registry"          = "acr"
    "managed-identity"            = "id"
    "kubernetes-cluster"          = "aks"
    "ssh-key"                     = "ssh"
  }
}

variable "environment" {
  description = "Environment type"
  type        = string
  validation {
    condition     = contains(["prd", "test", "dev", "srd", "snd", "uat"], var.environment)
    error_message = "Incorrect environment name given."
  }
}

variable "location" {
  description = "Location"
  type        = string
  default     = "West Europe"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "app"
}

variable "subscription_id" {
  description = "Subscription ID"
  type        = string
}

variable "vnet_address_space" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "developers_group_object_id" {
  type = string
}

variable "azure_aks_admin_group_object_id" {
  type = string
}
