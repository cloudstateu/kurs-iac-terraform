resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.shared
  name                = "${local.prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "endpoints" {
  provider                                       = azurerm.shared
  name                                           = "${local.prefix}-snet-endpoints"
  resource_group_name                            = data.azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [local.endpoints_address_prefix]
  enforce_private_link_endpoint_network_policies = true
}
