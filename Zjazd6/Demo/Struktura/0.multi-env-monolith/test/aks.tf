resource "azurerm_container_registry" "acr" {
  name                          = "acrapp01"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  network_rule_bypass_option    = "AzureServices"
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = true

  network_rule_set {
    default_action = "Deny"
  }
}

resource "azurerm_user_assigned_identity" "cni" {
  name                = "mui-app-01-cni"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_user_assigned_identity" "cni_kubelet" {
  name                = "mui-app-01-cni-kubelet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "kubenet_private_dns_contributor" {
  scope                = azurerm_private_dns_zone.aks.id
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
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.cni_kubelet.principal_id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                                = "aks-app-01-app"
  location                            = azurerm_resource_group.rg.location
  resource_group_name                 = azurerm_resource_group.rg.name
  dns_prefix                          = "aks-app"
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = true
  private_dns_zone_id                 = azurerm_private_dns_zone.aks.id
  node_resource_group                 = "aks-app-aks-nodes"
  sku_tier                            = "Free"
  azure_policy_enabled                = true
  local_account_disabled              = false
  automatic_channel_upgrade           = "node-image"

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
}

resource "azurerm_kubernetes_cluster_node_pool" "user2" {
  name                  = "user2"
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
