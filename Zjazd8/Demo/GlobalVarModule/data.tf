data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg_29" {
  name = "chm-student29"
}