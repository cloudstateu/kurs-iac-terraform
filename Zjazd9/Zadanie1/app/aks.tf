module "aks" {
  source = "./modules/aks"

  providers = {
    azurerm.aks = azurerm.app
    azurerm.acr = azurerm.shared
  }

  acr = {
    id = data.terraform_remote_state.shared.outputs.acr_id
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
