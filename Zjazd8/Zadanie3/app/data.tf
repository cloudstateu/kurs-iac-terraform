data "azurerm_client_config" "current" {
  provider = azurerm.app
}

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

data "azurerm_container_registry" "acr" {
  provider            = azurerm.shared
  name                = replace("${local.prefix_shared}-acr", "-", "")
  resource_group_name = data.azurerm_resource_group.shared.name
}

data "azurerm_private_dns_zone" "acr" {
  provider            = azurerm.shared
  name                = "privatelink.azurecr.io"
  resource_group_name = data.azurerm_resource_group.shared.name
}
