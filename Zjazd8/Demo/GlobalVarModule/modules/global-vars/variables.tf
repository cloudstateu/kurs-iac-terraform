locals {
  environments = {
    "production"           = "prd"
    "pre-production"       = "pre"
    "performance"          = "prf"
    "test"                 = "test"
    "user-acceptance-test" = "uat"
    "development"          = "dev"
    "shared"               = "srd"
    "sandbox"              = "snd"
  }
  resources = {
    "resource-group"              = "rg"
    "virtual-network"             = "vnet"
    "virtual-network-peering"     = "vnp"
    "subnet"                      = "sbn"
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
    "postgresql-server"           = "pgs"
    "postgresql-database"         = "pdb"
    "mysql-server"                = "msrv"
    "mysql-database"              = "mdb"
    "cosmosdb"                    = "cdb"
    "mongodb"                     = "mdb"
  }
}

variable "additional_tags" {
  type    = map(any)
  default = null
}

variable "resource_tags" {
  type = object({
    PI          = string
    OwnerDev    = string
    OwnerAdm    = string
    Creator     = string
    Department  = string
    System      = string
    Environment = string
    CostCenter  = string
    Sensitivity = string
    Shared      = bool
  })
  default = null
}