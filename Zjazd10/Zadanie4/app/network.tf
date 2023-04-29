resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.app
  name                = "${local.prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "app" {
  provider             = azurerm.app
  name                 = "${local.prefix}-snet-app"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.app_address_prefix]
}

resource "azurerm_subnet" "data" {
  provider             = azurerm.app
  name                 = "${local.prefix}-snet-data"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.data_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "endpoints" {
  provider                                  = azurerm.app
  name                                      = "${local.prefix}-snet-endpoints"
  resource_group_name                       = data.azurerm_resource_group.rg.name
  virtual_network_name                      = azurerm_virtual_network.vnet.name
  address_prefixes                          = [local.endpoints_address_prefix]
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_virtual_network_peering" "shared_to_app" {
  provider                  = azurerm.shared
  name                      = "${data.terraform_remote_state.shared.outputs.vnet_name}-to-${azurerm_virtual_network.vnet.name}"
  resource_group_name       = data.terraform_remote_state.shared.outputs.rg_name
  virtual_network_name      = data.terraform_remote_state.shared.outputs.vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}

resource "azurerm_virtual_network_peering" "app_to_shared" {
  provider                  = azurerm.app
  name                      = "${azurerm_virtual_network.vnet.name}-to-${data.terraform_remote_state.shared.outputs.vnet_name}"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = data.terraform_remote_state.shared.outputs.vnet_id
}
