resource "azurerm_private_dns_zone" "zone" {
  provider = azurerm.key_vault

  count = var.private_dns_zone_id == null ? 1 : 0

  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  provider = azurerm.key_vault

  count = var.private_dns_zone_id == null ? 1 : 0

  name                  = var.vnet.name
  resource_group_name   = var.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.zone[0].name
  virtual_network_id    = var.vnet.id
}
