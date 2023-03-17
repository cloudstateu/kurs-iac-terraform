resource "azurerm_log_analytics_workspace" "app_log" {
  name                = "${local.app_prefix}-log"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "app_cae" {
  name                           = "${local.app_prefix}-cae"
  location                       = data.azurerm_resource_group.rg.location
  resource_group_name            = data.azurerm_resource_group.rg.name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.app_log.id
  infrastructure_subnet_id       = azurerm_subnet.app_sbn.id
  internal_load_balancer_enabled = true
}

resource "azurerm_container_app" "app_ca" {
  name                         = "${local.app_prefix}-ca"
  container_app_environment_id = azurerm_container_app_environment.app_cae.id
  resource_group_name          = data.azurerm_resource_group.rg.name
  revision_mode                = "Single"

  ingress {
    target_port      = 80
    external_enabled = true
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    container {
      name   = "simple-hello-world-container"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}
