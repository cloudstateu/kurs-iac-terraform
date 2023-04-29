locals {
  dns_zones = {
    file  = "privatelink.file.core.windows.net"
    kv    = "privatelink.vaultcore.azure.net"
    redis = "privatelink.redis.cache.windows.net"
    # psql  = "${var.environment}.postgres.database.azure.com"
    #    aks   = "${var.environment}.privatelink.${data.azurerm_resource_group.rg.location}.azmk8s.io"
  }
}

resource "azurerm_private_dns_zone" "zones" {
  provider = azurerm.app
  for_each = local.dns_zones

  name                = each.value
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "zones" {
  provider = azurerm.app
  for_each = local.dns_zones

  name                  = "${azurerm_virtual_network.vnet.name}-${each.key}"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.zones[each.key].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  provider              = azurerm.shared
  name                  = "${azurerm_virtual_network.vnet.name}-acr"
  resource_group_name   = data.terraform_remote_state.shared.outputs.rg_name
  private_dns_zone_name = "privatelink.azurecr.io"
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
