
data "azurerm_resource_group" "rg" {
  name = "chm-studentX"
}

data "azurerm_client_config" "current" {
}
