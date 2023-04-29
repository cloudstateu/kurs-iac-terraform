resource "azurerm_private_dns_zone" "aks" {
  provider = azurerm.aks

  name                = "${var.environment}.privatelink.${var.rg.location}.azmk8s.io"
  resource_group_name = var.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks" {
  provider = azurerm.aks

  name                  = "${var.network.vnet_name}-aks"
  resource_group_name   = var.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = var.network.vnet_id
}

resource "azurerm_private_dns_zone_virtual_network_link" "shared" {
  provider = azurerm.aks

  name                  = "${var.shared_vnet.name}-shared"
  resource_group_name   = var.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = var.shared_vnet.id
}
