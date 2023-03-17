resource "azurerm_public_ip" "jh_vm_pip" {
  name                = "${local.jumphost_prefix}-vm-pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "jh_vm_nic" {
  name                = "${local.jumphost_prefix}-vm-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${local.jumphost_prefix}-vm-nic-ipconf"
    subnet_id                     = azurerm_subnet.jh_vm.id
    public_ip_address_id          = azurerm_public_ip.jh_vm_pip.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "jh_vm" {
  name                            = "${local.jumphost_prefix}-vm"
  location                        = data.azurerm_resource_group.rg.location
  resource_group_name             = data.azurerm_resource_group.rg.name
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = "test123!@#"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.jh_vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
