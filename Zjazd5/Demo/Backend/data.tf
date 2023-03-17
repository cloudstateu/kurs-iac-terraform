data "azurerm_resource_group" "rg" {
  name = "chm-student0"
}

data "azurerm_client_config" "current" {}
