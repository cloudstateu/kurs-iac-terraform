resource "azurerm_user_assigned_identity" "aks" {
  provider            = azurerm.aks
  name                = "${var.aks_name}-id"
  location            = var.rg.location
  resource_group_name = var.rg.name
}

resource "azurerm_user_assigned_identity" "aks_kubelet" {
  provider            = azurerm.aks
  name                = "${var.aks_name}-kubelet-id"
  location            = var.rg.location
  resource_group_name = var.rg.name
}

resource "azurerm_role_assignment" "aks_id_mio" {
  provider             = azurerm.aks
  scope                = azurerm_user_assigned_identity.aks_kubelet.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "aks_id_contributor" {
  provider             = azurerm.aks
  scope                = var.rg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "aks_id_dns_zone" {
  provider             = azurerm.aks
  scope                = azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "aks_kubelet_id_acr_pull" {
  provider             = azurerm.acr
  scope                = var.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aks_kubelet.principal_id
}
