data "azurerm_resource_group" "rg" {
  name = "chm-student29"
}

data "azurerm_client_config" "current" {
}