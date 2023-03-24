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

resource "azurerm_private_endpoint" "file" {
  name                = "${local.prefix}-file-pep"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.endpoints.id

  private_service_connection {
    name                           = "${local.prefix}-file-pep-psc"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.zones["file"].name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.zones["file"].id
    ]
  }
}
