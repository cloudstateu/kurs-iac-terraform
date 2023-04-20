data "azurerm_resource_group" "rg" {
  provider = azurerm.app
  name     = var.rg_name
}

data "azurerm_resource_group" "shared" {
  provider = azurerm.shared
  name     = var.shared_rg_name
}

data "azurerm_virtual_network" "shared" {
  provider            = azurerm.shared
  name                = "${local.prefix_shared}-vnet"
  resource_group_name = data.azurerm_resource_group.shared.name
}
