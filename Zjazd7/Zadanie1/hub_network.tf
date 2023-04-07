resource "azurerm_virtual_network" "hub_vnet" {
  provider            = azurerm.hub
  name                = "${local.hub_prefix}-vnet"
  address_space       = [local.hub_vnet_address_space]
  location            = data.azurerm_resource_group.hub.location
  resource_group_name = data.azurerm_resource_group.hub.name
}

resource "azurerm_subnet" "hub_fw_management" {
  provider             = azurerm.hub
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = data.azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [local.hub_sbn_fw_management_address_space]
}

resource "azurerm_subnet" "hub_fw" {
  provider             = azurerm.hub
  name                 = "AzureFirewallSubnet"
  resource_group_name  = data.azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [local.hub_sbn_fw_address_space]
}
