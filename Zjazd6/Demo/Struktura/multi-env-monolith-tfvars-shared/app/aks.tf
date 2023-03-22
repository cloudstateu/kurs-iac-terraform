resource "azurerm_user_assigned_identity" "cni" {
  name                = "${local.resources.managed-identity}-${var.environment}-${var.project_name}-01-cni"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_user_assigned_identity" "cni_kubelet" {
  name                = "${local.resources.managed-identity}-${var.environment}-${var.project_name}-01-cni-kubelet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "kubenet_private_dns_contributor" {
  scope                = azurerm_private_dns_zone.private_dns_zones["aks"].id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cni.principal_id
}

resource "azurerm_role_assignment" "kubenet_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.cni.principal_id
}

resource "azurerm_role_assignment" "kubenet_operator" {
  scope                = azurerm_user_assigned_identity.cni_kubelet.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.cni.principal_id
}

resource "azurerm_role_assignment" "kubenet_acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.cni_kubelet.principal_id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                                = "${local.resources.kubernetes-cluster}-${var.environment}-${var.project_name}-01-app"
  location                            = azurerm_resource_group.rg.location
  resource_group_name                 = azurerm_resource_group.rg.name
  dns_prefix                          = "aks-app-${var.environment}"
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = true
  private_dns_zone_id                 = azurerm_private_dns_zone.private_dns_zones["aks"].id
  node_resource_group                 = "${azurerm_resource_group.rg.name}-aks-nodes"
  sku_tier                            = "Free"
  azure_policy_enabled                = true
  local_account_disabled              = true
  automatic_channel_upgrade           = "node-image"

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = [
      var.azure_aks_admin_group_object_id
    ]
    azure_rbac_enabled = false
    managed            = true
    tenant_id          = var.tenant_id
  }

  default_node_pool {
    name                = "system"
    min_count           = 1
    node_count          = 1
    max_count           = 2
    vnet_subnet_id      = azurerm_subnet.snet_app.id
    vm_size             = "Standard_B2s"
    enable_auto_scaling = true
    upgrade_settings {
      max_surge = 33
    }
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    outbound_type     = "loadBalancer"
    load_balancer_sku = "standard"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.cni.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.cni_kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.cni_kubelet.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.cni_kubelet.id
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      default_node_pool[0].orchestrator_version,
      kubernetes_version
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user01" {
  name                  = "user01"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = azurerm_subnet.snet_app.id
  vm_size               = "Standard_D4s_v3"
  enable_node_public_ip = false
  mode                  = "User"

  min_count           = 2
  node_count          = 2
  max_count           = 5
  enable_auto_scaling = true
  upgrade_settings {
    max_surge = 33
  }
}
