data "azurerm_resource_group" "rg" {
  provider = azurerm.acr
  name     = var.rg_name
}

resource "azurerm_container_registry" "acr_premium" {
  provider                   = azurerm.acr
  count                      = (var.sku == "Premium") ? 1 : 0
  name                       = local.acr_name
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = data.azurerm_resource_group.rg.location
  sku                        = var.sku
  admin_enabled              = false
  network_rule_bypass_option = "AzureServices"
  network_rule_set {
    default_action = "Deny"
  }
}

resource "azurerm_container_registry" "acr_standard" {
  provider                   = azurerm.acr
  count                      = (var.sku == "Standard") ? 1 : 0
  name                       = local.acr_name
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = data.azurerm_resource_group.rg.location
  sku                        = var.sku
  admin_enabled              = false
}