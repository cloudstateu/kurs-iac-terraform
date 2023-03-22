resource "azurerm_resource_group" "rg" {
  name     = "${local.resources.resource-group}-${var.environment}-${var.project_name}-01"
  location = var.location
}
