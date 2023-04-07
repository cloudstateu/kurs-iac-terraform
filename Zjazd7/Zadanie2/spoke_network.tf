module "app" {
  source = "./modules/spoke"

  providers = {
    azurerm.hub   = azurerm.hub
    azurerm.spoke = azurerm.spoke
  }

  app_name      = "app"
  hub_rg_name   = azurerm_virtual_network.hub_vnet.resource_group_name
  hub_vnet_id   = azurerm_virtual_network.hub_vnet.id
  hub_vnet_name = azurerm_virtual_network.hub_vnet.name
  location      = data.azurerm_resource_group.spoke.location
  rg_name       = data.azurerm_resource_group.spoke.name
  student_name  = "chm-student0"
  subnets       = {
    "app" = {
      address_space = local.spoke_sbn_app_address_space
    }
  }
  vnet_address_space = local.spoke_vnet_address_space
}
