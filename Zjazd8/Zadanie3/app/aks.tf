module "aks" {
  source = "./modules/aks"

  providers = {
    azurerm.aks = azurerm.app
    azurerm.acr = azurerm.shared
  }

  acr = {
    id = data.azurerm_container_registry.acr.id
  }
  aks_name                   = "${local.prefix}-aks"
  dns_prefix                 = local.prefix
  environment                = var.environment
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
  network                    = {
    vnet_id   = azurerm_virtual_network.vnet.id
    vnet_name = azurerm_virtual_network.vnet.name
    subnet_id = azurerm_subnet.app.id
  }
  rg = {
    id       = data.azurerm_resource_group.rg.id
    name     = data.azurerm_resource_group.rg.name
    location = data.azurerm_resource_group.rg.location
  }
}

moved {
  from = azurerm_kubernetes_cluster.aks
  to   = module.aks.azurerm_kubernetes_cluster.aks
}

moved {
  from = azurerm_kubernetes_cluster_node_pool.user
  to   = module.aks.azurerm_kubernetes_cluster_node_pool.user
}

moved {
  from = azurerm_private_dns_zone.zones["aks"]
  to   = module.aks.azurerm_private_dns_zone.aks
}

moved {
  from = azurerm_private_dns_zone_virtual_network_link.zones["aks"]
  to   = module.aks.azurerm_private_dns_zone_virtual_network_link.aks
}

moved {
  from = azurerm_role_assignment.aks_id_contributor
  to   = module.aks.azurerm_role_assignment.aks_id_contributor
}

moved {
  from = azurerm_role_assignment.aks_id_dns_zone
  to   = module.aks.azurerm_role_assignment.aks_id_dns_zone
}

moved {
  from = azurerm_role_assignment.aks_id_mio
  to   = module.aks.azurerm_role_assignment.aks_id_mio
}

moved {
  from = azurerm_role_assignment.aks_kubelet_id_acr_pull
  to   = module.aks.azurerm_role_assignment.aks_kubelet_id_acr_pull
}

moved {
  from = azurerm_user_assigned_identity.aks
  to   = module.aks.azurerm_user_assigned_identity.aks
}

moved {
  from = azurerm_user_assigned_identity.aks_kubelet
  to   = module.aks.azurerm_user_assigned_identity.aks_kubelet
}

#resource "azurerm_user_assigned_identity" "aks" {
#  provider            = azurerm.app
#  name                = "${local.prefix}-aks-id"
#  location            = data.azurerm_resource_group.rg.location
#  resource_group_name = data.azurerm_resource_group.rg.name
#}
#
#resource "azurerm_user_assigned_identity" "aks_kubelet" {
#  provider            = azurerm.app
#  name                = "${local.prefix}-aks-kubelet-id"
#  location            = data.azurerm_resource_group.rg.location
#  resource_group_name = data.azurerm_resource_group.rg.name
#}
#
#resource "azurerm_role_assignment" "aks_id_mio" {
#  provider             = azurerm.app
#  scope                = azurerm_user_assigned_identity.aks_kubelet.id
#  role_definition_name = "Managed Identity Operator"
#  principal_id         = azurerm_user_assigned_identity.aks.principal_id
#}
#
#resource "azurerm_role_assignment" "aks_id_contributor" {
#  provider             = azurerm.app
#  scope                = data.azurerm_resource_group.rg.id
#  role_definition_name = "Contributor"
#  principal_id         = azurerm_user_assigned_identity.aks.principal_id
#}
#
#resource "azurerm_role_assignment" "aks_id_dns_zone" {
#  provider             = azurerm.app
#  scope                = azurerm_private_dns_zone.zones["aks"].id
#  role_definition_name = "Private DNS Zone Contributor"
#  principal_id         = azurerm_user_assigned_identity.aks.principal_id
#}
#
#resource "azurerm_role_assignment" "aks_kubelet_id_acr_pull" {
#  provider             = azurerm.shared
#  scope                = data.azurerm_container_registry.acr.id
#  role_definition_name = "AcrPull"
#  principal_id         = azurerm_user_assigned_identity.aks_kubelet.principal_id
#}
#
#resource "azurerm_kubernetes_cluster" "aks" {
#  provider                            = azurerm.app
#  name                                = "${local.prefix}-aks"
#  location                            = data.azurerm_resource_group.rg.location
#  resource_group_name                 = data.azurerm_resource_group.rg.name
#  dns_prefix                          = local.prefix
#  private_cluster_enabled             = true
#  private_cluster_public_fqdn_enabled = false
#  private_dns_zone_id                 = azurerm_private_dns_zone.zones["aks"].id
#
#  default_node_pool {
#    name                = "system"
#    enable_auto_scaling = true
#    min_count           = 1
#    node_count          = 1
#    max_count           = 2
#    vm_size             = "Standard_B2s"
#    vnet_subnet_id      = azurerm_subnet.app.id
#  }
#
#  network_profile {
#    network_plugin    = "azure"
#    network_policy    = "azure"
#    outbound_type     = "loadBalancer"
#    load_balancer_sku = "standard"
#  }
#
#  identity {
#    type         = "UserAssigned"
#    identity_ids = [azurerm_user_assigned_identity.aks.id]
#  }
#
#  kubelet_identity {
#    client_id                 = azurerm_user_assigned_identity.aks_kubelet.client_id
#    object_id                 = azurerm_user_assigned_identity.aks_kubelet.principal_id
#    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet.id
#  }
#
#  oms_agent {
#    log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
#  }
#}
#
#resource "azurerm_kubernetes_cluster_node_pool" "user" {
#  provider              = azurerm.app
#  name                  = "user"
#  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
#  vm_size               = "Standard_B2s"
#  enable_auto_scaling   = true
#  min_count             = 1
#  node_count            = 1
#  max_count             = 2
#  vnet_subnet_id        = azurerm_subnet.app.id
#}
