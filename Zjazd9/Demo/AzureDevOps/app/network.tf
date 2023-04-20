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
}

resource "azurerm_subnet" "endpoints" {
  provider                                       = azurerm.app
  name                                           = "${local.prefix}-snet-endpoints"
  resource_group_name                            = data.azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [local.endpoints_address_prefix]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_virtual_network_peering" "shared_to_app" {
  provider                  = azurerm.shared
  name                      = "${data.azurerm_virtual_network.shared.name}-to-${azurerm_virtual_network.vnet.name}"
  resource_group_name       = data.azurerm_resource_group.shared.name
  virtual_network_name      = data.azurerm_virtual_network.shared.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}

resource "azurerm_virtual_network_peering" "app_to_shared" {
  provider                  = azurerm.app
  name                      = "${azurerm_virtual_network.vnet.name}-to-${data.azurerm_virtual_network.shared.name}"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.shared.id
}

resource "azurerm_network_security_group" "nsg_app" {
  provider            = azurerm.app
  name                = "${local.prefix}-snet-app-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowAll"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_app_ass" {
  provider                  = azurerm.app
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.nsg_app.id
}