resource "azurerm_virtual_network" "app_vnet" {
  name                = "${local.app_prefix}-vnet"
  address_space       = [local.spoke_vnet_address_space]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "app_sbn" {
  name                 = "${local.app_prefix}-sbn-app"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = [local.spoke_sbn_app_address_space]
}

resource "azurerm_network_security_group" "app_sbn" {
  name                = "${local.app_prefix}-nsg-app"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "app_sbn" {
  subnet_id                 = azurerm_subnet.app_sbn.id
  network_security_group_id = azurerm_network_security_group.app_sbn.id
}

resource "azurerm_virtual_network_peering" "hub_to_app" {
  name                         = "${local.hub_prefix}-vnet-to-${local.app_prefix}-vnet"
  resource_group_name          = data.azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.app_vnet.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "app_to_hub" {
  name                         = "${local.app_prefix}-vnet-to-${local.hub_prefix}-vnet"
  resource_group_name          = data.azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.app_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_link_app_cae" {
  name                  = "${local.app_prefix}-link-app-cae"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.app_cae.name
  virtual_network_id    = azurerm_virtual_network.app_vnet.id
}

resource "azurerm_route_table" "app" {
  name                = "${local.app_prefix}-rt"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  route {
    name                   = "To-${local.jumphost_prefix}"
    address_prefix         = local.jumphost_vnet_address_space
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "app" {
  subnet_id      = azurerm_subnet.app_sbn.id
  route_table_id = azurerm_route_table.app.id
}
