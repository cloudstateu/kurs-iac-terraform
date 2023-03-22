resource "azurerm_storage_account" "storage" {
  name                     = "${local.resources.storage}${var.environment}${var.project_name}01app"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
