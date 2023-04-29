resource "azurerm_redis_cache" "cache" {
  provider            = azurerm.app
  name                = "${local.prefix}-redis"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  capacity            = 0
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
}

resource "azurerm_private_endpoint" "cache" {
  provider            = azurerm.app
  name                = "${local.prefix}-redis-pep"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.endpoints.id

  private_service_connection {
    name                           = "${local.prefix}-redis-pep-psc"
    subresource_names              = ["redisCache"]
    private_connection_resource_id = azurerm_redis_cache.cache.id
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.zones["redis"].name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.zones["redis"].id
    ]
  }
}
