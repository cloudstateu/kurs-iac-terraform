resource "azurerm_virtual_network" "app_vnet" {
  name                = "${local.app_prefix}-vnet"
  address_space       = [local.spoke_vnet_address_space]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "app_sbn" {
  name                 = "${local.app_prefix}-sbn-app"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = [local.spoke_sbn_app_address_space]
}

resource "azurerm_virtual_network_peering" "hub_to_app" {
  name                         = "${local.hub_prefix}-vnet-to-${local.app_prefix}-vnet"
  resource_group_name          = data.azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.app_vnet.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "app_to_hub" {
  name                         = "${local.app_prefix}-vnet-to-${local.hub_prefix}-vnet"
  resource_group_name          = data.azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.app_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}
