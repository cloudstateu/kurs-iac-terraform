resource "azurerm_private_dns_zone" "zone" {
  provider = azurerm.psql

  name                = "${var.environment}.postgres.database.azure.com"
  resource_group_name = var.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  provider = azurerm.psql

  name                  = "${var.vnet.name}-psql"
  resource_group_name   = var.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.zone.name
  virtual_network_id    = var.vnet.id
}
