resource "azurerm_role_assignment" "rg_reader" {
  principal_id         = var.developers_group_object_id
  role_definition_name = "Reader"
  scope                = azurerm_resource_group.rg.id
}

resource "azurerm_role_assignment" "aks_user" {
  principal_id         = var.developers_group_object_id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  scope                = azurerm_kubernetes_cluster.aks.id
}

resource "azurerm_role_assignment" "rg_contributor" {
  principal_id         = var.azure_aks_admin_group_object_id
  role_definition_name = "Contributor"
  scope                = azurerm_resource_group.rg.id
}
