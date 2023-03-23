resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${terraform.workspace}"
  address_space       = ["10.0.0.0/24"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}