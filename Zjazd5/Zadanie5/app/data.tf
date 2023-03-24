data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_virtual_network" "shared" {
  name                = "${local.prefix_shared}-vnet"
  resource_group_name = data.azurerm_resource_group.rg.name
}
