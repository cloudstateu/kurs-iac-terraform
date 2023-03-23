resource "azurerm_container_registry" "acr" {
  name                          = "${local.resources.container-registry}${local.environments.shared}${var.project_name}01"
  location                      = azurerm_resource_group.shared.location
  resource_group_name           = azurerm_resource_group.shared.name
  network_rule_bypass_option    = "AzureServices"
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = true

  network_rule_set {
    default_action = "Deny"
  }
}
