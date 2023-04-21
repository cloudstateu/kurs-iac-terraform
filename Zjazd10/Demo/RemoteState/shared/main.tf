resource "azurerm_resource_group" "rg" {
  provider = azurerm.shared
  name     = "remote-state-shared-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.shared
  name                = "remote-state-shared-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}
