data "azurerm_resource_group" "hub" {
  provider = azurerm.hub
  name     = "chm-student0"
}

data "azurerm_resource_group" "spoke" {
  provider = azurerm.spoke
  name     = "chm-student0-a"
}
