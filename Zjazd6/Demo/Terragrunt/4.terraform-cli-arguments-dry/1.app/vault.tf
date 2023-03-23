resource "azurerm_key_vault" "vault" {
  name                = "${local.prefix}-vault"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_private_endpoint" "vault" {
  name                = "${local.prefix}-vault-pe"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${local.prefix}-vault-pe-privatelink"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.vault.id
    subresource_names              = ["vault"]
  }
}
