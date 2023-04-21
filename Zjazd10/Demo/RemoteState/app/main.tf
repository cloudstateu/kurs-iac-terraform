data "terraform_remote_state" "shared" {
  backend = "azurerm"

  config = {
    subscription_id      = "1bcf81c2-1a09-47ab-8534-8fa56dfe9832"
    resource_group_name  = "chm-student0"
    storage_account_name = "jenkinstfstateterraform"
    container_name       = "tfstate"
    tenant_id            = "3a81269f-0731-42d7-9911-a8e9202fa750"
    key                  = "shared.state.tfstate"
  }
}

resource "azurerm_resource_group" "rg" {
  provider = azurerm.app
  name     = "remote-state-app-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.app
  name                = "remote-state-app-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_virtual_network_peering" "app_to_shared" {
  provider                  = azurerm.app
  name                      = "app-to-shared"
  remote_virtual_network_id = data.terraform_remote_state.shared.outputs.vnet_id
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
}

resource "azurerm_virtual_network_peering" "shared_to_app" {
  provider                  = azurerm.app
  name                      = "shared-to-app"
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  resource_group_name       = data.terraform_remote_state.shared.outputs.rg_name
  virtual_network_name      = data.terraform_remote_state.shared.outputs.vnet_name
}
