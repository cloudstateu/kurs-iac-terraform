resource "azurerm_container_registry" "acr" {
  name                       = replace(local.acr_name, "-", "")
  resource_group_name        = data.azurerm_resource_group.rg_29.name
  location                   = data.azurerm_resource_group.rg_29.location
  sku                        = "Standard"
  admin_enabled              = false
  network_rule_bypass_option = "AzureServices"
}

module "acr" {
  source = "./modules/acr"
  providers = {
    azurerm.acr = azurerm
  }
  env      = "dev"
  sku      = "Standard"
  rg_name  = "chm-student29"
  instance = "02"
}