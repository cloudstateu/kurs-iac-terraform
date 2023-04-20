data "azurerm_resource_group" "rg" {
  provider = azurerm.shared
  name     = var.rg_name
}
