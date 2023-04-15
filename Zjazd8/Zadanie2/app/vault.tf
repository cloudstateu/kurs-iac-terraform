module "vault" {
  source = "./modules/kv"

  providers = {
    azurerm.key_vault = azurerm.app
  }

  access_policies = {
    "my_user" = {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azurerm_client_config.current.object_id

      key_permissions = [
        "Get",
      ]

      secret_permissions = [
        "Get", "List", "Delete", "Set"
      ]

      storage_permissions = [
        "Get",
      ]
    }
  }
  private_dns_zone_id = azurerm_private_dns_zone.zones["kv"].id
  endpoint_subnet_id  = azurerm_subnet.endpoints.id
  kv_name             = "${local.prefix}-kv"
  rg                  = {
    name     = data.azurerm_resource_group.rg.name
    location = data.azurerm_resource_group.rg.location
  }
}

#resource "azurerm_key_vault" "vault" {
#  provider                   = azurerm.app
#  name                       = replace("${local.prefix}-kv", "-", "")
#  location                   = data.azurerm_resource_group.rg.location
#  resource_group_name        = data.azurerm_resource_group.rg.name
#  tenant_id                  = data.azurerm_client_config.current.tenant_id
#  soft_delete_retention_days = 7
#  purge_protection_enabled   = false
#  sku_name                   = "standard"
#}
#
#resource "azurerm_private_endpoint" "kv" {
#  provider            = azurerm.app
#  name                = "${local.prefix}-kv-pep"
#  resource_group_name = data.azurerm_resource_group.rg.name
#  location            = data.azurerm_resource_group.rg.location
#  subnet_id           = azurerm_subnet.endpoints.id
#
#  private_service_connection {
#    name                           = "${local.prefix}-kv-pep-psc"
#    private_connection_resource_id = azurerm_key_vault.vault.id
#    is_manual_connection           = false
#    subresource_names              = ["vault"]
#  }
#
#
#  private_dns_zone_group {
#    name                 = azurerm_private_dns_zone.zones["kv"].name
#    private_dns_zone_ids = [
#      azurerm_private_dns_zone.zones["kv"].id
#    ]
#  }
#}

moved {
  from = azurerm_key_vault.vault
  to   = module.vault.azurerm_key_vault.vault
}

moved {
  from = azurerm_private_endpoint.kv
  to   = module.vault.azurerm_private_endpoint.kv
}
