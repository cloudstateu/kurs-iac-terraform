module "psql" {
  source = "./modules/psql"

  providers = {
    azurerm.psql = azurerm.app
  }

  administrator_login = "psqladmin"
  databases           = {
    "default" = "default"
  }
  environment = var.environment
  name        = "${local.prefix}-psql"
  rg          = {
    name     = data.azurerm_resource_group.rg.name
    location = data.azurerm_resource_group.rg.location
  }
  subnet_id = azurerm_subnet.data.id
  vnet      = {
    id   = azurerm_virtual_network.vnet.id
    name = azurerm_virtual_network.vnet.name
  }
}

moved {
  from = random_password.password
  to   = module.psql.random_password.password[0]
}

moved {
  from = azurerm_postgresql_flexible_server.psql
  to   = module.psql.azurerm_postgresql_flexible_server.psql
}

moved {
  from = azurerm_private_dns_zone.zones["psql"]
  to   = module.psql.azurerm_private_dns_zone.zone
}

moved {
  from = azurerm_private_dns_zone_virtual_network_link.zones["psql"]
  to   = module.psql.azurerm_private_dns_zone_virtual_network_link.link
}


#resource "random_password" "password" {
#  length           = 16
#  special          = true
#  override_special = "!#$%&*()-_=+[]{}<>:?"
#}
#
#resource "azurerm_postgresql_flexible_server" "psql" {
#  provider               = azurerm.app
#  name                   = "${local.prefix}-psql"
#  location               = data.azurerm_resource_group.rg.location
#  resource_group_name    = data.azurerm_resource_group.rg.name
#  version                = "12"
#  delegated_subnet_id    = azurerm_subnet.data.id
#  private_dns_zone_id    = azurerm_private_dns_zone.zones["psql"].id
#  administrator_login    = "psqladmin"
#  administrator_password = random_password.password.result
#  zone                   = "3"
#  storage_mb             = 32768
#  sku_name               = "B_Standard_B1ms"
#
#  depends_on = [azurerm_private_dns_zone_virtual_network_link.zones["psql"]]
#}
