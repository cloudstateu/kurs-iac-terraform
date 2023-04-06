locals {
  dns_zones = {
    acr = "privatelink.azurecr.io"
  }
}

resource "azurerm_private_dns_zone" "zones" {
  for_each = local.dns_zones

  name                = each.value
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "zones" {
  for_each = local.dns_zones

  name                  = "${azurerm_virtual_network.vnet.name}-${each.key}"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.zones[each.key].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
