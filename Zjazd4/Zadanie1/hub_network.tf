resource "azurerm_virtual_network" "hub_vnet" {
  name                = "${local.hub_prefix}-vnet"
  address_space       = [local.hub_vnet_address_space]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "hub_fw_management" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [local.hub_sbn_fw_management_address_space]
}

resource "azurerm_subnet" "hub_fw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [local.hub_sbn_fw_address_space]
}
