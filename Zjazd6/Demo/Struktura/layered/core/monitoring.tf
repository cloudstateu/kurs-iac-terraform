resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "${local.resources.log-analytics-workspace}-${var.environment}-${var.project_name}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
