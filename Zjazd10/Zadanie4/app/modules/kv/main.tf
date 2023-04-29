resource "azurerm_key_vault" "vault" {
  provider                   = azurerm.key_vault
  name                       = replace(var.kv_name, "-", "")
  location                   = var.rg.location
  resource_group_name        = var.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  sku_name                   = "standard"

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = var.allowed_public_ip_addresses
  }
}

resource "azurerm_key_vault_access_policy" "access_policy" {
  provider = azurerm.key_vault
  for_each = var.access_policies

  key_vault_id        = azurerm_key_vault.vault.id
  object_id           = each.value.object_id
  tenant_id           = each.value.tenant_id
  key_permissions     = each.value.key_permissions
  secret_permissions  = each.value.secret_permissions
  storage_permissions = each.value.storage_permissions
}

resource "azurerm_private_endpoint" "kv" {
  provider            = azurerm.key_vault
  name                = "${var.kv_name}-pep"
  location            = var.rg.location
  resource_group_name = var.rg.name
  subnet_id           = var.endpoint_subnet_id

  private_service_connection {
    name                           = "${var.kv_name}-pep-psc"
    private_connection_resource_id = azurerm_key_vault.vault.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "privatelink.vaultcore.azure.net"
    private_dns_zone_ids = var.private_dns_zone_id == null ? [azurerm_private_dns_zone.zone[0].id] : [
      var.private_dns_zone_id
    ]
  }
}
