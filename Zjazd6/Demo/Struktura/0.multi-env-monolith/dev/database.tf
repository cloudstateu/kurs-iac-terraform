resource "azurerm_mysql_flexible_server" "mysql" {
  name                = "db-app-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login    = "mysqladmin"
  administrator_password = "testowe123!@#$!@#"

  backup_retention_days        = 7
  sku_name                     = "GP_Standard_D2ds_v4"
  version                      = "8.0.21"
  geo_redundant_backup_enabled = false
  zone                         = "1"

  delegated_subnet_id = azurerm_subnet.snet_data.id
  private_dns_zone_id = azurerm_private_dns_zone.mysql.id

  storage {
    auto_grow_enabled = true
    iops              = 396
    size_gb           = 32
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.mysql_link
  ]
}
