resource "random_password" "password" {
  count = var.administrator_password == null ? 1 : 0

  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_postgresql_flexible_server" "psql" {
  provider               = azurerm.psql
  name                   = var.name
  location               = var.rg.location
  resource_group_name    = var.rg.name
  version                = "12"
  delegated_subnet_id    = var.subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.zone.id
  administrator_login    = "psqladmin"
  administrator_password = var.administrator_password == null ? random_password.password[0].result : var.administrator_password
  zone                   = "3"
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.link]
}


resource "azurerm_postgresql_flexible_server_database" "databases" {
  provider = azurerm.psql

  for_each = var.databases

  name      = each.value
  server_id = azurerm_postgresql_flexible_server.psql.id
  collation = "en_US.utf8"
  charset   = "utf8"
}
