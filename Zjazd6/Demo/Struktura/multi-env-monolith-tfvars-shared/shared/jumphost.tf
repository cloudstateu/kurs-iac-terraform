resource "tls_private_key" "jumphost_RSA" {
  algorithm = "RSA"
}

resource "azurerm_ssh_public_key" "jumphost_ssh" {
  name                = "${local.resources.ssh-key}-${local.environments.shared}-${var.project_name}-01-jumphost"
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  public_key          = tls_private_key.jumphost_RSA.public_key_openssh
}

resource "azurerm_public_ip" "jumphost" {
  name                = "${local.resources.public-ip}-${local.environments.shared}-${var.project_name}-01-jumphost"
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "jumphost" {
  name                 = "${local.resources.network-interface}-${local.environments.shared}-${var.project_name}-01-jumphost"
  location             = azurerm_resource_group.shared.location
  resource_group_name  = azurerm_resource_group.shared.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "${local.resources.network-interface}-${local.environments.shared}-${var.project_name}-01-jumphost-ip-conf"
    subnet_id                     = azurerm_subnet.snet_jumphost.id
    public_ip_address_id          = azurerm_public_ip.jumphost.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "jumphost" {
  name                            = "${local.resources.virtual-machine}-${local.environments.shared}-${var.project_name}-01-jumphost"
  location                        = azurerm_resource_group.shared.location
  resource_group_name             = azurerm_resource_group.shared.name
  size                            = "Standard_B2s"
  admin_username                  = "jumphost"
  disable_password_authentication = true
  custom_data                     = filebase64("./templates/jumphost.sh")

  network_interface_ids = [
    azurerm_network_interface.jumphost.id,
  ]

  admin_ssh_key {
    public_key = azurerm_ssh_public_key.jumphost_ssh.public_key
    username   = "jumphost"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    name                 = "${local.resources.virtual-machine}-${local.environments.shared}-${var.project_name}-01-jumphost-disk"
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_virtual_machine_extension" "AADSSHLogin" {
  name                 = "AADSSHLoginForLinux"
  virtual_machine_id   = azurerm_linux_virtual_machine.jumphost.id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADSSHLoginForLinux"
  type_handler_version = "1.0"
}
