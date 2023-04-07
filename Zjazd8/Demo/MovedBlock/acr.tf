module "acr" {
  source = "./acr"
  providers = {
    azurerm.acr = azurerm
  }
  env      = "dev"
  sku      = "Standard"
  rg_name  = "chm-student29"
}