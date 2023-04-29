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
