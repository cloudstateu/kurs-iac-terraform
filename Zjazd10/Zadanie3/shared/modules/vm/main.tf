resource "azurerm_public_ip" "pip" {
  provider            = azurerm.vm
  name                = "${var.name}-pip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  provider            = azurerm.vm
  name                = "${var.name}-nic"
  resource_group_name = var.rg_name
  location            = var.location

  ip_configuration {
    name                          = "${var.name}-nic-ip-conf"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  provider                        = azurerm.vm
  name                            = var.name
  resource_group_name             = var.rg_name
  location                        = var.location
  size                            = "Standard_F2"
  admin_username                  = var.administrator_login
  admin_password                  = var.administrator_password
  disable_password_authentication = false
  network_interface_ids           = [
    azurerm_network_interface.nic.id,
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
