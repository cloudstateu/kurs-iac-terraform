resource "azurerm_virtual_network" "jh_vnet" {
  name                = "${local.jumphost_prefix}-vnet"
  address_space       = [local.jumphost_vnet_address_space]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "jh_vm" {
  name                 = "${local.jumphost_prefix}-sbn-vm"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.jh_vnet.name
  address_prefixes     = [local.jumphost_sbn_vm_address_space]
}

resource "azurerm_network_security_group" "jh_vm" {
  name                = "${local.jumphost_prefix}-nsg-vm"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "jh_vm" {
  subnet_id                 = azurerm_subnet.jh_vm.id
  network_security_group_id = azurerm_network_security_group.jh_vm.id
}

resource "azurerm_virtual_network_peering" "hub_to_jh" {
  name                         = "${local.hub_prefix}-vnet-to-${local.jumphost_prefix}-vnet"
  resource_group_name          = data.azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.jh_vnet.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "jh_to_hub" {
  name                         = "${local.jumphost_prefix}-vnet-to-${local.hub_prefix}-vnet"
  resource_group_name          = data.azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.jh_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "jh_link_app_cae" {
  name                  = "${local.jumphost_prefix}-link-app-cae"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.app_cae.name
  virtual_network_id    = azurerm_virtual_network.jh_vnet.id
}

resource "azurerm_route_table" "jh_vm" {
  name                = "${local.jumphost_prefix}-rt"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  route {
    name                   = "To-${local.app_prefix}"
    address_prefix         = local.spoke_vnet_address_space
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "jh_vm" {
  subnet_id      = azurerm_subnet.jh_vm.id
  route_table_id = azurerm_route_table.jh_vm.id
}
