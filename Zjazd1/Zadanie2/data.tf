data "azurerm_resource_group" "rg" {
  name = "chm-studentXX"
}

data "azurerm_client_config" "current" {
}
