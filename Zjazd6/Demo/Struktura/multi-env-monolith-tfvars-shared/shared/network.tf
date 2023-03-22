locals {
  vnet_address_space           = "10.2.0.0/16"
  snet_jumphost_address_prefix = cidrsubnet(local.vnet_address_space, 8, 0) //10.2.0.0/24
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.resources.virtual-network}-${local.environments.shared}-${var.project_name}-01"
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  address_space       = [local.vnet_address_space]
}

resource "azurerm_subnet" "snet_jumphost" {
  name                 = "${local.resources.subnet}-${local.environments.shared}-${var.project_name}-01-jumphost"
  resource_group_name  = azurerm_resource_group.shared.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.snet_jumphost_address_prefix]
}

resource "azurerm_network_security_group" "nsg_snet_jumphost" {
  name                = "${local.resources.network-security-group}-${local.environments.shared}-${var.project_name}-01-sbn-jumphost"
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AllowSSH"
    priority                   = 100
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_snet_jumphost" {
  subnet_id                 = azurerm_subnet.snet_jumphost.id
  network_security_group_id = azurerm_network_security_group.nsg_snet_jumphost.id
}
