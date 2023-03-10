resource "azurerm_storage_account" "storage" {
  name                     = "chmstudent0testimport"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  location                 = data.azurerm_resource_group.rg.location
  resource_group_name      = data.azurerm_resource_group.rg.name
}
