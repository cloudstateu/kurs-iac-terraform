data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_virtual_network" "shared" {
  name                = "${local.prefix_shared}-vnet"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_container_registry" "acr" {
  name                = replace("${local.prefix_shared}-acr", "-", "")
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = data.azurerm_resource_group.rg.name
}
