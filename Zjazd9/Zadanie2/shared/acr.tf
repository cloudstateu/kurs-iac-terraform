resource "azurerm_container_registry" "acr" {
  provider            = azurerm.shared
  name                = replace("${local.prefix}-acr", "-", "")
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Premium"
  admin_enabled       = false
}

resource "azurerm_private_endpoint" "acr" {
  provider            = azurerm.shared
  name                = "${local.prefix}-acr-pep"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.endpoints.id

  private_service_connection {
    name                           = "${local.prefix}-acr-pep-psc"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.zones["acr"].name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.zones["acr"].id
    ]
  }
}
