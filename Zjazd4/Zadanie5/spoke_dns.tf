resource "azurerm_private_dns_zone" "app_cae" {
  name                = azurerm_container_app_environment.app_cae.default_domain
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_a_record" "app_cae_wildcard" {
  name                = "*"
  records             = [azurerm_container_app_environment.app_cae.static_ip_address]
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 0
  zone_name           = azurerm_private_dns_zone.app_cae.name
}
