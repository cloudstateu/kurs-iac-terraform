module "jumphost" {
  source = "./modules/vm"

  providers = {
    azurerm.vm = azurerm.shared
  }

  administrator_login    = "azureuser"
  administrator_password = "testowe123!@#"
  location               = data.azurerm_resource_group.rg.location
  name                   = "${local.prefix}-jumphost-vm"
  rg_name                = data.azurerm_resource_group.rg.name
  subnet_id              = azurerm_subnet.endpoints.id
}
