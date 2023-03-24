resource "azurerm_storage_account" "storage" {
  name                     = replace("${local.prefix}-st", "-", "")
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "file" {
  name                 = "${local.prefix}-file"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 50
}
