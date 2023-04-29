resource "azurerm_kubernetes_cluster" "aks" {
  provider                            = azurerm.aks
  name                                = var.aks_name
  location                            = var.rg.location
  resource_group_name                 = var.rg.name
  dns_prefix                          = var.dns_prefix
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  private_dns_zone_id                 = azurerm_private_dns_zone.aks.id

  default_node_pool {
    name                = "system"
    enable_auto_scaling = true
    min_count           = 1
    node_count          = 1
    max_count           = 2
    vm_size             = "Standard_B2s"
    vnet_subnet_id      = var.network.subnet_id
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    outbound_type     = "loadBalancer"
    load_balancer_sku = "standard"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks_kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.aks_kubelet.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet.id
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  provider              = azurerm.aks
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_B2s"
  enable_auto_scaling   = true
  min_count             = 1
  node_count            = 1
  max_count             = 2
  vnet_subnet_id        = var.network.subnet_id
}
