data "azuread_client_config" "current" {
}

data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "shared" {
  name = "${local.resources.resource-group}-${local.environments.shared}-${var.project_name}-01"
}

data "azurerm_container_registry" "acr" {
  name                = "${local.resources.container-registry}${local.environments.shared}${var.project_name}01"
  resource_group_name = data.azurerm_resource_group.shared.name
}

data "azurerm_virtual_network" "shared" {
  name                = "${local.resources.virtual-network}-${local.environments.shared}-${var.project_name}-01"
  resource_group_name = data.azurerm_resource_group.shared.name
}
