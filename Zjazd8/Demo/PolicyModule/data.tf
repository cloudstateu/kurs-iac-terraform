data "azurerm_resource_group" "rg" {
  name = "chm-student0-a"
}

data "azurerm_subscription" "current" {
}

data "azurerm_management_group" "root_management_group" {
  name = data.azurerm_subscription.current.tenant_id
}
