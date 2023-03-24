data "azurerm_resource_group" "rg_hub" {
  provider = azurerm.hub
  name = "chm-student29"
}

data "azurerm_resource_group" "rg_spoke" {
  provider = azurerm.spoke
  name = "chm-student29-a"
}