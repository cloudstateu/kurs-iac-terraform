resource "azurerm_resource_group" "shared" {
  name     = "${local.resources.resource-group}-${local.environments.shared}-${var.project_name}-01"
  location = var.location
}

