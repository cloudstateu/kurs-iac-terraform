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

resource "azurerm_virtual_network_peering" "hub_to_jh" {
  name                         = "${local.hub_prefix}-vnet-to-${local.jumphost_prefix}-vnet"
  resource_group_name          = data.azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.jh_vnet.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "jh_to_hub" {
  name                      = "${local.jumphost_prefix}-vnet-to-${local.hub_prefix}-vnet"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.jh_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}
